package kr.co.tj.reply;


import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReplyDTO{

	
	private Long id;
	private String username;
	private String content;	
	private String productName;
	private Date createDate;
	private Date updateDate;
	private Long bid;
	
}
