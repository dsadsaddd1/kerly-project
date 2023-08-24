package kr.co.tj.member;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberDTO {

	private String id;
	private String username;
	private String name;
	private Date createDate;
	private Date updateDate;
	private String password;
	private String password2;
	private String orgPassword;
	private String token;
	private int role;
	private String PhoneNumber;
	private String address;
}
