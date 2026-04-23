-- PROCEDURE: 리턴형이 없는 함수 => 기능중심
/*
    CREATE OR REPLACE PROCEDURE pro_name(매개변수)
    IS
     필요 변수 설정
    BEGIN
     기능 처리
    END;
    /
    
    CALL pro_name(값...) => CallableStatement
*/
-- student
-- INSERT
CREATE OR REPLACE PROCEDURE studentInsert(
    pName IN student.name%TYPE,
    pKor student.kor%TYPE,       -- 생략시 디폴트로 IN변수 설정
    pEng student.eng%TYPE,
    pMath student.math%TYPE
)
IS
BEGIN
    INSERT INTO student 
        VALUES(std_seq.nextval,pName,pKor,pEng,pMath);
    COMMIT;
END;
/
-- UPDATE
CREATE OR REPLACE PROCEDURE studentUpdate(
    pHakbun student.hakbun%TYPE,
    pName student.name%TYPE,
    pKor student.kor%TYPE,
    pEng student.eng%TYPE,
    pMath student.math%TYPE
)
IS
 -- 필요한 변수 선언 위치
BEGIN
    UPDATE student SET
        name=pName,kor=pkor,eng=pEng,math=pMath
    WHERE hakbun=pHakbun;
    COMMIT;
END;
/
-- DELETE
CREATE OR REPLACE PROCEDURE studentDelete(
    pHakbun student.hakbun%TYPE
)
IS
BEGIN
    DELETE FROM student
    WHERE hakbun=phakbun;
    COMMIT;
END;
/
-- SELECT: OUT변수 포함
CREATE OR REPLACE PROCEDURE studentSelect(
    pHakbun IN student.hakbun%TYPE,
    pName OUT student.name%TYPE,
    pKor OUT student.kor%TYPE,
    pEng OUT student.eng%TYPE,
    pMath OUT student.math%TYPE
)
IS
BEGIN
    SELECT name,kor,eng,math INTO pName,pKor,pEng,pMath
    FROM student
    WHERE hakbun=pHakbun;
END;
/
/*
    매개변수 => IN / OUT / INOUT
                          ----- 둘다 가능한 변수
                    --- 값을 받는 변수: Call By Reference
                        C언어형식 => 모든 변수에 주소값
                        aaa(int* p) ==> aaa(&a)
                        SELECT에 많이 씀
              --- 값을 대입(INSERT,UPDATE,DELETE)
              --- Default => 생략시 IN변수로 설정
*/
CALL studentInsert('김두한',90,87,67);
CALL studentUpdate(2,'춘향이',80,80,70);
CALL studentDelete(6);

VARIABLE pName VARCHAR2(51);
VARIABLE pKor NUMBER;
VARIABLE pEng NUMBER;
VARIABLE pMath NUMBER;

EXECUTE studentSelect(1,:pName,:pKor,:pEng,:pMath);

PRINT pName;
PRINT pKor;
PRINT pEng;
PRINT pMath;
SELECT * FROM student;
-- 여러개의 SQL문장 제어 / 일괄 처리 / 보안...
/*
    FUNCTION vs PROCEDURE
    장점
      SQL문장을 몰수 없다 (보안)
      재사용 가능 => 제작 (DROP시까지 유지)
      SQL문장을 줄여서 사용 가능
    단점
      분석이 어렵다
      
      형식 / 호출 방식
      CREATE [OR REPLACE] FUNCTION func_name(매개변수)
      RETURN 데이터형
      IS
       필요한 변수 설정(지역변수)
      BEGIN
       SQL문장으로 제어
       RETURN 값;
      END;
      /
      
      CREATE [OR REPLACE] PROCEDURE pro_name(매개변수)
      IS
      BEGIN
       DML 관련 => INSERT/UPDATE/DELETE/SELECT
      END;
      /
      
      매개변수 => 값 채우기: OUT
                 -------- SELECT
                 값 주입: IN (생략 가능)
                 ------ WHERE, INSERT, UPDATE, DELETE
      호출: CALL 프로시저명(매개변수...)
            CallableStatement
      int[] arr=new in[5]
      
      public void display(int[] arr)
      {
      }
      display(arr)
*/
