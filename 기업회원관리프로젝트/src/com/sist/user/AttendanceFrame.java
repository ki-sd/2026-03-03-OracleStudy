package com.sist.user;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.*;
import java.time.LocalTime;

public class AttendanceFrame extends JFrame {

    JTable table;
    DefaultTableModel model;

    LocalTime START = LocalTime.of(9, 0);
    LocalTime END = LocalTime.of(18, 0);

    public AttendanceFrame() {

        setTitle("자동 인사관리 시스템");

        model = new DefaultTableModel(
                new String[]{"사번","이름","상태","출근","퇴근","외출사유","외출시간"}, 0
        );

        table = new JTable(model);
        add(new JScrollPane(table), BorderLayout.CENTER);

        // 🔹 더미 데이터
        model.addRow(new Object[]{"1001","김철수","미출근","","","",""});
        model.addRow(new Object[]{"1002","이영희","미출근","","","",""});
        model.addRow(new Object[]{"1003","박민수","미출근","","","",""});

        // 🔥 클릭 이벤트 (핵심)
        table.addMouseListener(new MouseAdapter() {
            public void mouseClicked(MouseEvent e) {

                int row = table.rowAtPoint(e.getPoint());
                int col = table.columnAtPoint(e.getPoint());

                if (col != 2) return; // 상태 컬럼만

                String status = table.getValueAt(row, 2).toString();
                LocalTime now = LocalTime.now();

                // =========================
                // 1. 출근
                // =========================
                if (status.equals("미출근")) {

                    table.setValueAt(now.toString(), row, 3);

                    String result = checkStatus(now, null);
                    table.setValueAt(result, row, 2);

                    log(row, "출근");
                }

                // =========================
                // 2. 퇴근
                // =========================
                else if (status.equals("근무중") || status.equals("지각")) {

                    table.setValueAt(now.toString(), row, 4);

                    String result = checkStatus(null, now);
                    table.setValueAt(result, row, 2);

                    log(row, "퇴근");
                }

                // =========================
                // 3. 외출 → 복귀
                // =========================
                else if (status.equals("외출중")) {

                    table.setValueAt("근무중", row, 2);
                    table.setValueAt("", row, 5);
                    table.setValueAt(now.toString(), row, 6);

                    log(row, "복귀");
                }

                // =========================
                // 4. 외출 처리
                // =========================
                else if (status.equals("근무중")) {

                    String reason = JOptionPane.showInputDialog("외출 사유");

                    if (reason != null && !reason.trim().isEmpty()) {

                        table.setValueAt("외출중", row, 2);
                        table.setValueAt(reason, row, 5);
                        table.setValueAt(now.toString(), row, 6);

                        log(row, "외출: " + reason);
                    }
                }
            }
        });

        setSize(900, 400);
        setVisible(true);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
    }

    // =========================
    // 자동 상태 판정
    // =========================
    public String checkStatus(LocalTime in, LocalTime out) {

        if (in != null) {

            if (in.isBefore(START) || in.equals(START)) {
                return "근무중";
            } else if (in.isBefore(LocalTime.of(10, 0))) {
                return "지각";
            } else {
                return "결근";
            }
        }

        if (out != null) {

            if (out.isAfter(END) || out.equals(END)) {
                return "퇴근";
            } else {
                return "조퇴";
            }
        }

        return "미출근";
    }

    // =========================
    // 로그 출력
    // =========================
    public void log(int row, String action) {

        String id = table.getValueAt(row, 0).toString();
        System.out.println("[LOG] " + id + " - " + action + " - " + LocalTime.now());
    }

    // =========================
    public static void main(String[] args) {
        new AttendanceFrame();
    }
}