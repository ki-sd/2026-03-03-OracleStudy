-- 2026-04-16 JOIN / SUBQUERY (162p-178p)
/*
	JOIN
	 => 정규화: 테이블이 나눠짐
	 => 연결해서 필요한 데이터를 추출하는 과정
	                         ----JOIN은 SELECT에서만 사용가능
     => JOIN 종류
        오라클 JOIN (오라클에서만 사용) / ANSI JOIN (DB표준)	
		1.INNER JOIN: 교집합
		              => NULL은 처리 안됨
		  = EUQI_JOIN => = => 가장 많이 사용되는 JOIN
		  = NON_EUQI_JOIN => = 외의 연산자 => 범위
		2.OUTER JOIN: NULL값 처리 가능 => INNER JOIN을 보완
		  = LEFT OUTER JOIN => FROM table1,table2 => 왼쪽(table1)에 처리가 안된 데이터 읽기
		  = RIGHT OUTER JOIN => FROM table1,table2 => 오른쪽(table2)에 처리가 안된 데이터 읽기
		  = FULL OUTER JOIN => FROM table1,table2 => 양쪽 모두에 처리가 안된 데이터 읽기
		  => Admin에서 주로 사용
		--------------------------------------- 컬럼이 다를 수 있다
		3.컬럼명이 동일해야하는 경우
		  = 자연 JOIN: NATURAL JOIN
		  = USING: JOIN ~ USING
		=> 두개 이상의 테이블을 연결해서 출력에 필요한 데이터 추출하는 과정
		
	 => 형식
	    1) INNER JOIN
	    오라클 JOIN
		 SELECT A.column, B.column
		 FROM A,B
		 WHERE A.column=B.column  ==> 테이블 별칭 사용 가능
		 
		 SELECT a.column, b.column
		 FROM A a,B b
		 WHERE a.column=b.column
		 =============================> 같은 column명 반드시 구분
										다른 column명 => 생략 가능 (다른 테이블에 그 column이 없을 경우)
		ANSI JOIN
		 SELECT A.col,B.col
		 FROM A JOIN B
		 ON A.col=B.col
		 
		=> 데이터를 합쳐서 한번에 출력할 목적
		   ---------------------- 포함 클래스
		   class A
		   {
				int a;
				String s;
		   }
		   class B
		   {
				A aa;
				int b;
				String ss;
		   }
		=> 여러 테이블 정보를 동시에 출력이 필요한 경우
		
			1.INNER JOIN
			 두개 이상의 테이블에서 공통으로 존재하는 값을 이용해서 데이터만 조회
			 = 교집합
			 = 가장 많이 사용되는 JOIN (디폴트)
			 = 조건이 맞는 경우 => row 전체 데이터 추출이 가능 (행 반환)
			 
			2.문법 형식
			 SELECT 출력 데이터
			 FROM table1,table2
			 WHERE table1.col=table2.col
			 
			3.EQUI_JOIN ==> 같은 값인 경우 (=)
			  NON_EQUI_JOIN ==> 범위에 포함된 경우 (BETWEEN, 비교, 논리)
			  
			4.SELF JOIN => 같은 테이블로 JOIN
						   --------- 구분 필요 (테이블 별칭으로)
			  => FROM emp e1,emp e2
			
			5.NULL인경우 처리하지 못하는 단점 존재
		    ------------------------------------ INTERSECT(교집합)
		2) OUTER JOIN => INNER JOIN + α
		   한쪽 테이블 기준으로 모든 데이터를 출력 = NULL인 경우에는 출력이 안됨
		   = LEFT OUTER JOIN
		     INTERSECT + MINUS A-B
		   = RIGHT OUTER JOIN
		     INTERSECT + MINUS B-A
		   = FULL OUTER JOIN
		     UNION ALL
		   
		    1. 문법/형식
				ANSI
			   SELECT A.col,B.col
			   FROM A LEFT OUTER JOIN B
			   ON A.col=B.col
			   
			    ORACLE
			   SELECT A.col,B.col
			   FROM A, B
			   WHERE A.col=B.col(+)
			 -----------------------------
			   SELECT A.col,B.col
			   FROM A RIGHT OUTER JOIN B
			   ON A.col=B.col
			   
			   SELECT A.col,B.col
			   FROM A, B
			   WHERE A.col(+)=B.col
			 -----------------------------
			   SELECT A.col,B.col
			   FROM A FULL OUTER JOIN B
			   ON A.col=B.col
			   ===> UNION ALL
			 ----------------------------- 오라클JOIN이 없다
			 
			         SELECT * FROM emp;
select * from dept;

SELECT * FROM customer;
SELECT * FROM book;
SELECT * FROM orders;

SELECT orderid,name,orders.bookid,bookname,saleprice,orderdate
FROM orders,customer,book
WHERE orders.custid=customer.custid
AND orders.bookid=book.bookid;

SELECT * FROM emp; -- 사원 정보 
SELECT * FROM dept; -- 부서 정보 
-- 오라클 JOIN
SELECT empno,ename,job,hiredate,sal,dname,loc
FROM emp,dept
WHERE emp.deptno=dept.deptno;
-- ANSI JOIN 
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

-- 오라클 JOIN 
SELECT empno,ename,sal,job,hiredate,grade
FROM emp e,salgrade s
WHERE sal BETWEEN losal AND hisal;

-- ANSI JOIN => JOIN ~ ON(조건문)
SELECT empno,ename,sal,job,hiredate,grade
FROM emp e JOIN salgrade s
ON sal BETWEEN losal AND hisal;

-- 이름 , 직위 , 입사일 , 급여 , 사번 , 부서명,근무지 ,급여등급
SELECT empno,ename,job,hiredate,sal,dname,loc,grade
FROM emp,dept,salgrade
WHERE emp.deptno=dept.deptno 
AND sal BETWEEN losal AND hisal;

-- ANSI JOIN 
SELECT empno,ename,job,hiredate,sal,dname,loc,grade
FROM emp JOIN dept
ON emp.deptno=dept.deptno 
JOIN salgrade 
ON sal BETWEEN losal AND hisal;

-- 상세보기 
SELECT empno,ename,job,hiredate,sal,comm,dname,loc
FROM emp,dept 
WHERE emp.deptno=dept.deptno
AND empno=&사번;

SELECT empno,ename,job,hiredate,sal,comm,dname,loc
FROM emp JOIN dept 
ON emp.deptno=dept.deptno
AND empno=&사번;

SELECT emp.*,dname,loc
FROM emp JOIN dept 
ON emp.deptno=dept.deptno
AND empno=&사번;

SELECT * FROM emp;

-- SELF JOIN ==> 컬럼명이 다른 경우에서 JOIN (저장된 값이 같은 경우)
/*
         게시물 번호 
     게시판  =====  댓글 
             ID 
     회원정보 ===== 예약  =====  맛집정보 
              ID
     회원정보 ===== 배송정보 
*/
SELECT * FROM orders;
select * from customer;
select * from book;

SELECT e1.ename "본인",e2.ename "사수명" 
FROM emp e1, emp e2
WHERE e1.mgr=e2.empno(+);

CREATE TABLE board(
  no NUMBER,
  CONSTRAINT board_no_pk PRIMARY KEY(no)
);
DROP TABLE board;
-- SELECT (JOIN/SUBQUERY) 
-- INSERT / UPDATE / DELETE

-- 1. ENAME(emp) / DNAME (detp)
SELECT DISTINCT deptno FROM emp; -- 10,20,30
SELECT deptno FROM dept;

SELECT ename,dname
FROM emp,dept
WHERE emp.deptno(+)=dept.deptno;
-- dept-emp 
SELECT ename,dname
FROM emp RIGHT OUTER JOIN dept
ON emp.deptno=dept.deptno;
-- emp-dept => 
SELECT ename,dname
FROM emp LEFT OUTER JOIN dept
ON emp.deptno=dept.deptno;

SELECT * FROM sawon;

UPDATE sawon SET
deptno=85
WHERE empno=1100;

SELECT ename,dname
FROM sawon,dept 
WHERE sawon.deptno(+)=dept.deptno
ORDER BY empno ASC;

/*
   int[] emp={1,2,3,4,5};
   int[] dept={1,2,3,4,6};
   for(int i=0;i<emp.lenght;i++)
   {
      for(int j=0;j<dept.lenght;j++)
      {
         if(emp[i]==dept[j])
         {
            1 2 3 4
         }
         => 5
      }
   }
*/

select * from dept;