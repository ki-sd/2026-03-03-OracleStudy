-- 회원
CREATE TABLE member(
	id VARCHAR2(20),
	pwd VARCHAR2(10) CONSTRAINT mem_pwd_nn NOT NULL,
	name VARCHAR2(51)CONSTRAINT mem_name_nn NOT NULL,
	sex VARCHAR2(6),
	post VARCHAR2(7) CONSTRAINT mem_post_nn NOT NULL,
	addr1 VARCHAR2(200) CONSTRAINT mem_addr1_nn NOT NULL,
	addr2 VARCHAR2(200),
	phone VARCHAR2(14),
	content CLOB,
	isAdmin CHAR(1) DEFAULT 'n',
	regdate DATE DEFAULT SYSDATE,
	
	CONSTRAINT mem_id_pk PRIMARY KEY(id),
	CONSTRAINT mem_sex_pk CHECK(sex IN('남자','여자')),
	CONSTRAINT mem_phone_uk UNIQUE(phone)
);
-- 장바구니 & 구매
CREATE TABLE buy(
	no NUMBER,
	id VARCHAR2(20),
	type NUMBER CONSTRAINT buy_type_nn NOT NULL,
	gno NUMBER CONSTRAINT buy_gno_nn NOT NULL,
	account NUMBER DEFAULT 0,
	price NUMBER DEFAULT 0,
	regdate DATE DEFAULT SYSDATE,
	
	CONSTRAINT buy_no_pk PRIMARY KEY(no),
	CONSTRAINT buy_id_fk FOREIGN KEY(id)
	REFERENCES member(id)
);
