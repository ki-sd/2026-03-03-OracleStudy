SELECT LENGTH('ABC'),LENGTH('홍길동'),
       LENGTHB('ABC'),LENGTHB('홍길동')
FROM DUAL;

SELECT ename,UPPER(ename),LOWER(ename),INITCAP(ename)
FROM emp;
-- 실제 => 자바 조절 => toUpperCase()
SELECT * FROM emp
WHERE ename=UPPER('scott');

--replace
SELECT 'Hello Java',REPLACE('Hello Java','a','b')
FROM DUAL;
SELECT 'Hello Java',REPLACE('Hello Java','Java','Oracle')
FROM DUAL;

--trim
SELECT ' Hello Oracle',LTRIM(' Hello Oracle')
FROM DUAL;
SELECT 'Hello Oracle ',RTRIM('Hello Oracle ')
FROM DUAL;
SELECT 'aaaaaaHello Oracleaaaaaaaa',LTRIM('aaaaaaHello Oracleaaaaaaaa','a')
FROM DUAL;
SELECT 'HTML Hello Oracle HTML',LTRIM('HTML Hello Oracle HTML','HTML')
FROM DUAL;
SELECT 'aaaaaaHello Oracleaaaaaaaa',RTRIM('aaaaaaHello Oracleaaaaaaaa','a')
FROM DUAL;
SELECT 'HTML Hello Oracle HTML',RTRIM('HTML Hello Oracle HTML','HTML')
FROM DUAL;
SELECT '        Hello Oracle          ',TRIM('        Hello Oracle          ')
FROM DUAL;
-- TRIM: 문자열 제거가 안됨 => 문자(char) 1개만 가능
SELECT 'aaaaaaHello Oracleaaaaaaaa',TRIM('a' FROM 'aaaaaaHello Oracleaaaaaaaa')
FROM DUAL;

-- ASCII / CHR
SELECT ASCII('A'),CHR(65)
FROM DUAL;

SELECT hiredate 
FROM emp
WHERE SUBSTR(hiredate,1,2)=81;
-- 날짜는 문자열 형식으로 저장
SELECT hiredate 
FROM emp
WHERE hiredate LIKE '81%';

-- SUBSTR
/*
    ORACLE
    123456
*/
SELECT SUBSTR('ORACLE',1,3)
FROM DUAL;
SELECT SUBSTR('ORACLE',3,2)
FROM DUAL;

-- 사원 이름 => ename / emp
-- KING => KI**
SELECT ename, RPAD(SUBSTR(ename,1,2),LENGTH(ename),'*')
FROM emp;

-- INSTR
SELECT INSTR('Hello Java','a',1,2)
FROM DUAL;
-- -1은 뒤에서부터
SELECT INSTR('Hello Java','a',-1,2)
FROM DUAL;

-- CONCAT
SELECT CONCAT('Hello ','Oracle')
FROM DUAL;

-- 응용
SELECT ename,hiredate,sal
FROM emp
WHERE ename LIKE '__O__';

SELECT ename,hiredate,sal
FROM emp
WHERE INSTR(ename,'O',1,1)=3;

-- 1,1은 생략 가능
SELECT ename,hiredate,sal
FROM emp
WHERE INSTR(ename,'O')=3;

--숫자 함수
-- MOD
-- 사원(emp)중 사번이 짝수인 사람 출력
SELECT *
FROM emp
WHERE MOD(empno,2)=0;
--ROUND
-- 사원 급여 평균
SELECT ROUND(AVG(sal),2)
FROM emp;
SELECT TRUNC(AVG(sal),2)
FROM emp;
-- CEIL은 정수형
SELECT CEIL(AVG(sal))
FROM emp;

SELECT ename,ROUND(MONTHS_BETWEEN(SYSDATE,hiredate)/12) "YEAR"
FROM emp;

--SYSDATE : 등록일
SELECT SYSDATE-1,SYSDATE,SYSDATE+1
FROM DUAL;

--LAST_DAY
SELECT LAST_DAY('26/02/01')
FROM DUAL;

--NEXT_DAY
SELECT NEXT_DAY(SYSDATE,'수')
FROM DUAL;

--ADD_MONTHS : 개월수 추가
SELECT ADD_MONTHS(SYSDATE,6)
FROM DUAL;
SELECT ADD_MONTHS('26/03/03',7)
FROM DUAL;

-- 원화 표시는 앞에 L자
SELECT ename,TO_CHAR(sal,'L999,999')
FROM emp;

SELECT hiredate,TO_CHAR(hiredate,'YYYY/MM/DD HH24:MI:SS DAY')
FROM emp;
SELECT hiredate,TO_CHAR(hiredate,'RRRR/MM/DD HH24:MI:SS DAY')
FROM emp;

-- TO_DATE
SELECT TO_DATE('2026-04-15','YYYY-MM-DD')
FROM DUAL;
SELECT TO_DATE('20260415','YYYYMMDD')
FROM DUAL;
SELECT TO_DATE('04-15-2026','MM-DD-YYYY')
FROM DUAL;
SELECT TO_DATE('2026-04-15 14:14:49','YYYY-MM-DD HH24:MI:SS')
FROM DUAL;

SELECT SYSDATE,TO_CHAR(SYSDATE,'YYYY"년" MM"월" DD"일"')
FROM DUAL;
-- 날짜 계산 ==> 날짜형(DATE)로 변환 후 +,-
SELECT TO_DATE('2026-04-10','YYYY-MM-DD')+5
FROM DUAL;
-- 웹 => 문자열 : 알림 : WebSocket+Stormp(Pinia)
--        카프카 : 안정적
-- NVL
SELECT empno,ename,job,mgr,hiredate,sal,NVL(comm,0)as comm,deptno
FROM emp;
-- comm이 null값이면 성과급없음
SELECT empno,ename,job,mgr,hiredate,sal,NVL(TO_CHAR(comm),'성과급없음')as comm,deptno
FROM emp;

CREATE TABLE board
(
	no NUMBER PRIMARY KEY,
	name VARCHAR2(20) NOT NULL
);
INSERT INTO board 
VALUES((SELECT NVL(MAX(no)+1,1) FROM board),'aaa');
SELECT * FROM board;
DROP TABLE board;

-- DECODE
SELECT ename,DECODE(deptno,
                    10,'영업부',
                    20,'개발부',
                    30,'총무부',
                    40,'기획부') as dname
FROM emp;

SELECT DECODE(deptno,
                10,'★☆☆☆☆',
                20,'★★☆☆☆',
                30,'★★★☆☆',
                40,'★★★★☆',
                50,'★★★★★') as star
FROM emp;

SELECT ename,sal,DECODE(TRUNC(sal/1000),
                        0,'LOW',
                        1,'LOW',
                        2,'MID',
                        3,'HIGH',
                        'TOP') as grade
FROM emp;   

-- CASE
SELECT ename,deptno,sal,
        CASE deptno
            WHEN 10 THEN sal*0.1
            WHEN 20 THEN sal*0.2
            WHEN 30 THEN sal*0.3
            ELSE 0
        END as bonus
FROM emp;
-- 분류 => 범위
SELECT ename,hiredate,
        CASE
         WHEN hiredate<TO_DATE('1982-01-01','YYYY-MM-DD') THEN 'OLD'
         ELSE 'NEW'
        END as type
FROM emp;        

SELECT COUNT(*) "인원수",
       SUM(sal) "급여 총합",
       AVG(sal) "급여 평균",
       MAX(sal) "최고 급여",
       MIN(sal) "최저 급여"
FROM emp
WHERE deptno=10;
SELECT COUNT(*) "인원수",
       SUM(sal) "급여 총합",
       AVG(sal) "급여 평균",
       MAX(sal) "최고 급여",
       MIN(sal) "최저 급여"
FROM emp
WHERE deptno=20;
SELECT COUNT(*) "인원수",
       SUM(sal) "급여 총합",
       AVG(sal) "급여 평균",
       MAX(sal) "최고 급여",
       MIN(sal) "최저 급여"
FROM emp
WHERE deptno=30;

SELECT * FROM emp
ORDER BY deptno ASC;

SELECT deptno, 
       COUNT(*) "인원수",
       SUM(sal) "급여 총합",
       AVG(sal) "급여 평균",
       MAX(sal) "최고 급여",
       MIN(sal) "최저 급여"
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;

-- 연도별
SELECT TO_CHAR(hiredate,'DAY'),
       COUNT(*) "인원수",
       SUM(sal) "급여 총합",
       AVG(sal) "급여 평균",
       MAX(sal) "최고 급여",
       MIN(sal) "최저 급여"
FROM emp
GROUP BY TO_CHAR(hiredate,'DAY')
ORDER BY TO_CHAR(hiredate,'DAY') ASC;
-- 직위별
-- 관리자 페이지 / 마이 페이지 => 통계
SELECT job,
       COUNT(*) "인원수",
       SUM(sal) "급여 총합",
       AVG(sal) "급여 평균",
       MAX(sal) "최고 급여",
       MIN(sal) "최저 급여"
FROM emp
GROUP BY job
ORDER BY job ASC;
-- 복합 컬럼
SELECT deptno,job,
       COUNT(*) "인원수",
       SUM(sal) "급여 총합",
       AVG(sal) "급여 평균",
       MAX(sal) "최고 급여",
       MIN(sal) "최저 급여"
FROM emp
GROUP BY deptno,job
ORDER BY deptno ASC;

-- Having
SELECT deptno,SUM(sal)
FROM emp
GROUP BY deptno
HAVING SUM(sal)>=5000; -- 집계함수 이용

/*
CREATE TABLE sawon (
empno NUMBER(5) PRIMARY KEY,
ename VARCHAR2(30) NOT NULL,
gender CHAR(1) CHECK (gender IN ('M','F')),
address VARCHAR2(50),
age NUMBER(3) CHECK (age BETWEEN 20 AND 60),
position VARCHAR2(20) CHECK (position IN ('사원','대리','과장','차장','부장')),
location VARCHAR2(30),
salary NUMBER(10,2) CHECK (salary > 0),
phone VARCHAR2(20) UNIQUE,
intro VARCHAR2(100),
deptno NUMBER(2) NOT NULL,
hire_date DATE
);
INSERT INTO sawon
SELECT
1000 + LEVEL AS empno,

CASE LEVEL
WHEN 1 THEN '김민준' WHEN 2 THEN '이서연' WHEN 3 THEN '박지훈'
WHEN 4 THEN '최유진' WHEN 5 THEN '정우진' WHEN 6 THEN '강민서'
WHEN 7 THEN '조현우' WHEN 8 THEN '윤지우' WHEN 9 THEN '장동현'
WHEN 10 THEN '한서진' WHEN 11 THEN '오지훈' WHEN 12 THEN '서예은'
WHEN 13 THEN '신동혁' WHEN 14 THEN '배지수' WHEN 15 THEN '문성민'
WHEN 16 THEN '김하늘' WHEN 17 THEN '이준호' WHEN 18 THEN '박서연'
WHEN 19 THEN '최민준' WHEN 20 THEN '정다은'
WHEN 21 THEN '김도윤' WHEN 22 THEN '이유진' WHEN 23 THEN '박준영'
WHEN 24 THEN '최지우' WHEN 25 THEN '정하윤' WHEN 26 THEN '강지훈'
WHEN 27 THEN '조예린' WHEN 28 THEN '윤서준' WHEN 29 THEN '장민서'
WHEN 30 THEN '한지민'
WHEN 31 THEN '오세훈' WHEN 32 THEN '서준혁' WHEN 33 THEN '신유진'
WHEN 34 THEN '배민준' WHEN 35 THEN '문지우' WHEN 36 THEN '김서준'
WHEN 37 THEN '이하은' WHEN 38 THEN '박시우' WHEN 39 THEN '최준서'
WHEN 40 THEN '정민재'
WHEN 41 THEN '강서연' WHEN 42 THEN '조민준' WHEN 43 THEN '윤하늘'
WHEN 44 THEN '장서준' WHEN 45 THEN '한유진' WHEN 46 THEN '오지민'
WHEN 47 THEN '서지훈' WHEN 48 THEN '신예준' WHEN 49 THEN '배서연'
WHEN 50 THEN '문하윤'
WHEN 51 THEN '김지훈' WHEN 52 THEN '이서윤' WHEN 53 THEN '박민준'
WHEN 54 THEN '최유나' WHEN 55 THEN '정지훈' WHEN 56 THEN '강민준'
WHEN 57 THEN '조서연' WHEN 58 THEN '윤지훈' WHEN 59 THEN '장유진'
WHEN 60 THEN '한민서'
WHEN 61 THEN '오하늘' WHEN 62 THEN '서지민' WHEN 63 THEN '신민준'
WHEN 64 THEN '배유진' WHEN 65 THEN '문지훈' WHEN 66 THEN '김예준'
WHEN 67 THEN '이민서' WHEN 68 THEN '박서준' WHEN 69 THEN '최하윤'
WHEN 70 THEN '정서준'
WHEN 71 THEN '강지민' WHEN 72 THEN '조하은' WHEN 73 THEN '윤민준'
WHEN 74 THEN '장유나' WHEN 75 THEN '한지훈' WHEN 76 THEN '오민서'
WHEN 77 THEN '서유진' WHEN 78 THEN '신지훈' WHEN 79 THEN '배민서'
WHEN 80 THEN '문서준'
WHEN 81 THEN '김하윤' WHEN 82 THEN '이준서' WHEN 83 THEN '박지민'
WHEN 84 THEN '최민서' WHEN 85 THEN '정서윤' WHEN 86 THEN '강하늘'
WHEN 87 THEN '조유진' WHEN 88 THEN '윤지민' WHEN 89 THEN '장민준'
WHEN 90 THEN '한서윤'
WHEN 91 THEN '오지훈' WHEN 92 THEN '서민서' WHEN 93 THEN '신하윤'
WHEN 94 THEN '배지훈' WHEN 95 THEN '문유진' WHEN 96 THEN '김서윤'
WHEN 97 THEN '이하준' WHEN 98 THEN '박민재' WHEN 99 THEN '최유진'
ELSE '정지민'
END AS ename,

CASE WHEN MOD(LEVEL,2)=0 THEN 'M' ELSE 'F' END AS gender,

CASE MOD(LEVEL,8)
WHEN 0 THEN '서울 강남구'
WHEN 1 THEN '서울 송파구'
WHEN 2 THEN '부산 해운대구'
WHEN 3 THEN '대구 수성구'
WHEN 4 THEN '인천 남동구'
WHEN 5 THEN '광주 서구'
WHEN 6 THEN '대전 유성구'
ELSE '울산 남구'
END AS address,

23 + MOD(LEVEL, 25) AS age,

CASE
WHEN LEVEL <= 20 THEN '사원'
WHEN LEVEL <= 45 THEN '대리'
WHEN LEVEL <= 70 THEN '과장'
WHEN LEVEL <= 90 THEN '차장'
ELSE '부장'
END AS position,

'본사' AS location,

3000 + (LEVEL * 38) AS salary,

'010-2026-' || LPAD(LEVEL,4,'0') AS phone,

CASE MOD(LEVEL,6)
WHEN 0 THEN '책임감 있고 성실한 직원입니다.'
WHEN 1 THEN '팀워크가 뛰어나 협업에 강합니다.'
WHEN 2 THEN '문제 해결 능력이 우수한 인재입니다.'
WHEN 3 THEN '빠른 적응력과 실행력을 갖추고 있습니다.'
WHEN 4 THEN '분석력과 기획력이 뛰어난 인재입니다.'
ELSE '조직 내 신뢰도가 높은 직원입니다.'
END AS intro,

MOD(LEVEL,3)*10 + 10 AS deptno,

TRUNC(SYSDATE - DBMS_RANDOM.VALUE(0, 3650)) AS hire_date

FROM dual
CONNECT BY LEVEL <= 100;

CREATE TABLE dept (
    deptno   NUMBER(2) PRIMARY KEY,
    dname    VARCHAR2(30) NOT NULL,
    loc      VARCHAR2(50) NOT NULL
);

INSERT INTO dept VALUES (10, '인사팀', '서울 강남구');
INSERT INTO dept VALUES (20, '개발팀', '서울 송파구');
INSERT INTO dept VALUES (30, '기획팀', '부산 해운대구');
INSERT INTO dept VALUES (40, '영업팀', '대구 수성구');
INSERT INTO dept VALUES (50, '마케팅팀', '인천 남동구');
INSERT INTO dept VALUES (60, '재무팀', '광주 서구');
INSERT INTO dept VALUES (70, 'IT운영팀', '대전 유성구');
INSERT INTO dept VALUES (80, '데이터팀', '울산 남구');
INSERT INTO dept VALUES (90, '고객지원팀', '수원 영통구');
INSERT INTO dept VALUES (99, '경영지원실', '서울 중구');
commit;
*/

SELECT * FROM sawon;
SELECT * FROM dept;

-- 직위별로 통계
SELECT position,
       COUNT(*) "인원수",
       SUM(salary) "급여 총합",
       AVG(salary) "급여 평균",
       MAX(salary) "최고 급여",
       MIN(salary) "최저 급여"
FROM sawon
GROUP BY position
ORDER BY position;

-- 나이별 통계
SELECT age,
       COUNT(*) "인원수",
       SUM(salary) "급여 총합",
       AVG(salary) "급여 평균",
       MAX(salary) "최고 급여",
       MIN(salary) "최저 급여"
FROM sawon
GROUP BY age
ORDER BY age;

DESC sawon;


SELECT ename,comm
FROM emp
WHERE comm IS NOT NULL;