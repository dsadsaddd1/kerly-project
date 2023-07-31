package kr.co.tj.newOrder2;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderItemDTO {

    private Long id;
    private String itemName;
    private Long itemPrice;
    private Long itemStock;
    private String itemSellerName;
    private Long itemTotalPrice;
    private Long itemId;
    private Long orderId;

    // ... (기타 필드 및 게터/세터 생략)
}