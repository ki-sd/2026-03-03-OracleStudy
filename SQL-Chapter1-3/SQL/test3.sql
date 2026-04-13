-- Chapter 1 => 데이터베이스(발전과정)
-- Chapter 2 => 테이블 구성요소/데이터 추출법/데이터 모델
-- Chapter 3 => DQL(SELECT)
-- 테이블 여러개를 연결해서 데이터 추출 (JOIN,SubQuery)
-- Chapter 4 => DDL(테이블, 뷰, 인덱스, 시퀀스, 시노님)
-- Chapter 5 => SQL고급(내장함수), DML(INSERT,UPDATE,DELETE)
-- Chapter 6~7 => 데이터베이스 설계 (ER-모델,정규화)
-- Chapter 8 => 트랜잭션
-- Chapter 9 => 보안/백업/복원 => Admin
/*
SELECT empno,ename,job,dname,loc
FROM emp NATURAL JOIN dept;
SELECT empno,ename,job,dname,loc
FROM emp JOIN dept USING(deptno);*/

--3장 SQL 기초 (129p)
/*
    1.SELECT: 데이터 검색
	  = 형식/순서
	  = 연산자
	  = JOIN/SubQuery
*/
/*
RENAME emp TO emp2;
RENAME dept TO dept2;
*/
/*
     SELECT 문장 (142p)
	 1.데이터 검색
	 2.형식 / 순서
	  SELECT *(ALL) | 원하는 컬럼(column_list)
	  FROM table_name
	  -------------------- 필수
	  WHERE 조건(연산자)
	  GROUP BY 그룹컬럼
	  HAVING 그룹조건 ====> GROUP BY가 있는 경우에만 사용
	  ORDER BY 정렬컬럼 (ASC|DESC)
	  -------------------- 선택
	 3.주의점
	   = 대소문자 구분 X
	     (약속 => 키워드는 대문자로)
	   = 실제 저장된 데이터는 대소문자 구분 O
	   = 문장 종료 시 ; 사용
	     => 자바에서는 자동으로 ;이 추가됨
	   = 문자, 날짜는 반드시 ' '사용
	 
	 4.문자열 형식으로만 되어있음
	 5.날짜 형식 => 'YY/MM/DD' => '26/04/13'
	 6.중복없는 데이터
	   DISTINCT column
	 7.문자열결합 ||
	   ename ||'는 급여가 '||sal||'입니다' => 연산자에 ||,&& => OR, AND
	 8.& ==> Scanner ==> 크롤링(이미지 => http~~& => ^)
	 9.띄어쓰기 (FROM emp)
	   => 1 SELECT ~
	      2 ===> ;이 없는 경우
*/
-- SELECT * FROM emp
/*
 사원정보
 EMPNO  NOT NULL NUMBER(4) 사번
 ENAME  VARCHAR2(10) 이름
 JOB    VARCHAR2(9) 직위
 MGR    NUMBER(4) 사번
 HIREDATE  DATE 입사일
 SAL    NUMBER(7,2) 급여
 COMM   NUMBER(7,2) 성과급
 DEPTNO   NUMBER(2) 부서번호
*/
/*
     SQL => 문자열 형식 => String sql="";
	 --- 143p
	 1.DML: 데이터 조작언어
	  -----
	    SELECT:데이터 검색 => 테이블,뷰에서 검색 ***형식이 많이 존재
		----------------
		INSERT:데이터 추가
		UPDATE:데이터 수정
		DELETE:데이터 삭제
		----------------- COMMIT 필요
		
	 2.DDL: 데이터 정의언어
	   --- 테이블/뷰/시퀀스/인덱스/시노님/함수/프로시져,트리거
	    CREATE:생성
		DROP:삭제
		ALTER:변경
		TRUNCATE:데이터 잘라내기
		RENAME:이름변경
	 3.DCL: 데이터 제어언어
	   --- 권한
	    GRANT:권한부여
		REVOKE:권한해제
	 4.TCL: 트랜젝션 제어언어
	  ----
	    COMMIT:정상적으로 저장
		ROLLBACK:명령문 전체 취소
		SAVEPOINT:원하는 부분 취소
*/