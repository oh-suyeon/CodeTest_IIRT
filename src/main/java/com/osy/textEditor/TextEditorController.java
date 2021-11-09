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
	 * Text Editor 실행
	 * @return
	 */
	@RequestMapping(value = "/text-editor", method = RequestMethod.GET)
	public String textEditorView() {
		logger.info("text-editor 실행");
		return "textEditor/textEditorView";
	}
	
	
}
