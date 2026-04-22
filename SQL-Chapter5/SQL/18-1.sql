/*
        PL/SQL = 변수 처리 방법
*/
SET SERVEROUTPUT ON;
DECLARE
    -- 일반 변수 사용
    vempno NUMBER(4);
    vename VARCHAR2(20);
    vjob VARCHAR2(20);
    vhiredate DATE;
BEGIN
    -- 구현
    SELECT empno,ename,job,hiredate
        INTO vempno, vename, vjob, vhiredate
    FROM emp
    WHERE empno=7788;
    
    -- 변수 출력
    -- System.out.println()
    DBMS_OUTPUT.PUT_LINE('******* 결과 ********');
    DBMS_OUTPUT.PUT_LINE('사번:'||vempno);
    DBMS_OUTPUT.PUT_LINE('이름:'||vename);
    DBMS_OUTPUT.PUT_LINE('직위:'||vjob);
    DBMS_OUTPUT.PUT_LINE('입사일:'||vhiredate);
END;
/

-- %TYPE: 가장 많이 사용되는 변수
-- 사용 방식: 테이블명.컬럼명%TYPE
/*
    ***1.DML (게시판)
    ***2.JOIN / SUBQUERY (지니뮤직, 멜론)
    3.PROCEDURE
    
CUSTID  NOT NULL NUMBER(2)    
NAME             VARCHAR2(40) 
ADDRESS          VARCHAR2(50) 
PHONE            VARCHAR2(20) 

    main()   DECLARE
    {        BEGIN
    }        END
*/
DESC customer;
DECLARE
    -- 변수 선언 = 테이블에 존재하는 실제 컬럼의 데이터형 읽기
    vcustid customer.custid%TYPE;
    vname customer.name%TYPE;
    vaddress customer.address%TYPE;
    vphone customer.phone%TYPE;
BEGIN
    -- 값을 채움
    SELECT custid,name,address,phone
    INTO vcustid,vname,vaddress,vphone
    FROM customer
    WHERE custid=1;
    -- ROW단위 => 값은 하나만 받을수있음
    -- 화면 출력
    DBMS_OUTPUT.PUT_LINE('******* 결과 ********');
    DBMS_OUTPUT.PUT_LINE('번호:'||vcustid);
    DBMS_OUTPUT.PUT_LINE('이름:'||vname);
    DBMS_OUTPUT.PUT_LINE('주소:'||vaddress);
    DBMS_OUTPUT.PUT_LINE('전화:'||vphone);
END;
/

-- 한개의 테이블의 컬럼 전체 데이터형 읽기 => %ROWTYPE
-- 변수 테이블명%ROWTYPE ==> 구조체(java의 클래스)

DECLARE
    vemp emp%ROWTYPE;
BEGIN
    SELECT *
    INTO vemp
    FROM emp
    WHERE empno=&사번;
    
    DBMS_OUTPUT.PUT_LINE('******* 결과 ********');
    DBMS_OUTPUT.PUT_LINE('사번:'||vemp.empno);
    DBMS_OUTPUT.PUT_LINE('이름:'||vemp.ename);
    DBMS_OUTPUT.PUT_LINE('직위:'||vemp.job);
    DBMS_OUTPUT.PUT_LINE('입사일:'||vemp.hiredate);
    DBMS_OUTPUT.PUT_LINE('급여:'||vemp.sal);
    DBMS_OUTPUT.PUT_LINE('부서번호:'||vemp.deptno);
END;
/
-- 사용자 정의 데이터형 RECORD => JOIN된 테이블에서 갖고올때 => DBA
-- %TYPE / CURSOR
/*
    형식)
        => 자바의 VO
        => TYPESCRIPT: interface
        TYPE record명 IS RECORD(
            변수 설정
        );
        RECORD 변수 선언  =>  ROW 1개만 받을 수 있다
*/
DECLARE
    -- 레코드 선언
    TYPE empDept IS RECORD(
        empno emp.empno%TYPE,
        ename emp.ename%TYPE,
        job emp.job%TYPE,
        hiredate emp.hiredate%TYPE,
        sal emp.sal%TYPE,
        dname dept.dname%TYPE,
        loc dept.loc%TYPE,
        grade salgrade.grade%TYPE
    );
    -- RECORD 변수 선언
    ed empDept;
BEGIN
    -- 데이터값 채우기 => INNER JOIN (교집합) => ANSI
    SELECT empno,ename,job,hiredate,sal,dname,loc,grade
    INTO ed
    FROM emp JOIN dept ON emp.deptno=dept.deptno
    JOIN salgrade ON sal BETWEEN losal AND hisal
    WHERE empno=&사번;
    
    DBMS_OUTPUT.PUT_LINE('******* 결과 ********');
    DBMS_OUTPUT.PUT_LINE('사번:'||ed.empno);
    DBMS_OUTPUT.PUT_LINE('이름:'||ed.ename);
    DBMS_OUTPUT.PUT_LINE('직위:'||ed.job);
    DBMS_OUTPUT.PUT_LINE('입사일:'||ed.hiredate);
    DBMS_OUTPUT.PUT_LINE('급여:'||ed.sal);
    DBMS_OUTPUT.PUT_LINE('부서:'||ed.dname);
    DBMS_OUTPUT.PUT_LINE('근무지:'||ed.loc);
    DBMS_OUTPUT.PUT_LINE('급여등급:'||ed.grade);
    
END;
/
/*
        제어문 => 연산자
        PL/SQL
            연산자
              1) 산술연산자: +, -, *, /
              2) 비교연산자: =, <>, <, >, <=, >=
              3) 논리연산자: AND, OR, NOT
              4) NULL: IS NULL, IS NOT NULL
              5) BETWEEN ~ AND
              6) LIKE
              7) IN
             내장 함수
              1) 문자 함수
                 SUBSTR / INSTR / LENGTH
              2) 숫자 함수
                 CEIL / ROUND / MOD
              3) 날짜 함수
                 SYSDATE / MONTHS_BETWEEN
              4) 변환 함수
                 TO_CHAR / TO_DATE
              5) 기타 함수
                 NVL / CASE
              6) 집계 함수
                 COUNT / SUM / AVG / MAX 
                 
                 
             ===> 제어문
             단일 조건문
               = 독립적
               = 형식 ====> {}블록이 없다
                 IF 조건문 THEN 처리문장
                 END IF;
             다중 조건문
                 IF 조건문 THEN 처리문장
                 ELSIF 조건문 THEN 처리문장
                 ELSIF 조건문 THEN 처리문장
                 ELSIF 조건문 THEN 처리문장
                 ...
                 ELSE 처리문장
                 END IF;
             선택 조건문
                 IF 조건문 THEN 처리문장
                 ELSE 처리문장
                 END IF;
             일반 반복문
             WHILE
             FOR
             ----------------------------------- 중심: SQL
*/
-- 단일 조건문
-- 초기값 int a=10 ===> vempno emp.empno%TYPE:=값
DECLARE
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE:=&empno;
    vdname dept.dname%TYPE;
BEGIN
    SELECT ename,job,deptno
    INTO vename,vjob,vdeptno
    FROM emp
    WHERE empno=vempno;
    
    IF (vdeptno=10)                -- 괄호는 선택 
    THEN vdname:='개발부';
    END IF;
    IF vdeptno=20 
    THEN vdname:='영업부';
    END IF;
    IF vdeptno=30 
    THEN vdname:='기획부';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('******* 결과 ********');
    DBMS_OUTPUT.PUT_LINE('이름:'||vename);
    DBMS_OUTPUT.PUT_LINE('직위:'||vjob);
    DBMS_OUTPUT.PUT_LINE('부서:'||vdname);
END;
/
-- 다중조건문
DECLARE
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE:=&empno;
    vdname dept.dname%TYPE;
BEGIN
    SELECT ename,job,deptno
    INTO vename,vjob,vdeptno
    FROM emp
    WHERE empno=vempno;
    
    IF (vdeptno=10) THEN 
        vdname:='개발부';
    ELSIF vdeptno=20 THEN 
        vdname:='영업부';
    ELSIF vdeptno=30 THEN 
        vdname:='기획부';
    ELSE
        vdname:='신입';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('******* 결과 ********');
    DBMS_OUTPUT.PUT_LINE('이름:'||vename);
    DBMS_OUTPUT.PUT_LINE('직위:'||vjob);
    DBMS_OUTPUT.PUT_LINE('부서:'||vdname);
END;
/
-- 선택문 CASE
DECLARE
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE:=&empno;
    vdname dept.dname%TYPE;
BEGIN
    SELECT ename,job,deptno
    INTO vename,vjob,vdeptno
    FROM emp
    WHERE empno=vempno;
    -- 다중 조건문보다 사용빈도 높음
    vdname:=CASE vdeptno
            WHEN 10 THEN '개발부'
            WHEN 20 THEN '영업부'
            WHEN 30 THEN '기획부'
            ELSE '신입'
            END;
    
    DBMS_OUTPUT.PUT_LINE('******* 결과 ********');
    DBMS_OUTPUT.PUT_LINE('이름:'||vename);
    DBMS_OUTPUT.PUT_LINE('직위:'||vjob);
    DBMS_OUTPUT.PUT_LINE('부서:'||vdname);
END;
/

-- IF ~ ELSE => true/false => 수행을 다르게 한다
/*
    IF 조건 THEN 처리문   => 조건이 true일떄
    ELSE 처리문          => 조건이 false일때
    END IF;
*/
SELECT * FROM emp;
DECLARE
    vename emp.ename%TYPE;
    vsal emp.sal%TYPE;
    vcomm emp.comm%TYPE;
    vempno emp.empno%TYPE:=&empno;
BEGIN
    SELECT ename,sal,comm
    INTO vename,vsal,vcomm
    FROM emp
    WHERE empno=vempno;
    -- NULL값이면 => ELSE  7654 7844 8566
    IF vcomm>0 THEN
        DBMS_OUTPUT.PUT_LINE(vename||'사원의 급여는 '||vsal||'이고 성과급은 '||vcomm||'입니다');
    ELSE
        DBMS_OUTPUT.PUT_LINE(vename||'사원의 급여는 '||vsal||'이고 성과급은 없습니다');
    END IF;
END;
/

/*
        조건문
          단일
             IF 조건 THEN 처리문장
             END IF;
          다중
             IF 조건문 THEN 처리문장
             ELSIF 조건문 THEN 처리문장
             ELSIF 조건문 THEN 처리문장
             ...
             ELSIF 조건문 THEN 처리문장
             END IF;
             
             CASE 컬럼
              WHEN 조건 THEN 처리문장
              WHEN 조건 THEN 처리문장
              WHEN 조건 THEN 처리문장
              ELSE 처리문장
              END;
          선택
             IF 조건 THEN 처리문장
             ELSE 처리문장
             END IF;
*/
/*
        반복문
          1. 기본 LOOP
             형식)
                 LOOP
                   처리문장
                   처리문장 => 빈복 수행 문장
                   EXIT[조건] => 종료  => do~while
                 END LOOP;
          2. WHILE
             형식)
                 WHILE 조건 LOOP
                    처리문장
                    처리문장
                    ...
                 END LOOP;
          ***3. FOR
             형식)
                 예)
                    FOR i IN 1..9 LOOP   => 1,2,3...8,9
                 FOR 변수 IN start..end LOOP
                    처리문장
                    ..
                 END LOOP;
                 
                    FOR i IN REVERSE 1..9 LOOP   => 9,8,7,..,2,1
                 FOR 변수 IN REVERSE start..end LOOP
                    처리문장
                    ..
                 END LOOP;
         => Function / Trigger / Procedure => 제작하지 않으면 쓸 일이 없다
         
       => CURSOR
       => 함수 / 트리거
*/
-- LOOP (do~while)
DECLARE
    sno NUMBER:=1; -- int i=1
    eno NUMBER:=10;
BEGIN
    LOOP
        -- 반복문 수행
        DBMS_OUTPUT.PUT_LINE(sno);
        -- 증가값 i++
        sno:=sno+1;
        -- 종료
        EXIT WHEN sno>eno;
    END LOOP;
END;
/

-- WHILE
DECLARE
    no NUMBER:=1;
BEGIN
    WHILE no<=10 LOOP
        DBMS_OUTPUT.PUT(no||' ');
        no:=no+1;
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
END;
/

-- FOR
DECLARE
BEGIN
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT(i||' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
END;
/

DECLARE
BEGIN
    FOR i IN REVERSE 1..10 LOOP
        DBMS_OUTPUT.PUT(i||' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
END;
/

-- 1~100까지 짝수합 / 홀수합 / 총합
DECLARE
    total NUMBER:=0;
    even NUMBER:=0;
    odd NUMBER:=0;
BEGIN
    FOR i IN 1..100 LOOP
        total:=total+i;
        IF MOD(i,2)=0 THEN
            even:=even+i;
        ELSE
            odd:=odd+i;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1~100 총합:'||total);
    DBMS_OUTPUT.PUT_LINE('1~100 짝수합:'||even);
    DBMS_OUTPUT.PUT_LINE('1~100 홀수합:'||odd);
END;
/
-- DECLARE : 선언부 = 재사용 할 수 없다
-- CREATE FUNCTION / CREATE TRIGGER / CREATE PROCEDURE
/*
    반복문 => 여러개의 ROW를 출력할때 사용
    
    CURSOR: ROW 여러개를 저장하는 공간
    1. 커서 선언
       CURSOR 커서명 IS
         SELECT ~~
    2. 커서 열기
       OPEN 커서명
    3. 커서 안에 데이터를 읽기 (추출)
       FETCH
    4. 출력
       DBMS_OUTPUT.PUT_LINE()
    5. 커서 닫기
       CLOSE 커서명
*/
DECLARE
    vemp emp%ROWTYPE;
    CURSOR cur IS
        SELECT * FROM emp;  -- 커서 선언
BEGIN
    OPEN cur;               -- 커서 열기
    LOOP
        FETCH cur INTO vemp; -- 커서 데이터 추출
        EXIT WHEN cur%NOTFOUND; -- 추출 종료(데이터가 없을때까지 추출)
        DBMS_OUTPUT.PUT_LINE(vemp.empno||' '||vemp.ename||' '||vemp.job);  -- 출력
    END LOOP;
    CLOSE cur;               -- 커서 닫기
END;
/
-- FOR문 이용 (for~each)
DECLARE
    vemp emp%ROWTYPE;
    CURSOR cur IS
        SELECT * FROM emp;
BEGIN
    FOR vemp IN cur LOOP
        DBMS_OUTPUT.PUT_LINE(vemp.empno||' '||vemp.ename||' '||vemp.job);
    END LOOP;
END;
/

/*
    PL/SQL문법
     => SQL문장을 그대로 사용 / 연산자 / 내장 함수
     => 문법 사항
     = 선언부
     DECLARE
     CREATE FUNCTION func_name(매개변수...)
     IS
       선언부 => 지역변수
     CREATE PROCEDURE proc_name(매개변수...)
     IS
       선언부 => 지역변수
     CREATE TRIGGER trigger_name
     IS
       선언부 => 지역변수
     = 구현부
     BEGIN
        SQL => 제어문(수행 => SQL문장)
        => INTO : 변수값을 받는 경우
        => SELECT : 화면 출력 (변수로 사용되는것이 아님)
     END;
     
     변수: %TYPE, 스칼라 변수, CURSOR
     제어문: IF / IF ~ ELSE / CASE / FOR
     형식)
          -------------------------------------
           IF 조건 THEN 
            처리문장
            처리문장
            ...
           END IF;
           
           IF 조건 THEN
            처리문장
           ELSE
            처리문장
           END IF;
           
           CASE 값
            WHEN 조건 THEN 값
            WHEN 조건 THEN 값
            WHEN 조건 THEN 값
            ...
            ELSE 값
           END;
           
           입고: 이미 저장된 상품 => UPDATE 수량 증가
                없는 상품 => INSERT
           출고: 남아 있는 상품 => UPDATE
                상품이 없는 경우 => DELETE
           -------------------------------------- TRIGGER
           FOR 변수 IN CURSOR LOOP    ==> for~each
            반복 처리 문장
           END LOOP;
           -------------------------------------- PROCEDURE
*/
        