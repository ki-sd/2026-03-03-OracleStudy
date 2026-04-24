package com.sist.dao;
import java.sql.*;
import java.util.*;

import com.sist.vo.MusicVO;

public class MusicDAO {
	private PreparedStatement ps;
	private Connection conn;
	private final String URL="jdbc:oracle:thin:@localhost:1521:XE";
	private static MusicDAO dao;
	public MusicDAO() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		}catch(Exception ex) {}
	}
	public static MusicDAO newInstance() {
		if(dao==null)
			dao=new MusicDAO();
		return dao;
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
	public List<MusicVO> musicListData(int page){
		List<MusicVO> list=new ArrayList<MusicVO>();
		try {
			getConnection();
			String sql="SELECT no, title, singer, album, state "
					+"FROM genie_music "
					+"OFFSET ? ROWS FETCH NEXT 20 ROWS ONLY";
			ps=conn.prepareStatement(sql);
			int start=(page*20)-20;
			ps.setInt(1, start);
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				MusicVO vo=new MusicVO();
				vo.setNo(rs.getInt(1));
				vo.setTitle(rs.getString(2));
				vo.setSinger(rs.getString(3));
				vo.setAlbum(rs.getString(4));
				vo.setState(rs.getString(5));
				list.add(vo);
			}
			rs.close();
		}catch(Exception ex) {}
		finally {
			disConnection();
		}
		return list;
	}
	public int musicTotalPage() {
		int total=0;
		try {
			getConnection();
			String sql="SELECT CEIL(COUNT(*)/20.0) "
					+ "FROM genie_music";
			ps=conn.prepareStatement(sql);
			ResultSet rs=ps.executeQuery();
			rs.next();
			total=rs.getInt(1);
			rs.close();
		}catch(Exception ex) {
			ex.printStackTrace();
		}finally {
			disConnection();
		}
		return total;
	}
	public MusicVO musicDetailData(int no) {
		MusicVO vo=new MusicVO();
		try {
			getConnection();
			String sql="SELECT no,title,singer,album,state,idcrement "
					+ "FROM genie_music "
					+ "WHERE no=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, no);
			ResultSet rs=ps.executeQuery();
			rs.next();
			vo.setNo(rs.getInt(1));
			vo.setTitle(rs.getString(2));
			vo.setSinger(rs.getString(3));
			vo.setAlbum(rs.getString(4));
			vo.setState(rs.getString(5));
			vo.setIdcrement(rs.getInt(6));
			rs.close();
		}catch(Exception ex) {}
		finally {
			disConnection();
		}
		return vo;
	}
	public List<MusicVO> musicFindData(String col, String fd){
		List<MusicVO> list=new ArrayList<MusicVO>();
		try {
			getConnection();
			String sql="SELECT no,title,singer,album,state "
					+ "FROM genie_music "
					+ "WHERE "+col+" LIKE '%'||?||'%'";
			ps=conn.prepareStatement(sql);
			ps.setString(1, fd);
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				MusicVO vo=new MusicVO();
				vo.setNo(rs.getInt(1));
				vo.setTitle(rs.getString(2));
				vo.setSinger(rs.getString(3));
				vo.setAlbum(rs.getString(4));
				vo.setState(rs.getString(5));
				list.add(vo);
			}
			rs.close();
		}catch(Exception ex) {}
		finally {
			disConnection();
		}
		return list;
	}
}
