package kr.co.tj.item;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import javax.transaction.Transactional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@Service
public class ItemService {

	@Autowired
	private ItemRepository itemRepository;

	   public List<ItemDTO> search(String keyword, int pageNum) {
		      List<Sort.Order> sortList = new ArrayList<>();
		      sortList.add(Sort.Order.desc("id"));

		      Pageable pageable = PageRequest.of(pageNum, 20, Sort.by(sortList));
		      Page<ItemEntity> pageItem = itemRepository.findByitemNameContaining(keyword, pageable);
//		      Page<ItemDTO> pageDto = pageItem.map(itemEntity -> new ModelMapper().map(itemEntity, ItemDTO.class));
		      
		      List<ItemEntity> list_entity = pageItem.getContent();
		       List<ItemDTO> dtoList = new ArrayList<>();
		       
		       for(ItemEntity x : list_entity) {
		          ItemDTO dto = new ModelMapper().map(x, ItemDTO.class);
		          dtoList.add(dto);
		       }

		      return dtoList;
		   }
	public Page<ItemDTO> findAll(String username, int pageNum) {

		List<Sort.Order> sortList = new ArrayList<>();
		sortList.add(Sort.Order.desc("id"));

		Pageable pageable = PageRequest.of(pageNum, 5, Sort.by(sortList));
		Page<ItemEntity> pageItem = itemRepository.findByUsername(username, pageable);
		Page<ItemDTO> pageDto = pageItem.map(itemEntity -> new ModelMapper().map(itemEntity, ItemDTO.class));

		return pageDto;
	}

	public List<ItemDTO> itemListOfStaff(String username) {

		List<ItemDTO> list_dto = new ArrayList<>();

		List<ItemEntity> list_entity = itemRepository.findByUsername(username);

		list_dto.add(new ModelMapper().map(list_entity, ItemDTO.class));

		return list_dto;
	}

//	public Page<ItemDTO> findAll(int page) {
//		List<Sort.Order> sortList = new ArrayList<>();
//		sortList.add(Sort.Order.desc("id"));
//
//		Pageable pageable = PageRequest.of(page, 5, Sort.by(sortList));
//		Page<ItemEntity> pageItem = itemRepository.findAll(pageable);
//		Page<ItemDTO> pageDto = pageItem.map(itemEntity -> new ModelMapper().map(itemEntity, ItemDTO.class));
//
//		return pageDto;
//	}

	   public List<ItemDTO> findAll(int page) {
		      List<Sort.Order> sortList = new ArrayList<>();
		      sortList.add(Sort.Order.desc("id"));

		      Pageable pageable = PageRequest.of(page, 20, Sort.by(sortList));
		      Page<ItemEntity> pageItem = itemRepository.findAll(pageable);
		      
		       List<ItemEntity> list_entity = pageItem.getContent();
		       List<ItemDTO> dtoList = new ArrayList<>();
		      
		       for(ItemEntity x : list_entity) {
		             ItemDTO dto = new ModelMapper().map(x, ItemDTO.class);
		             dtoList.add(dto);
		          }

		      return dtoList;
		   }
	

	
	public List<ItemDTO> findByItemType(String itemType, int page) {
	
	    List<Sort.Order> sortList = new ArrayList<>();
	    sortList.add(Sort.Order.desc("id"));

	    Pageable pageable = PageRequest.of(page, 20, Sort.by(sortList));
	    Page<ItemEntity> pageItem = itemRepository.findByItemType(itemType, pageable);

	    List<ItemEntity> list_entity = pageItem.getContent();
	    List<ItemDTO> dtoList = new ArrayList<>();
	    
	    for(ItemEntity x : list_entity) {
	    	ItemDTO dto = new ModelMapper().map(x, ItemDTO.class);
	    	dtoList.add(dto);
	    }

	    return dtoList;
	}
	

	@Transactional
	public void delete(long id) {
		itemRepository.deleteById(id);

	}

	public List<ItemDTO> findByItemType(String itemType) {
		List<ItemDTO> list_dto = new ArrayList<>();
		List<ItemEntity> list_entity = itemRepository.findByItemType(itemType);

		list_dto.add(new ModelMapper().map(list_entity, ItemDTO.class));

		return list_dto;
	}

	@Transactional
	public ItemDTO updateItem(ItemDTO itemDTO) {

		Optional<ItemEntity> optioanl = itemRepository.findById(itemDTO.getId());

		ItemEntity entity = optioanl.get();

		if (entity == null) {
			throw new RuntimeException("잘못된 정보에용");
		}

		entity.setItemName(itemDTO.getItemName());
		entity.setPrice(itemDTO.getPrice());
		entity.setDiscount(itemDTO.getDiscount());
		entity.setEa(itemDTO.getEa());
		entity.setItemDescribe(itemDTO.getItemDescribe());
		entity.setUpdateDate(new Date());
		entity.setItemType(itemDTO.getItemType());
		entity = itemRepository.save(entity);

		return new ModelMapper().map(entity, ItemDTO.class);
	}

	public ItemDTO findById(Long id) {

		Optional<ItemEntity> optional = itemRepository.findById(id);

		ItemEntity entity = optional.get();      
		return new ModelMapper().map(entity, ItemDTO.class);
	}

	public List<ItemDTO> findByUsername(String username) {

		List<ItemDTO> list_dto = new ArrayList<>();

		List<ItemEntity> list_entity = itemRepository.findByUsername(username);

		list_dto.add(new ModelMapper().map(list_entity, ItemDTO.class));

		return list_dto;
	}

	public List<ItemDTO> findAll() {
		List<ItemDTO> list_dto = new ArrayList<>();
		List<ItemEntity> list_entity = itemRepository.findAll();

		list_entity.forEach(e -> {
			list_dto.add(new ModelMapper().map(e, ItemDTO.class));
		});
		return list_dto;
	}

	public ItemDTO createItem(ItemDTO itemDTO) {

		ItemEntity entity = new ModelMapper().map(itemDTO, ItemEntity.class);

		Date now = new Date();
		entity.setCreateDate(now);
		entity.setUpdateDate(now);

		entity = itemRepository.save(entity);

		return new ModelMapper().map(entity, ItemDTO.class);
	}

	@Transactional
	public String updateEaByProductId2(ItemEntity itemEntity) {
	    try {
	        ItemEntity existingItemEntity = itemRepository.findById(itemEntity.getId())
	                .orElseThrow(() -> new RuntimeException("해당 상품을 찾을 수 없습니다."));
	        
	        Long orderedEa = itemEntity.getEa() != null ? itemEntity.getEa() : 0L;
	        Long currentEa = existingItemEntity.getEa() != null ? existingItemEntity.getEa() : 0L;
	        System.out.println("::::::::");
	        System.out.println(orderedEa);
	        System.out.println("::::::::");
	        System.out.println(currentEa);
	        existingItemEntity.setEa(currentEa + orderedEa);
	        itemRepository.save(existingItemEntity);
	        return "ok";
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "fail";
	    }
	}

	@Transactional
	public String updateEaByProductId(ItemEntity itemEntity) {
		try {
			ItemEntity existingItemEntity = itemRepository.findById(itemEntity.getId())
					.orElseThrow(() -> new RuntimeException("해당 상품을 찾을 수 없습니다."));

			Long orderedEa = itemEntity.getEa();
			Long currentEa = existingItemEntity.getEa();

			if (currentEa < orderedEa) {
				throw new RuntimeException("재고가 부족합니다.");
			}

			existingItemEntity.setEa(currentEa - orderedEa);
			itemRepository.save(existingItemEntity);

			return "ok";
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
	}
	
	 public List<ItemEntity> getItemsByIds(List<ItemEntity> items) {
	        List<Long> itemIds = items.stream()
	                .map(ItemEntity::getId)
	                .collect(Collectors.toList());
	        return itemRepository.findAllById(itemIds);
	    }
//	public void updateOrderStock(Long itemId) {
//		// TODO Auto-generated method stub
//		
//		
//		try {
//			ItemEntity exItemEntity = itemRepository.findById(itemId).orElseThrow(() -> new RuntimeException("해당 상품을 찾을 수 없습니다."));
//			
//			Long exStock = 
//					
//			
//			
//		}catch (Exception e) {
//			
//		}
//	}
	 
//	public ItemEntity findById(Long itemId) {
//		// TODO Auto-generated method stub
//		Optional<ItemEntity> optional = itemRepository.findById(itemId);
//		
//		System.out.println(itemId);
//				ItemEntity entity = optional.get();
//		
//				return entity;
//
//	}

}
