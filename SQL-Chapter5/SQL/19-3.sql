-- TRIGGER
/*
     자동 이벤트 처리 = 미리 설정된 조건에 맞는 경우에 자동 실행
         ------
         DML (INSERT,UPDATE,DELETE)
     = 테이블이 다른 경우에만 적용
              -------
              |     |
     = 입고, 출고, 재고 => 입고: 같은 (UPDATE) / 다른 (INSERT)
        |          |      출고: 남아있음 (UPDATE) / 재고0 (DELETE)
        ------------
     = 맛집 좋아요 => 자동 증가
                                 1차: 신발 물류 관리 / 컨텐츠 관리 / 지도 맵 관리
                                 2차: 레시피,맛집 / 공간 대여 / 학원 (온라인시험)
    
     형식)
            CREATE [OR REPLACE] TRIGGER trigger_name
            BEFORE|AFTER [INSERT|UPDATE|DELETE] ON table_name
            ------ -----
            |먼저  |이후 적용
            EACH ROW
            DECLARE
                변수 선언
            BEGIN
                
            END;
            /
        삭제
            DROP TRIGGER trigger_name
            
    = SQL 문장을 줄일수 있다 / 보안
    = 가독성이 떨어진다
      ---------------
      | 자바에서 호출하지 않기 때문
      | 오라클 자체에서 자동 실행
*/
CREATE TABLE 상품(
    품번 NUMBER,
    상품명 VARCHAR2(100),
    단가 NUMBER
);
CREATE TABLE 입고(
    품번 NUMBER,
    수량 NUMBER,
    금액 NUMBER
);
CREATE TABLE 출고(
    품번 NUMBER,
    수량 NUMBER,
    금액 NUMBER
);
CREATE TABLE 재고(
    품번 NUMBER,
    수량 NUMBER,
    금액 NUMBER,
    누적금액 NUMBER
);

DELETE FROM 상품;
-- SQL 튜닝 TRUNCATE
INSERT INTO 상품 VALUES(100,'새우깡',1500);
INSERT INTO 상품 VALUES(200,'감자깡',1200);
INSERT INTO 상품 VALUES(300,'고구마깡',1000);
INSERT INTO 상품 VALUES(400,'치토스',2000);
INSERT INTO 상품 VALUES(500,'맛동산',2500);
COMMIT;
/*
    INSERT INTO 입고 VALUES(100,3,1500)
    :NEW => 새로 등록된 값
    :OLD => 이전에 등록된 값
*/
CREATE OR REPLACE TRIGGER 입고_trigger
AFTER INSERT ON 입고
FOR EACH ROW
DECLARE
    v_cnt NUMBER;
BEGIN
    -- 상품 재고 여부 확인
    SELECT COUNT(*) INTO v_cnt
    FROM 재고
    WHERE 품번=:NEW.품번; -- 입고시 INSERT로 들어온 값
    
    IF v_cnt=0 THEN
        INSERT INTO 재고 VALUES(:NEW.품번,
                                :NEW.수량,
                                :NEW.금액,
                                :NEW.수량*:NEW.금액);
    ELSE
        UPDATE 재고 SET
            수량=수량+:NEW.수량,
            누적금액=누적금액+(:NEW.수량*:NEW.금액)
            WHERE 품번=:NEW.품번;
            -- AutoCommit => COMMIT 사용시 오류
    END IF;
END;
/

INSERT INTO 입고 VALUES(100,5,1500);
SELECT * FROM 입고;
SELECT * FROM 재고;

-- 출고 처리
CREATE OR REPLACE TRIGGER 출고_trigger
AFTER INSERT ON 출고
FOR EACH ROW
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT 수량 INTO v_cnt
    FROM 재고
    WHERE 품번=:new.품번;
    
    IF :NEW.수량=v_cnt THEN
        DELETE FROM 재고
        WHERE 품번=:NEW.품번;
    ELSE
        UPDATE 재고 SET 
            수량=수량-:NEW.수량,
            누적금액=누적금액-(:NEW.수량*:NEW.금액)
            WHERE 품번=:NEW.품번;
    END IF;
END;
/

INSERT INTO 출고 VALUES(100,5,1500);
SELECT * FROM 출고;
SELECT * FROM 재고;

-- [질의 3-1] 모든 도서의 이름과 가격을 검색하시오.
SELECT bookname,price
FROM book;

-- [질의 3-2] 모든 도서의 도서번호, 도서이름, 출판사, 가격을 검색하시오.
SELECT bookid,bookname,publisher,price
FROM book;

-- [질의 3-3] 도서 테이블에 있는 모든 출판사를 검색하시오.
SELECT DISTINCT publisher
FROM book;

-- [질의 3-4] 가격이 20,000원 미만인 도서를 검색하시오.
SELECT *
FROM book
WHERE price<20000;

-- [질의 3-5] 가격이 10,000원 이상 20,000 이하인 도서를 검색하시오.
SELECT *
FROM book
WHERE price BETWEEN 10000 AND 20000;

-- [질의 3-6] 출판사가 ‘굿스포츠’ 혹은 ‘대한미디어’ 인 도서를 검색하시오.
SELECT *
FROM book
WHERE publisher='굿스포츠' OR publisher='대한미디어';

-- [질의 3-7] ‘축구의 역사’를 출간한 출판사를 검색하시오.
SELECT publisher
FROM book
WHERE bookname='축구의 역사';

-- [질의 3-8] 도서이름에 ‘축구’ 가 포함된 출판사를 검색하시오.
SELECT DISTINCT publisher
FROM book
WHERE bookname LIKE '%축구%';

SELECT DISTINCT publisher
FROM book
WHERE REGEXP_LIKE(bookname,'축구');

--[질의 3-9] 도서이름의 왼쪽 두 번째 위치에 ‘구’라는 문자열을 갖는 도서를 검색하시오.
SELECT bookname
FROM book
WHERE REGEXP_LIKE(bookname,'.구+');

SELECT bookname
FROM book
WHERE SUBSTR(bookname,2,1)='구';

--[질의 3-10] 축구에 관한 도서 중 가격이 20,000원 이상인 도서를 검색하시오.
SELECT bookname
FROM book
WHERE bookname LIKE '%축구%'
AND price>20000;

SELECT bookname
FROM book
WHERE price>20000 AND bookname LIKE '%축구%';
  -- CREATE INDEX idx_price_name ON book(price,bookname)
  /*
        price 조건으로 먼저 검색
        스캔범위 감소
  */
--[질의 3-11] 출판사가 ‘굿스포츠’ 혹은 ‘대한미디어’ 인 도서를 검색하시오.
SELECT bookname
FROM book
WHERE publisher='굿스포츠' OR publisher='대한미디어';


SELECT bookname
FROM book
WHERE publisher IN('굿스포츠', '대한미디어');

--[질의 3-12] 도서를 이름순으로 검색하시오. 
SELECT bookname
FROM book
ORDER BY bookname ASC;
 -- 정렬 컬럼에는 인덱스를 만든다
CREATE INDEX idx_bookname ON book(bookname ASC);

SELECT bookname
FROM book
WHERE bookname>='가';

-- INDEX_ASC INDEX_DESC => PK,UK
-- SORT 연산 최소화

--[질의 3-13] 도서를 가격순으로 검색하고, 가격이 같으면 이름순으로 검색하시오.
SELECT *
FROM book
ORDER BY price,bookname ASC;

--[질의 3-14] 도서를 가격의 내림차순으로 검색하시오. 만약 가격이 같다면 출판사의 오름차순으로 출력하시오.
SELECT *
FROM book
ORDER BY price ASC, publisher DESC;

--[질의 3-15] 고객이 주문한 도서의 총 판매액을 구하시오.
SELECT SUM(saleprice)
FROM orders;

--[질의 3-16] 2번 김연아 고객이 주문한 도서의 총 판매액을 구하시오.
SELECT SUM(saleprice)
FROM orders
WHERE custid=2;

--[질의 3-17] 고객이 주문한 도서의 총 판매액, 평균값, 최저가, 최고가를 구하시오.
SELECT SUM(saleprice) "총 판매액",AVG(saleprice) "평균값",MIN(saleprice) "최저가",MAX(saleprice) "최고가"
FROM orders;

--[질의 3-18] 마당서점의 도서 판매 건수를 구하시오.
SELECT COUNT(*) FROM orders;

--[질의 3-19] 고객별로 주문한 도서의 총 수량과 총 판매액을 구하시오.
SELECT COUNT(custid),SUM(saleprice)
FROM orders
GROUP BY custid;

--[질의 3-20] 가격이 8,000원 이상인 도서를 구매한 고객에 대하여 고객별 주문 도서의 총 수량을 구하시오. 단, 두 권 이상 구매한 고객만 구하시오.
SELECT custid, COUNT(bookid)
FROM orders
WHERE saleprice>=8000
HAVING COUNT(custid)>=2
GROUP BY custid;

--[질의 3-21] 고객과 고객의 주문에 관한 데이터를 모두 보이시오.
SELECT customer.custid, name, address, phone, orderid, bookid, saleprice, orderdate
FROM customer JOIN orders
ON customer.custid=orders.custid;

--[질의 3-22] 고객과 고객의 주문에 관한 데이터를 고객별로 정렬하여 보이시오.
SELECT customer.custid, name, address, phone, orderid, bookid, saleprice, orderdate
FROM customer JOIN orders
ON customer.custid=orders.custid
ORDER BY customer.custid;

--[질의 3-23] 고객의 이름과 고객이 주문한 도서의 판매가격을 검색하시오.
SELECT name,saleprice
FROM customer JOIN orders
ON customer.custid=orders.custid;

--[질의 3-24] 고객별로 주문한 모든 도서의 총 판매액을 구하고, 고객별로 정렬하시오.
SELECT name,SUM(saleprice)
FROM customer JOIN orders
ON customer.custid=orders.custid
GROUP BY customer.name
ORDER BY customer.name;

--[질의 3-25] 고객의 이름과 고객이 주문한 도서의 이름을 구하시오. 
SELECT name,bookname
FROM customer JOIN orders
ON customer.custid=orders.custid
JOIN book
ON orders.bookid=book.bookid;

--[질의 3-26] 가격이 20,000원인 도서를 주문한 고객의 이름과 도서의 이름을 구하시오.
SELECT name,bookname
FROM customer JOIN orders
ON customer.custid=orders.custid
JOIN book
ON orders.bookid=book.bookid
WHERE saleprice=20000;

--[질의 3-27] 도서를 구매하지 않은 고객을 포함하여 고객의 이름과 고객이 주문한 도서의 판매가격을 구하시오.
SELECT name,saleprice
FROM customer LEFT OUTER JOIN orders
ON customer.custid=orders.custid;

--[질의 3-28] 가장 비싼 도서의 이름을 보이시오.
SELECT bookname
FROM book
WHERE price=(SELECT MAX(price)FROM book);

--[질의 3-30] ‘대한미디어’에서 출판한 도서를 구매한 고객의 이름을 보이시오.
SELECT name
FROM customer
WHERE custid IN 
    (SELECT custid FROM orders WHERE bookid IN 
        (SELECT bookid FROM book WHERE publisher LIKE '대한미디어'));

--[질의 3-31] 출판사별로 출판사의 평균 도서 가격보다 비싼 도서를 구하시오. 
SELECT b1.bookname
FROM book b1
WHERE b1.price>(SELECT AVG(b2.price) FROM book b2 WHERE b2.publisher=b1.publisher);


--[질의 3-32] 도서를 주문하지 않은 고객의 이름을 보이시오. 
SELECT name
FROM customer
MINUS
SELECT name
FROM customer
WHERE custid IN(SELECT custid FROM orders);

--[질의 3-33] 주문이 있는 고객의 이름과 주소를 보이시오.
SELECT name,address
FROM customer
WHERE custid IN(SELECT custid FROM orders);

--[질의 3-34] Customer 테이블에서 고객번호가 5인 고객의 주소를 ‘대한민국 부산’으로 변경하시오.
UPDATE customer SET
address='대한민국 부산'
WHERE custid=5;

--[질의 3-35] Customer 테이블에서 박세리 고객의 주소를 김연아 고객의 주소로 변경하시오.
UPDATE customer SET
address=(SELECT address FROM customer WHERE name='김연아')
WHERE name='박세리';

--[질의 3-36] Customer 테이블에서 고객번호가 5인 고객을 삭제한 후 결과를 확인하시오.
DELETE FROM customer
WHERE custid=5;
SELECT * FROM customer;
--[질의 3-37] 모든 고객을 삭제하시오.
DELETE FROM customer;
TRUNCATE TABLE customer;


SELECT * FROM customer;
INSERT INTO customer VALUES(5,'박세리','대한민국 대전','');
commit;