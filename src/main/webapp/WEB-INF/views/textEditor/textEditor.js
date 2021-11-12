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

let historyIdCnt = 0;

const textEditor = {
    recodeEditHistory : (typeInput, textInput)=>{
                            let edit = {
                                type: typeInput
                                ,text: textInput
                                ,historyId: historyIdCnt++
                            }
                            editHistory.push(edit);
                            return editHistory;
                        }
    , getNextHistoryId : ()=> historyIdCnt
}

module.exports = textEditor;