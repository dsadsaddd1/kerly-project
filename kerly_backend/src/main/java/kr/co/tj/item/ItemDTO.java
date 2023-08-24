package kr.co.tj.item;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ItemDTO {
	
	private Long id;
	
	private String itemName;
	
	private Long price;
	
	private Long discount;
	
	private String username;
	
	private Long ea;
	
	private String itemDescribe;
	
	private String itemType;
	
	private Date createDate;
	private Date updateDate;

}
