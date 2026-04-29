package com.sist.user;
import java.util.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

import com.sist.dao.MemberDAO;
import com.sist.vo.MemberVO;
public class UserMainFrame extends JFrame implements ActionListener{
	MenuPanel mp=new MenuPanel ();
	ControlPanel cp;
	static boolean bLogin=false;
	static char isAdmin='n';
	Login login=new Login();
	public UserMainFrame() {
		cp=new ControlPanel();
		mp.init();
		setLayout(null);
		mp.setBounds(250, 15, 700, 45);
		cp.setBounds(10, 70, 980, 580);
		add(mp);
		add(cp);
		
		setSize(1024,700);
		setVisible(true);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		
		mp.b3.addActionListener(this);
		mp.b2.addActionListener(this);
		mp.b1.addActionListener(this);
		mp.b6.addActionListener(this);
		mp.b4.addActionListener(this);
		mp.b5.addActionListener(this);
		
		// login
		login.b1.addActionListener(this); //로그인
		login.b2.addActionListener(this); //취소
		
	}
	public static void main(String[] args) {
		try {
			UIManager.setLookAndFeel("com.jtattoo.plaf.smart.SmartLookAndFeel");
		}catch(Exception ex) {}
		new UserMainFrame();
	}
	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		if(e.getSource()==mp.b3) {
			cp.card.show(cp, "JOIN");
		}
		else if(e.getSource()==mp.b1) {
			cp.card.show(cp, "HOME");
		}
		else if(e.getSource()==mp.b2) {
			login.tf.setText("");
			login.pf.setText("");
			login.setVisible(true);
		}
		else if(e.getSource()==login.b1) {
			String id=login.tf.getText();
			if(id.trim().length()<1) {
				login.tf.requestFocus();
				return;
			}
			String pwd=String.valueOf(login.pf.getPassword());
			if(pwd.trim().length()<1) {
				login.pf.requestFocus();
				return;
			}
			MemberDAO dao=new MemberDAO();
			MemberVO vo=dao.isLogin(id, pwd);
			if(vo.getMsg().equals("NOID")) {
				JOptionPane.showMessageDialog(this, "존재하지 않는 아이디입니다");
				login.tf.setText("");
				login.pf.setText("");
				login.tf.requestFocus();
			}
			else if(vo.getMsg().equals("NOPWD")) {
				JOptionPane.showMessageDialog(this, "비밀번호가 틀립니다");
				login.pf.setText("");
				login.pf.requestFocus();
			}
			else if(vo.getMsg().equals("OK")) {
				String s=vo.getIsAdmin().equals("y")?"관리자":"일반사용자";
				String title=vo.getId()+"("+s+")";
				setTitle(title);
				UserMainFrame.bLogin=true;
				UserMainFrame.isAdmin=vo.getIsAdmin().charAt(0);
				login.setVisible(false);
				cp.myId=id;
				mp.init();
				if(vo.getIsAdmin().equals("y")) {
					cp.card.show(cp, "ADMIN");
				}
			}
		}
		else if(e.getSource()==login.b2) {
			login.tf.setText("");
			login.pf.setText("");
			login.setVisible(false);
		}
		else if(e.getSource()==mp.b6) {
			JOptionPane.showMessageDialog(this, "종료합니다");
			dispose();
			System.exit(0);
		}
		else if(e.getSource()==mp.b4) {
			cp.card.show(cp, "MYPAGE");
			cp.mf.print();
		}
	}
}
