package com.sist.dao;
// Oracle 연결 => 사용자 요청
import java.util.*; // 데이터 묶어서 => 윈도우/브라우저로 전송

import com.sist.vo.BoardVO;

// List<BoardVO>
                    // BoardVO => 게시물 한개에 대한 정보
import java.sql.*; // Connection / PreparedStatement / ResultSet
public class BoardDAO {
	private Connection conn; // 오라클 연결
	private PreparedStatement ps; // SQL 전송 => 결과값 읽기
	// ResultSet => SQL문장에 따라 메모리 크기 달라짐
	private static BoardDAO dao; // 싱글턴
	// Connection 생성 조절
	private static final String URL="jdbc:oracle:thin:@localhost:1521:XE";
	
	// 드라이버 등록 => 한번만 수행 => 한번 호출 (생성자)
	public BoardDAO() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			// 리플렉션 => 클래스 이름으로 제어 (메모리 할당, 메서드 호출, 변수 값 추가, ....)
			// 스프링 => invoke()
		}catch(Exception ex) {
			ex.printStackTrace();
		}
	}
	// 연결
	public void getConnection() {
		try {
			conn=DriverManager.getConnection(URL,"hr","happy");
		}catch(Exception ex) {}
	}
	// 닫기
	public void disConnection() {
		try {
			if(ps!=null) ps.close();
			if(conn!=null) conn.close();
		}catch(Exception ex) {}
	}
	// 싱글턴 => 스프링 디폴트
	public static BoardDAO newInstance() {
		if(dao==null)
			dao=new BoardDAO();
		return dao;
	}
	// -------------------------------------------- 공통사항
	// 기능
	// 1. 목록 => 페이징
	public List<BoardVO> boardListData(int page){
		List<BoardVO> list=new ArrayList<BoardVO>();
		try {
			//연결
			getConnection();
			//SQL
			String sql="SELECT no,subject,name,TO_CHAR(regdate,'YYYY-MM-DD') as dbday,hit "
					+"FROM board "
					+"ORDER BY no DESC "
					+"OFFSET ? ROWS FETCH NEXT 10 ROWS ONLY";
			ps=conn.prepareStatement(sql);
			// ?에 값을 채운다
			int rowSize=10;
			int start=(page*rowSize)-rowSize;
			// 1p => 0  2p => 10
			ps.setInt(1, start);
			// 실행후 결과값 받기
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				BoardVO vo=new BoardVO();
				vo.setNo(rs.getInt(1));
				vo.setSubject(rs.getString(2));
				vo.setName(rs.getString(3));
				vo.setDbday(rs.getString(4));
				vo.setHit(rs.getInt(5));
				list.add(vo);
			}
			rs.close();
		}catch(Exception ex) {
			ex.printStackTrace();
		}
		finally {
			disConnection();
		}
		return list;
	}
	// 1-1. 총페이지 구하기
	public int boardTotalPage() {
		int total=0;
		try {
			// 연결
			getConnection();
			// SQL문장
			String sql="SELECT CEIL(COUNT(*)/10.0) FROM board";
			ps=conn.prepareStatement(sql);
			ResultSet rs=ps.executeQuery();
			rs.next();
			total=rs.getInt(1);
			rs.close();
		}catch(Exception ex) {
			ex.printStackTrace();
		}finally {
			//오라클 닫기
			disConnection();
		}
		return total;
	}
	// 2. 상세보기 => WHERE / 조회수 증가
	// 3. 글쓰기 => INSERT
	// 4. 수정 => UPDATE
	// 5. 삭제 => DELETE
	// 6. 찾기 => LIKE
}
