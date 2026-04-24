/*
@c:\oracleDev\oracle_data\movie
commit;
SELECT * FROM movie;
@c:\oracleDev\oracle_data\music
commit;
SELECT * FROM genie_music;
@c:\oracleDev\oracle_data\seoul_hotel
@c:\oracleDev\oracle_data\seoul_loc
@c:\oracleDev\oracle_data\seoul_nature
@c:\oracleDev\oracle_data\seoul_shop
commit;
SELECT * FROM seoul_hotel;
SELECT * FROM seoul_location;
SELECT * FROM seoul_nature;
SELECT * FROM seoul_shop;
*/
/*
     DML / DQL => 구현 (JDBC와 연결)
      INSERT / UPDATE / DELETE / SELECT
      ---------------------------------
      = 연산자
      = 내장함수
     DDL / TCL => 간단한 테이블 제작
     = SEQUENCE / View / Index
     = JOIN / SUBQUERY
     = DDL
       CREATE / ALTER / DROP
       => 제약조건
          PRIMARY KEY / FOREIGN KEY / UNIQUE
          CHECK / NOT NULL
          DEFAULT
*/
/*
    1. SELECT:                                      JOIN(교재) => EMP / DEPT => JDBC에서 사용법
        데이터 검색
        => 목록 / 상세보기 / 검색
          ----   -------   ----
                           WHERE => LIKE/REGEXP_LIKE
                 WHERE primarykey=값 => 번호
          |페이징 => OFFSET 시작번호 ROWS FETCH NEXT 갯수 ROWS ONLY
                    => LIMIT 시작,갯수 (MySQL)
        => 자바 (JDBC)
           목록 => List<VO> => 매개변수 페이지요청
                              ------------------ 사용자 보내준 값
*/
-- 페이지별 출력
DESC movie;
/*
MNO         NUMBER(4)     
TITLE       VARCHAR2(100) 
GENRE       VARCHAR2(100) 
POSTER      VARCHAR2(200) 
ACTOR       VARCHAR2(300) 
REGDATE     VARCHAR2(100) 
GRADE       VARCHAR2(50)  
DIRECTOR    VARCHAR2(100) 
*/
ALTER TABLE movie ADD CONSTRAINT movie_mno_pk PRIMARY KEY(mno);
-- CONSTRAINT 추가 => FK,PK,CK,UK => ADD
-- NOT NULL, DEFAULT => MODIFY
SELECT mno, title, grade, director
FROM movie
OFFSET 0 ROWS FETCH NEXT 20 ROWS ONLY;
-- VO => 20개 묶어서 => 전송 => 배열 / List (가변)
-- 0번부터 시작
-- 자바 => 사용자로부터 => PAGE(매개변수)
-- SQL튜닝 => I/O를 최대한 줄인다 => *보다는 컬럼 나열 (필요없는 컬럼 제거)
-- 상세보기 => WHERE => 1개만 출력:mno(매개변수)
SELECT mno, title,grade,actor,director,genre
FROM movie
WHERE mno=100;
-- 전체 컬럼의 값을 받을 수 있게 => 클래스화(VO/DTO)
-- 검색
SELECT mno,title,grade,actor,director,genre
FROM movie
WHERE title LIKE '%비밀%';

SELECT mno,title,grade,actor,director,genre
FROM movie
WHERE REGEXP_LIKE(title,'비밀');  -- 검색어 사용자가 보냄 (매개변수)

-- 제목검색/장르검색/등급검색/배우검색 => 콤보
SELECT mno,title,grade,actor,director,genre
FROM movie
WHERE genre LIKE '%액션%';

SELECT mno,title,grade,actor,director,genre
FROM movie
WHERE grade LIKE '15%';

SELECT mno,title,grade,actor,director,genre
FROM movie
WHERE actor LIKE '%이%';

/*
    = : 상세보기
    >,<,>=,<= : 등급
    BETWEEN ~ AND : 범위 포함 (예약기간,특가 기간 등)
    IN : 한번에 여러명 검색
    LIKE : 검색
    NULL : 회원인 경우 => 상품구매, 예약없는 사람
           IS NOT NULL, IS NULL
    NOT : 반대값
    
    날짜 / 금액 => 변경
    TO_CHAR :
    NVL : NULL을 대체하는 함수
    -------------------------- SUBSTR / INSTR / LENGTH
    CEIL : 총페이지, ROUND, TRUNC
    ---------------------------
    SYSDATE : 현재 날짜 => INSERT / UPDATE
    ---------------------------
    CASE : TRIGGER / PROCEDURE
*/
/*
    자바
     => 값을 받아서 저장 => 저장된 값을 다른 클래스 전송
        VO => 1개, List<VO> => 여러개
        ----------------------------
        
     => JOIN
        => INNER JOIN => ANSI
        SELECT A.col, B.col
        FROM A JOIN B
        ON a.col=b.col;
        => 테이블간 컬럼명이 다르면 컬럼명만 써도 인식
        => 같은이름의 컬럼은 테이블명.컬럼명, 별칭명.컬럼명
     => SUBQUERY
        => 인라인뷰 / 스칼라서브쿼리
                    -------------
                     JOIN 대신  => 컬럼 대신 : SELECT 뒤에
           ------- 보안 / 페이지 => 테이블 대신 : FROM 뒤에
        => 반드시 기억 => ()
        => INSERT / UPDATE / DELETE 에서 사용 가능
        => (SELECT ~)
*/
-- 통계: GROUP BY
SELECT grade, COUNT(*)
FROM movie
GROUP BY grade
ORDER BY grade;
-- 주로 사용 : 집계함수
/*
    COUNT => ROW 갯수
    MAX => 자동 증가번호 => SEQUENCE로 대체되어서 사용빈도 없어짐
    SUM / AVG => 장바구니
    
    ----------------------------------------------------------
    ROLLUP / CUBE
    REGEXP ~
    GROUPING => 부록
    ----------------------------------------------------------
    => 연결된 테이블 여러개 => JOIN / SUBQUERY
       emp / dept
       book / orders
       customer / orders
       멜론 / 지니뮤직
       
    => SELECT 형식 / 순서
       GROUP BY / ORDER BY / JOIN / SUBQUERY
    
*/
DESC movie;
DESC genie_music;
SELECT * FROM genie_music;