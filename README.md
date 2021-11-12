# Project_TextEditor
![image](https://user-images.githubusercontent.com/80368430/140927519-2f111ac0-a1a2-4d9f-8b74-dc847cd488c4.PNG)

<h3>텍스트 편집기</h3>

<hr>

<h5>요약</h5>
<ul>
  <li>복수의 단어 선택/삭제 가능한 텍스트 편집기</li>
  <li>언어: 웹(Javascript+HTML)</li>
  <li>로직 구현: /WEB-INF/views/textEditor/textEditorView.jsp</li>
  <li>URI: http://localhost:9091/text-editor</li>
</ul>

<hr>

<h5>코드 리팩토링 내역</h5>
<ol>
  <li>변수, 함수 이름으로 기능을 알 수 있다면 주석 달지 말기. ✔</li>
  <li>함수 명 : 스네이크, 카멜 표기법 함께 사용하지 말기. 상수는 스네이크, 일반 변수는 카멜 표기법. ✔</li>
  <li>캡슐화 : 한 페이지가 넘어가는 함수는 너무 긴 것. 분리할 수 있는 부분을 캡슐화했으면 좋았을 것. ✔</li>
  <li>ui와 로직이 한 함수에 섞이면 안 됨. ui 객체를 생성하는 코드는 따로 함수로 빼기. ✔</li>
  <li>추상화 : 코드에 숫자, +, - 등의 연산자가 들어가면 가독성 떨어짐. 함수로 만들어 추상화할 것. ✔</li>
  <li>변수 명 : 무슨 기능을 하는지 모호하지 않아야 함. 정보 중복 주의. ✔</li>
  <li>리터럴 값은 변수화 시켜야 함. 객체 상태로 묶기. ✔</li>
  <li>new Array()와 [] : 리터럴인 []를 사용하기. 가독성, 일부 브라우저에서 빠름. ✔</li> 
  <li>==, != 지양하고 ===, !== 사용하기 ('', 0, null, undefined도 false가 될 수 있다.) ✔</li>
  <li>restAPI : uri에 대소문자(카멜 표기법) 쓰지 않고 '-'으로 단어 쪼갠다. ✔</li>
  <li>람다 적용 ✔</li>
  <li>테스트 코드 작성하기 : Jest 도구 사용해보기. ✔</li>
  <li>❗ 실행 취소, 재 실행 작업 반복 시 버그 발생</li>
</ol>


