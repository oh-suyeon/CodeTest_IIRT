const textEditor = require('./textEditor');

let historyIdCnt = 0;

test('recodeEditHistory 입력', ()=>{
    expect(textEditor.recodeEditHistory('typeInput', 'textInput')).toEqual([{
        type: 'typeInput'
        ,text: 'textInput'
        ,historyId: 0
    }]);
});

test('getNextHistoryId 확인', ()=>{
    expect(textEditor.getNextHistoryId()).toBe(1);
});