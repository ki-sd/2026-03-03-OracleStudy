package com.sist.dao;
import java.sql.*;
import java.util.*;

import javax.swing.JOptionPane;

import com.sist.vo.*;
/*
 *    ***아이디 중복 체크
 *    ***우편번호 검색
 *    ***회원가입
 *    ***회원정보
 *    회원수정
 *    ***회원탈퇴
 */
public class MemberDAO {
	private Connection conn;
	private PreparedStatement ps;
	private final String URL="jdbc:oracle:thin:@localhost:1521:XE";
	
	public MemberDAO() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		}catch(Exception ex) {
			ex.printStackTrace();
		}
	}
	public void getConnection() {
		try {
			conn=DriverManager.getConnection(URL,"hr","happy");
		}catch(Exception ex) {}
	}
	public void disConnection() {
		try {
			if(ps!=null) ps.close();
			if(conn!=null) conn.close();
		}catch(Exception ex) {}
	}
	// 기능 => 우편번호 검색
	public List<ZipcodeVO> postFind(String dong){
		List<ZipcodeVO> list=new ArrayList<ZipcodeVO>();
		try {
			getConnection();
			String sql="SELECT zipcode,sido,gugun,dong,NVL(bunji,' ') "
					+ "FROM zipcode "
					+ "WHERE dong LIKE '%'||?||'%'";
						// CONCAT('%',?,'%')
			ps=conn.prepareStatement(sql);
			ps.setString(1, dong);
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				ZipcodeVO vo=new ZipcodeVO();
				vo.setZipcode(rs.getString(1));
				vo.setSido(rs.getString(2));
				vo.setGugun(rs.getString(3));
				vo.setDong(rs.getString(4));
				vo.setBunji(rs.getString(5));
				list.add(vo);
			}
			rs.close();
		}catch(Exception ex) {
			ex.printStackTrace();
		}finally {
			disConnection();
		}
		return list;
	}
	public int postFindCount(String dong){
		int count=0;
		try {
			getConnection();
			String sql="SELECT COUNT(*) "
					+ "FROM zipcode "
					+ "WHERE dong LIKE '%'||?||'%'";
						// CONCAT('%',?,'%')
			ps=conn.prepareStatement(sql);
			ps.setString(1, dong);
			ResultSet rs=ps.executeQuery();
			rs.next();
			count=rs.getInt(1);
			rs.close();
			// 검색 결과 갯수
		}catch(Exception ex) {
			ex.printStackTrace();
		}finally {
			disConnection();
		}
		return count;
	}
	// 아이디 증복
	public int memberIdCheck(String id) {
		int count=0;
		try {
			getConnection();
			String sql="SELECT COUNT(*) "
					+ "FROM member "
					+ "WHERE id=?";
			ps=conn.prepareStatement(sql);
			ps.setString(1, id);
			ResultSet rs=ps.executeQuery();
			rs.next();
			count=rs.getInt(1);
			rs.close();
		}catch(Exception ex) {
			ex.printStackTrace();
		}finally {
			disConnection();
		}
		return count;
	}
	// 회원 가입
	//ID      NOT NULL VARCHAR2(20)  
	//PWD     NOT NULL VARCHAR2(10)  
	//NAME    NOT NULL VARCHAR2(51)  
	//SEX              VARCHAR2(6)   
	//POST    NOT NULL VARCHAR2(7)   
	//ADDR1   NOT NULL VARCHAR2(200) 
	//ADDR2            VARCHAR2(200) 
	//PHONE            VARCHAR2(14)  
	//CONTENT          CLOB          
	//ISADMIN          CHAR(1)       
	//REGDATE          DATE    
	public int memberJoin(MemberVO vo) {
		int check=0;
		try {
			getConnection();
			// "'"+vo.getName()+"','"....
			String sql="INSERT INTO member VALUES(?,?,?,?,?,?,?,?,?,'n',SYSDATE)";
			ps=conn.prepareStatement(sql);
			ps.setString(1, vo.getId());
			ps.setString(2, vo.getPwd());
			ps.setString(3, vo.getName());
			ps.setString(4, vo.getSex());
			ps.setString(5, vo.getPost());
			ps.setString(6, vo.getAddr1());
			ps.setString(7, vo.getAddr2());
			ps.setString(8, vo.getPhone());
			ps.setString(9, vo.getContent());
			check=ps.executeUpdate();
		}catch(Exception ex) {
			ex.printStackTrace();
		}finally {
			disConnection();
		}
		return check;
	}
	// 로그인 => Admin: 관리자 / user: 마이페이지
	/*
	 *    경우의 수
	 *    1. 아이디가 없는경우         2개 => boolean
	 *    2. 비밀번호가 틀린 경우       3개이상 => int / String
	 *    3. 로그인 성공하는 경우
	 */
	public MemberVO isLogin(String id,String pwd) {
		MemberVO vo=new MemberVO();
		try {
			getConnection();
			String sql="SELECT COUNT(*) "
					+ "FROM member "
					+ "WHERE id=?";
			ps=conn.prepareStatement(sql);
			ps.setString(1, id);
			ResultSet rs=ps.executeQuery();
			rs.next();
			int count=rs.getInt(1);
			rs.close();
			
			if(count==0) {
				vo.setMsg("NOID");
			}else {
				sql="SELECT pwd,id,isadmin FROM member "
						+ "WHERE id=?";
				ps=conn.prepareStatement(sql);
				ps.setString(1, id);
				rs=ps.executeQuery();
				rs.next();
				String db_pwd=rs.getString(1);
				String db_id=rs.getString(2);
				String isadmin=rs.getString(3);
				rs.close();
				
				if(db_pwd.equals(pwd)) {
					vo.setMsg("OK");
					vo.setIsAdmin(isadmin);
					vo.setId(db_id);
				}else {
					vo.setMsg("NOPWD");
				}
			}
		}catch(Exception ex) {
			ex.printStackTrace();
		}finally {
			disConnection();
		}
		
		return vo;
	}
	 public List<MemberVO> memberListData()
	  {
		  List<MemberVO> list=
				  new ArrayList<MemberVO>();
		  try
		  {
			  getConnection();
			  String sql="SELECT m.id,name,sex,addr1,phone,grade "
					    +"FROM member m JOIN grades g "
					    +"ON m.id=g.id "
					    +"AND m.isadmin!='y'";
			  ps=conn.prepareStatement(sql);
			  ResultSet rs=ps.executeQuery();
			  while(rs.next())
			  {
				  MemberVO vo=
						  new MemberVO();
				  vo.setId(rs.getString(1));
				  vo.setName(rs.getString(2));
				  vo.setSex(rs.getString(3));
				  vo.setAddr1(rs.getString(4));
				  vo.setPhone(rs.getString(5));
				  vo.setGrade(rs.getString(6));
				  list.add(vo);
			  }
			  rs.close();
		  }catch(Exception ex)
		  {
			  ex.printStackTrace();
		  }
		  finally
		  {
			  disConnection();
		  }
		  return list;
	  }
	  public List<String> memberGetId()
	  {
		  List<String> list=
				  new ArrayList<String>();
		  try
		  {
			  getConnection();
			  String sql="SELECT id "
					    +"FROM member";
			  // 0 , 1 
			  ps=conn.prepareStatement(sql);
			  
			  ResultSet rs=ps.executeQuery();
			  while(rs.next())
			  {
				  list.add(rs.getString(1));
			  }
			  rs.close();
			  
		  }catch(Exception ex)
		  {
			  ex.printStackTrace();
		  }
		  finally
		  {
			  disConnection();
		  }
		  return list;
	  }
	  public void gradeInsert(String id,String grade)
	  {
		  try
		  {
			  getConnection();
			  String sql="INSERT INTO grades "
					    +"VALUES(?,?)";
			  ps=conn.prepareStatement(sql);
			  ps.setString(1, id);
			  ps.setString(2, grade);
			  ps.executeUpdate();
			  
		  }catch(Exception ex)
		  {
			  ex.printStackTrace();
		  }
		  finally
		  {
			  disConnection();
		  }
	  }
	  public void gradeUpdate(String id,String grade) {
		  try {
				getConnection();
				String sql="UPDATE grades SET "
						+ "grade=? "
						+ "WHERE id=?";
				ps=conn.prepareStatement(sql);
				ps.setString(1, grade);
				ps.setString(2, id);
				ps.executeUpdate();
			}catch(Exception ex) {
				ex.printStackTrace();
			}finally {
				disConnection();
			}
	  }
	  public void memberDelete(String id) {
		  try {
			  getConnection();
			  String sql="DELETE FROM member "
			  		+ "WHERE id=?";
			  ps=conn.prepareStatement(sql);
			  ps.setString(1, id);
			  ps.executeUpdate();
		  }catch(Exception ex) {
			  ex.printStackTrace();
		  }finally {
			  disConnection();
		  }
	  }
}
