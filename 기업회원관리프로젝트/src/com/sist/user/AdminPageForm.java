package com.sist.user;

import java.util.List;
import java.util.*;
import java.awt.*;
import javax.swing.*;
import javax.swing.table.*;
public class AdminPageForm extends JPanel{
	JTabbedPane tp=new JTabbedPane();
	ControlPanel cp;
	MemberControlForm mcf=new MemberControlForm();
	MemberGradeForm mgf=new MemberGradeForm();
	public AdminPageForm(ControlPanel cp) {
		// JPanel: FlowLayout
		this.cp=cp;
		setLayout(null);
		tp.addTab("회원관리", mcf);
		tp.addTab("회원검색", new JPanel());
		tp.addTab("상품관리", new JPanel());
		tp.addTab("구매관리", new JPanel());
		tp.addTab("등급관리", mgf);
		tp.setTabPlacement(tp.LEFT);
		tp.setBounds(10, 15, 920, 480);
		add(tp);
	}
}
