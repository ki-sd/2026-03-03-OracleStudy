CREATE TABLE emp_copy
AS
 SELECT * FROM emp;
SELECT * FROM emp_copy;

CREATE TABLE emp_copy2
AS
 SELECT * FROM emp
 WHERE 1=2;
 -- 조건이 FALSE면 됨
SELECT * FROM emp_copy2;

CREATE TABLE emp_copy3
AS
  SELECT empno,ename,job,hiredate,sal,dname,loc,grade
  FROM emp,dept,salgrade
  WHERE emp.deptno=dept.deptno
  AND sal BETWEEN losal AND hisal;
SELECT * FROM emp_copy3;

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
	REFERENCES 제품(제품번호),
	CONSTRAINT 전표상세_금액_ck CHECK(금액>0)
 );

-- emp 데이터 출력 rownum 포함
-- 개발자가 rownum 순서는 변경 가능 => 인라인뷰
SELECT empno,ename,job,hiredate,sal,rownum
FROM emp;
-- 사원 5명만 출력 => HIT/별점/인기순위...
SELECT empno,ename,job,hiredate,sal,rownum
FROM emp
WHERE rownum<=5;
-- 급여가 많은 상위 5명 출력
-- rownum 변경 => SELECT => 테이블 대신 SELECT => 인라인뷰
-- 한번 사용후 버린다 => 메모리에 저장 안됨 => 보안
SELECT empno,ename,job,hiredate,sal,rownum
FROM (SELECT empno,ename,job,hiredate,sal,rownum
    FROM emp
    ORDER BY sal DESC)
WHERE rownum<=5;
-- 실제 실무 페이징 => 미리 저장
SELECT empno,ename,job,hiredate,sal,num
FROM (SELECT empno,ename,job,hiredate,sal,rownum as num
    FROM (SELECT empno,ename,job,hiredate,sal
        FROM emp
        ORDER BY empno ASC))
WHERE num BETWEEN 6 AND 10;
-- 최근
SELECT empno,ename,job,hiredate,sal
FROM emp
ORDER BY empno ASC
OFFSET 1 ROWS FETCH NEXT 5 ROWS ONLY;

-- emp에서 급여가 가장 많은 사원과 같이 근무하는 부서의 사원 정보
/*
    급여가 가장 많은 사원
    근무하는 부서의 사원 정보
*/
-- 단일행 서브쿼리
-- SQL+SQL
-- 자바에서 오라클 연동 => SQL문장을 줄여서 사용
SELECT MAX(sal)
FROM emp;

SELECT deptno
FROM emp
WHERE sal=(SELECT MAX(sal)
    FROM emp
    WHERE (SELECT *
        FROM emp
        WHERE deptno=10));
-- 다중행
SELECT *
FROM emp
WHERE deptno IN(10,20,30);

SELECT *
FROM emp
WHERE deptno IN(SELECT DISTINCT deptno FROM emp);

-- (10,20,30) => 30   deptno<30
SELECT *
FROM emp
WHERE deptno < ANY(SELECT DISTINCT deptno FROM emp);

-- (10,20,30) => 10   deptno>10
SELECT *
FROM emp
WHERE deptno > ANY(SELECT DISTINCT deptno FROM emp);

-- (10,20,30) => 30   deptno>=30
SELECT *
FROM emp
WHERE deptno >= ALL(SELECT DISTINCT deptno FROM emp);

-- (10,20,30) => 10   deptno<=10
SELECT *
FROM emp
WHERE deptno <= ALL(SELECT DISTINCT deptno FROM emp);

/*
        >  ANY(SOME) ==> MIN
        <  ANY(SOME) ==> MAX
        
        >  ALL ==> MAX
        <  ALL ==> MIN
        
        => ANY/ALL/SOME => 결과값중 한개 선택 (MIN,MAX)
*/
/*
    스칼라 서브쿼리: JOIN 대체
     SELECT (SELECT~) => 컬럼 대신 사용
     FROM emp;
*/
--  사번,이름,직위,입사일,급여,부서명,근무지 => JOIN
SELECT empno,ename,job,hiredate,sal,dname,loc
FROM emp,dept
WHERE emp.deptno=dept.deptno;
-- 예약 / 결제 ...
SELECT empno,ename,job,hiredate,sal,
    (SELECT dname FROM dept WHERE deptno=emp.deptno) as dname,
    (SELECT loc FROM dept WHERE deptno=emp.deptno) as loc
FROM emp;

desc orders;
SELECT * FROM orders;

SELECT orderid,name,bookname,saleprice,orderdate
FROM orders o,customer c,book b
WHERE o.custid=c.custid
AND o.bookid=b.bookid;

SELECT orderid,
    (SELECT name FROM customer WHERE custid=orders.custid) as name,
    (SELECT bookname FROM book WHERE bookid=orders.bookid) as bookname,
    saleprice,orderdate
FROM orders;
-- SQL문장이 길어짐 => 단순하게 JOIN,집계함수 연계할떄 주로 사용
SELECT ename,
    CASE
        WHEN sal > (SELECT AVG(sal) FROM emp)
        THEN 'HIGH'
        ELSE 'LOW'
    END AS grade
FROM emp;

SELECT empno,ename,job,hiredate,sal
FROM (SELECT ename,job,hiredate,sal FROM emp);

-- VIEW: 단순뷰 => 사용빈도 거의 없음
-- system => 권한 부여 (GRANT/REVOKE)
CREATE VIEW emp_view
AS
  SELECT *
  FROM emp;
  
DROP VIEW emp_view;
  
SELECT * FROM emp_view;

-- 확인
SELECT text
FROM user_views
WHERE view_name='EMP_VIEW';

-- 테이블 복사
CREATE TABLE empCopy
AS
  SELECT * FROM emp;
DROP VIEW emp_view;
-- SELECT * FROM empCopy;
CREATE VIEW emp_view
AS
  SELECT * FROM empCopy WITH READ ONLY;
-- DML 사용
INSERT INTO emp_view
VALUES(8000,'홍길동','대리',7788,SYSDATE,3000,100,10);
SELECT * FROM emp_view;

SELECT * FROM empCopy;

DELETE FROM emp_view;
DROP TABLE empCopy;
DROP VIEW emp_view;
DROP VIEW empdept;
ROLLBACK;

-- 수정과 동시에 생성 => 여러개 테이블 참조시에는 DML 불가능
CREATE OR REPLACE VIEW empDept
AS
  SELECT empno,ename,job,hiredate,sal,dname,loc,grade,comm,mgr
  FROM emp,dept,salgrade
  WHERE emp.deptno=dept.deptno
  AND sal BETWEEN losal AND hisal;

-- 자바에서 사용 => SQL 간결화
SELECT * FROM empDept;

SELECT text FROM user_views
WHERE view_name='EMPDEPT';

CREATE SEQUENCE board_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

SELECT board_seq.nextval FROM DUAL;
SELECT board_seq.currval FROM DUAL;

CREATE TABLE student (
    hakbun NUMBER PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    kor NUMBER DEFAULT 0,
    eng NUMBER DEFAULT 0,
    math NUMBER DEFAULT 0
);
CREATE SEQUENCE student_seq
    START WITH 100
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

INSERT INTO student VALUES(
    student_seq.nextval,
    '홍길동',
    90,
    80,
    90
);
SELECT * FROM student;
drop table student;
select student_seq.nextval FROM DUAL;
DROP SEQUENCE student_seq;
-- 