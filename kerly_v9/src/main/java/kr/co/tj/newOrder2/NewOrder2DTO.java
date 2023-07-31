package kr.co.tj.newOrder2;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.CollectionTable;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;

import kr.co.tj.item.ItemEntity;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

//@Data
//@NoArgsConstructor
//@AllArgsConstructor
//@Builder
//public class NewOrder2DTO {
//
//    @Id
//    private Long id;
//
//    private Long totalPrice;
//
//    private Date createDate;
//    private String username;
//    
//    private List<String> itemNames = new ArrayList<>();
//    private List<Long> itemPrices = new ArrayList<>();
//    private List<Long> itemIds = new ArrayList<>();
//    private List<Long> itemStocks = new ArrayList<>();
//    private List<String> sellerNames = new ArrayList<>();
//    private List<Long> item_totalPrice = new ArrayList<>();
//    
//
//}

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NewOrder2DTO {

    private Long id;
    private Long totalPrice;
    private Date createDate;
    private String username;
    private List<OrderItemDTO> orderItems;
    private String orderNum;

    // ... (기타 필드 및 게터/세터 생략)
}