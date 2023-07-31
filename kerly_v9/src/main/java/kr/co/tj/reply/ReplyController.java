package kr.co.tj.reply;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/reply-service")
public class ReplyController {

	@Autowired
	private ReplyService replyService;

	@Autowired
	private Environment env;

	//	댓글 페이지네이션 코드
	@GetMapping("/replys/bid")
	public ResponseEntity<?> listByBid(@RequestParam("bid") Long bid, @RequestParam("pageNum") int pageNum) {

		List<ReplyDTO> replyList = replyService.findByBid(bid, pageNum);

		return ResponseEntity.ok().body(replyList);
	}
	
	
	


	@GetMapping("/health_check")
	public String status() {
		return "reply service입니다." + env.getProperty("local.server.port");
	}

	@GetMapping("/all/{bid}")
	public ResponseEntity<?> findByBId(@PathVariable("bid") Long bid) {
		Map<String, Object> map = new HashMap<>();


		if ( bid == null) {
			map.put("result", "잘못된 접근입니다. 존재하지 않는 bid입니다.");
			return ResponseEntity.badRequest().body(map);
		}
		
		try {
			List<ReplyDTO> list = replyService.findByBId(bid);
			map.put("result", list);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			map.put("err", e.getMessage());
			return ResponseEntity.badRequest().body(map);
		}

	}

	// 댓글 입력
	@PostMapping("/user/replys")
	public ResponseEntity<?> insert(@RequestBody ReplyDTO replyDTO) {
		Map<String, Object> map = new HashMap<>();

		if (replyDTO == null 
				|| replyDTO.getUsername() == null 
				|| replyDTO.getUsername().isEmpty()
				|| replyDTO.getContent() == null 
				|| replyDTO.getContent().isEmpty()) {

			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("잘못된 접근입니다.");
		}

		try {
			replyDTO = replyService.insert(replyDTO);
			map.put("result", replyDTO);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			map.put("err", e.getMessage());
			return ResponseEntity.badRequest().body(map);
		}
	}

	// 댓글 id로 검색해서 불러오기
	@GetMapping("/id/{id}")
	public ResponseEntity<?> findById(@PathVariable("id") Long id) {
		Map<String, Object> map = new HashMap<>();

		if (id == null) {
			map.put("result", "존재하지 않는 id입니다.");
			return ResponseEntity.badRequest().body(map);
		}

		try {
			ReplyDTO dto = replyService.findById(id);
			map.put("result", dto);

			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			map.put("err", e.getMessage());
			return ResponseEntity.badRequest().body(map);
		}
	}

	// 특정 유저가 작성한 모든 댓글 불러오기
	@GetMapping("/username/{username}")
	public ResponseEntity<?> findByUsername(@PathVariable("username") String username) {
		Map<String, Object> map = new HashMap<>();
		
		if (username == null) {
			map.put("result", "존재하지 않는 유저입니다.");
			return ResponseEntity.badRequest().body(map);
		}

		try {
			List<ReplyDTO> list = replyService.findByUsername(username);
			map.put("result", list);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			map.put("err", e.getMessage());
			return ResponseEntity.badRequest().body(map);
		}

	}
	
//	댓글 페이지네이션 코드
	@GetMapping("replys/username")
	public ResponseEntity<?> listByUsername(@RequestParam("username") String username, @RequestParam("pageNum") int pageNum) {
		Map<String, Object> map = new HashMap<>();

		Page<ReplyDTO> page = replyService.findByUsername(username, pageNum);
		map.put("result", page);

		return ResponseEntity.ok().body(map);
	}
	

	// 댓글 수정하기
	@PutMapping("/update")
	public ResponseEntity<?> update(@RequestBody ReplyDTO replyDTO) {
		Map<String, Object> map = new HashMap<>();

		if (replyDTO == null 
				|| replyDTO.getId() == null 
				|| replyDTO.getId() == 0L
				|| replyDTO.getUsername() == null 
				|| replyDTO.getUsername().isEmpty()
				|| replyDTO.getContent() == null 
				|| replyDTO.getContent().isEmpty()) {
			map.put("result", "잘못된 접근입니다. replyDTO값이 존재하지 않습니다.");
			return ResponseEntity.badRequest().body(map);
		}

		try {
			replyDTO = replyService.update(replyDTO);
			map.put("result", replyDTO);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			map.put("err", e.getMessage());
			return ResponseEntity.badRequest().body(map);
		}
	}

	// 댓글 삭제하기
	@DeleteMapping("/delete")
	public ResponseEntity<?> delete(@RequestBody ReplyDTO replyDTO) {

		Map<String, Object> map = new HashMap<>();
		
		if (replyDTO == null 
				|| replyDTO.getId() == null 
				|| replyDTO.getId() == 0L) {
			map.put("result", "잘못된 접근입니다. replyDTO값이 존재하지 않습니다.");
			return ResponseEntity.badRequest().body(map);
		}

		try {
			replyService.delete(replyDTO.getId());
			map.put("result", replyDTO);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			map.put("err", e.getMessage());
			return ResponseEntity.badRequest().body(map);
		}
	}
}
