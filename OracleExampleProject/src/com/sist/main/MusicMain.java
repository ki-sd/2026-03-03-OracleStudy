package com.sist.main;
import java.awt.*;
import java.awt.event.*;
import java.util.List;

import javax.swing.*;
import javax.swing.table.*;

import com.sist.dao.*;
import com.sist.vo.*;
public class MusicMain extends JFrame
implements ActionListener
{
    JLabel titleLa;
    JTable table;
    DefaultTableModel model;
    TableColumn column;
   
    JButton[] btns=new JButton[6];
    MovieDAO dao=new MovieDAO();
    String[] bTitle={"가요","POP","OST","트롯","JAZZ","CLASSIC"};
    public MusicMain()
    {
    	
    	
    	titleLa=new JLabel("뮤직 목록",JLabel.CENTER);// <table>
    	titleLa.setFont(new Font("맑은 고딕",Font.BOLD,30)); //<h3></h3>
    	
    	String[] col={"번호","" , "곡명","가수명","앨범"};//<tr><th></th>....</tr>
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
    			column.setPreferredWidth(50);
    		}
    		else if(i==2)
    		{
    			column.setPreferredWidth(200);
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
    	for(int i=0;i<btns.length;i++)
    	{
    		btns[i]=new JButton(bTitle[i]);
    		p.add(btns[i]);
    	}
    	
    	p.setBounds(10, 70, 800, 35);
    	add(p);
    	
    	setSize(850, 700);
    	setVisible(true);
    	setDefaultCloseOperation(EXIT_ON_CLOSE);
    	
    	
    }
    public void print(String col,String fd)
    {
    	for(int i=model.getRowCount()-1;i>=0;i--)
    	{
    		model.removeRow(i);
    	}
    	// 데이터 읽기 
    	List<MovieVO> list=dao.movieFindData(col, fd);
    	for(MovieVO vo:list)
    	{
    		String[] data={
    			String.valueOf(vo.getMno()),
    			vo.getTitle(),
    			vo.getActor(),
    			vo.getRegdate(),
    			vo.getGenre()
    		};
    		
    		model.addRow(data);
    	}
    }
	public static void main(String[] args) {
		// TODO Auto-generated method stub
        new MusicMain();
	}
	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		
	}

}