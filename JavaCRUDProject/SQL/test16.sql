-- 3장~4장
/*
	SQL:
		DML/DDL/DCL/TCL
	
	DML
		
	DDL
	  CREATE
	    1)테이블 생성
		  CREATE TABLE table_name
		  (
			컬럼 데이터형 [제약조건], => default/not null
			컬럼 데이터형 [제약조건],
			컬럼 데이터형 [제약조건],
			[제약조건] => PK,FK,UK,CK
		  )
		  CREATE TABLE table_name
		  AS
		   SELECT~
		2)뷰생성
		  CREATE [OR REPLACE] VIEW viewName
		  AS
		   SELECT ~
		3)시퀀스 생성
		  CREATE SEQUENCE seq_name
		   START WITH 1
		   INCREMENT BY 1
		   NOCACHE
		   NOCYCLE
		4)인덱스 생성
		  CREATE INDEX idx_name ON table_name(column)
		  CREATE INDEX idx_name ON table_name(column1,colomn2 DESC/ASC)
		  CREATE INDEX idx_name ON table_name(함수(column))
		                                      |NVL(bunji,' ')
	  ALTER
	    => 테이블
		ALTER TABLE table_name ADD column 데이터형 [제약조건]
		ALTER TABLE table_name MODIFY column 데이터형 [제약조건]
		ALTER TABLE table_name DROP COLUMN column
		ALTER TABLE table_name RENAME COLUMN column_old to column_new
	  DROP
	    DROP TABLE table_name
		DROP INDEX idx_name
		DROP SEQUENCE seq_name
		DROP VIEW view_name
	  RENAME
		RENAME old_name TO new_name  => 테이블 이름 변경
	  TRUNCATE
		TRUNCATE TABLE table_name  => 테이블 데이터 삭제 (테이블은 유지)
	
	DCL
	  GRANT
	   GRANT 권한 TO 유저
	  REVOKE
	   REVOKE 권한 FROM 유저
	TCL
	  COMMIT / ROLLBACK
	----------------------------------------
	 데이터형: NUMBER / VARCHAR2 / CHAR / CLOB / DATE / TIMESTAMP
	 제약조건: PRIMARY LEY / FOREIGN KEY / CHECK / NOT NULL / UNIQUE / DEFAULT
*/