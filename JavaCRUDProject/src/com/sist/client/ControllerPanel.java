package com.sist.client;
import java.util.*;
import java.awt.*;
import javax.swing.*;
public class ControllerPanel extends JPanel {
	CardLayout card=new CardLayout();
	UserMainForm mf;
	BoardList bList;
	BoardInsert bInsert;
	BoardDetail bDetail;
	HomePanel hp=new HomePanel();
	public ControllerPanel(UserMainForm mf) {
		this.mf=mf;
		bList=new BoardList(mf);
		bInsert=new BoardInsert(mf);
    	bDetail=new BoardDetail(mf);
		setLayout(card);
		//setBackground(Color.CYAN);
		add("HOME",hp);
		add("BLIST",bList);
		add("BINSERT",bInsert);
    	add("BDETAIL",bDetail);
	}
}
