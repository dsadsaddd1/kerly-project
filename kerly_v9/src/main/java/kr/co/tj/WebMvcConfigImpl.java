package kr.co.tj;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfigImpl implements WebMvcConfigurer {
	@Override
	public void addCorsMappings(CorsRegistry registry) {
		registry.addMapping("/**")       // 모든 요청을 막지만
		.allowedOrigins("/**") // 해당 주소에서 오는 요청은 허용
		.allowedMethods("GET", "POST", "PUT", "DELETE") // 허용하는 전송 방식
		.allowedHeaders("*") // 모든 헤더 허용
		.allowCredentials(true) // 인증정보를 요청하면 허용하겠다.
		.maxAge(360000);  // 시간 설정. 1당 1초.
	}
}
