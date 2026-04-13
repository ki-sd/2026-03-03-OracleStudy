--Chapter 2장 => 관계 데이터 모델
/*
	테이블 : 데이터를 저장한 단위(파일)
	---------- 릴레이션
	구조 : 이차원 형식
		ROW / COLUMN
		
		----------------------------
		    no    name      sex ===> column : 중복이 있으면 안된다 => class 멤버변수
		----------------------------
		     1     홍길동    남자===> row : 멤버변수의 초기화 : 객체
		----------------------------
		     3     심청이    여자
		----------------------------
		     2     박문수    남자
		----------------------------
		=> 순서는 관계 없다  (column  )
		 
		(회원 1 홍길동 남자)
		(회원 2 박문수 남자)
		(회원 3 심청이 여자)
		
		int[] no={1,2,3};
		String[] name={...};
		String[] sex={    ,    };
		
		테이블(릴레이션)
		: 관련된 데이터를 한곳에 모아서 관리가 쉽게 => List
		: 테이블은 한개의 데이터베이스 안에서 유일 값이다
		: 클래스 => 멤버변수 , 테이블 => 컬럼
					|  			 |
					---------------------
		:컬럼은 순서가 없다 (학번,이름,학년...)  이름, 학년 , 학번
		:데이터 순서가 없다 ==> 단점(번호가 섞이는 경우도 있다)
						   정렬 : ORDER BY (사용하지 않는다) => 인덱스

		*** 릴레이션 = 테이블 => 데이터를 저장하는 하나의 테이블
		   -------------
		     컬럼
		     튜플(ROW)
		     도메인 : 컬럼이 가지고 있는 데이터
			 
	    ***73p
		속성은 단일 값이다 id => aaa,bbb=>aaa
		속성은 중복이 없다 (속성 = 컬럼)
		속성은 순서 상관없다
		튜플도 순서가 없다
		----- 중복이 가능이 가능 => 구분이 안된다(가급적이면 중복없는 데이터 포함)
		----- 번호 / ID
		----- 생성 => CREATE TABLE / INSERT / UPDATE / DELETE / SELECT
		   *** 데이터 무결성 / 참조 무결성
		                     ---------
						  | 이미 사용중인 데이터를 참조할 수 있게 만든다 : FOREIGN KEY
		      ----------
		      | 이상 현상을 방지 (수정 , 추가 , 삭제) => 원하는 않는 데이터가 변경
		      | 반드시 중복이 없는 데이터 포함 : PRIMARY KEY
		
		***78p 키의 종류      
		1. 각 데이터를 구별하기 위한 값
		   기본키(데이터 구분자) => 배열 / List => 인덱스
		   PRIMARY KEY => 유일 값 => 번호 (자동 증가)
		   영화번호 / 맛집번호 / 레시피 번호 / 게시물 번호...
		   CREATE SEQUENCE ...
		   => 데이터 무결성 목적으로 반드시 한개 이상이 존재
		2. 후보키
		   기본키가 될 수 있는 키
		   => ID(PK) : 주민번호(보안X) => 전화번호 , 이메일
								--------------------- NULL UNIQUE
		3. 대체키
		    후보키중에 기본키로 선택이 안된 키
		    => 이메일 , 주민번호 => 동사무소 , 은행 ...

		4. 외래키 : 참조 무결성
		   다른 테이블의 기본키를 이용해서 연결 : Foreign KEY
		   게시판 === 댓글 (게시판 번호 포함)
		   회원    === 예약(ID참조)
		   카테고리 === 맛집
		   학생 === 성적목록
		   테이블끼리 연결이 되는 키
		5. 슈퍼키 / 대리키 ...
		  
		***90p
		관계 대수 : 데이터를 찾는 방법
			1. 셀렉션 => 조건에 맞는 데이터를 찾는 경우
					   WHERE(조건)
			2. 프로젝션 : => 출력에 필요한 컬럼만 선택
			3. 조인 : 서로 다른 테이블을 연결해서 사용
			4. 집합연산지 : 합집합 / 교집합 / 차집합 
*/
--    셀렉션  
/*
	emp	
EMPNO                                     NOT NULL NUMBER 		사번	===> 정수(8자리)
 ENAME                                     NOT NULL VARCHAR2(50)	사원명 ==> 문자열 50byte 까지
 JOB                                       NOT NULL VARCHAR2(50)	직위
 HIREDATE                                  NOT NULL DATE			입사일 ==> 날짜형
 SAL                                       NOT NULL NUMBER(10,2)	급여	  ==> 소수점 2자리 사용이 가능(double)
 DEPTNO                                    NOT NULL NUMBER		부서번호
*/
/*SELECT *
FROM emp
WHERE deptno=5;
*/
/*
SELECT empno,ename,job 
FROM emp;
*/
/*
CREATE TABLE dept
(
  deptno NUMBER PRIMARY KEY,
  dname VARCHAR2(20),
  loc VARCHAR(20)
);
INSERT INTO dept VALUES(1,'개발부','서울');
INSERT INTO dept VALUES(2,'영업부','경기');
INSERT INTO dept VALUES(3,'기획부','강원');
INSERT INTO dept VALUES(4,'총무부','제주');
INSERT INTO dept VALUES(5,'자재부','인천');
INSERT INTO dept VALUES(6,'비서부','대구');
COMMIT;
*/
-- 각 사원의 사번 / 이름 / 직위/  부서명 / 근무지
--equals join / non equals join / outer join(left outer join / right outer join)
--inner(동등 조인)
/*
SELECT empno,ename,job,dname,loc
FROM emp,dept
WHERE emp.deptno=dept.deptno;
*/
/*
SELECT empno,ename,job,dname,loc
FROM emp,dept
WHERE emp.deptno(+)=dept.deptno;
*/
/*
SELECT *
FROM orders;
*/
/*
CREATE TABLE test1(
	no NUMBER
);
CREATE TABLE test2(
	no NUMBER
);
INSERT INTO test1 VALUES(1);
INSERT INTO test1 VALUES(2);
INSERT INTO test1 VALUES(3);
INSERT INTO test1 VALUES(4);
INSERT INTO test1 VALUES(5);

INSERT INTO test2 VALUES(4);
INSERT INTO test2 VALUES(5);
INSERT INTO test2 VALUES(6);
INSERT INTO test2 VALUES(7);
INSERT INTO test2 VALUES(8);
COMMIT;
*/
/*
   UNION ALL: 1 2 3 4 5 4 5 6 7 8 (둘 값을 모두)
   UNION: 1 2 3 4 5 6 7 8 (둘 값에서 중복제거하고 모두)
   INTERSECT: 4 5 (교집합)
   MINUS: A-B(1 2 3) / B-A(6 7 8) (차집합) 
*/
SELECT * FROM test1
UNION ALL
SELECT * FROM test2;

SELECT * FROM test1
UNION
SELECT * FROM test2;

SELECT * FROM test1
INTERSECT
SELECT * FROM test2;

SELECT * FROM test1
MINUS
SELECT * FROM test2;

SELECT * FROM test2
MINUS
SELECT * FROM test1;