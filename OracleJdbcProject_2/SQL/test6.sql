-- 4.15 오라클 3일차 (내장-단일행 함수 / Group By / Join)
-- SELECT문장 (검색) => 연산자 / 집계함수 / Group By / JOIN / Subquery
-- DDL (Table, 데이터형) => INSERT / UPDATE / DELETE
/*
	내장함수:라이브러리(오라클에서 지원하는 함수)
	        내장함수
			  |
		 ----------------------
		 |         |          |            PL/SQL => 5장
	   집계함수   단일행 함수   사용자 정의 CREATE FUNCTION func_name(매개변수..)
	   -------   ---------
	  column단위  row단위
	  => row 갯수:count
	  => row 전체 최대값,최소값:max,min
	  => row의 총합, 평균:sum,avg
	  => 순위: rank,dense_rank
	  ------------------------
	  => row 한개 계산: rollup
	  => row/column: cube
	  ------------------------ Group By가 존재
	  
	  단일행 함수
	  ---------
	      단점: 비절차적 => 오류발생 시 다음줄로 넘어감 (정지 안됨)
	      1.문자 함수
		    = LENGTH/LENGTHB => 문자의 갯수/문자의 바이트수
			  LENGTH('ABC') ===> 3
			  LENGTH('홍길동') ===> 3
			  LENGTHB('ABC') ===> 3
			  LENGTHB('홍길동') ===> 9 (한글은 한글자당 3byte)\
			= LPAD/***RPAD
			  d= ===> ad******
			  LPAD(문자열,글자수,'변경할 문자')
			  LPAD('KING',10,'#') ====> #KING
			  LPAD('KING',3,'#')===>K
			  RPAD(문자열,글자수,'변경할 문자')
			  RPAD('KING',5,'#') ====> KING#
			  RPAD('KING',3,'#') ====> KIN
			= ***UPPER/LOWER/INITCAP
			  UPPER(문자열) => 대문자 변경
			  UPPER('abc') => ABC
			  LOWER(문자열) => 소문자 변경
			  LOWER('ABC') => abc
			  INITCAP(문자열) => 첫자만 대문자
			  INITCAP('king') => King
			= ***REPLACE: 변경 ==========> 크롤링 ==> & => ^
			  REPLACE(문자열,찾는문자,변경할문자)
			  REPLACE('Hello Java','a','b') => Hello Jbvb
			  REPLACE('Hello Java','Java','Oracle') => Hello Oracle
			= TRIM: 공백/특정 문자 제거 (자바 => 공백만 제거) 
			  LTRIM(), RTRIM(), TRIM()
			  |왼쪽    |오른쪽   |좌우 제거
			  LTRIM('문자열'), LTRIM('문자열','제거할 문자')
			  |왼쪽 공백 제거   |왼쪽 문자 제거
			  RTRIM('문자열'), RTRIM('문자열','제거할 문자')
			  |오른쪽 공백 제거 |오른쪽 문자 제거
			  TRIM('문자열'), TRIM(문자 FROM 문자열)
			  |좌우 공백 제거  |문자 제거
			= ASCII/CHR
			        |숫자=>문자변환
			  |문자=>숫자변환
			  ASCII('A') => 65
			  CHR(65) => 'A'
			=***SUBSTR/***INSTR/CONCAT
			                    |문자열 결합 => || => '%'||?||'%' => Oracle
						                       CONCAT('%',?,'%') => MySQL
			             |문자 위치(indexOf)
			    |문자열 자르기(substring)
			  SUBSTR(문자열,시작위치,갯수) => 문자번호 => 1부터 시작
			  123456789
			  SUBSTR('123456789',4,3) => 456
			  SUBSTR('ORACLE',1,3) => ORA
			  
			  INSTR(문자열,찾을문자,시작위치,몇번째)
			                      ------
								  양수 => indexOf (앞에서부터)
								  음수 => lastIndexOf (뒤에서부터)
			  Hello Java
			  INSTR('Hello Java','a',1,2) => 10
			  
			  CONCAT: 문자열 결합 => ||
			  CONCAT('문자열','결합될 문자열')
			  CONCAT('Hello ','Oracle') => Hello Oracle
			
			***중요
			=>LENGTH: 문자의 갯수
			=>SUBSTR: 문자 자르기
			=>INSTR: 문자 번호 검색
			=>RPAD: 문자 채우기
			=>REPLACE: 문자 변경
			
		  2.숫자 함수 (211p)
		    = MOD: % (나머지)
			  MOD(10,2) => 10%2
			= CEIL: 올림 ==> 총 페이지 구하기
			  CEIL(9.1) => 10
			---------------------  
			= TRUNC: 버림
			  TRUNC(9.8) => 9
			= ROUND: 반올림
			  ROUND(9.8) => 10
			--------------------- 날짜(Long)
		  3.날짜 함수
		    = ***SYSDATE: 시스템의 날짜/시간 => 숫자
			  SYSDATE-1 / SYSDATE+1
			  등록일 자동 처리
			= ***MONTHS_BETWEEN(현재,과거): 총 개월수 => 근무개월수
			= ADD_MONTHS(날짜,추가할 개월수): 날짜+개월 후의 날짜 => 금융권
			  적금:3년/보험...
			= LAST_DAY(날짜): 그 달의 마지막 날
			= NEXT_DAY(날짜,'요일'): 날짜 이후의 첫 '요일' 날짜
			
		  4.변환 함수
		    = ***TO_CHAR: 숫자/날짜 => 문자열 변환
			= TO_NUMBER: 문자 => 숫자 
			= TO_DATE: 문자 => 날짜
			= VARCHAR2/DATE/NUMBER
			  CHAR
			  CLOB
			  => 날짜 변환/숫자 변환(1,000) ==> 9,999,999
			     Date 사용 시 => SimpleDateFormat => 입력시간 : 0000000
			  => 
			    연도: YY/YYYY
				 월: MM
				 일: DD
				 시: HH/HH24
				 분: MI
				 초: SS
				요일: DAY
			= TO_NUMBER(): 정수형 변환 => 많이사용하지 않음
			  SELECT '10'+1 FROM DUAL => 11
			  =>가급적 사용X TO_NUMBER 쓰는게 속도가 좀 더 빠름 (SQL튜닝)
			= TO_DATE(): 문자열을 DATE로 변환
			  => 생년월일, 예약날짜 => 문자열 => DATE변환
		  5.기타 함수
		    = NVL: null값이 있는경우 다른값으로 변경(대체)
			  NVL(comm,0),NVL(bunji,' ')
			      ---- - 데이터형 일치 => ''(null), ' '(문자)
			  ==> 자동 증가 번호
			  SELECT NVL(MAX(no)+1,1) FROM board
			= DECODE: 선택문
			  |값 1개 지정
			    DECODE(연산,
						조건,값,
						조건,값,
						값) as 별칭
						
			= CASE: 다중 조건문
			  |범위 지정
			  => 조건식 다양하게 사용 가능(연산자)<,>,BETWEEN ~ AND
			     많이 사용되는 문장
				 => TRIGGER
				 => 부서별 보너스 계산
				 => 호봉/연차
			  CASE
			    WHEN 조건 THEN 값
				WHEN 조건 THEN 값
				WHEN 조건 THEN 값
				ELSE 값
			  END as 별칭
			  
			  --------------------
			    DECODE      CASE
			  --------------------
			      =      모든 조건 연산
				가독성↓     가독성↑
			   단순값비교  복잡한 조건
			  --------------------------------
			  형식 => 순서 => 라이브러리 => 활용
			  사용처
			  SQL
			   |DQL(데이터 검색): SELECT
			    SELECT column_list
				FROM table_name
				[
					WHERE --------- 연산자(true/false)
					GROUP BY ------ 함수
					HAVING -------- 집계함수
					ORDER BY ------ 컬럼/컬럼순서
				]
				FROM - WHERE - GROUP BY - HAVING - SELECT - ORDER BY
			연산자
			  = 산술연산자: ROW단위 통계(+,-,/,*)
			   +: 덧셈, /:(정수/정수=실수)
			  = 비교연산자: =,!=(<>,^=),<,>,<=,>=
			   ***숫자,문자,날짜 => 연산가능
			  = 논리연산자: AND,OR,NOT => !(X)
			  = BETWEEN ~ AND: 기간,범위
			  = IN(OR를 대체)
			  = NULL(연산처리 안됨) => IS NULL, IS NOT NULL
			  = LIKE: _(한글자),%(여러글자)
			    startsWith: A%, endsWith: %A, contains: %A%
			함수
			  = 단일행 함수
			   -문자함수
			     LENGTH
				 SUBSTR
				 INSTR
				 RPAD
			   -숫자함수
			     CEIL
				 ROUND
				 TRUNC
				 MOD
			   -날짜함수
			     SYSDATE
				 MONTHS_BETWEEN
			   -변환함수
			     TO_CHAR
				 TO_DATE
			   -기타함수
			     NVL
				 CASE
			  = 집계 함수
			   -COUNT: ROW의 갯수
			   -MAX/MIN: COLUMN의 최대/최소값
			   -AVG: COLUMN전체 평균
			   -SUM: COLUMN전체 합
			   -RANK/DENSE_RANK(순차적): 순위
*/