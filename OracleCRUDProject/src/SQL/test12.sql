-- 04-20 4장: 내장함수 / 서브쿼리 / View / Index  / 시퀀스 / 시노님
/*
	3장 ==> 142p ~ 178p
	SQL
	 *** 데이터베이스 연동: => 구조 파악
	     1)Table: 데이터 저장하는 메모리(파일)
		 DESC table_name
		 ---------------
		 SELECT * FROM user+tables
		 FROM table_name='반드시 대문자'
		 -------------------------------
		 SELECT * FROM user_constraints
		 FROM table_name='대문자'
		 -------------------------------
		 => 데이터형
		    NUMBER: 숫자 저장 => int,double
			CHAR / VARCHAR2 / CLOB => String
			DATE / TIMESTAMP => Date
	     => 컬럼확인 / 데이터현
	 = DML
	   ***DISTINCT: 중복없는 데이터(장르,부서명,카테고리...)
	   ***문자열 결합: ||
	   ***별칭 컬럼 "별칭", 컬럼 AS 별칭 =====> MyBatis에서 주로 사용
	                                      => 함수, 컬럼 길다, VO변수명과 다른 경우
	   ***오라클 명령어는 대소문자 구분이 없음(키워드 대문자)
	      (단 실제 저장된 데이터는 대소문자 구분 함)
	   = SELECT: 데이터 검색
	             SELECT * |column_lis|
				 FROM table_name|view_name|SELECT ~~
				 [
					WHERE 조건 (연산자)
					GROUP BY 그룹컬럼|함수
					HAVING 그룹조건
					ORDER BY 컬럼|함수(ASC/DESC)
				 ]
				 => 실행
				    FROM - WHERE = GROUP BY = HAVING - SELECT - ORDER BT
					*** JOIN / SUBQUERY
	   = INSERT: 데이터 추가
				INSERT INTO table_name VALUES(값...) ==> 모든 값 주입
				=> DEFAULT 적용 안됨 => DEFAULT까지 포함
				INSERT INTO table_name(컬럼...) VALUES(값...)
				=> DEFAULT 적용
	   = UPDATE: 데이터 수정
	            UPDATE table_name SET
				컬럼=값, 컬럼=값..
				[WHERE 조건]
				=> 주의점: 문자/날짜 => 반드시 ' '
	   = DELETE: 데이터 삭제
				DELETE FROM table_name
				[WHERE 조건] ==> ROW단위 삭제
	   = 연산자
	     -산술 연산자: +,-,*,/
		             +: 순수 덧셈
					 /: 0으로 나눌수 없음, 정수/정수=실수
		 -비교 연산자: =,!=(<>),<,>,<=,>=
					**숫자,문자,날짜 비교 가능
		 -논리 연산자: AND,OR
					  &&,|| => 오라클에선 다른 의미
					     |문자열결합(+)
					  |입력(Scanner)
		 -BETWEEN ~ AND: 기간, 범위 => 페이징에서 주로 등장
						 >= AND <=
		 -IN: OR여러개 한번에 처리
		      컬럼 IN(값...)
		 -NOT: 부정 연산자(!사용하면 안됨)
			   NOT IN, NOT BETWEEN ~, NOT LIKE
		 -NULL: 연산처리가 안됨 => 지정
		        IS NULL / IS NOT NULL
		 -LIKE: 유사문자 검색
		        %(문자제한 없음)
				_(한글자)
	   = 내장함수 => 오라클에서 지원하는 라이브러리
	     문자함수
		   SUBSTR(문자열|컬럼명,시작위치,자르는 갯수)
		                      ------- 문자 인덱스 번호:1
		   INSTR(문자열|컬럼명,찾는문자,시작위치,몇번째?)
		                             ------ 양수: indexOf
									 ------ 음수: lastIndexOf
		   LENGTH(문자열|컬럼명): 한글은 Byte(3Byte)
		   RPAD(문자열,출력갯수,대체하는문자)
		 숫자함수
		   CEIL: 올림=>총페이지
		   ROUND: 반올림
		   MOD: %
		 날짜함수
		   SYSDATE: 시스템의 시간 및 날짜
		   MONTHS_BETWEEN: 지정된 기간 개월수
		   ADD_MONTHS: 개월등록 => 몇일인지
		 변환함수
		   TO_CHAR: 문자열 변환
		   TO_DATE: 문자열=>데이터형
		   *** YYYY / RRRR
		   *** MM
		   *** DD
		   *** HH / HH24
		   *** MI
		   *** SS
		   *** 숫자 변환 => ###,###
		 기타함수
		   NVL: NULL을 다른값으로 처리
		   *** NVL(컬럼,값)
		               -- 값은 반드시 데이터형 일치
		   CASE: 다중 조건문 사용
		       CASE
			    WHEN 조건 THEN 값
				...
				ELSE 값
		 집계함수
		   COUNT: ROW 갯수
		   MAX: 자동증가번호
		   SUM/AVG: 총합/평균
		   RANK/DENSE_RANK: 순위
	 = DDL: 데이터 정의어
	    = CREATE: 데이터 저장소(TABLE), 가상테이블(VIEW),
		          속도최적화(INDEX)
				  함수(FUNCTION), 기능(PROCEDURE), 자동화(TRIGGER)
				  자동 증가번호(시퀀스), 동의어(테이블 별칭)=>시노님
				  CREATE TABLE / CREATE VIEW / CREATE INDEX
				  CREATE FUNCTION ...
		= ALTER: 정의한것을 수정
		         ADD(추가) / DROP(삭제) / MODIFY(수정)
		= DROP: CREATE는 반드시 DROP으로 삭제
		= TRUNCATE: 데이터 잘라내기 => 테이블 구조는 유지
		= RENAME: 테이블 이름,컬럼변경
	 = DCL
	    = GRANT: 권한 부여
		= REVOKE: 권한 해제
	 = TCK
	    = COMMIT: 정상 저장
		= ROLLBACK: 모든 명령 취소
		= SAVEPOINT: 지정된 위치부터 ROLLBACK수행
	--------------------------------------------------------------
	179p
	Table제작 => 벤치마킹
	 = 데이터형
	   문자 저장
	    CHAR(1~2000byte,고정) => 메모리 누수 => 같은 글자수일때만 (남자/여자, y/n)
		VARCHAR2(1~4000byte,가변) => 입력된 글자수만큼 메모리에 저장
		CLOB(1~4Gb,가변) => 줄거리/자기소개서
	   숫자 저장
	    NUMBER => NUMBER(8,2) => 정수/실수 => 최대:NUMBER(38,128)
		  평점 NUMBER(2,1)
	   날짜 저장
	    DATE
		TIMESTAMP
	   --------------------------
	      컬럼과 매칭 => VO(오라클 데이터 읽어서 저장)
		    DESC table_name => 컬럼명과 일치 (변수) => MyBatis/JPA
		  ---------------------------
		    CHAR            String
			VARCHAR2
			CLOP
		  ---------------------------
		    NUMBER        정수: int
			              실수: double
		  ---------------------------
		    DATE       java.util.Date
		  ---------------------------
	 = 제약조건: 프로그램에 필요한 컬럼에 대해 조건 설정
	            => 데이터 무결성/참조 무결성 => 이상현상(수정,삭제)
		1)NOT NULL: 입력값 반드시 필요(비밀번호,이름...)
		2)UNIQUE: 중복이 없는 값 => 후보키로 사용 => NULL값 허용
		                          ----- 전화번호/이메일(금융권=>주민번호)
		3)NOT NULL + UNIQUE = PRIMARY KEY(기본키)
		 ***데이터 무결성을 위해서는 PRIMARY KEY는 테이블당 한개이상 반드시 필요
		 ***회원:ID, 사원:사번... 기타:번호
		4)FOREIGN  KEY: 다른 테이블 연동 => 반드시 존재하는 컬럼의 데이터만 참조
		5)CHECK: 지정된 데이터만 추가
		6)DEFAULT: 입력이 없는경우 자동으로 처리되는 기본값
	 = 식별자
	    1)같은 데이터베이스(XE): 같은 테이블명 사용 불가
		  => 협업: 데이터베이스 공통
		2)문자로 시작(알파벳,한글)=>호환성을 위해 알파벳 권장
		  => 대소문자 구분X(단 오라클 저장시 대문자로 저장됨)
		  => user_table/user_constraints/user_views...
		3)숫자사용 가능(숫자로 시작할순없음)
		4)특수문자 => _,$
		5)테이블명 길이 => 30byte
		6)키워드 사용 불가
		***테이블명과 컬럼명 같을수있음
		***AutoCommit => 자동으로 저장
	 = 형식
	    CREATE TABLE table_name
		(
		   컬럼명 데이터형 [제약조건],
		   컬럼명 데이터형 [제약조건],
		   컬럼명 데이터형 [제약조건],
		   ...
		   [제약조건], => 컬럼이 먼저 생성 => 나중에 제약조건 생성
		   [제약조건] => PK,CK,UK,FK...
		)
*/
--테이블 생성: 기존의 테이블 복사(재사용)/새로운 테이블 생성
--기존의 테이블 복사(재사용)
/*
	CREATE TABLE table_name
	AS
	 SELECT * FROM table_name
	=> 테이블 + 데이터
	
	CREATE TABLE table_name
	AS
	 SELECT * FROM table_name
	 WHERE 1=2;
	=> 테이블 형태만 만드는 경우
	=> View
*/
/*
CREATE TABLE emp_copy
AS
 SELECT * FROM emp;
 */
 /*
    약자
	 PK: PRIMARY KEY
	 FK: FOREIGN KEY
	 UK: UNIQUE
	 NN: NOT NULL
	 CK: Check
	판매전표
	-----------------------------------------------
	 컬럼명      전표번호   판매일자     고객명  총액 
	-----------------------------------------------
	 제약조건      PK    NN,DEFAULT     NN    CK
	-----------------------------------------------
	 참조테이블    
	-----------------------------------------------
	 참조컬럼
	-----------------------------------------------
	 체크속성                                  >0
	-----------------------------------------------
	 데이터형   VARCHAR2   DATE     VARCHAR2 NUMBER
	-----------------------------------------------
	 크기         13                   51     8,2
	-----------------------------------------------
	
	제품
	-----------------------------------------------
	 컬럼명      제품번호   제품명     제품단가   
	-----------------------------------------------
	 제약조건      PK       NN          CK    
	-----------------------------------------------
	 참조테이블    
	-----------------------------------------------
	 참조컬럼
	-----------------------------------------------
	 체크속성                           >0
	-----------------------------------------------
	 데이터형   VARCHAR2   VARCHAR2   NUMBER
	-----------------------------------------------
	 크기         13        100        8,2
	-----------------------------------------------
	
	전표상세
	-----------------------------------------------
	 컬럼명      전표번호   제품번호  수량   단가  금액 
	-----------------------------------------------
	 제약조건     PK,FK      FK     NN    NN    CK
	-----------------------------------------------
	 참조테이블   판매전표	   제품	   
	-----------------------------------------------
	 참조컬럼	    전표번호	  제품번호
	-----------------------------------------------
	 체크속성                                   >0
	-----------------------------------------------
	 데이터형   VARCHAR2   VARCHAR2 NUMBER NUMBER NUMBER
	-----------------------------------------------
	 크기         13        100  
	-----------------------------------------------
 */
 -- 컬럼명
 -- 데이터형
 -- 제약조건
 /*
 CREATE TABLE 판매전표(
	전표번호 VARCHAR2(13),
	판매일자 DATE DEFAULT SYSDATE CONSTRAINT 판매전표_판매일자_nn NOT NULL,
	고객명 VARCHAR2(51)CONSTRAINT 판매전표_고객명_nn NOT NULL,
	총액 NUMBER,
	
	CONSTRAINT 판매전표_전표번호_pk PRIMARY KEY(전표번호),
	CONSTRAINT 판매전표_총액_ck CHECK(총액>0)
 );
 CREATE TABLE 제품(
	제품번호 VARCHAR2(13),
	제품명 VARCHAR2(100) CONSTRAINT 제품_제품명_nn NOT NULL,
	제품단가 NUMBER,
	
	CONSTRAINT 제품_제품번호_pk PRIMARY KEY(제품번호),
	CONSTRAINT 제품_제품단가_ck CHECK(제품단가>0)
 );
 CREATE TABLE 전표상세(
	전표번호 VARCHAR2(13),
	제품번호 VARCHAR2(100),
	수량 NUMBER CONSTRAINT 전표상세_수량_nn NOT NULL,
	단가 NUMBER CONSTRAINT 전표상세_단가_nn NOT NULL,
	금액 NUMBER,
	
	CONSTRAINT 전표상세_전표번호_pk PRIMARY KEY(전표번호),
	CONSTRAINT 전표상세_전표번호_fk FOREIGN KEY(전표번호)
	REFERENCES 판매전표(전표번호),
	CONSTRAINT 전표상세_제품번호_fk FOREIGN KEY(제품번호)
	REFERENCES 제품(제품번호,
	CONSTRAINT 전표상세_금액_ck CHECK(금액>0)
 );
 */
-- 데이터형 크기 변경
ALTER TABLE 판매전표 MODIFY 전표번호 VARCHAR2(20);
-- 추가
ALTER TABLE 판매전표 ADD 고객주소 VARCHAR2(200) DEFAULT ' ' CONSTRAINT 판매전표_고객주소_nn NOT NULL;
-- 컬럼명 변경
ALTER TABLE 판매전표 RENAME COLUMN 고객주소 TO 주소;
-- 삭제
ALTER TABLE 판매전표 DROP COLUMN 주소;
-- 데이터 삭제
TRUNCATE TABLE 판매전표;
-- 전체 삭제
DROP TABLE 전표상세;    -- 참조하고있는 테이블 먼저 삭제
DROP TABLE 판매전표;
DROP TABLE 제품;
  