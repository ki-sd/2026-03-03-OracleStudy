package com.sist.dao;
// DB연결 => 요청 데이터 검색 / 수정 / 삭제 / 추가
import java.util.*;
import java.sql.*;
public class SawonDAO {
	// 연결
	private Connection conn;
	// 송수신
	private PreparedStatement ps;
	// 싱글턴
	private static SawonDAO dao;
	// 오라클 주소
	private static final String URL="jdbc:oracle:thin:@localhost:1521:XE";
	// 1.드라이버 등록 => 한번 수행
	public SawonDAO() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver"); //메모리 할당
			// 리플렉션 => 클래스 이름으로 제어 (메모리 저장, 변수값, 메서드)
			// ojdbc8.jar
		}catch(Exception ex) {
			ex.printStackTrace();
		}
	}
	// 2. 싱글턴 => 사용자 한명 => Connection 한개씩만 사용
	public static SawonDAO newInstance() {
		if(dao==null)
			dao=new SawonDAO();
		return dao;
	}
	// 3. 오라클 연동
	public void getConnection() {
		try {
			conn=DriverManager.getConnection(URL,"hr","happy");
			// conn hr/happy => SQLPlus
		}catch(Exception ex) {}
	}
	// 4. 오라클 닫기
	public void disConnection() {
		try {
			if(ps!=null)ps.close();
			if(conn!=null)conn.close();
			//exit
		}catch(Exception ex) {}
	}
	///////////////////// ===> 모든 DAO 공통
	/// 로그인 => COUNT
	/// 사원 목록 => 페이징 => ROWNUM
	/// 상세보기 => 사번
	/// 통계 처리 => GROUP BY
}
