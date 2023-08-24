package kr.co.tj.item;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
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
@RequestMapping("/item-service")
public class ItemController {

	@Autowired
	private ItemService itemService;
	   
	   @GetMapping("/search/keyword")
	   public ResponseEntity<?> search(@RequestParam("keyword") String keyword, @RequestParam("pageNum") int pageNum) {
	      Map<String, Object> map = new HashMap<>();

	      try {
	         List<ItemDTO> page = itemService.search(keyword, pageNum);
	         map.put("result", page);
	         return ResponseEntity.ok().body(page);
	      } catch (Exception e) {
	         e.printStackTrace();
	         map.put("result", "에러");
	         return ResponseEntity.badRequest().body(map);
	      }
	   }


	@GetMapping("/list/username/search")
	public ResponseEntity<?> list(@RequestParam("username") String username, @RequestParam("pageNum") int pageNum) {
		Map<String, Object> map = new HashMap<>();
		Page<ItemDTO> page = itemService.findAll(username, pageNum);
		map.put("result", page);

		return ResponseEntity.ok().body(map);
	}


	@GetMapping("/list/username/{username}")
	public ResponseEntity<?> itemListOfStaff(@PathVariable("username") String username) {
		Map<String, Object> map = new HashMap<>();

		try {
			List<ItemDTO> list = itemService.itemListOfStaff(username);
			map.put("result", list);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("result", "해당 스태프의 리스트를 가져오지 못했습니다.");
			return ResponseEntity.badRequest().body(map);
		}
	}

	   @GetMapping("/items/list") // itemList 불러오기
	   public ResponseEntity<?> list(int pageNum) {

	      Map<String, Object> map = new HashMap<>();

	      List<ItemDTO> page = itemService.findAll(pageNum);
	      map.put("result", page);

	      return ResponseEntity.ok().body(page);
	   }
	
	
	@GetMapping("/itemtype/itemtype")
	public ResponseEntity<?> listByItemType(@RequestParam("itemType") String itemType, @RequestParam("pageNum") int pageNum) {
	    Map<String, Object> map = new HashMap<>();

	    List<ItemDTO> itemList = itemService.findByItemType(itemType, pageNum);
	    map.put("result", itemList);
	    
	    return ResponseEntity.ok().body(itemList);
	}
	
	
	@DeleteMapping("/item/admin")
	public ResponseEntity<?> delete(@RequestBody ItemDTO itemDTO) {

		Map<String, Object> map = new HashMap<>();

		Long id = itemDTO.getId();

		if (itemDTO == null || id == null || id == 0L) {
			map.put("result", "잘못된 정보입니다.");
			return ResponseEntity.badRequest().body(map);
		}

		try {
			itemService.delete(id);
			map.put("result", "삭제 성공이요");
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("result", "삭제 실패");
			return ResponseEntity.badRequest().body(map);
		}
	}

	@GetMapping("/list/itemtype/{itemType}")
	public ResponseEntity<?> findByItemType(@PathVariable("itemType") String itemType) {
		Map<String, Object> map = new HashMap<>();

		if (itemType == null) {
			map.put("result", "잘못된 접근입니다.");
			return ResponseEntity.badRequest().body(map);
		}

		try {
			List<ItemDTO> list = itemService.findByItemType(itemType);
			map.put("result", list);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			map.put("err", e.getMessage());
			return ResponseEntity.badRequest().body(map);
		}
	}

	@PutMapping("/item/admin/update")
	public ResponseEntity<?> update(@RequestBody ItemDTO itemDTO) {

		Map<String, Object> map = new HashMap<>();

		if (itemDTO == null || itemDTO.getItemName() == null || itemDTO.getPrice() == 0 || itemDTO.getEa() == 0
				|| itemDTO.getItemDescribe() == null || itemDTO.getItemDescribe() == "" || itemDTO.getItemType() == null
				|| itemDTO.getItemType() == "") {
			map.put("result", "잘못된 정보입니다");
			return ResponseEntity.badRequest().body(map);
		}

		try {
			itemDTO = itemService.updateItem(itemDTO);
			map.put("result", itemDTO);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("result", "수정 시루떡");
			return ResponseEntity.badRequest().body(map);
		}

	}

	@GetMapping("/id/{id}")
	public ResponseEntity<?> findById(@PathVariable("id") Long id) {

		Map<String, Object> map = new HashMap<>();

		if (id == null) {
			map.put("result", "잘못된 정보입니다.");
			return ResponseEntity.badRequest().body(map);
		}

		try {
			ItemDTO dto = itemService.findById(id);
			map.put("result", dto);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("result", "에러 발생");
			return ResponseEntity.badRequest().body(map);
		}
	}

	@GetMapping("/item/username/{username}")
	public ResponseEntity<?> findByUsername(@PathVariable() String username) {

		Map<String, Object> map = new HashMap<>();

		if (username == null) {
			map.put("result", "잘못된 정보입니다.");
			return ResponseEntity.badRequest().body(map);
		}

		List<ItemDTO> list;
		try {
			list = itemService.findByUsername(username);
			map.put("result", list);
			return ResponseEntity.ok().body(list);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("result", "에러 발생");
			return ResponseEntity.badRequest().body(map);
		}

	}

	@GetMapping("/all")
	public ResponseEntity<?> findAll() {

		Map<String, Object> map = new HashMap<>();

		try {
			List<ItemDTO> list = itemService.findAll();
			map.put("list", list);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			map.put("result", "에러 발생");
			return ResponseEntity.badRequest().body(map);
		}
	}

	@PostMapping("/item/manager")
	public ResponseEntity<?> createItem(@RequestBody ItemDTO itemDTO) {

		Map<String, Object> map = new HashMap<>();

		if (itemDTO.getItemName() == null 
				|| itemDTO.getPrice() == 0 
				|| itemDTO.getDiscount() <= -1
				|| itemDTO.getUsername() == null 
				|| itemDTO.getUsername().equals("") 
				|| itemDTO.getEa() <= 0
				|| itemDTO.getItemDescribe() == null 
				|| itemDTO.getItemDescribe().equals("")
				|| itemDTO.getItemType() == null 
				|| itemDTO.getItemType().equals("")) {

			map.put("result", "상품 입력 실패1");
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(map);
		}

		try {
			itemDTO = itemService.createItem(itemDTO);
			map.put("result", itemDTO);
			return ResponseEntity.ok().body(map);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("result", "등록 실패");
			return ResponseEntity.badRequest().body(map);
		}

	}

}
