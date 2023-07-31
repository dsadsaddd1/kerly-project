package kr.co.tj.item;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "items")
@Entity
@Builder
public class ItemEntity {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(nullable = false)
	private String itemName;
	
	@Column(nullable = false)
	private Long price;
	
	private Long discount;
	
	@Column(nullable = false)
	private String username;
	
	@Column(nullable = false)
	private Long ea;
	
	@Column(nullable = false)
	private String itemDescribe;
	
	@Column(nullable = false)
	private String itemType;
	
	private Date createDate;
	private Date updateDate;

}
