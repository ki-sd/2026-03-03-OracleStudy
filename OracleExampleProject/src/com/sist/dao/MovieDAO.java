package com.sist.dao;
import com.sist.vo.MovieVO;
import java.sql.*;
import java.util.*;
/*
 *    1. 드라이버 등록
 *       연결 준비
 *       Class.forName("oracle.jdbc.driver.OracleDriver")
 *                      com.mysql.cj.driver.Driver
 *                      => mysql, mariadb
 *    2. 오라클 연결
 *    	 Connection conn=DriverManager.getConnection(URL,username,password)
 *       => conn hr/happy
 *       URL
 *        jdbc:업체명:드라이버종류:@IP:PORT:DB명
 *             oracle thin    localhost 1521 XE
 *    3. SQL문장 제작
 *       String sql="SELECT/INSERT/UPDATE/DELETE"
 *                 => mybatis: XML
 *                 => JPA: 메서드
 *    4. SQL문장을 오라클로 전송
 *       PreparedStatement ps=conn.preparedStatement(sql)
 *    5. 오라클 실행 => 결과값 받기
 *       ResultSet rs=ps.executeQuery() => SELECT
 *       int a=ps.executeUpdate() => INSERT/UPDATE/DELETE
 *    6. List/VO에 값 채우기
 *       list.add()
 *    7. 닫기
 *       ps.close() / conn.close()
 *       
 *       == 기능
 *       목록 : 사용자가 페이지 요청
 *             -------------- 매개변수
 *             20개
 *             1 ROW => VO => while
 *                    객체 저장 => List
 *             리턴형: List<MovieVO>
 *             매개변수: (int page)
 *       상세보기 : 사용자가 번호 요청
 *               ------------- 중복없는 데이터 => PRIMARY KEY
 *             리턴형: MovieVO
 *             매개변수: int mno
 *       검색 : 사용자가 검색어 요청
 *             리턴형: List<MovieVO>
 *             매개변수: 2개
 *                     String 검색유형(컬럼명), String 검색어
 */
/*
 *     자바
 *      => 변수(VO), 필요시 => 매개변수 / 지역변수
 *                          | 사용자 요청값
 *      => 연산자: 산술연산자, 대입연산자
 *      => 제어문: if / for / while
 *      => 배열 / List
 *               ---- VO를 모아서 전송
 *      => 객체지향 프로그램
 *         => 캡슐화: VO
 *         => 포함 => Connection / PreparedStatement
 *         => 오버라이딩
 *         => class / method
 *                    => 리턴형 / 매개변수
 *      => 예외처리
 *         try ~ catch
 *      => 라이브러리
 *         String / Math(ceil) / StringTokenizer
 *         Date / FileInputStream / FileOutputStream
 *         BufferedReader
 *         Connection / PreparedStatement / ResultSet
 *         ***List / Map
 *      ----------------------------------------------
 *      J2EE : 브라우저에서 값 받기 / 브라우저로 값 전송
 *      
 */
public class MovieDAO {
	// 1. 연결 객체
	private Connection conn;
	// 2. 송수신
	private PreparedStatement ps;
	// ResultSet => SQL문장에 따라 저장되는 데이터가 달라진다 => 지역변수로 사용
	// 3. URL
	private final String URL="jdbc:oracle:thin:@localhost:1521:XE";
	// MySQL / MariaDB => 3306
	// MSSQL => 1433 => 디폴트값 pub
	// 주의점 : 포트가 다를 수 있음
	// 드라이버 등록 => 한번만 설정
	private static MovieDAO dao;
	public MovieDAO() {
		// 연결만 : thin드라이버
		// 오라클에 있는 데이터를 드라이버에 설정 : OCI (유료)
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		}catch(Exception ex) {
			ex.printStackTrace();
		}
	}
	// 오라클 연결 => SQLPlus
	public void getConnection() {
		try {
			conn=DriverManager.getConnection(URL,"hr","happy");
		}catch(Exception ex) {}
	}
	// 오라클 닫기
	public void disConnection() {
		try {
			if(ps!=null)
				ps.close();
			if(conn!=null)
				conn.close();
		}catch(Exception ex) {}
	}
	// -------------------------------------------- 공통 사항 => 오라클 반드시 열고 닫기
	// 기능
	// 1.목록
	public List<MovieVO> movieListData(int page) {
		List<MovieVO> list=new ArrayList<MovieVO>();
		try {
			getConnection();
			String sql="SELECT mno,title,actor,regdate,genre "
					+"FROM movie "
					+"ORDER BY mno "
					+"OFFSET ? ROWS FETCH NEXT 20 ROWS ONLY";
			ps=conn.prepareStatement(sql);
			int start=(page*20)-20;
			ps.setInt(1, start);
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				// ROW 1개당 => VO ==> 20개
				MovieVO vo=new MovieVO();
				// ROW단위 => 저장
				vo.setMno(rs.getInt(1));
				vo.setTitle(rs.getString(2));
				vo.setActor(rs.getString(3));
				vo.setRegdate(rs.getString(4));
				vo.setGenre(rs.getString(5));
				// 전체 저장
				list.add(vo);
			}
			rs.close();
		}catch(Exception ex) {}
		finally {
			disConnection();
		}
		return list;
	}
	// 1-1. 총 페이지
	public int movieTotalPage() {
		int total=0;
		try {
			// 1.연결
			getConnection();
			// 2.SQL문장 만들기
			String sql="SELECT CEIL(COUNT(*)/20.0) "
					+"FROM movie";
			// 3.오라클 전송
			ps=conn.prepareStatement(sql);
			// 4. 실행 후 결과값 가지고오기
			ResultSet rs=ps.executeQuery();
			// 5. 데이터가 출력된 위치에 커서 올려두기
			rs.next();
			total=rs.getInt(1);
			rs.close();
		}catch(Exception ex) {
			ex.printStackTrace();
		}
		finally {
			disConnection();
		}
		return total;
	}
	// 2.상세보기
	public MovieVO movieDetailData(int mno) {
		MovieVO vo=new MovieVO();
		try {
			getConnection();
			String sql="SELECT mno,title,actor,genre,director,grade,regdate "
					+ "FROM movie "
					+ "WHERE mno=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, mno);
			ResultSet rs=ps.executeQuery();
			rs.next();
			vo.setMno(rs.getInt(1));
			vo.setTitle(rs.getString(2));
			vo.setActor(rs.getString(3));
			vo.setGenre(rs.getString(4));
			vo.setDirector(rs.getString(5));
			vo.setGrade(rs.getString(6));
			vo.setRegdate(rs.getString(7));
			rs.close();
			
		}catch(Exception ex) {}
		finally {
			disConnection();
		}
		return vo;
	}
	// 3.검색
	/*
	 *    검색이 안됨
	 *    String sql="SELECT * FROM movie "
	 *              +"WHERE ? LIKE '%'||?||'%'" => "WHERE "+col+" LIKE '%'||?||'%'"
	 *    ps.setString(1,col);
	 *    ps.setString(2,fd);
	 *    --------------------------- 실제값만 ?
	 *    table명 / 컬럼명은 문자열 결합
	 */
	public List<MovieVO> movieFindData(String col, String fd){
		List<MovieVO> list=new ArrayList<MovieVO>();
		try {
			getConnection();
			String sql="SELECT mno,title,actor,regdate,genre "
					+"FROM movie "
					+"WHERE "+col+" LIKE '%'||?||'%' "        // "WHERE "+col+" LIKE '%"+fd+"%'"
					+"ORDER BY mno";
			// 자바 => 오라클 SQL (LIKE)
			ps=conn.prepareStatement(sql);
			ps.setString(1, fd);
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				MovieVO vo=new MovieVO();
				vo.setMno(rs.getInt(1));
				vo.setTitle(rs.getString(2));
				vo.setActor(rs.getString(3));
				vo.setRegdate(rs.getString(4));
				vo.setGenre(rs.getString(5));
				list.add(vo);
			}
			rs.close();
		}catch(Exception ex) {}
		finally {
			disConnection();
		}
		return list;
	}
	
	
	public static MovieDAO newInstance() {
		if(dao==null)
			dao=new MovieDAO();
		return dao;
	}
	
}
