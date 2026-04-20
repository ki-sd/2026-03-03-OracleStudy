-- 237p 뷰(View)
/*
	1.하나이상의 테이블을 연결해 만든 가상테이블
	  --------------             --------- 데이터 저장이 안된다 (보안)
	2.장점
	   = 편리성: SQL문장을 간결하게 만들 수 있다
	   = 재사용
	   = 보안성: 데이터가 저장이 안된 상태
				=> SQL문장 (SELECT 문장)
	   = 응용프로그램(웹,애플리케이션) => 사용하기 편리하다, SQL문장이 간결하기 때문에 오류가 거의 없다
	   = JOIN이 많거나 서브쿼리가 많음 => SQL문장이 복잡해지는 경우 => View
	3.View 생성
	   = 단순뷰: 한개의 테이블 참조(사용빈도 거의 X)
	   = 복합뷰: 두개 이상의 테이블 연결(JOIN, 서브쿼리)
	   = 인라인뷰: 임시 테이블을 만들어서 처리(한번만 사용 가능=재사용X)
	4.View => 보여만 주는 역할(SELECT)
			  DML사용도 가능(INSERT,UPDATE,DELETE)
			  => 단순뷰에서만 가능
			  => 단점) view에서 DML이 되는게 아니고 참조하고있는 실제 테이블이 변경
			  => 옵션
			     WITH CHECK OPTION => DML이 가능
				 WITH READ ONLY => 읽기 전용 (DML불가)
	   저장된 내용 확인
	   ** SELECT text FROM user_views
	      WHERE view_name='대문자';
	5.생성(237p)
	  CREATE VIEW view_name   => View는 SELLECT~ 문장을 저장
	  AS
	    SELECT ~
	6.수정(239p)
	  CREATE OR REPLACE VIEW view_name
	         ----------
	  AS
	    SELECT ~
	  => DROP없이 수정 가능
	7.삭제(240p)
	  DROP VIEW view_name
	  
	= 한번 사용: 인라인뷰 (재사용X)
	= 여러군데에서 동시 사용 => 계속 같은 쿼리 사용: 저장=>VIEW
	
	서브쿼리 / 뷰 / 시퀀스 / 시노님
	              ----- PRIMARY KEY => 자동 증가
	서브쿼리
	 = 인라인뷰
		  :FROM절 뒤에 => 테이블 대신 (가상테이블)
		1.쿼리 실행중 임시 결과 집합을 만들어서 JOIN/가공
		2.일회성 => 저장이 안된다 => 보안
		3.GROUP BY / WHERE 사용이 불가능한 경우 => 인라인뷰 해결
		4.집계 결과를 다시 조건 필터링할때
		5.TOP-N / 페이징 처리
		6.복잡한 JOIN 단순화 => JOIN을 줄이는 경우
     = 스칼라 서브쿼리
	      :SELECT 뒤에 가상컬럼으로 사용
		1.결과값 1개, 컬럼 1개
		2. 각 ROW마다 실행 => 속도저하 => 데이터가 많은경우 JOIN 권장
		   => 대량 데이터에서 성능 주의
		3. JOIN보다는 직관적/소량 데이터, 캐시 가능한 경우
		                              ---- MyBatis/JPA
			대용량 => JOIN/인라인 뷰 주로 사용
	뷰
	   : 저장된 SELECT 쿼리 (가상테이블)
	   : 테이블 한개이상 참조
	   : 쿼리(SQL문장) DB에 저장
	   : 복잡한 쿼리 => 재사용 => 서브쿼리,JOIN => 실무에서는 정규화 => 테이블이 많이 나눠져있다 보통 7 이상 => View => 응용프로그램이 쉽다
	   : 여러 시스템에 동일 SQL 사용시 주로 생성
	     => 프로젝트가 여러개 => 묻고 답하기 / 계층형 게시판 / 대댓글
		 => 뷰 / PL/SQL => 프로시져로 제작
	   : 컬럼중 민감한 => 제외하고 공개 가능
	   : 분석툴에서 테이블 대신 뷰 사용하는 경향 ↑
	   = 사용처
	     = 반복되는 쿼리
		 = 보안 필요
		 = 시스템 간 공통 데이터 정의
		 = 가독성/유지보수
	   = 단점
	     = 남용시 성능 저하
		 = 복잡한 뷰 => 디버깅이 어려움
	   
	   뷰 생성 / 수정
	    CREATE OR REPLACE view_name
		AS
		 SELECT ~~ (JOIN)
		 
	   뷰 삭제
	    DROP VIEW view_name
		
	   권장
	    CREATE OR REPLACE view_name
		AS
		 SELECT ~~ WITH READ ONLY => 읽기 전용
		 
	***시퀀스: 자동 증가 번호
		 = 테이블에서 PRIMARY KEY 값을 설정
		 = PRIMARY KEY => ID 외 거의 모든 데이터는 숫자
		 = 게시물 번호, 맛집 번호, 영화 번호, 예약번호, 찜번호
		 = 중복 없는 값을 만들때
		 = 데이터 삭제 시 복원 X
		 생성
		  CREATE SEQUENCE seq_name
		   옵션 설정 => 시작번호, 증가량, 무한 설정...
		 삭제
		  DROP SEQUENCE seq_name
		 옵션
		  START WITH 1 => 1부터 시작
		  INCREMENT BY 1 => 1씩 증가 ===> 무한대
		  NOCYCLE => 무한정
		  NOCACHE => 미리 번호 생성 없이 처리
		 **독립적이다
		 **현재 값/다음 값
		          ------
				  seq_name.nextval => 초기값으로 돌아가려면 삭제후 다시 생성
		   -----
		   seq_name.currval
		 **테이블당 sequence는 1개 사용
		 **회원 제외 모든 테이블에 시퀀스 적용
		 
*/