-- 정렬 방법 => ORDER BY 
/*
     SELECT ~
     FROM table_name
     ORDER BY 컬럼 ASC|DESC 
                   -------
                   1. 컬럼명 
                   2. 컬럼의 위치 => 1번 시작 
                   3. 함수
     SELECT * 
     FROM emp 
       1        2      3    4       5       6    7       8
    empno,ename,job,mgr,hiredate,sal,comm,deptno
                  1        2      3     4        5
    SELECT empno,ename,sal,deptno,hiredate
    FROM emp
    ORDER BY 3

    이중 정렬 => 대댓글 
    ORDER BY sal,ename 
                   ---
                     1 =======> 같은 값을 가지고 있는 데이터끼리 정렬 
     
*/
SELECT ename,sal 
FROM emp
ORDER BY sal DESC; 
