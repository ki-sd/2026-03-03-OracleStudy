package com.sist.main;
import java.awt.*;
import java.awt.event.*;
import java.util.List;

import javax.swing.*;
import javax.swing.table.*;
import com.sist.vo.*;
import com.sist.dao.*;
public class MovieMain extends JFrame implements ActionListener, MouseListener{
	JButton prevBtn,nextBtn;
    JLabel pageLa,titleLa;
    JTable table;
    DefaultTableModel model;
    TableColumn column;
    MovieDAO dao=new MovieDAO();
    int curpage=1;
    int totalpage=0;
    public MovieMain()
    {
    	
    	prevBtn=new JButton("이전");
    	nextBtn=new JButton("다음");
    	pageLa=new JLabel("0 page / 0 pages"); //<label>0 page / 0 pages</label>
    	titleLa=new JLabel("영화 목록",JLabel.CENTER);// <table>
    	titleLa.setFont(new Font("맑은 고딕",Font.BOLD,30)); //<h3></h3>
    	
    	String[] col={"번호","영화명","출연","개봉일","장르"};//<tr><th></th>....</tr>
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
    			column.setPreferredWidth(150);
    		}
    		else if(i==2)
    		{
    			column.setPreferredWidth(250);
    		}
    		else if(i==3)
    		{
    			column.setPreferredWidth(200);
    		}
    		else if(i==4)
    		{
    			column.setPreferredWidth(200);
    		}
    	}
    	table.getTableHeader().setReorderingAllowed(false);
    	table.setShowVerticalLines(false);
    	table.setRowHeight(30);
    	table.getTableHeader().setBackground(Color.pink);
    	
    	// 배치 
    	setLayout(null);
    	titleLa.setBounds(10, 15, 820, 50);
    	add(titleLa);
    	
    	js.setBounds(10, 110, 800, 450);
    	add(js);
    	
    	JPanel p=new JPanel();
    	p.add(prevBtn);
    	p.add(pageLa);
    	p.add(nextBtn);
    	
    	p.setBounds(10, 570, 800, 35);
    	add(p);
    	
    	setSize(850, 730);
    	setVisible(true);
    	setDefaultCloseOperation(EXIT_ON_CLOSE);
    	print();
    	
    	prevBtn.addActionListener(this);
    	nextBtn.addActionListener(this);
    	table.addMouseListener(this);
    }
    public void print() {
    	// 테이블 전체 지운다
    	for(int i=model.getRowCount()-1;i>=0;i--) {
    		model.removeRow(i);
    	}
    	
    	// 데이터 읽기
    	List<MovieVO> list=dao.movieListData(curpage);
    	totalpage=dao.movieTotalPage();
    	
    	for(MovieVO vo:list) {
    		String[] data= {
    			String.valueOf(vo.getMno()),
    			vo.getTitle(),
    			vo.getActor(),
    			vo.getRegdate(),
    			vo.getGenre()
    		};
    		model.addRow(data);
  
    	}
    	
    	pageLa.setText(curpage+" page / "+totalpage+" pages");
    }
    public void printDetail() {
    	int row=table.getSelectedRow();     // 선택된 ROW 갖고오기
		String mno=model.getValueAt(row, 0).toString();
		MovieVO vo=dao.movieDetailData(Integer.parseInt(mno));
		String msg="영화번호:"+vo.getMno()+"\n"
			+"영화명:"+vo.getTitle()+"\n"
			+"출연:"+vo.getActor()+"\n"
			+"감독:"+vo.getDirector()+"\n"
			+"장르:"+vo.getGenre()+"\n"
			+"등급:"+vo.getGrade()+"\n"
			+"개봉일:"+vo.getRegdate();
		JOptionPane.showMessageDialog(this, msg);
    }
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try {
			UIManager.setLookAndFeel("com.jtattoo.plaf.smart.SmartLookAndFeel");
		}catch(Exception ex) {}
        new MovieMain();
	}
	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		if(e.getSource()==prevBtn) {
			if(curpage>1) {
				curpage--;
				print();
			}
		}
		else if(e.getSource()==nextBtn) {
			if(curpage<totalpage) {
				curpage++;
				print();
			}
		}
	}
	@Override
	public void mouseClicked(MouseEvent e) {
		// TODO Auto-generated method stub
		if(e.getSource()==table) {
			if(e.getClickCount()==2) {    // 더블클릭
				printDetail();
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
