package kr.co.tj.bookmark;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import javax.management.RuntimeErrorException;
import javax.transaction.Transactional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import kr.co.tj.reply.ReplyEntity;


@Service
public class BookmarkService {
	
	@Autowired
	private BookmarkRepository bookmarkRepository;

	public BookmarkDTO createBookmark(BookmarkDTO bookmarkDTO) {
		// TODO Auto-generated method stub
		
		BookmarkEntity entity = new ModelMapper().map(bookmarkDTO, BookmarkEntity.class);
		
		Date now = new Date();
		entity.setCreateDate(now);
		
		entity = bookmarkRepository.save(entity);
		
		return new ModelMapper().map(entity, BookmarkDTO.class);
	}

//	public BookmarkDTO findByBidAndUsername(Long bid, String username) {
//		// TODO Auto-generated method stub
//		
//		Optional<BookmarkEntity> optional = bookmarkRepository.findByBidAndUsername(bid, username);	
//		BookmarkEntity entity = optional.get();
//		
//
//		return new ModelMapper().map(entity, BookmarkDTO.class);
//	}
//	
	
	   public BookmarkDTO findByBidAndUsername(Long bid, String username) {
	       Optional<BookmarkEntity> optional = bookmarkRepository.findByBidAndUsername(bid, username);
	       if (!optional.isPresent()) {
	           BookmarkEntity entity = optional.get();
	           return new ModelMapper().map(entity, BookmarkDTO.class);
	       }
	       return null;
	   }
	   

	
//	
//	public BookmarkDTO findByBidAndUsername(Long bid, String username) {
//
//	      Optional<BookmarkEntity> optional = bookmarkRepository.findByBidAndUsername(bid, username);
//	      BookmarkEntity entity = optional.orElse(null);
//	       if (entity == null) {
//	           return null;
//	       }
//	      entity = optional.get();
//	      return new ModelMapper().map(entity, BookmarkDTO.class);
//	   }

	@Transactional
	public void delete(Long bid) {
		// TODO Auto-generated method stub
		bookmarkRepository.deleteByBid(bid);
	}

//	public List<BookmarkDTO> findByUsername(String username) {
//		// TODO Auto-generated method stub
//		
//		List<BookmarkEntity> list_entity = bookmarkRepository.findByUsername(username);
//		List<BookmarkDTO> list_dto = new ArrayList<>();
//		
//		if(list_entity.isEmpty()) {
//			throw new RuntimeException("존재하지 않는 유저");
//		}
//		
//		for(BookmarkEntity e: list_entity) {
//			list_dto.add(new ModelMapper().map(e, BookmarkDTO.class));
//		}
//		
//		return list_dto;
//	}

	public List<BookmarkDTO> findByUsername(String username, int pageNum) {
		// TODO Auto-generated method stub
		
		List<Sort.Order> sortList = new ArrayList<>();
	       sortList.add(Sort.Order.desc("id"));
	       
	       Pageable pageable = PageRequest.of(pageNum, 20, Sort.by(sortList));
	       Page<BookmarkEntity> pageItem = bookmarkRepository.findByUsername(username, pageable);
		
	       
	       List<BookmarkEntity> list_entity = pageItem.getContent();
	       List<BookmarkDTO> list_dto = new ArrayList<>();
	       
	       for(BookmarkEntity x : list_entity) {
	    	   BookmarkDTO dto = new ModelMapper().map(x, BookmarkDTO.class);
	    	   list_dto.add(dto);
	       }
		return list_dto;
	}

}
