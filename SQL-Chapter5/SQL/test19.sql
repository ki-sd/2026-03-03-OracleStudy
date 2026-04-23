-- PL/SQL => FUNCTION / PROCEDURE / TRIGGER => 웹 개발자는 만들어진 내용을 사용
/*
	1.FUNCTION: 리턴값 존재 => SELECT 안에서 주로 사용
				=> 내장함수: SUBSTR,TRIM,RPAD,...
				=> 사용자 정의 함수(지원하지 않는 함수)
				=> INSERT/UPDATE/DELETE를 사용하지 않는다
				=> SELECT를 이용한다
				=> 계산,변환,조회
							--- JOIN데이터
				       ---- 날짜,숫자 변환
				   --- ROW단위계산
	2.PROCEDURE: 작업 수행용(리턴형이 없다)
				 => 데이터변경/트랜잭션 처리
				 => 공통으로 적용되는 기능(댓글,좋아요,찜하기)
										--- 웹에서 적용
	3.TRIGGER: 테이블에서 이벤트(사건)가 발생 => 다른 테이블의 데이터 변경
			   => INSERT, UODATE,DELETE
			   => 반드시 테이블이 다른 경우에만 적용
			   => 입고 = 재고, 출고 = 재고
			   => 맛집 = 좋아요
			   => 자동화
*/