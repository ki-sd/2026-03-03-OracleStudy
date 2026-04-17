-- DML(데이터 조작언어) 187p
/*
		INSERT
		UPDATE
		DELETE
		------------ 내용 변경 => COMMIT(ORACLE)
		             |자바는 AutoCommit
		
		INSERT: 데이터 추가 (테이블)
		------------------------
		UPDATE: 데이터 수정
		DELETE: 데이터 삭제
		------------------------ 이상현상: 원하지 않는 데이터 변경
		                                  ------------------- PRIMARY KEY
										  무결성 원칙
		INSERT
		  형식)
		    1. 전체 값 추가
			   INSERT INTO board VALUES(값,값...) => 문자열,날짜 ''
			               ----- board에 있는 모든 컬럼값을 추가
						   ----- DEFAULT가 무용
			2. 지정된 값 추가
			   INSERT INTO board(no,name,subject,content,pwd) VALUES(지정한 컬럼 갯수만큼)
		
		UPDATE
		  형식)
		    1. 전체 수정
			   UPDATE table_name SET
			   컬럼=값,컬럼=값,....
			2. 조건 수정
			   UPDATE table_name SET
			   컬럼=값,컬럼=값,...
			   WHERE 조건
		
		DELETE
		  형식)
		    1. 전체 삭제
			   DELETE FROM table_name
			2. 조건 삭제
			   DELETE FROM table_name
			   WHERE 조건
			   
		======> INSERT/UPDATE => 제약조건 확인
*/
CREATE TABLE board (
    no NUMBER,
    name VARCHAR2(51) CONSTRAINT board_name_nn NOT NULL,
    subject VARCHAR2(2000) CONSTRAINT board_subject_nn NOT NULL,
    content CLOB CONSTRAINT board_content_nn NOT NULL,
    pwd VARCHAR2(10) CONSTRAINT board_pwd_nn NOT NULL,
    regdate DATE DEFAULT SYSDATE,
    hit NUMBER DEFAULT 0,
    
    CONSTRAINT board_no_pk PRIMARY KEY(no)
);