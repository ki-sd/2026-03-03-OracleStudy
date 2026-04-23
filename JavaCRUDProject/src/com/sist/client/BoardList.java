package com.sist.client;
import java.awt.*;
import java.awt.event.*;
import java.util.List;
import javax.swing.*;
import javax.swing.table.*;

import com.sist.dao.BoardDAO;
import com.sist.vo.BoardVO;

public class BoardList extends JPanel implements ActionListener, MouseListener{
    JButton inBtn,prevBtn,nextBtn;
    JLabel pageLa,titleLa;
    JTable table;
    DefaultTableModel model;
    TableColumn column;
    int totalpage=0;
    int curpage=1;
    UserMainForm mf;
    public BoardList(UserMainForm mf)
    {
    	this.mf=mf;
    	inBtn=new JButton("새글");//<input type=button value="새글">
    	prevBtn=new JButton("이전");
    	nextBtn=new JButton("다음");
    	pageLa=new JLabel("0 page / 0 pages"); //<label>0 page / 0 pages</label>
    	titleLa=new JLabel("게시판",JLabel.CENTER);// <table>
    	titleLa.setFont(new Font("맑은 고딕",Font.BOLD,30)); //<h3></h3>
    	
    	String[] col={"번호","제목","이름","작성일","조회수"};//<tr><th></th>....</tr>
    	String[][] row=new String[0][5];
    	// 한줄에 5개 데이터를 첨부 
    	model=new DefaultTableModel(row,col) // 데이터 관리
    	{

			@Override
			public boolean isCellEditable(int row, int column) {
				// TODO Auto-generated method stub
				return false;
			}
    		 // 익명의 클래스 => 포함 클래스 => 상속없이 오버라이딩 => 클릭 => 편집기 => 편집방지 
    		 
    	};
    	table=new JTable(model); // 테이블 모양 관리 
    	JScrollPane js=new JScrollPane(table);
    	for(int i=0;i<col.length;i++)
    	{
    		column=table.getColumnModel().getColumn(i);
    		if(i==0)
    		{
    			column.setPreferredWidth(50);
    		}
    		else if(i==1)
    		{
    			column.setPreferredWidth(350);
    		}
    		else if(i==2)
    		{
    			column.setPreferredWidth(100);
    		}
    		else if(i==3)
    		{
    			column.setPreferredWidth(150);
    		}
    		else if(i==4)
    		{
    			column.setPreferredWidth(50);
    		}
    	}
    	table.getTableHeader().setReorderingAllowed(false);
    	table.setShowVerticalLines(false);
    	table.setRowHeight(30);
    	table.getTableHeader().setBackground(Color.pink);
    	
    	// 배치 
    	setLayout(null);
    	titleLa.setBounds(200, 15, 620, 50);
    	add(titleLa);
    	inBtn.setBounds(200, 70, 100, 30);
    	add(inBtn);
    	js.setBounds(200, 110, 600, 450);
    	add(js);
    	
    	JPanel p=new JPanel();
    	p.add(prevBtn);
    	p.add(pageLa);
    	p.add(nextBtn);
    	
    	p.setBounds(200, 570, 600, 35);
    	add(p);
    	
    	prevBtn.addActionListener(this);
    	nextBtn.addActionListener(this);
    	inBtn.addActionListener(this);
    	table.addMouseListener(this);
    	print();
    }
    public void print()
    {
    	// 테이블 지우기
    	for(int i=model.getRowCount()-1;i>=0;i--) {
    		model.removeRow(i);
    	}
    	// 오라클 연동 
    	BoardDAO dao=BoardDAO.newInstance();
    	List<BoardVO> list=dao.board_list(curpage);
    	totalpage=dao.boardTotalPage();
    	
    	// 목록 출력 
    	for(BoardVO vo:list)
    	{
    		String[] data={
    			String.valueOf(vo.getNo()),
    			vo.getSubject(),
    			vo.getName(),
    			vo.getDbday(),
    			String.valueOf(vo.getHit())
    		};
    		model.addRow(data);
    	}
    	// 페이지 지정 
    	pageLa.setText(curpage + " page / "
    	              +totalpage+" pages");
    }
	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		if(e.getSource()==inBtn)
		{
			mf.cp.bInsert.nameTf.setText("");
			mf.cp.bInsert.subTf.setText("");
			mf.cp.bInsert.ta.setText("");
			mf.cp.bInsert.pwdPf.setText("");
			
			mf.cp.card.show(mf.cp, "BINSERT");
			mf.cp.bInsert.nameTf.requestFocus();
		}
		else if(e.getSource()==prevBtn)
		{
			if(curpage>1)
			{
				curpage--;
				print();
			}
		}
		else if(e.getSource()==nextBtn)
		{
			if(curpage<totalpage)
			{
				curpage++;
				print();
			}
		}
	}
	@Override
	public void mouseClicked(MouseEvent e) {
		// TODO Auto-generated method stub
		if(e.getSource()==table)
		{
			if(e.getClickCount()==2)// 더블 클릭
			{
				// ROW 
				int row=table.getSelectedRow();
				String no=model.getValueAt(row, 0).toString();
//				JOptionPane.showMessageDialog(this,
//						"선택된 게시물 번호:"+no);
				mf.cp.card.show(mf.cp, "BDETAIL");
				mf.cp.bDetail.print(Integer.parseInt(no));
			}
		}
	}
	@Override
	public void mousePressed(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void mouseReleased(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void mouseEntered(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void mouseExited(MouseEvent e) {
		// TODO Auto-generated method stub
		
	}
    
}
