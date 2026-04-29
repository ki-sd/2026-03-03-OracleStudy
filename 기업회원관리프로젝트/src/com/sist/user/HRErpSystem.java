package com.sist.user;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.*;
import java.time.*;
import java.util.*;

public class HRErpSystem extends JFrame {

    // =========================
    // TABLES
    // =========================
    JTable empTable, attTable, payTable, reportTable;
    DefaultTableModel empModel, attModel, payModel, reportModel;

    LocalTime START = LocalTime.of(9, 0);
    LocalTime END = LocalTime.of(18, 0);

    public HRErpSystem() {

        setTitle("HR ERP SYSTEM");

        JTabbedPane tab = new JTabbedPane();

        tab.add("사원관리", employeePanel());
        tab.add("근태관리", attendancePanel());
        tab.add("급여관리", salaryPanel());
        tab.add("리포트", reportPanel());

        add(tab);

        setSize(1100, 600);
        setVisible(true);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
    }

    // =================================================
    // 1. 사원 관리
    // =================================================
    public JPanel employeePanel() {

        JPanel p = new JPanel(new BorderLayout());

        empModel = new DefaultTableModel(
                new String[]{"사번","이름","부서","직급","기본급"}, 0
        );

        empTable = new JTable(empModel);

        empModel.addRow(new Object[]{"1001","김철수","개발","대리",3000000});
        empModel.addRow(new Object[]{"1002","이영희","디자인","사원",2500000});
        empModel.addRow(new Object[]{"1003","박민수","영업","과장",3500000});

        p.add(new JScrollPane(empTable), BorderLayout.CENTER);

        return p;
    }

    // =================================================
    // 2. 근태 관리
    // =================================================
    public JPanel attendancePanel() {

        JPanel p = new JPanel(new BorderLayout());

        attModel = new DefaultTableModel(
                new String[]{"사번","이름","상태","출근","퇴근","외출사유"}, 0
        );

        attTable = new JTable(attModel);

        attModel.addRow(new Object[]{"1001","김철수","미출근","","",""});
        attModel.addRow(new Object[]{"1002","이영희","미출근","","",""});
        attModel.addRow(new Object[]{"1003","박민수","미출근","","",""});

        attTable.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) {

                int row = attTable.rowAtPoint(e.getPoint());
                int col = attTable.columnAtPoint(e.getPoint());

                if (col != 2) return;

                String status = attTable.getValueAt(row, 2).toString();
                LocalTime now = LocalTime.now();

                // 출근
                if (status.equals("미출근")) {
                    attTable.setValueAt(now.toString(), row, 3);
                    attTable.setValueAt(getStatus(now, null), row, 2);
                }

                // 퇴근
                else if (status.equals("근무중") || status.equals("지각")) {
                    attTable.setValueAt(now.toString(), row, 4);
                    attTable.setValueAt(getStatus(null, now), row, 2);
                }

                // 외출
                else if (status.equals("근무중")) {

                    String reason = JOptionPane.showInputDialog("외출 사유");

                    if (reason != null) {
                        attTable.setValueAt("외출중", row, 2);
                        attTable.setValueAt(reason, row, 5);
                    }
                }

                refreshSalary(); // 🔥 급여 자동 갱신
            }
        });

        p.add(new JScrollPane(attTable), BorderLayout.CENTER);

        return p;
    }

    // =================================================
    // 3. 급여 관리 (자동 계산 핵심)
    // =================================================
    public JPanel salaryPanel() {

        JPanel p = new JPanel(new BorderLayout());

        payModel = new DefaultTableModel(
                new String[]{"사번","이름","기본급","지각","조퇴","외출","최종급여"}, 0
        );

        payTable = new JTable(payModel);

        refreshSalary();

        p.add(new JScrollPane(payTable), BorderLayout.CENTER);

        return p;
    }

    // =================================================
    // 4. 리포트
    // =================================================
    public JPanel reportPanel() {

        JPanel p = new JPanel(new BorderLayout());

        reportModel = new DefaultTableModel(
                new String[]{"사번","출근횟수","지각","조퇴","외출횟수"}, 0
        );

        reportTable = new JTable(reportModel);

        JButton btn = new JButton("리포트 생성");

        btn.addActionListener(e -> generateReport());

        p.add(btn, BorderLayout.NORTH);
        p.add(new JScrollPane(reportTable), BorderLayout.CENTER);

        return p;
    }

    // =================================================
    // 급여 자동 계산
    // =================================================
    public void refreshSalary() {

        payModel.setRowCount(0);

        for (int i = 0; i < empModel.getRowCount(); i++) {

            String id = empModel.getValueAt(i,0).toString();
            String name = empModel.getValueAt(i,1).toString();
            int base = Integer.parseInt(empModel.getValueAt(i,4).toString());

            int late = countStatus("지각");
            int early = countStatus("조퇴");
            int out = countOut();

            int penalty = (late * 10000) + (early * 15000) + (out * 5000);

            int finalPay = base - penalty;

            payModel.addRow(new Object[]{
                    id, name, base, late, early, out, finalPay
            });
        }
    }

    // =================================================
    // 리포트 생성
    // =================================================
    public void generateReport() {

        reportModel.setRowCount(0);

        for (int i = 0; i < attModel.getRowCount(); i++) {

            String id = attModel.getValueAt(i,0).toString();

            int late = attModel.getValueAt(i,2).equals("지각") ? 1 : 0;
            int early = attModel.getValueAt(i,2).equals("조퇴") ? 1 : 0;
            int out = attModel.getValueAt(i,2).equals("외출중") ? 1 : 0;
            int attend = attModel.getValueAt(i,2).equals("근무중") ? 1 : 0;

            reportModel.addRow(new Object[]{
                    id, attend, late, early, out
            });
        }
    }

    // =================================================
    // 상태 계산
    // =================================================
    public String getStatus(LocalTime in, LocalTime out) {

        if (in != null) {
            if (in.isBefore(START)) return "근무중";
            if (in.isBefore(LocalTime.of(10,0))) return "지각";
            return "결근";
        }

        if (out != null) {
            if (out.isAfter(END)) return "퇴근";
            return "조퇴";
        }

        return "미출근";
    }

    // =================================================
    // 카운트 함수
    // =================================================
    public int countStatus(String status) {

        int c = 0;

        for (int i = 0; i < attModel.getRowCount(); i++) {
            if (attModel.getValueAt(i,2).equals(status)) c++;
        }

        return c;
    }

    public int countOut() {

        int c = 0;

        for (int i = 0; i < attModel.getRowCount(); i++) {
            if (attModel.getValueAt(i,2).equals("외출중")) c++;
        }

        return c;
    }

    // =================================================
    public static void main(String[] args) {
    	try
        {
        	UIManager.setLookAndFeel("com.jtattoo.plaf.hifi.HiFiLookAndFeel");
        }catch(Exception ex) {}
        new HRErpSystem();
    }
}