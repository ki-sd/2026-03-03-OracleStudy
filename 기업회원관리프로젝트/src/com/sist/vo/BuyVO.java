package com.sist.vo;
//	NO                                        NOT NULL NUMBER
//	ID                                                 VARCHAR2(20)
//	TYPE                                      NOT NULL NUMBER
//	GNO                                       NOT NULL NUMBER
//	ACCOUNT                                            NUMBER
//	PRICE                                              NUMBER
//	REGDATE                                            DATE
import java.util.*;

import lombok.Data;
@Data
public class BuyVO {
	private int no,type,gno,account,price;
	private String id,dbday;
	private Date regdate;
	private GoodsVO gvo=new GoodsVO();
}
