package com.osy.textEditor;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class TextEditorController {
	
	private static final Logger logger = LoggerFactory.getLogger(TextEditorController.class);
	
	/**
	 * textEditor 실행
	 * @return
	 */
	@RequestMapping(value = "/textEditor", method = RequestMethod.GET)
	public String textEditorView() {
		logger.info("textEditor 실행");
		return "textEditor/textEditorView";
	}
	
	
}
