package kr.co.tj.reply;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import javax.transaction.Transactional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;


@Service
public class ReplyService {

	@Autowired
	private ReplyRepository replyRepository;


	// 댓글 입력
	public ReplyDTO insert(ReplyDTO replyDTO) {
		// TODO Auto-generated method stub
		
		ReplyEntity replyEntity = new ModelMapper().map(replyDTO, ReplyEntity.class);
		
		Date date = new Date();
		replyEntity.setCreateDate(date);
		replyEntity.setUpdateDate(date);
		replyEntity = replyRepository.save(replyEntity);
		
		replyDTO = new ModelMapper().map(replyEntity, ReplyDTO.class);
		
		return replyDTO;
	}



	public ReplyDTO findById(Long id) {
		Optional<ReplyEntity> optional = replyRepository.findById(id);
		
		if(!optional.isPresent()) {
			throw new RuntimeException("잘못된 접근입니다. 댓글이 존재하지 않습니다.");
		}
		
		ReplyEntity replyEntity = optional.get();
		ReplyDTO replyDTO = new ModelMapper().map(replyEntity, ReplyDTO.class);
		
		return replyDTO;
	}



	public List<ReplyDTO> findByBId(Long bid) {
		// TODO Auto-generated method stub
		List<ReplyEntity> list_entity = replyRepository.findByBid(bid);
		List<ReplyDTO> list_dto = new ArrayList<>();
		
		if(list_entity.isEmpty()) {
			throw new RuntimeException("잘못된 접근입니다. 게시글이 존재하지 않습니다.");
		}
		
		
		for (ReplyEntity e: list_entity) {
			list_dto.add(new ModelMapper().map(e, ReplyDTO.class));
		}

		return list_dto;
	}



	public List<ReplyDTO> findByUsername(String username) {
		// TODO Auto-generated method stub
		List<ReplyEntity> list_entity = replyRepository.findByUsername(username);
		List<ReplyDTO> list_dto = new ArrayList<>();
		
		if(list_entity.isEmpty()) {
			throw new RuntimeException("잘못된 접근입니다. 유저가 존재하지 않습니다.");
		}
		
		for (ReplyEntity e: list_entity) {
			list_dto.add(new ModelMapper().map(e, ReplyDTO.class));
		}

		return list_dto;
	}


	@Transactional
	public ReplyDTO update(ReplyDTO replyDTO) {

		Optional<ReplyEntity> optional = replyRepository.findById(replyDTO.getId());
		
		if(!optional.isPresent()) {
			throw new RuntimeException("잘못된 접근입니다. 댓글이 존재하지 않습니다.");
		}
		
		ReplyEntity replyEntity = optional.get();
		
		if(!replyEntity.getUsername().equals(replyDTO.getUsername())) {
			throw new RuntimeException("잘못된 접근입니다. 댓글 작성자가 일치하지 않습니다.");
		}
		
		replyEntity.setContent(replyDTO.getContent());
		Date date = new Date();
		replyEntity.setUpdateDate(date);
		
		replyEntity = replyRepository.save(replyEntity);	
		replyDTO = new ModelMapper().map(replyEntity, ReplyDTO.class);
		return replyDTO;
	}


	public void delete(Long id) {
		// TODO Auto-generated method stub
		
		if(id == null) {
			throw new RuntimeException("잘못된 접근입니다. 댓글이 존재하지 않습니다.");
		}
		
		replyRepository.deleteById(id);
	}


	   //댓글 페이지네이션 코드
	   public List<ReplyDTO> findByBid(Long bid, int page) {    
	       List<Sort.Order> sortList = new ArrayList<>();
	       sortList.add(Sort.Order.desc("id"));

	       Pageable pageable = PageRequest.of(page, 20, Sort.by(sortList));
	       Page<ReplyEntity> pageItem = replyRepository.findByBid(bid, pageable);
	    
	       List<ReplyEntity> list_entity = pageItem.getContent();
	       List<ReplyDTO> list_dto = new ArrayList<>();
	       for(ReplyEntity x : list_entity) {
	    	   ReplyDTO dto = new ModelMapper().map(x, ReplyDTO.class);
	    	   list_dto.add(dto);
	       }
	       
	       return list_dto;
	   }



	public Page<ReplyDTO> findByUsername(String username, int page) {
		 List<Sort.Order> sortList = new ArrayList<>();
	       sortList.add(Sort.Order.desc("id"));

	       Pageable pageable = PageRequest.of(page, 5, Sort.by(sortList));
	       Page<ReplyEntity> pageItem = replyRepository.findByUsername(username, pageable);
	       Page<ReplyDTO> pageDto = pageItem.map(replyEntity -> new ModelMapper().map(replyEntity, ReplyDTO.class));


	       return pageDto;
	}
	
	
}
