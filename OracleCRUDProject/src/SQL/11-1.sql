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

INSERT INTO board VALUES(1,'홍길동','CRUD',
 'DDL(CREATE),DML(INSERT)','1234',SYSDATE,0);
 
INSERT INTO board(no,name,subject,content,pwd) VALUES(2,'홍길동',' ',
 'DDL(CREATE),DML(INSERT)','1234');
 
SELECT * FROM board;
 
UPDATE board SET
name='심청이',subject='UPDATE 명령어 학습중'
WHERE no=2;
 
COMMIT;

DELETE FROM board;

INSERT INTO board VALUES((SELECT NVL(MAX(no)+1,1) FROM board),'홍길동','CRUD',
 'DDL(CREATE),DML(INSERT)','1234',SYSDATE,0);
COMMIT;

SELECT * FROM board
ORDER BY no DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
-- LIMIT 20,10 => MySQL

DESC board;