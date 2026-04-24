package com.sist.vo;

import lombok.Data;

/*
 *      매칭
 *         변수 = 컬럼
 *         오라클        자바
 *         CHAR
 *         VARCHAR2
 *         CLOB      String
 *         -------------------------
 *         NUMBER    int / double
 *         -------------------------
 *         DATE      java.util.Date
 *         -------------------------
 *         
 *         오라클 ======X====== 윈도우
 *         오라클 ======X====== 브라우저 (웹)
 *                    |자바
 */
/*
 * 	MNO      NOT NULL NUMBER(4)     
	TITLE             VARCHAR2(100) 
	GENRE             VARCHAR2(100) 
	POSTER            VARCHAR2(200) 
	ACTOR             VARCHAR2(300) 
	REGDATE           VARCHAR2(100) 
	GRADE             VARCHAR2(50)  
	DIRECTOR          VARCHAR2(100) 
 */
@Data
public class MovieVO {
	private int mno;
	private String title,genre,poster,actor,regdate,grade,director;
}
