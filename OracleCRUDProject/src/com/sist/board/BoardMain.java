package com.sist.board;
import java.util.*;
import java.awt.*;
import javax.swing.*;
import java.awt.event.*;
public class BoardMain extends JFrame implements ActionListener{
	private CardLayout card=new CardLayout();
	BoardList bList=new BoardList();
	public BoardMain() {
		setLayout(card);
		add("bList",bList);
		setSize(640, 550);
		bList.print();
		setVisible(true);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
	}
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try {
			UIManager.setLookAndFeel("com.jtattoo.plaf.mcwin.McWinLookAndFeel");
		}catch(Exception ex) {}
		new BoardMain();	
	}
	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		
	}

}
