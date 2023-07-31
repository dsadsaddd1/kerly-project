package kr.co.tj.bookmark;

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
@Table(name = "bookmark")
@Entity
@Builder
public class BookmarkEntity {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(nullable = false)
	private String itemName;
		
	@Column(nullable = false)
	private String username;
	
	@Column(nullable = false)
	private String sellerName;
	
	@Column(nullable = false)
	private Long bid;
	
	private Date createDate;

}
