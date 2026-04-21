-- SELECT deptno,rowid,rownum FROM dept;

CREATE INDEX idx_emp_ename ON emp(ename DESC);
SELECT /*+ INDEX(emp idx_emp_ename) */
      empno,ename,job,hiredate
FROM emp
WHERE ename>='A';
DROP INDEX idx_emp_ename;

-- sal
CREATE INDEX idx_emp_sal ON emp(sal ASC);
SELECT /*+ INDEX(emp idx_emp_sal) */empno,ename,job,hiredate,sal
FROM emp
WHERE sal>0;
DROP INDEX idx_emp_sal;

-- ORDER BY sal ASC, ename ASC (복합INDEX)
CREATE INDEX idx_emp_salename ON emp(sal ASC,ename ASC);
SELECT /*+ INDEX(emp idx_emp_salename */empno,ename,sal,hiredate
FROM emp
WHERE sal>0 AND ename>='A';

ALTER TABLE emp ADD CONSTRAINT emp_empno_pk PRIMARY KEY(empno);
SELECT /*+ INDEX_ASC(emp emp_empno_pk) */
    *
FROM emp;
ALTER TABLE emp ADD CONSTRAINT emp_empno_pk PRIMARY KEY(empno);
SELECT /*+ INDEX_DESC(emp emp_empno_pk) */
    *
FROM emp;

DROP INDEX idx_emp_salename;

-- 단일 인덱스




SELECT * FROM food;
-- 가격검색
CREATE INDEX idx_food_price ON food(price);
-- 지역검색
CREATE INDEX idx_food_address ON food(address);

SELECT * FROM food
WHERE REGEXP_LIKE(address,'마포');
-- %, _ 사용하지 않는다
SELECT * FROM food
WHERE address LIKE '%마포%'
OR address LIKE '%서대문%';

SELECT * FROM food
WHERE REGEXP_LIKE(address,'마포|서대문');
-- 이름중에 알파벳이 포함
SELECT * FROM food
WHERE REGEXP_LIKE(name,'[A-Za-z]');

-- TableSpace에 저장 => 이미 결정이된 상태

-- 복합 인덱스
-- 여러개 조건이 같이 사용
-- 지역 + 음식종류
CREATE INDEX idx_food_addr_type ON food(address,type);
-- 음식종류 + 가격대
CREATE INDEX idx_food_type_price ON food(type,price ASC);
-- 음식종류 + 주차
CREATE INDEX idx_food_type_parking ON food(type,parking);
-- 분위기 + 평점
CREATE INDEX idx_food_theme_score ON food(theme,score DESC);
-- 필터 + 정렬
CREATE INDEX idx_food_filter_sort ON food(type,price,score);

--함수 기반 인덱스
/*
    B-tree / Function-Base / Bitmap => 251p
            |데이터를 가공해서 검색시 사용
    CREATE INDEX idx_ename ON emp(UPPER(ename))
    CREATE INDEX idx_food_type ON food(SUBSTR(type,1,2))
    CREATE INDEX idx_food_score ON food(ROUND(score))
    CREATE INDEX idx_food_address ON food(SUBSTR(address,1,2))
    
    Theme LIKE
    CREATE INDEX idx_food_theme ON food(theme)
    
    NULL
    CREATE INDEX idx_score ON FOOD(NVL(score,0))
    
    => 단일 인덱스
        : 단순 검색
    => 복합 인덱스
        WHERE 조건 순서 중요 (왼쪽부터 사용)
        예) food(score,address)
            WHERE score>0 AND address LIKE '서울%'
    => 함수 인덱스
        일반 인덱스에서 함수 사용 => 인덱스 적용 안됨
        => 미리 함수 이용해서 처리
        예) WHERE ename=UPPER('') => 인덱스 적용 안됨
           => WHERE UPPER(ename)='' => 함수 이용시에는 반드시 함수기반 인덱스 생성
           
    일반적으로 실무 코딩
        필터링 => 인덱스
        CREATE INDEX idx_food_filter_sort ON food(type,price,score)
        함수 기반
        CREATE INDEX idx_food_address ON food(SUBSTR(address,1,2))
        정렬
        CREATE INDEX idx_food_type_price ON food(type,price ASC);
        
        => 검색조건 그대로 인덱스를 만들어야 DB가 빠르게 찾는다
        
        정렬
        
*/
CREATE INDEX idx_food_score ON food(score DESC);
SELECT *
FROM food
ORDER BY score DESC;

SELECT /*+ INDEX(food idx_food_score) */
    *
FROM food
WHERE score>0;

CREATE INDEX idx_food_name ON food(name);

SELECT --+ INDEX(food idx_food_name)
    *
FROM food
WHERE name>='가';

CREATE TABLE T_ORD (
    ORD_ID   NUMBER,
    ORD_DT   DATE,
    AMT      NUMBER
);

INSERT INTO T_ORD
SELECT 
    LEVEL,
    SYSDATE - DBMS_RANDOM.VALUE(0, 365),
    TRUNC(DBMS_RANDOM.VALUE(1000, 100000))
FROM DUAL
CONNECT BY LEVEL <= 10000;

COMMIT;

CREATE TABLE T_ORD_BIG NOLOGGING AS
SELECT 
    T1.*, 
    T2.RNO, 
    TO_CHAR(T1.ORD_DT,'YYYYMMDD') ORD_YMD
FROM T_ORD T1,
     (SELECT ROWNUM RNO FROM DUAL CONNECT BY ROWNUM<=1000) T2;

SELECT COUNT(*) FROM t_ord_big;

CREATE INDEX idx_id ON T_ORD_BIG(ORD_ID);
SELECT * FROM T_ORD_BIG
WHERE ord_id=100;

CREATE INDEX idx_dt ON t_ord_big(ord_dt);

SELECT *
FROM t_ord_big
WHERE ord_dt BETWEEN SYSDATE-7 AND SYSDATE;

CREATE INDEX idx_date ON t_ord_big(TO_CHAR(ord_dt,'YYYYMMDD'));
SELECT *
FROM t_ord_big
WHERE TO_CHAR(ord_dt,'YYYYMMDD')='20260421';

SELECT *
FROM t_ord_big
WHERE ord_dt>TO_DATE ('20260421','YYYYMMDD')
    AND ord_dt<TO_DATE ('20260422','YYYYMMDD');
