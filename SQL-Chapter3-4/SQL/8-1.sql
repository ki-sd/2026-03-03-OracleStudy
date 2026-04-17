SELECT * FROM customer;
SELECT * FROM book;
SELECT * FROM orders;

SELECT orderid, name, orders.bookid, bookname, saleprice, orderdate
FROM orders,customer,book
WHERE orders.custid=customer.custid 
AND orders.bookid=book.bookid
ORDER BY orderid ASC;

SELECT * FROM emp;
SELECT * FROM dept;

-- 오라클 JOIN
SELECT empno,ename,job,hiredate,sal,dname,loc
FROM emp, dept
WHERE emp.deptno=dept.deptno;

-- ANSI JOIN (표준) (INNER JOIN이 디폴트이므로 INNER는 생략 가능)
SELECT empno,ename,job,hiredate,sal,dname,loc
FROM emp JOIN dept
ON emp.deptno=dept.deptno;

-- 자연 JOIN
SELECT empno,ename,job,hiredate,sal,dname,loc
FROM emp NATURAL JOIN dept;

-- JOIN ~ USING
SELECT empno,ename,job,hiredate,sal,dname,loc
FROM emp JOIN dept USING(deptno);

CREATE TABLE salgrade(
    grade NUMBER,
    losal NUMBER,
    hisal NUMBER
);
INSERT INTO SALGRADE VALUES (1,  700, 1200);
INSERT INTO SALGRADE VALUES (2, 1201, 1400);
INSERT INTO SALGRADE VALUES (3, 1401, 2000);
INSERT INTO SALGRADE VALUES (4, 2001, 3000);
INSERT INTO SALGRADE VALUES (5, 3001, 9999);
COMMIT;

-- NON_EQUI_JOIN
-- ORACLE JOIN
SELECT empno,ename,job,hiredate,sal,grade
FROM emp e, salgrade s
WHERE sal BETWEEN losal AND hisal;

-- ANSI JOIN
SELECT empno,ename,job,hiredate,sal,grade
FROM emp e JOIN salgrade s
ON sal BETWEEN losal AND hisal;

-- 이름, 직위, 입사일, 급여, 사번, 부서명, 근무지, 급여등급
-- ORACLE JOIN
SELECT empno,ename,job,hiredate,sal,dname,loc,grade
FROM emp, dept, salgrade
WHERE emp.deptno=dept.deptno
AND sal BETWEEN losal AND hisal;

-- ANSI JOIN
SELECT empno,ename,job,hiredate,sal,dname,loc,grade
FROM emp JOIN dept 
ON emp.deptno=dept.deptno
JOIN salgrade
ON sal BETWEEN losal AND hisal;

-- 상세보기
-- ORACLE JOIN
SELECT empno,ename,job,hiredate,sal,comm,dname,loc
FROM emp, dept
WHERE emp.deptno=dept.deptno
AND empno=&사번;

--ANSI JOIN
SELECT empno,ename,job,hiredate,sal,comm,dname,loc
FROM emp JOIN dept
ON emp.deptno=dept.deptno
AND empno=&사번;

SELECT emp.*,dname,loc
FROM emp JOIN dept
ON emp.deptno=dept.deptno
AND empno=&사번;

SELECT * FROM emp;

-- SELF JOIN => 컬럼명이 다른 경우에 JOIN (저장된 값이 같은 경우)
/*
    게시판 ===== 댓글
    회원정보 ==== 예약
*/
SELECT e1.ename "본인",e2.ename "사수"
FROM emp e1, emp e2
WHERE e1.mgr=e2.empno(+);

-- 1. ENAME(emp) / DNAME(dept)
SELECT DISTINCT deptno FROM emp; -- 10,20,30
SELECT deptno FROM dept;

SELECT ename,dname
FROM emp,dept
WHERE emp.deptno(+)=dept.deptno;

SELECT ename,dname
FROM emp RIGHT OUTER JOIN dept
ON emp.deptno=dept.deptno;

SELECT * FROM sawon;

UPDATE sawon SET
deptno=85
WHERE empno=1100;

SELECT * FROM dept;

SELECT ename,dname
FROM sawon LEFT OUTER JOIN dept
ON sawon.deptno=dept.deptno;
