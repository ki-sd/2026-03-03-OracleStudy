package com.sist.user;

import java.awt.CardLayout;
import java.awt.Color;

import javax.swing.JPanel;

// 화면 변경
public class ControlPanel extends JPanel {
	UserMainFrame uf;
	// 1.Home
	HomePanel hp;
	JoinPanel jp;
	GoodsDetailForm gdf;
	CardLayout card=new CardLayout();
	String myId;
	public ControlPanel() {
//		this.uf=uf;
		setBackground(Color.cyan);
		setLayout(card);
		hp=new HomePanel(this);
		gdf=new GoodsDetailForm(this);
		jp=new JoinPanel(this);
		
		add("HOME",hp);
		add("DETAIL",gdf);
		add("JOIN",jp);
	}
}
