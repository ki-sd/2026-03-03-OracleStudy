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
	BoardDelete bDelete;
	HomePanel hp=new HomePanel();
	// 화면 관리
	public ControllerPanel(UserMainForm mf) {
		this.mf=mf;
		bList=new BoardList(mf);
		bInsert=new BoardInsert(mf);
    	bDetail=new BoardDetail(mf);
    	bDelete=new BoardDelete(mf);
		setLayout(card);
		//setBackground(Color.CYAN);
		add("HOME",hp);
		add("BLIST",bList);
		add("BINSERT",bInsert);
    	add("BDETAIL",bDetail);
    	add("BDELETE",bDelete);
	}
}
