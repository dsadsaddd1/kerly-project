package kr.co.tj.member;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/member-service")
public class MemberController {

	@Autowired
	private MemberService memberService;



	// 아이디 중복 확인
	@GetMapping("/checkid")
	public ResponseEntity<?> checkId(String username) {
		Map<String, Object> map = new HashMap<>();

		map.put("result", memberService.checkByUsername(username));
		return ResponseEntity.ok().body(map);

	}


	// 회원 비밀번호 수정
	@PutMapping("/user/password")
	public ResponseEntity<?> updatePassword(@RequestBody MemberDTO memberDTO) {
		Map<String, Object> map = new HashMap<>();

		if (memberDTO == null) {
			map.put("result", "에러가 발생했습니다1.");
			return ResponseEntity.ok().body(map);
		}

		if (memberDTO.getOrgPassword() == null) {
			map.put("result", "에러가 발생했습니다2.");
			return ResponseEntity.ok().body(map);
		}

		if (memberDTO.getUsername() == null) {
			map.put("result", "에러가 발생했습니다3.");
			return ResponseEntity.ok().body(map);
		}

		String password = memberDTO.getPassword();
		String password2 = memberDTO.getPassword2();

		if (password == null) {
			map.put("result", "에러가 발생했습니다4.");
			return ResponseEntity.ok().body(map);
		}

		if (password2 == null) {
			map.put("result", "에러가 발생했습니다5.");
			return ResponseEntity.ok().body(map);
		}

		if (!password.equals(password2)) {
			map.put("result", "에러가 발생했습니다6.");
			return ResponseEntity.ok().body(map);
		}

		try {
			memberDTO = memberService.updatePassword(memberDTO);
			map.put("result", "성공");
			return ResponseEntity.ok().body(map);
		} catch (RuntimeException e) {
			e.printStackTrace();
			map.put("result", e.getMessage()); // 예외 메시지를 반환
			return ResponseEntity.ok().body(map);
		}
	}

	// 회원 정보 수정
	@PutMapping("/user/username")
	public ResponseEntity<?> updateMember(@RequestBody MemberDTO memberDTO) {
		Map<String, Object> map = new HashMap<>();

		if (memberDTO == null) {
			map.put("result", null);
			map.put("msg", "에러가 발생했습니다.");
			return ResponseEntity.ok().body(map);
		}

		if (memberDTO.getUsername() == null) {
			map.put("result", null);
			map.put("msg", "에러가 발생했습니다.");
			return ResponseEntity.ok().body(map);
		}

		if (memberDTO.getPassword() == null) {
			map.put("result", null);
			map.put("msg", "에러가 발생했습니다.");
			return ResponseEntity.ok().body(map);
		}

		try {
			memberDTO = memberService.updateMember(memberDTO);
			if (memberDTO != null) {
				map.put("result", "수정되었습니다.");
			} else {
				map.put("result", "수정 실패했습니다.");
			}
			map.put("result", memberDTO);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			map.put("result", "수정에 실패했습니다.");
			return ResponseEntity.ok().body(map);
		}

	}

	// 회원 삭제
	@DeleteMapping("/delete")
	public ResponseEntity<?> delete(@RequestBody MemberDTO memberDTO) {
		Map<String, Object> map = new HashMap<>();

		if (memberDTO == null) {
			map.put("result", "잘못된 정보입니다.");
			return ResponseEntity.ok().body(map);
		}

		int result = memberService.delete(memberDTO);
		switch (result) {
		case 200:
			map.put("result", "삭제에 성공했습니다.");
			break;

		case 500:
			map.put("result", "삭제에 실패했습니다.");
		case 404:
			map.put("result", "회원이 존재하지 않습니다.");

		default:
			break;
		}

		return ResponseEntity.ok().body(map);

	}

	// 회원 정보 자세히 보기
	@GetMapping("/username/{username}")
	public ResponseEntity<?> findByUsername(@PathVariable("username") String username) {
		Map<String, Object> map = new HashMap<>();

		if (username == null) {
			map.put("result", "에러가 발생했습니다.");
			return ResponseEntity.ok().body(map);
		}

		MemberDTO dto;

		try {
			dto = memberService.findByUsername(username);
			map.put("result", dto);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			map.put("result", "회원의 정보를 찾을 수 없습니다.");
			return ResponseEntity.ok().body(map);
		}
	}

	// 회원 목록
	@GetMapping("/all")
	public ResponseEntity<?> findAll() {
		Map<String, Object> map = new HashMap<>();

		try {
			List<MemberDTO> memberList = memberService.findAll();
			map.put("result", memberList);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			map.put("result", "회원 리스트를 불러오지 못했습니다");
			return ResponseEntity.ok().body(map);
		}
	}

}