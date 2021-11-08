<!DOCTYPE html>
<html>
<head>
	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
	<title>TextEditor</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.2/dist/css/bootstrap.min.css" rel="stylesheet">
  	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.2/dist/js/bootstrap.bundle.min.js"></script>
	
	<!-- css 적용 -->
	<link href="/resources/css/style.css" rel="stylesheet" type="text/css">
	
</head>
<body>

	<div class="container-fluid p-3 bg-primary text-white text-center">
		<h1>오수연</h1>
		<p>텍스트 편집기</p>
	</div>

	<div class="container mt-5">
		<div class="row">
			<div class="col-sm-8">
				<h3>생성한 단어</h3>
				<div id="generatedText" class="textDiv"></div>
				
				<div class="row mt-2">
					<div class="col-sm-7">
						<button type="button" id="undoBtn" class="btn btn-secondary">실행취소</button>
						<button type="button" id="redoBtn" class="btn btn-secondary">재실행</button>
					</div>
					<div class="col-sm-5 text-end">
						<button type="button" id="addTextBtn" class="btn btn-primary">추가</button>
					</div>
				</div>
			</div>
			<div class="col-sm-4">
				<h3>선택한 단어</h3>
				<div class="textDiv">
					<table>
						<colgroup>
							<col style="width: 90%">
							<col style="width: 10%">
						</colgroup>
						<tbody id="selectText"></tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

</body>

	<script>
		
		// ** var 사용하지 않기 (const/let 사용)
		// ** jquery 사용하지 않기
		
		// 편집 내역
		let editHistory = new Array();
		// 실행 취소 내역 
		let undoHistory = new Array();
		
		document.addEventListener("DOMContentLoaded", function () {
			fn_generateText(); // 10,000개 단어 생성
			
			// [단어] 클릭 이벤트
			const textSpans = document.querySelectorAll(".textSpan")
			for(const textSpan of textSpans){
				textSpan.addEventListener("click", function (e) {
					const flag = fn_selectText(e.target);
					if(flag != false){
						fn_recodeEditHistory("select", e.target);
						undoHistory = new Array(); // 초기화
					}
				});
			}
			
			// [추가] 버튼 클릭 이벤트
			document.querySelector("#addTextBtn").addEventListener("click", function () {
				const selectTexts = fn_addText();
				if(selectTexts != false){
					fn_recodeEditHistory("add", selectTexts);
					undoHistory = new Array(); // 초기화
				}
			});

			// [실행취소] 버튼 클릭 이벤트
			document.querySelector("#undoBtn").addEventListener("click", function () {
				fn_undo();
			});
			
			// [재실행] 버튼 클릭 이벤트
			document.querySelector("#redoBtn").addEventListener("click", function () {
				fn_redo();
			});
			
		});
		
		// 10,000개 단어 생성
		function fn_generateText() {
			const characters = "abcdefghijklmnopqrstuvwxyz";
			
			let generatedTexts = "";
			
			for(let i = 0; i <= 10000; i++){
				let generatedText = "";
				let textlenght = Math.floor(Math.random() * 7.5) + 3; // 3 ~ 10 길이의 단어 생성  
				for(let j = 0; j < textlenght; j++){
					let randomIdx = Math.floor(Math.random() * 26);
					generatedText += characters[randomIdx];
				}
				generatedTexts += "<span class='textSpan'>"+generatedText+"</span> "; // span으로 생성, 클릭 시 기능 추가
			}
			document.querySelector("#generatedText").innerHTML = generatedTexts;	
		}
		
		// editHistory 기록 배열 추가
		let historyId = 0;
		function fn_recodeEditHistory(typeInput, textInput) {
			let edit = {
				type: typeInput
				,text: textInput
				,historyId: historyId
			}
			editHistory.push(edit);
			historyId++;
		}

		// 기록 객체를 historyId로 검색
		function fn_findHistoryById(historyIdParam) {
			const history = editHistory.concat(undoHistory).find(function(element) {
				if(element.historyId == historyIdParam){
					return true;
				}
			});
			return history;
		}
		
		// [선택]
		function fn_selectText(text) {
			if(text.classList.contains("selectText") || text.classList.contains("addText")){
				return false;
			}else{
				text.classList.add("selectText");
				return true;
			}
		}
		
		// [추가]
		function fn_addText(historyIdParam) {
			let selectTexts = new Array();
			let historyIdInnerVal = historyId;
			
			// 선택된 단어를 배열에 추가
			if(historyIdParam != null){
				const history = fn_findHistoryById(historyIdParam);
				selectTexts = history.text;
				historyIdInnerVal = historyIdParam
			}else {
				selectTexts = document.querySelectorAll(".selectText");
				if(selectTexts.length == 0) return false;
			}
			
			// div에 추가
			const tr = document.createElement("tr");
			tr.classList.add("borderBottom");

			const tdselectText = document.createElement("td");
			
			for(const selectText of selectTexts){
				const tdInnerText = document.createElement("p");
				tdInnerText.innerText = selectText.innerText;
				tdselectText.append(tdInnerText);
				
				// 하이라이트 효과
				selectText.classList.remove("selectText");
				selectText.classList.add("addText");
			}
			document.querySelector("#selectText").append(tr);
			tr.append(tdselectText);
			
			// 삭제 버튼
			const tdDeleteBtn = document.createElement("td");
			tdDeleteBtn.innerHTML = "<button type='button' class='btn btn-light' onclick='fn_deleteText("+historyIdInnerVal+")'>X</button>";
			tr.append(tdDeleteBtn);
			tr.setAttribute("id", "tr" + historyIdInnerVal); // 삭제하기 위해 id를 지정
			
			return selectTexts;
		}
		
		// [삭제]
		function fn_deleteText(historyIdParam, historyFlag) {
			document.querySelector("#tr" + historyIdParam).remove();

			const history = fn_findHistoryById(historyIdParam);
			
			for(const text of history.text){
				text.classList.remove("addText");
			}
			
			if(historyFlag == null){
				fn_recodeEditHistory("delete", history.text);
				editHistory[editHistory.length - 1].addTextHistoryId = historyIdParam;
				undoHistory = new Array(); // 초기화
			}
		} 
		
		// [실행 취소]
		function fn_undo() {
			if(editHistory.length == 0) return;
			
			const lastHistory = editHistory.pop();
			undoHistory.push(lastHistory);
			
			if(lastHistory.type == "select"){ 
				lastHistory.text.classList.remove("selectText");
				
			}else if(lastHistory.type == "add"){ 
				fn_deleteText(lastHistory.historyId, 1); // 1(historyFlag)을 넣어 editHistory에 기록하지 않음
				for(const text of lastHistory.text){ // 다시 [선택] 상태로 만들기
					fn_selectText(text);
				}
				
			}else if(lastHistory.type == "delete"){ 
				fn_addText(lastHistory.addTextHistoryId);
			}
		}
		
		// [재실행]
		function fn_redo() {
			if(undoHistory.length == 0) return;
			
			const lastUndo = undoHistory[undoHistory.length - 1];

			if(lastUndo.type == "select"){
				fn_selectText(lastUndo.text);
				
			}else if(lastUndo.type == "add"){
				fn_addText(lastUndo.historyId);
				
			}else if(lastUndo.type == "delete"){
				fn_deleteText(lastUndo.addTextHistoryId);
			}
			editHistory.push(lastUndo);
			undoHistory.pop(); 
		}
	</script>

</html>