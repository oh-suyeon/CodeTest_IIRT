//test.js로 끝나면 자동으로 테스트 파일로 인식
// npm test 명령어를 실행하면 프로젝트 내의 모든 test 파일 실행
// test.js로 끝나거나, __tests__폴더에 있으면 자동으로 테스트 파일로 인식
// 직접 선택한 파일만 테스트하고 싶다면 npm test 명령어 뒤에 파일명이나 경로를 입력

const fn = require('./fn');

test('1은 1이야.', ()=>{
    expect(1).toBe(1);
});

test('2 더하기 3은 5야.', ()=>{
    expect(fn.add(2, 3)).toBe(5);
});

test('3 더하기 3은 5야.', ()=>{
    expect(fn.add(3, 3)).toBe(5);
});