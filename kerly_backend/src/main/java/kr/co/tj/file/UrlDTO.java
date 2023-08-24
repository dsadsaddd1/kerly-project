package kr.co.tj.file;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UrlDTO {
	
    private Long id;
    
    private String imageUrl;
    
    private String username;

}
