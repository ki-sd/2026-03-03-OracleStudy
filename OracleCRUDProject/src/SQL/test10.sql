-- 2026-04-17 (179p) DDL: 데이터 정의어
/*
		SQL
		 DML: 데이터 조작(처리) => SELECT: 데이터 검색
		 => ROW단위				 INSERT: 데이터 추가
								 UPDATE: 데이터 수정
								 DELETE: 데이터 삭제
								 ------------------- CRUD
		 DDL: 데이터 정의어 => CREATE: 생성
		 => Column단위					 ------TABLE(데이터를 저장하는 공간)***
							       SEQUENCE(자동증가번호)
								   VIEW(가상테이블) => SELECT 저장
								   INDEX(검색 최적화/정렬)
								   FUNCTION/PROCEDURE/TRIGGER
								   ==> AutoCommit
							 ALTER: 추가/수정/삭제
							       ADD,MODIFY,DROP
							 DROP: 전체삭제
							 RENAME: 데이터 이름 변경=리팩토링
							 TRUNCATE: 삭제 => 테이블은 유지
							            => 데이터만 삭제
		 = 테이블을 만드는 방법 => 식별자
		   ----- class => 멤버변수:column
		   ----- row => 객체
		   1)문자로 시작(알파벳,한글): 운영체제 문제 (한글 읽는형식이 다름)
		                            -----------------------------
									AWS서버: 리눅스=호스팅
			 **대소문자 구분 없음 (오라클 자체에 저장 =>대문자로 저장)
			 **user-tables에 저장
		   2)table명, column명 => 문자의 갯수 30byte (한글 10글자
		                         => 7자~15자(freeboard,goods_list,cart )
								 => column이름을 table명을 사용해도 된다
		   3)같은 데이터베이스(XE)에서는 table명은 유일해야함
		   4)키워드 사용 불가:SELECT,ORDER BY,...
		   5)숫자 사용 가능 (앞에 사용 X)
		   6)특수문자 사용 가능 (_,$) => _:
		     FileName => file_name
			 
		   형식)
		        CREATE TABLE table_name(
					컬럼명 데이터형 [제약조건],
					----- 식별자
					컬럼명 데이터형 [제약조건],
					컬럼명 데이터형 [제약조건],
					[제약조건],
					[제약조건]
				)
		 1.오라클 지원하는 데이터형
		    1)문자형: 문자,문자열 저장 =======> 자바: String
			   CHAR
			    = 고정 바이트
				= 1~2000byte까지 사용
				= 일정한 값(남자/여자/우편번호...)
				= 성별/(admin/user)=>y/n
				= 한글 => 3byte
				= CHAR(10) => 'y'
				  -----------------------
				    y \0 \0 ....
				  ----------------------- 메모리 누수
			   VARCHAR2
			    = 가변 바이트: 입력한 글자수만큼 메모리 할당
				= 1~40000byte
				= 문자저장중 가장 많이 사용되는 데이터형
				*** 반드시 byte수 지정
				= VARCHAR2(100)
				= 이름,주소,전화번호... 이미지(http)
			   CLOB
			    = 가변 바이트
				= ~4Gb
				= 글자가 많은 경우: 줄거리, 자기소개, 게시판 내용, 레시피 방법...
			2)숫자형: 정수,실수 저장 ========>  자바: int,double
			   NUMBER =======> default NUMBER(8,2) ==> 최대 NUMBER(38,128)
			                   정수:8자리까지
							   실수:6자리정수+소수점2자리
			   NUMBER(10) ===> 10자리까지 사용
			   NUMBER(10,2) => 10자리까지 사용/소수점으로 2자리까지 사용 가능
			3)날짜형: DATE => SYSDATE ======> 자바: java.util.Date
			   DATE
			    = 날짜 저장 => 문자형식: yy/mm/dd
			   TIMESTAMP
			    = 기록경주
			4)기타 => 이미지,동영상...:증명사진 ======> 자바: InputStream
			   BFILE
			    = 4Gb까지
				= File형식으로 저장
			   BLOB
			    = 4Gb까지
				= binary형식으로 저장
		    --------------------------------------------------------------
			   자바 매핑 => ~VO
			   CHAR/VARCHAR2/CLOB => String
			   NUMBER => int/double
			   DATE => java.util.Date
			   BFILE/BLOB => InputStream
			   
		 2.데이터 유지 = 제약조건
		   = 정형화된 데이터: 규격/규칙에 맞게 저장 => 바로 사용가능
		                    구분이 잘 되어있다 => 데이터베이스
		   = 반정형화 데이터: 구분이 된 데이터 => XML,HTML,JSON => 크롤링
		   = 비정형화 데이터: 규격/규칙/구분 없는 데이터 => 트위터,facebook
		     -------------> 분석 ==> 필요한 데이터만 정형화된 데이터로 변경
			                -----------------------------------------
							머신러닝: 데이터수집-분석-정형화-학습 ...
		   = 웹사이트에 출력된 데이터는 정형화된 데이터
		     ------- 데이터베이스에서 출력
		   제약조건
		    반드시 입력값을 필요로 하는 경우
			1) NOT NULL
			   name VARCHAR2(20) NOT NULL
			중복이 없는 값 추가 => null 허용
			2) UNIQUE => email/phone : 후보키
			3) NOT NULL + UNIQUE
			   => ROW 구분자: 숫자(자동처리),ID
			   => https://211.249.220.24/index.html
			   => https://daum.net/index.html
			   PRIMARY KEY: 데이터 무결성 => 테이블 제작시 반드시 1개이상 추가
			4) 다른 테이블과 연결: 외래키/참조키
			   FOREIGN KEY => 반드시 PRIMARY KEY 존재
			5) 지정된 데이터만 출력
			   CHECK: radio/select(콤보) => 부서명/근무지/장르...
			6) DEFAULT: 미리 데이터 설정
			   regdate DATE DEFAULT SYSDATE
			   hit NUMBER DEFAULT 0...
			=> 컬럼에서 제약조건을 여러개 사용 가능
		    => 테이블안에서 PRIMARY KEY는 한개 설정가능,
			   나중 설정시 여러개 설정 가능
		   
		   제약조건 형식 정리
		    NOT NULL
			  => 컬럼 데이터형 NOT NULL
			  => 컬럼 데이터형 CONSTRAINT 제약조건명 NOT NULL => 권장 (유지보수 용이)
			UNIQUE
			  => 컬럼 데이터형 UNIQUE
			  => 컬럼 데이터형,
			     CONSTRAINT 제약조건명 UNIQUE(컬럼명)
			CHECK
			  => 컬럼 데이터형 CHECK(컬럼명,IN(값1,값2,...))
			  => 컬럼 데이터형,
			     CONSTRAINT 제약조건명 CHECK(컬럼명,IN(값1,값2,...))
			PRIMARY KEY
			  => 컬럼 데이터형 PRIMARY KEY
			  => 컬럼 데이터형,
			     CONSTRAINT 제약조건명 PRIMARY KEY(컬럼명)
			FOREIGN KEY
			  => 컬럼 데이터형,
			     CONSTRAINT 제약조건명 FOREIGN KEY(컬럼명)
				 REFERENCES 참조테이블(참조컬럼)
			DEFAULT
			  => 컬럼 데이터형 DEFAULT 값
			  
		   테이블 제작 형식
		    CREATE TABLE table_name
			(
				컬럼명 데이터형 [제약조건][제약조건]... , => NOT NULL, DEFAULT
				컬럼명 데이터형 [제약조건][제약조건]... ,
				컬럼명 데이터형 [제약조건][제약조건]... ,
				[제약조건], => PK, UK, CK, FK
				[제약조건]
			)
			
			DEFAULT 우선 => 그 뒤에 제약조건
*/
CREATE TABLE aaa (
	name VARCHAR2(10) CONSTRAINT aaa_name_nn NOT NULL DEFAULT '홍길동' 
);