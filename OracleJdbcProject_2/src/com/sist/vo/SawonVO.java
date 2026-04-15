package com.sist.vo;
/*
이름        널?       유형            
--------- -------- ------------- 
EMPNO     NOT NULL NUMBER(5)     
ENAME     NOT NULL VARCHAR2(30)  
GENDER             CHAR(1)       
ADDRESS            VARCHAR2(50)  
AGE                NUMBER(3)     
POSITION           VARCHAR2(20)  
LOCATION           VARCHAR2(30)  
SALARY             NUMBER(10,2)  
PHONE              VARCHAR2(20)  
INTRO              VARCHAR2(100) 
DEPTNO    NOT NULL NUMBER(2)     
HIRE_DATE          DATE         

   NUMBER => int
   DATE => java.util.Date
   VARCHAR2/CHAR => String
   TO_CHAR => String
   TO_DATE => Date
   
   TO_CHAR(salary,'L999,999')
 */
import java.util.*;

import lombok.Data;
@Data
// DB의 ROW와 매칭 => DTO / Entity / Bean
public class SawonVO {
	private int empno,age,deptno,salary;
	private String ename,gender,address,position,location,phone,intro,dbday,pay;
	private Date hire_date;
	public static void main(String[] args) {
		System.out.println(new Date());
	}
}
