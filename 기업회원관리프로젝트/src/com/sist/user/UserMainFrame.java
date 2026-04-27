package com.sist.user;
import java.util.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
public class UserMainFrame extends JFrame implements ActionListener{
	MenuPanel mp=new MenuPanel ();
	ControlPanel cp;
	
	public UserMainFrame() {
		cp=new ControlPanel();
		setLayout(null);
		mp.setBounds(250, 15, 700, 45);
		cp.setBounds(10, 70, 980, 580);
		add(mp);
		add(cp);
		
		setSize(1024,700);
		setVisible(true);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		
		mp.b3.addActionListener(this);
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
	}
}
