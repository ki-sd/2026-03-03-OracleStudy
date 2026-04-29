package com.sist.dao;
import java.sql.*;
import java.util.*;

import com.sist.vo.BuyVO;
import com.sist.vo.GoodsVO;
public class GoodsDAO {
	// 전체적으로 사용
	private Connection conn;
	private PreparedStatement ps;
	private final String URL="jdbc:oracle:thin:@localhost:1521:XE";
	private String[] tables= {
			"",
			"goods_all",
			"goods_best",
			"goods_new",
			"goods_special"
	};
	
	public GoodsDAO() {
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
	
	// 기능 설정 => 회원 가입/회원 탈퇴/로그인
	// 상품 구매
	// 구매 테이블
	// 관리 => 상품구매 많은 회원 => 등급지정 => 관리자
	// 구매 현황, 회원 관리
	// 1.상품 목록
	public List<GoodsVO> goodsListData(int type, int page) {
		List<GoodsVO> list=new ArrayList<GoodsVO>();
		try {
			getConnection();
			String sql="SELECT no,goods_poster,goods_name,goods_price "
					+ "FROM "+tables[type]
					+ " ORDER BY no ASC "
					+ "OFFSET ? ROWS FETCH NEXT 12 ROWS ONLY";
			ps=conn.prepareStatement(sql);
			int start=(page*12)-12;
			ps.setInt(1, start);
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				GoodsVO vo=new GoodsVO();
				vo.setNo(rs.getInt(1));
				vo.setGoods_poster(rs.getString(2));
				vo.setGoods_name(rs.getString(3));
				vo.setGoods_price(rs.getString(4));
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
	// 총페이지
	public int goodsTotalPage(int type) {
		int total=0;
		try {
			getConnection();
			String sql="SELECT CEIL(COUNT(*)/12.0) "
					+ "FROM "+tables[type];
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
	// 상세보기
	/*
	 *   1.목록 (row가 여러개)
	 *           | VO => 여러개 저장(List)
	 *   2.상세보기 => row (1개)
	 *              --------- VO 1개
	 *   SELECT no FROM goods => int
	 *          -- 컬럼이 두개 이상 => VO
	 */
	public GoodsVO goodsDetailData(int type,int gno) {
		GoodsVO vo=new GoodsVO();
		try {
			getConnection();
			String sql="SELECT no,goods_name,goods_poster,goods_sub,goods_delivery,goods_discount,goods_price "
					+ "FROM "+tables[type]
					+" WHERE no=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, gno);
			ResultSet rs=ps.executeQuery();
			rs.next();
			vo.setNo(rs.getInt(1));
			vo.setGoods_name(rs.getString(2));
			vo.setGoods_poster(rs.getString(3));
			vo.setGoods_sub(rs.getString(4));
			vo.setGoods_delivery(rs.getString(5));
			vo.setGoods_discount(rs.getInt(6));
			vo.setGoods_price(rs.getString(7));
			rs.close();
		}catch(Exception ex) {
			ex.printStackTrace();
		}finally {
			disConnection();
		}
		return vo;
	}
	// 구매
	public void goodsBuyData(BuyVO vo) {
		try {
			getConnection();
			String sql="INSERT INTO buy VALUES("
					+ "buy_no_seq.nextval,?,?,?,?,?,SYSDATE)";
			ps=conn.prepareStatement(sql);
			ps.setString(1, vo.getId());
			ps.setInt(2, vo.getType());
			ps.setInt(3, vo.getGno());
			ps.setInt(4, vo.getAccount());
			ps.setInt(5, vo.getPrice());
			ps.executeUpdate();
		}catch(Exception ex) {
			ex.printStackTrace();
		}finally {
			disConnection();
		}
	}
	// JOIN
	/*
	 *     고객   <구매>   도서
	 *           | id, 전화번호
	 *     
	 *     = INNER (EQUI_JOIN) => INTERSECT
	 *     = OUTER => LEFT/RIGHT => INTERSECT + MINUS
	 */
	public List<BuyVO> buyListData(String id){
		List<BuyVO> list=new ArrayList<BuyVO>();
		try {
			getConnection();
			String sql="SELECT b.no,goods_poster,goods_name,account,"
					+ "TO_CHAR(regdate,'YYYY-MM-DD'),price "
					+ "FROM buy b JOIN goods_all g "
					+ "ON b.gno=g.no "
					+ "AND b.id=? "
					+ "ORDER BY regdate DESC";
			ps=conn.prepareStatement(sql);
			ps.setString(1, id);
			ResultSet rs=ps.executeQuery();
			while(rs.next()) {
				BuyVO vo=new BuyVO();
				vo.setNo(rs.getInt(1));
				vo.getGvo().setGoods_poster(rs.getString(2));
				vo.getGvo().setGoods_name(rs.getString(3));
				vo.setAccount(rs.getInt(4));
				vo.setDbday(rs.getString(5));
				vo.setPrice(rs.getInt(6));
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
	public void buyDelete(int no) {
		try {
			getConnection();
			String sql="DELETE FROM buy "
					+ "WHERE no="+no;
			ps=conn.prepareStatement(sql);
			ps.executeUpdate();
		}catch(Exception ex) {
			ex.printStackTrace();
		}finally {
			disConnection();
		}
	}
	
}
