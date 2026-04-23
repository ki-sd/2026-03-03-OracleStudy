package com.sist.dao;
import java.util.*;

import com.sist.commons.DBUtil;
import com.sist.vo.BoardVO;

import java.sql.*;
public class BoardDAO {
	private DBUtil db=new DBUtil();
	private Connection conn;
	private PreparedStatement ps;
	private static BoardDAO dao;  // 싱글턴
	public static BoardDAO newInstance() {
		if(dao==null)
			dao=new BoardDAO();
		return dao;
	}
	// 기능 => 목록
	public List<BoardVO> board_list(int page) {
		List<BoardVO> list=
				new ArrayList<BoardVO>();
		try {
			conn=db.getConnection();
			// SQL문장 오라클로 전송
			String sql="SELECT /*+ INDEX_DESC(board board_no_pk)*/ no,subject,name,TO_CHAR(regdate,'YYYY-MM-DD'),hit "
					+"FROM board "
					+"OFFSET ? ROWS FETCH NEXT 10 ROWS ONLY";
			int start=(page*10)-10;
			// 전송
			ps=conn.prepareStatement(sql);
			// ? 값을 채워줌
			ps.setInt(1, start);
			// 실행 => 결과값
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {  //출력 첫 위치로 커서 이동
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
			db.disConnection(conn, ps);
		}
		return list;
	}
	// 총페이지 => CEIL
	public int boardTotalPage() {
		int total=0;
		try {
			// 1.연결
			conn=db.getConnection();
			// 2.SQL문장을 만든다
			String sql="SELECT CEIL(COUNT(*)/10.0) as total FROM board";
			// 3.오라클로 전송
			ps=conn.prepareStatement(sql);
			// 4.?가 있는 경우 => 값을 채운다
			ResultSet rs=ps.executeQuery();
			// 5.출력된 메모리 위치 커서를 이동
			rs.next();
			// 6.해당 데이터형을 이용해 데이터를 갖고온다
			// NUMBER, VARCHAR2, CLOB, DATE
			//                         getDate()
			//         --------------- getString()
			// ------정수 getInt(),실수 getDouble()
			total=rs.getInt("total");
			//               ------ 컬럼 인덱스번호, 컬럼명
			// MyBatis는 컬럼명으로 읽는다 (함수=>반드시 별칭)
			rs.close();
		}catch(Exception ex) {
			ex.printStackTrace();
		}
		finally {
			db.disConnection(conn, ps);
		}
		return total;
	}
	// 데이터 추가
	public void board_insert(BoardVO vo) {
		try {
			 //1. 연결 
			 conn=db.getConnection();
			 //2. SQL문장 만들기 
			 String sql="INSERT INTO board VALUES("
					     +"board_seq.nextval,?,?,?,?,"
					     +"SYSDATE,0)";
			 //3. 전송
			 ps=conn.prepareStatement(sql);
			 //4. 실행전에 ?에 값을 채운다 
			 ps.setString(1, vo.getName());
		     ps.setString(2, vo.getSubject());
		     ps.setString(3, vo.getContent());
			 ps.setString(4, vo.getPwd());
			 ps.executeUpdate(); // 데이터베이스 변경
			 // => COMMIT 포함 => 자바 AutoCommit()
			 // INSERT / UPDATE / DELETE 
			 // SELECT => executeQuery()
			 /*
			  *   INSERT
			  *   INSERT ==>error => 트랜잭션 
			  *   INSERT 
			  */
		}catch(Exception ex) {
			ex.printStackTrace();
		}
		finally {
			db.disConnection(conn, ps);
		}
	}
	// 상세보기
	public BoardVO board_detail(int no)
	   {
		   BoardVO vo=new BoardVO();
		   try
		   {
			   // 1. 연결 
			   conn=db.getConnection();
			   // 2. SQL문장 
			   String sql="UPDATE board SET "
					     +"hit=hit+1 "
					     +"WHERE no=?";
			   // 조회수 증가 
			   ps=conn.prepareStatement(sql);
			   ps.setInt(1, no);
			   ps.executeUpdate(); // commit 수행 
			   
			   // 실제 데이터 읽기 
			   sql="SELECT no,name,subject,content,hit,"
				  +"TO_CHAR(regdate,'YYYY-MM-DD HH24:MI:SS') "
				  +"FROM board "
				  +"WHERE no=?";
			   ps=conn.prepareStatement(sql);
			   ps.setInt(1, no);
			   ResultSet rs=ps.executeQuery();
			   rs.next();
			   // 값 채우기 
			   vo.setNo(rs.getInt(1));
			   vo.setName(rs.getString(2));
			   vo.setSubject(rs.getString(3));
			   vo.setContent(rs.getString(4));
			   vo.setHit(rs.getInt(5));
			   vo.setDbday(rs.getString(6));
			   rs.close();
		   }catch(Exception ex)
		   {
			   ex.printStackTrace();
		   }
		   finally
		   {
			   db.disConnection(conn, ps);
		   }
		   return vo;
	   }
//	public static void main(String[] args) {
//		BoardDAO dao=BoardDAO.newInstance();
//		List<BoardVO> list=dao.board_list(1);
//		for(BoardVO vo:list) {
//			System.out.println(
//					vo.getNo()+" "
//					+vo.getSubject()+" "
//					+vo.getName()+" "
//					+vo.getDbday()+" "
//					+vo.getHit());
//		}
//	}
}
