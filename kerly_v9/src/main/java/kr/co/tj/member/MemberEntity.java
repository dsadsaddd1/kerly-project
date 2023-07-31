package kr.co.tj.member;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.GenericGenerator;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Builder
@Table(name="member")
public class MemberEntity {

	@Id
	@GeneratedValue(generator = "id-uuid")
	@GenericGenerator(strategy = "uuid", name = "id-uuid")
	private String id;
	
	@Column(unique = true, nullable = false)
	private String username;
	
	@Column(nullable = false)
	private String name;
	
	private Date createDate;
	
	private Date updateDate;
	
	@Column(nullable = false)
	private String password;
	

	@ColumnDefault("0")
	private int role;
	
	private String token;
	
	private String PhoneNumber;
	private String address;
}