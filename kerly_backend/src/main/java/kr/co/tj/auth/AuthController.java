package kr.co.tj.auth;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.co.tj.member.MemberDTO;
import kr.co.tj.member.MemberService;

@RestController
@RequestMapping("/auth-service")
public class AuthController {
	
	@Autowired
	private MemberService memberService;
	
	
	@GetMapping("/checkid")
	public ResponseEntity<?> checkId(String username) {

		return ResponseEntity.ok().body(memberService.checkByUsername(username));

	}
	
	
	 // 로그인
	   @PostMapping("/login")
	   public ResponseEntity<?> login(@RequestBody MemberDTO memberDTO){
	      Map<String, Object> map = new HashMap<>();
	      
	      if(memberDTO == null) {
	         return ResponseEntity.ok().body("실패");
	      }
	      
	      if(memberDTO.getUsername() == null || memberDTO.getUsername().isEmpty()) {
	         map.put("result", "아이디를 입력해주세요.");
	         return ResponseEntity.ok().body(map);
	      }
	      if(memberDTO.getPassword() == null || memberDTO.getPassword().isEmpty()) {
	         map.put("result", "비밀번호를 입력해주세요.");
	         return ResponseEntity.ok().body(map);
	      }
	      
	      
	      try {
	         memberDTO = memberService.login(memberDTO);
	         map.put("result", memberDTO);
	         return ResponseEntity.ok().body(map);
	      } catch (Exception e) {
	         e.printStackTrace();
	         map.put("result", "로그인에 실패했습니다.");
	         return ResponseEntity.ok().body(map);
	      }
	      
	   }

	 // 회원가입
	   @PostMapping("/create")
	   public ResponseEntity<?> createMember(@RequestBody MemberDTO memberDTO){
	      Map<String, Object> map = new HashMap<>();
	      
	      if(memberDTO == null) {
	         map.put("result", "입력란에 입력해주세요.");
	         return ResponseEntity.ok().body(map);
	      }
	      
	      if(memberDTO.getUsername()==null) {
	         map.put("result", "아이디를 입력해주세요.");
	         return ResponseEntity.ok().body(map);
	      }
	      
	      if(memberDTO.getName()==null) {
	         map.put("result", "이름을 입력해주세요.");
	         return ResponseEntity.ok().body(map);
	      }
	      
	      if(memberDTO.getPassword()==null) {
	         map.put("result", "비밀번호를 입력해주세요.");
	         return ResponseEntity.ok().body(map);
	      }
	      
	      if(memberDTO.getPassword2()==null) {
	         map.put("result", "비밀번호를 입력해주세요.");
	         return ResponseEntity.ok().body(map);
	      }
	      
	      String password = memberDTO.getPassword();
	      String password2 = memberDTO.getPassword2();
	      
	      if (!password.equals(password2)) {
	         map.put("result", "비밀번호가 일치하지 않습니다.");
	         return ResponseEntity.badRequest().body(map);
	      }
	      
	      
	      try {
	         memberDTO = memberService.createMember(memberDTO);
	         map.put("result", memberDTO);
	         return ResponseEntity.ok().body(map);
	      } catch (Exception e) {
	         // TODO Auto-generated catch block
	         e.printStackTrace();
	         map.put("result", "회원가입에 실패하였습니다.");
	         return ResponseEntity.ok().body(map);
	      }
	   }
}
