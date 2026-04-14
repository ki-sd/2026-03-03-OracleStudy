-- 오라클 2일차 => WHERE / ORDER BY 
-- WHERE 조건 => 연산자 / 정확한 검색 => 내장 함수 (단일함수,집계함수)
-- 145page 
-- GROUP BY / JOIN / SubQuery => SELECT 
-- DDL (Table) => INSERT / UPDATE / DELETE 
-- 고급 : View / Index / Sequence / PL/SQL 
-- 데이터베이스 설계 (ER-MODEL) / 정규화 
-- 트랜잭션 / 보안 / 복원 / 백업 
/*
     오라클 : 경우의 수가 많다 (SQL문장 여러개가 존재)
     => 결과값 출력 / 최적화 
     프로젝트 : => 가장 간단한 거 => 어려운  ==> 리팩토링 / 코드리뷰 => AI
     개발자 => 계속 코딩 / 변경 ...
     => 구현 
     SQL : 구조화된 질의언어 
             ---------- 문장형식으로 제작 : 순서 / 형식 
                          ---------- 여러개를 사용할 수 있다 => 본인 스타일을 만든다 
     = DML : 데이터 조작언어 
                 SELECT  : 데이터 검색 (70%) 
                 INSERT : 데이터 추가 
                 UPDATE : 데이터 수정 
                 DELETE : 데이터 삭제 
     = DDL : 데이터 정의 언어 => TABLE (데이터 저장장소) => 파일
                                              View (가상테이블) => 보안 / 간순한 쿼리 
                                              => SELECT~
                                              SEQUENCE : 자동 증가 (PRIMARY KEY)
                                              INDEX : 검색 , 정렬 => 속도의 최적화 
                                              => PL/SQL : 호불호 => 재사용 => ERP
                                              => 댓글 
                                              FUNCTION : 사용자 정의 함수 
                                              PROCEDURE : 사용자 정의 함수 => 기능 
                                              TRIGGER : 자동화 처리 
                 CREATE : 생성 
                 DROP : 삭제 
                 ALTER : 수정 
                 TRUNCATE : 데이터만 잘라내기 
                 RENAME : 이름 변경 
                 -----------------------------------> 제약조건 (키) 
     =   DCL : 권한부여 / 해제 
                  GRANT : 권한 부여 
                  REVOKE : 권한 해제 ==> View / INDEX / 시노님 => 권한이 없다  
     =  TCL : 정상 저장 / 모든 명령 취소 => 일괄 처리 
                                                           ----------- 트랜잭션 
                 COMMIT : 정상적으로 저장 
                 ROLLBACK : 명령 취소 
                 SAVEPOINT : 지정된 위치 부터 취소 

    1.  SELECT : 데이터 검색 
        = 형식/순서 
           필수 
           --------------------------------------------------------------------------
           SELECT * | column_list(원하는 컬럼만 선택) 
           FROM table_name | view_name | SELECT ~~ (인라인뷰) => 패이징 
           --------------------------------------------------------------------------
           [
                WHERE 조건 
                GROUP BY  그룹컬럼 
                HAVING 그룹에 대한 조건 => 반드시 GROUP BY 동반 
                ORDER BY 컬럼 (ASC|DESC)
                                      ------ default (생략이 가능)  
           ]
        = 처리 순서 
           FROM - WHERE - GROUP BY - HAVING - SELECT - ORDER BY 
        -------------------------------------------------
         데이터베이스   :  폴더  
        -------------------------------------------------
         테이블 : 파일 
        -------------------------------------------------
         컬럼 : 멤버변수 
        -------------------------------------------------
         ROW(Tuple) : 인스턴스 => 객체 (초기화)
        -------------------------------------------------
        ** 컬럼으로 구분 : 관리가 쉽다 
        ** 명령어 => 읽기 / 쓰기가 편리 
        ** 조건 => 검색 => WHERE 컬럼명 연산자 값  => if문 
                                                        --------
*/
-- SELECT 사용법
/*
    1. 전체 데이터 읽기 ========> *
    2. 출력에 필요한 내용만 읽기 ===> column_list
    3. 중복이 없이 출력 ====> DISTINCT 
    4. 별칭 => MyBatis (함수)  컬럼 "" , 컬럼 as 별칭
    5. 문자열 결합 ====> ||
    6. 문법 사항
       대소문자 구분은 없다 / 실제 저장된 데이터는 대소문자 구분
       문장이 종료되면 반드시 ;을 사용한다 
           => 자바에서는 ;을 사용하면 안된다 (자동 추가)
       약속 : 키워드는 대문자로 사용 
*/
-- 가급적이면 사용하지 않는다 => SQL튜닝 
--SELECT * 
--FROM book; 
-- 출력에 필요없는 내용 => 자바에서 사용 => setXxx를 이용해서 
-- 모든값을 받는다 
-- null값인 경우의 문제 => 출력시에 null 
--SELECT bookname,price 
--FROM book;
/*
SELECT * 
FROM zipcode;
SELECT zipcode,sido,gugun,dong,NVL(bunji,' ')
FROM zipcode
*/
-- 장르 / 부서명 / 직위 
--SELECT DISTINCT publisher
--FROM book;
--SELECT bookname||'은 출판사가 '||publisher||'입니다' "msg"
--FROM book;
--SELECT bookname||'은 출판사가 '||publisher||'입니다' as msg
--FROM book;
/*
     WHERE : 조건 검색 => 가장 많이 사용되는 키워드 
                 ----------- true/false 
                 | 연산자 => 149page 

     1. 산술연산자 ( + , - , * , / ) ==> 나머지(X) => 함수 (MOD())
          + : 순수하게 덧셈만 가능 
          / : 0으로 나누면 오류 발생 
              정수/정수=실수  => 5/2 = 2.5
          SELECT 뒤에서 주로 사용 
          *** 연습용 테이블 : DUAL 
     2. 비교연산자  ==> true/false => WHERE절 뒤에 (조건) 
          = (같다) 
          != (같지 않다) , <>(권장) , ^=
          < (작다)
          > (크다)
          <= (작거나 같다)
          >= (크거나 같다)
          *** 숫자(정수,실수) , 문자열 , 날짜 ==> 'YY/MM/DD'
     3. 논리연산자 ==> true / false => WHERE절 뒤에 (조건) 
          AND => &&를 사용하면 안된다 (&는 입력값을 받는 경우에 사용) 
          OR   => || (문자열 결합)
          NOT => ! 
          NOT IN / NOT BETWEEN , NOT LIKE 
          !IN() ==> 오류 
          AND / OR 
                    | 미포함인 경우 
          | 포함된 경우 

           (조건) AND (조건)
            |                |
            --------------
               | 최종결과 
            (조건) OR (조건)
            |                |
            --------------
               | 최종결과 

     ---------------------------------------------------------------
     4. BETWEEN ~ AND ==> true/false ==> 페이징 기법 
        => AND를 대체하는 연산자 
        WHERE 컬럼 BETWEEN 값1 AND 값2 
         ==> 값1과 값2 사이의 값 
         ==>  컬럼>=값1 AND 컬럼<=값2 
                         --                     --
                          |                      |
                          ------------------- 포함 
     5. IN 
        => OR여러개 대체 
        예) 
              부서번호가 10 20 30
              SELECT * 
              FROM emp 
              WHERE deptno=10 OR deptno=20 OR deptno=30

              SELECT *
              FROM emp 
              WHERE deptno IN(10,20,30)
          => 다중 조건 : checkbox
     ***6. IS NULL , IS NOT NULL  ==> ifnull 
            null 값은 연산처리시 결과값이 null이다 
            comm=null (X) 
            comm IS NULL 
            comm IS NOT NULL 
            이미지가 없는 맛집 => 이미지없음 
     7. LIKE  => SELECT문장 핵심은 검색  => 패턴 
        유사 문자열 검색 
            % : 문자의 갯수를 모르는 경우 
            _  : 문자 한글자 
        => contains  ===> %검색어% 
        => startsWith ==> 검색어%
        => endsWith ===> %검색어 
        ==> 5글자 가운데 C  ===> __C__
        ==> 3글자 A    A__
        ==> REGEXP_LIKE() => 정규식 
        WHERE ename LIKE '%A%' OR ename LIKE '%B%' ename LIKE '%C%'
        WHERE REGEXP(ename ,'[A-Z]') => 함수 
        사용자 대신 => SQL문장을 만들어서 처리 => 웹 개발자 
        
    ---------------------------------------------------------------- 자바에 존재하지 않는다 
    
*/
-- SELECT 사용법
/*
    1. 전체 데이터 읽기 ========> *
    2. 출력에 필요한 내용만 읽기 ===> column_list
    3. 중복이 없이 출력 ====> DISTINCT 
    4. 별칭 => MyBatis (함수)  컬럼 "" , 컬럼 as 별칭
    5. 문자열 결합 ====> ||
    6. 문법 사항
       대소문자 구분은 없다 / 실제 저장된 데이터는 대소문자 구분
       문장이 종료되면 반드시 ;을 사용한다 
           => 자바에서는 ;을 사용하면 안된다 (자동 추가)
       약속 : 키워드는 대문자로 사용 
*/
-- 가급적이면 사용하지 않는다 => SQL튜닝 
SELECT * 
FROM book; 
-- 출력에 필요없는 내용 => 자바에서 사용 => setXxx를 이용해서 
-- 모든값을 받는다 
-- null값인 경우의 문제 => 출력시에 null 
SELECT bookname,price 
FROM book;
/*
SELECT * 
FROM zipcode;
SELECT zipcode,sido,gugun,dong,NVL(bunji,' ')
FROM zipcode
*/
-- 장르 / 부서명 / 직위 
SELECT DISTINCT publisher
FROM book;
SELECT bookname||'은 출판사가 '||publisher||'입니다' "msg"
FROM book;
SELECT bookname||'은 출판사가 '||publisher||'입니다' as msg
FROM book;

SELECT 10+5 , 10-5 , 10*5 , 10/3 
FROM DUAL;
-- Integer.parseInt() => 속도가 늦어진다 
SELECT TO_NUMBER('10')+5,'10'-5,'10'*5,null/3
FROM DUAL;

-- emp 사원 => 이달의 총급여? => sal / comm => sal+comm
-- 연산자 처리 => null값이 있는 경우 => 모든 연산이 null이다
SELECT ename , sal , NVL(comm,0) , sal+NVL(comm,0) "총급여"
FROM emp;
/*
    오라클의 단점 => 산술연산자
*/
-- 사원 총연봉
SELECT ename, sal*12 "연봉"
FROM emp;

SELECT ename, (sal*12)/12 "급여"
FROM emp;

-- 비교연산자 
/*
     emp 
       = empno 사번 
       = ename 이름 
       = job  직위 
       = mgr  사수사번 
       = hiredate 입사일
       = sal 급여
       = comm 성과급 
       = deptno 부서번호 ==> 부서정보 (테이블)
       = 오라클에서 제공하는 연습용 테이블 
     book : 교재 
       = bookid : 책번호 => ISBN
       = bookname : 책이름 
       = publisher : 출퍈사 
       = price : 가격 
*/
-- 1. 급여가 1500 이상인 사원의 모든 목록을 출력 
-- >=1500
SELECT *
FROM emp
WHERE sal>=1500;
-- 2. 급여가 3000인 사원의 이름 , 입사일 , 직위 , 급여 
SELECT ename,hiredate,job,sal 
FROM emp 
WHERE sal=3000;

-- 3. 직위가 CLERK이 아닌 사원의 모든 출력 
SELECT * 
FROM emp
WHERE job!='CLERK';
-- 표준 => 권장  (!= 개발자 호환)
SELECT * 
FROM emp
WHERE job<>'CLERK';

SELECT * 
FROM emp
WHERE job^='CLERK';

-- 81이전에 입사한 사원의 모든 정보 출력 
SELECT * 
FROM emp 
WHERE hiredate<'81/01/01'; -- YY/MM/DD

-- 문자열 / 숫자 / 날짜 => 비교연산자 이용 
-- book 테이블 가격이 20000미만인 책 정보 전체 출력 
SELECT *
FROM book
WHERE price<20000;
-- AND 범위지정 
-- emp => 입사일 => 81년에 입사한 사원의 모든 정보 출력 
SELECT * 
FROM emp
WHERE hiredate>='81/01/01' AND hiredate<='81/12/31';

SELECT * 
FROM emp
WHERE hiredate<'81/01/01' OR hiredate>'81/12/31';
/*
    예약일 / 예약일이 아닌 날
*/
SELECT * 
FROM emp
WHERE NOT (hiredate>='81/01/01' AND hiredate<='81/12/31');
/*
SELECT * 
FROM emp
WHERE TO_CHAR(hiredate,'YY')=81;

SELECT * 
FROM emp
WHERE SUBSTR(hiredate,1,2)=81;
*/
-- 직위(job) CLERK , 이름 SMITH => ID/PWD => 로그인 처리 
SELECT *
FROM emp
WHERE job='CLERK' AND ename='SMITH';

-- 부서번호 10 이거나 / 직위 MANAGER
SELECT * 
FROM emp
WHERE deptno=10 OR job='MANAGER';

SELECT * 
FROM emp
WHERE deptno=10 OR job='manager';
-- 저장된 데이터는 대소문자 구분 

SELECT * 
FROM emp
WHERE ename='KING';

/*
    대입 연산자  : =
    구분 => WHERE에서 사용 (같다) 
    WHERE외에서 사용 => 대입 
    UPDATE 
      ename='홍길동'
*/
-- BETWEEN ~ AND 
-- emp테이블에서 급여 1500이상 3000이하 
SELECT *
FROM emp
WHERE sal>=1500 AND sal<=3000;

SELECT *
FROM emp
WHERE sal BETWEEN 1500 AND 3000;

-- book => price : 10000이산 30000이하 
SELECT *
FROM book
WHERE price BETWEEN 10000 AND 30000;
-- 아닌 책 
SELECT *
FROM book
WHERE price NOT BETWEEN 10000 AND 30000;

-- IN
/*
     사원이름 : KING , SMITH , SCOTT를 검색 
*/
SELECT *
FROM emp
WHERE ename='KING' OR ename='SMITH' OR ename='SCOTT';

SELECT * 
FROM emp
WHERE ename IN('KING','SMITH','SCOTT');

-- book publisher => 굿스포츠 , 대한미디어에서 출판한 모든 책 정보
SELECT * 
FROM book
WHERE publisher NOT IN('굿스포츠','대한미디어');

-- null 처리 
-- 성과급이 없는 사원의 모든 정보 
SELECT *
FROM emp 
WHERE comm IS NULL;
-- 성과급이 있는 사원 
SELECT *
FROM emp 
WHERE comm IS NOT NULL AND comm<>0;

-- 자바 / 오라클 
-- LIKE 
-- 이름중에 A를 포함 
SELECT ename 
FROM emp
WHERE ename LIKE '%A%';
-- A자로 시작하는 이름 
SELECT ename 
FROM emp
WHERE ename LIKE 'A%';

-- EN / LN으로 끝나는 이름 
SELECT ename 
FROM emp
WHERE ename LIKE '%EN' OR ename LIKE '%IN';

-- 5글자 가운데 O
SELECT ename 
FROM emp
WHERE ename LIKE '__O__';

SELECT ename 
FROM emp
WHERE ename LIKE '__A%';

-- %검색어%

-- 검색용 => LIKE 

-- bookname => 축구가 포함된 책 정보 출력 
-- 두번째 글자가 '구'자인 책제목 출력 
SELECT * 
FROM customer
WHERE phone IS NULL;
-- 

-- 산술연산자 
--SELECT 10+5 , 10-5 , 10*5 , 10/3 
--FROM book;
-- 범위 , 기간 => BETWEEN ~ AND 




