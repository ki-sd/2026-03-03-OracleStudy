package com.sist.vo;

import lombok.Data;

/*
 * 	NO           NUMBER(3)     
	CNO          NUMBER(1)     
	TITLE        VARCHAR2(300) 
	SINGER       VARCHAR2(200) 
	ALBUM        VARCHAR2(200) 
	POSTER       VARCHAR2(260) 
	STATE        CHAR(6)       
	IDCREMENT    NUMBER(3)  
 */
@Data
public class MusicVO {
	private int no,idcrement;
	private String title,singer,album,poster,state;
}
