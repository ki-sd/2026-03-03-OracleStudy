-- FUNCTION 연습
CREATE TABLE student(
    hakbun NUMBER PRIMARY KEY,
    name VARCHAR2(51) NOT NULL,
    kor NUMBER(3),
    eng NUMBER(3),
    math NUMBER(3)
);
CREATE SEQUENCE std_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
    
INSERT INTO student VALUES(std_seq.nextval,'홍길동',90,87,78);
INSERT INTO student VALUES(std_seq.nextval,'심청이',75,89,67);
INSERT INTO student VALUES(std_seq.nextval,'박문수',78,89,56);
INSERT INTO student VALUES(std_seq.nextval,'이순신',73,82,80);
INSERT INTO student VALUES(std_seq.nextval,'강감찬',67,89,90);
COMMIT;
/*
    Function 형식
    CREATE [OR REPLACE] FUNCTION func_name(매개변수)
    RETURN 데이터형(NUMBER,VARCHAR2,CLOB,DATE)
    IS
      지역변수
    BEGIN
      기능 처리
      RETURN 값
    END;
    /
*/
SELECT hakbun,name,kor,eng,math,(kor+eng+math) "total",
    ROUND((kor+eng+math)/3.0,2) "avg"
FROM student;
-- Column단위는 통계 있음 / ROW 단위는 통계 없음
CREATE OR REPLACE FUNCTION studentTotal(
    pHakbun student.hakbun%TYPE
)RETURN NUMBER
IS
    pSum NUMBER;
BEGIN
    SELECT kor+eng+math INTO pSum
    FROM student
    WHERE hakbun=phakbun;
    RETURN pSum;
END;
/

SELECT hakbun,name,kor,eng,math,studentTotal(hakbun)
FROM student;
-- 회사 실적 => 분기별 / 부서별 => ERP
CREATE OR REPLACE FUNCTION studentAvg(
    pHakbun student.hakbun%TYPE
)RETURN NUMBER
IS
    pAvg NUMBER;
BEGIN
    SELECT ROUND((kor+eng+math)/3.0,2) INTO pAvg
    FROM student
    WHERE hakbun=phakbun;
    RETURN pAvg;
END;
/

SELECT hakbun,name,kor,eng,math,studentTotal(hakbun) "TOTAL",
        studentAvg(hakbun) "AVG"
FROM student;
-- 계산식에서 주로 사용
-- JOIN에서
/*
    INNER JOIN (=) / OUTER JOIN(LEFT,RIGHT)
    oracle JOIN 보다는 ANSI JOIN 사용 => SQL튜닝
*/
SELECT empno,ename,hiredate,job,sal,dname,loc
FROM emp JOIN dept
ON emp.deptno=dept.deptno
ORDER BY sal DESC;

CREATE OR REPLACE FUNCTION deptGetDname(
    pDeptNo dept.deptno%TYPE
) RETURN VARCHAR2
IS
    pDname dept.dname%TYPE;
BEGIN
-- dname을 가지고 온다 => JOIN없이 사용 가능
    SELECT dname INTO pDname
    FROM dept
    WHERE deptno=pDeptNo;
    RETURN pDname;
END;
/
/*
    JSP / Spring-Boot : JDBC => MyBatis: selectList(sql)
                                JPA: findByName() => WHERE name=' '
    => Front-End
*/
-- 스칼라 서브쿼리
SELECT empno,ename,hiredate,job,sal,deptGetDname(deptno) "DEPT"
FROM emp;
-- 예약  /  결제
SELECT * FROM orders;

CREATE OR REPLACE FUNCTION ordersGetCustName(
    vCustId customer.custid%TYPE
) RETURN VARCHAR2
IS
    vCustName customer.name%TYPE;
BEGIN
    SELECT name INTO vCustName
    FROM customer
    WHERE custid=vCustId;
    RETURN vCustName;
END;
/

CREATE OR REPLACE FUNCTION ordersGetBookName(
    vBookId book.bookid%TYPE
) RETURN VARCHAR2
IS
    vBookName book.bookname%TYPE;
BEGIN
    SELECT bookname INTO vBookName
    FROM book
    WHERE bookid=vBookId;
    RETURN vBookName;
END;
/

SELECT orderid,ordersGetCustName(custid) "CUSTOMER", ordersGetBookName(bookid) "BOOK", saleprice, orderdate
FROM orders;

SELECT orderid,name,bookname,saleprice,orderdate
FROM orders JOIN customer
ON orders.custid=customer.custid
JOIN book
ON orders.bookid=book.bookid;

SELECT orderid,
        (SELECT name FROM customer WHERE custid=orders.custid) "CUSTOMER",
        (SELECT bookname FROM book WHERE bookid=orders.bookid) "BOOK",
        saleprice,orderdate
FROM orders;

-- JOIN, 스칼라 서브쿼리 대신 => 함수화
-- 변환
CREATE OR REPLACE FUNCTION dateChange(
    pEmpno emp.empno%TYPE
)RETURN VARCHAR2
IS
    pDate VARCHAR2(30);
BEGIN
    SELECT TO_CHAR(hiredate,'YYYY-MM-DD HH24:MI:SS') INTO pDate
    FROM emp
    WHERE empno=pEmpno;
    RETURN pDate;
END;
/
-- 급여 인상 / 연봉 ...
SELECT empno,ename,dateChange(empno) "HIREDATE"
FROM emp;

-- 삭제
DROP FUNCTION studentTotal;
DROP FUNCTION studentAvg;
DROP FUNCTION deptGetDname;
DROP FUNCTION ordersGetBookName;
DROP FUNCTION ordersGetCustName;
DROP FUNCTION dateChange;

/*
    생성: CREATE FUNCTION
    삭제: DROP FUNCTION func_name
    수정: CREATE OR REPLACE FUNCTION
    
    ROW 단위 계산
    JOIN / 스칼라 서브쿼리
    데이터 변환
    => SELECT 뒤에서 호출 / RETURN 값을 가지고 있어야 한다
    => INSERT/UPDATE/DELETE 안됨 (가능은 하지만 굳이 안씀)
       -------------------- PROCEDURE: 웹 적용
       
    함수: 재사용 => 반복적인 SQL문장이 있는 경우
                         --------
                         |감추는 경우 (보안)
    => 오라클: 보안(인라인뷰, 프로시저...,VIEW)
    => 최적화: INDEX
    => CI/CD => war/jar
*/