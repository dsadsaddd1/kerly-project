package kr.co.tj.sec;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import kr.co.tj.member.MemberEntity;

@Component
public class TokenProvider {
	private static final String SECRET_KEY="ewftgwegweswqr";
	
	// 토큰에 대한 유효성 검사
	public String validateAndGetUserId(String token) {

		Claims claims = Jwts.parser()
		.setSigningKey(SECRET_KEY)
		.parseClaimsJws(token)
		.getBody(); // 유효성 검사
		
		return claims.getSubject(); // userId 넘겨주는
	}
	
	public String validateAndAuthority(String token) {

		Claims claims = Jwts.parser()
		.setSigningKey(SECRET_KEY)
		.parseClaimsJws(token)
		.getBody(); // 유효성 검사
		
		return (String)claims.get("authority");
	}
	
	
	// 토큰 발행
	public String create(MemberEntity memberEntity) {
		String[] arr = {"ROLE_USER", "ROLE_ADMIN"};
		Map<String, Object> map = new HashMap<>();
		map.put("authority", arr[memberEntity.getRole()]);
		
		Claims claims = Jwts.claims(map);
		
		Date expire = Date.from(Instant.now().plus(1, ChronoUnit.HOURS));
		
		return Jwts.builder()
		.signWith(SignatureAlgorithm.HS512, SECRET_KEY)
		.setSubject(memberEntity.getId())
		.setIssuer("kerly")
		.setIssuedAt(new Date())
		.setExpiration(expire)
		.setClaims(claims)
		.compact();
	}
}
