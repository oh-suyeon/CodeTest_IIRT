<!DOCTYPE html>
<html>
<head>
	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	
	<title>Text Editor</title>
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
		
		let editHistory = [];
		let undoHistory = [];
		
		const HISTORY_TYPE = {
			SELECT 		: 1
			, ADD 		: 2
			, DELETE 	: 3
		}
		
		const SAVE_YN = {
			Y 	: 1
			, N : 0
		}
		
		const STYLE_CLASS = {
			SELECT 	: "selectText"
			, ADD 	: "addText"
			, TR	: "borderBottom"
		}
		
		document.addEventListener("DOMContentLoaded", function () {
			
			generateText();
			
			textSpanClickEvent();
			
			addTextBtnClickEvent();

			undoBtnClickEvent();

			redoBtnClickEvent();
			
		});

		function printLog(){
			console.log("editHistory");
			for(const history of editHistory){
				console.log(history);
			}
			
			console.log("undoHistory");
			for(const history of undoHistory){
				console.log(history);
			}
		}

		function generateText() {
			const characters = "abcdefghijklmnopqrstuvwxyz";
			
			let generatedTexts = "";
			
			for(let i = 0; i <= 10000; i++){
				let generatedText = "";
				let textlenght = getTextLenght(); 
				for(let j = 0; j < textlenght; j++){
					let randomIdx = getRandomIdx();
					generatedText += characters[randomIdx];
				}
				generatedTexts += renderSpan(generatedText); 
			}
			document.querySelector("#generatedText").innerHTML = generatedTexts;	
		}
		
		function getTextLenght() {
			return Math.floor(Math.random() * 7.5) + 3;
		}
		
		function getRandomIdx() {
			return Math.floor(Math.random() * 26);
		}
		
		function renderSpan(generatedText) {
			return "<span class='textSpan'>"+generatedText+"</span> ";
		}
		
		function textSpanClickEvent() {
			const textSpans = document.querySelectorAll(".textSpan")
			for(const textSpan of textSpans){
				textSpan.addEventListener("click", function (e) {
					const saveYn = selectText(e.target);
					if(saveYn === SAVE_YN.N) return;
					historyApp.recodeEditHistory(HISTORY_TYPE.SELECT, e.target);
					undoHistory = []; 
				});
			}
		}
		
		function addTextBtnClickEvent() {
			document.querySelector("#addTextBtn").addEventListener("click", function () {
				const selectTexts = addTextForAddBtn();
				if(selectTexts !== false){
					const historyId = historyApp.recodeEditHistory(HISTORY_TYPE.ADD, selectTexts);
					renderTr(selectTexts, historyId);
					undoHistory = []; 
				}
			});
		}
		
		function undoBtnClickEvent() {
			document.querySelector("#undoBtn").addEventListener("click", function () {
				undo();
			});
		}
		
		function redoBtnClickEvent() {
			document.querySelector("#redoBtn").addEventListener("click", function () {
				redo();
			});
		}
		
		// 클로저 사용
		const historyApp = (function () {
			let historyIdCnt = 0;
			function recodeEditHistory(typeInput, textInput) {
				let edit = {
					type: typeInput
					,text: textInput
					,historyId: historyIdCnt++
				}
				editHistory.push(edit);
				printLog();
				return historyIdCnt - 1;
			}
			function getNextHistoryId() {
				return historyIdCnt;
			}
			return {recodeEditHistory : recodeEditHistory
					, getNextHistoryId : getNextHistoryId};
		})();

		function findHistoryById(historyIdParam) {
			const history = editHistory.concat(undoHistory).find(function(element) {
				if(element.historyId == historyIdParam){
					return true;
				}
			});
			return history;
		}
		
		function selectText(text) {
			if(text.classList.contains(STYLE_CLASS.SELECT) || text.classList.contains(STYLE_CLASS.ADD)){
				return false;
			}else{
				text.classList.add(STYLE_CLASS.SELECT);
				return true;
			}
		}
		
		function addTextForAddBtn() {
			let selectTexts = document.querySelectorAll("." + STYLE_CLASS.SELECT);
			if(selectTexts.length === 0) return false; 
			return selectTexts;
		}
		
		function addTextForUndoRedoBtn(historyId) {
			const history = findHistoryById(historyId);
			let selectTexts = history.text;
			renderTr(selectTexts, historyId);
		}
		
		function renderTr(selectTexts, historyId) {
			const tr = document.createElement("tr");
			tr.classList.add(STYLE_CLASS.TR);

			const tdselectText = document.createElement("td");
			
			for(const selectText of selectTexts){
				const tdInnerText = document.createElement("p");
				tdInnerText.innerText = selectText.innerText;
				tdselectText.append(tdInnerText);
				
				selectText.classList.remove(STYLE_CLASS.SELECT);
				selectText.classList.add(STYLE_CLASS.ADD);
			}
			document.querySelector("#selectText").append(tr);
			tr.append(tdselectText);
			
			const tdDeleteBtn = document.createElement("td");
			tdDeleteBtn.innerHTML = renderBtn(historyId);
			tr.append(tdDeleteBtn);
			tr.setAttribute("id", "tr" + historyId); 
		}
		
		function renderBtn(historyId) {
			return "<button type='button' class='btn btn-light' onclick='deleteText("+historyId+")'>X</button>"
		}
		
		function deleteText(historyId, saveYn) {
			document.querySelector("#tr" + historyId).remove();

			const history = findHistoryById(historyId);
			
			for(const text of history.text){
				text.classList.remove(STYLE_CLASS.ADD);
			}
			
			if(saveYn === SAVE_YN.N) return;
			
			historyApp.recodeEditHistory(HISTORY_TYPE.DELETE, history.text);
			editHistory[editHistory.length - 1].addTextHistoryId = historyId;
			undoHistory = [];
		} 
		
		function undo() {
			if(editHistory.length === 0) return;
			
			const lastHistory = editHistory.pop();
			undoHistory.push(lastHistory);
			printLog();
			
			if(lastHistory.type === HISTORY_TYPE.SELECT){ 
				lastHistory.text.classList.remove(STYLE_CLASS.SELECT);
				
			}else if(lastHistory.type === HISTORY_TYPE.ADD){ 
				deleteText(lastHistory.historyId, SAVE_YN.N); 
				for(const text of lastHistory.text){ // 다시 [선택] 상태로 만들기
					selectText(text);
				}
				
			}else if(lastHistory.type === HISTORY_TYPE.DELETE){ 
				addTextForUndoRedoBtn(lastHistory.addTextHistoryId);
			}
		}
		
		function redo() {
			if(undoHistory.length === 0) return;
			
			const lastUndo = undoHistory[undoHistory.length - 1];

			if(lastUndo.type === HISTORY_TYPE.SELECT){
				selectText(lastUndo.text);
				
			}else if(lastUndo.type === HISTORY_TYPE.ADD){
				addTextForUndoRedoBtn(lastUndo.historyId);
				
			}else if(lastUndo.type === HISTORY_TYPE.DELETE){
				deleteText(lastUndo.addTextHistoryId);
			}
			editHistory.push(lastUndo);
			undoHistory.pop(); 
			printLog();
		}
	</script>

</html>