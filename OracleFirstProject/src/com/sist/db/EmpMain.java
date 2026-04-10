package com.sist.db;
import java.sql.*;
/*
 *     1. 메서드
 *     2. 제어문
 *     3. 클래스 => 변수 / 메서드 / 생성자
 *     4. 캡슐화
 *     5. 추상 클래스 / 인터페이스(**)
 *     6. 예외처리
 *     --------------------------------
 *     7. 라이브러리
 *        => String / Collection (List,Map)
 *        => IO
 *        => 형식 (문법)
 *        => 사용처
 *        
 *     ------------------------------------
 *     J2EE (2차 자바)
 *     ------------------------------------
 *     3차 자바 => Spring
 *     ------------------------------------
 *     4차 자바 => MyBatis / JPA
 *     ------------------------------------
 *     5차 자바 => Spring-Boot
 *     ------------------------------------ 구조는 변경X
 *        
 */
import java.util.*;
public class EmpMain {

	public static void main(String[] args) throws Exception {
		// TODO Auto-generated method stub
		Scanner sc=new Scanner(System.in);
		System.out.print("직위입력:");
		String job=sc.next();
		//1. 드라이버
		Class.forName("oracle.jdbc.driver.OracleDriver");
		String url="jdbc:oracle:thin:@localhost:1521:XE";
		//2. 오라클 연결
		Connection conn=DriverManager.getConnection(url,"hr","happy");
		// Socket
		//3. 명령문 전송
		String sql="SELECT empno,ename,job "+
				"FROM emp "+
				"WHERE job "+
				"LIKE '%"+job+"%'";
		PreparedStatement ps=conn.prepareStatement(sql);
		// OutputStream
		//4. 실행 결과값
		ResultSet rs=ps.executeQuery();
		//5. 출력
		while(rs.next()) {
			System.out.println(rs.getInt(1)+" "+rs.getString(2)+" "+rs.getString(3));
		}
		rs.close();
		ps.close();
		conn.close();
	}
}
