//package kr.co.tj.member;
//
//import java.util.ArrayList;
//import java.util.Date;
//import java.util.List;
//
//import javax.transaction.Transactional;
//
//import org.modelmapper.ModelMapper;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
//import org.springframework.stereotype.Service;
//
//import kr.co.tj.sec.TokenProvider;
//
//@Service
//public class MemberService {
//
//	@Autowired
//	private MemberRepository memberRepository;
//
//	@Autowired
//	private BCryptPasswordEncoder passwordEncoder;
//
//	@Autowired
//	private TokenProvider tokenProvider;
//
//	public String checkByUsername(String username) {
//
//		MemberEntity entity = memberRepository.findByUsername(username);
//
//		if (entity == null) {
//			return "사용 가능";
//		} else {
//			return "사용 불가";
//		}
//	}
//
////	public List<MemberDTO> getOrders(String username) {
////		
////		 MemberEntity memberEntity = memberRepository.findByUsername(username);
////		 
////	      if(memberEntity == null) {
////	    	 throw new RuntimeException("에러가 발생했습니다.");
////	      }
////	      
////	      
////	      MemberDTO memberDTO = new MemberDTO();
////	      memberDTO = new ModelMapper().map(memberEntity, MemberDTO.class);
////	      List<MemberDTO> list_dto = new ArrayList<>();
////	      
//////	      List<OrderResponse> orderList = orderFeign.getOrdersByUsername(username);
////	      
//////	      memberDTO.setOrderList(orderList);
////	      
////	      return list_dto;
////
////	}
//
//	// 회원 비밀번호 수정
//	@Transactional
//	public MemberDTO updatePassword(MemberDTO memberDTO) {
//
//		MemberEntity entity = memberRepository.findByUsername(memberDTO.getUsername());
//
//		if (entity == null) {
//			throw new RuntimeException("에러가 발생했습니다.");
//		}
//
//		if (!passwordEncoder.matches(memberDTO.getOrgPassword(), entity.getPassword())) {
//
//			throw new RuntimeException("비밀번호 틀림");
//		}
//
//	//	entity.setPassword(memberDTO.getPassword());
//		entity.setPassword(passwordEncoder.encode(entity.getPassword()));
//
//		memberDTO = getDate(memberDTO);
//
//		entity = memberRepository.save(entity);
//
//		memberDTO = new ModelMapper().map(entity, MemberDTO.class);
//
//		memberDTO.setId(null);
//		memberDTO.setPassword(null);
//
//		return memberDTO;
//
//	}
//
//	// 회원 정보 수정
//	@Transactional
//	public MemberDTO updateMember(MemberDTO dto) {
//
//		MemberEntity entity = memberRepository.findByUsernameAndPassword(dto.getUsername(), dto.getPassword());
//
//		if (entity == null) {
//			return null;
//		}
//
//		if(!passwordEncoder.matches(dto.getPassword(), entity.getPassword())) {
//			throw new RuntimeException("비밀번호가 다름.");
//		}
//
//		entity.setName(dto.getName());
//		entity.setPhoneNumber(dto.getPhoneNumber());
//		entity.setAddress(dto.getAddress());
//		entity.setUpdateDate(new Date());
//
//		entity = memberRepository.save(entity);
//
//		dto = new ModelMapper().map(entity, MemberDTO.class);
//		
//		dto.setId(null);
//		dto.setPassword(null);
//
//		return dto;
//	}
//
//	// 회원 삭제
//	@Transactional
//	public int delete(MemberDTO memberDTO) {
//
//		MemberEntity memberEntity = memberRepository.findByUsername(memberDTO.getUsername());
//
//		if (memberEntity == null) {
//			return 404;
//		}
//
//		try {
//			memberRepository.delete(memberEntity);
//			return 200;
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//			return 500;
//		}
//	}
//
//	// 회원 정보 자세히 보기
//	public MemberDTO findByUsername(String username) {
//
//		if (username == null) {
//			throw new RuntimeException("에러가 발생했습니다.");
//		}
//
//		MemberEntity entity = memberRepository.findByUsername(username);
//
//		MemberDTO dto = new ModelMapper().map(entity, MemberDTO.class);
//		dto.setId(null);
//		dto.setPassword(null);
//
//		return dto;
//	}
//
//	// 회원 목록
//	public List<MemberDTO> findAll() {
//		List<MemberEntity> memberEntity = memberRepository.findAll();
//		List<MemberDTO> memberDTO = new ArrayList<>();
//
//		for (MemberEntity e : memberEntity) {
//			memberDTO.add(new ModelMapper().map(e, MemberDTO.class));
//			;
//		}
//
//		return memberDTO;
//	}
//
//	// 로그인
//	public MemberDTO login(MemberDTO memberDTO) {
//		
//		MemberEntity memberEntity = memberRepository.findByUsername(memberDTO.getUsername());
//
//
//		if (memberEntity == null) {
//			throw new RuntimeException("회원 정보를 입력해주세요.");
//		}
//
//		if (!passwordEncoder.matches(memberDTO.getPassword(), memberEntity.getPassword())) {
//			System.out.println(passwordEncoder.matches(memberDTO.getOrgPassword(), memberEntity.getPassword()));
//			throw new RuntimeException("비밀번호 틀림");
//		}
//
//		
//		String token = tokenProvider.create(memberEntity);
//		memberDTO = new ModelMapper().map(memberEntity, MemberDTO.class);
//		memberDTO.setToken(token);
//		memberDTO.setId(null);
//		memberDTO.setPassword(null);
//		System.out.println(token);
//		
//		return memberDTO;
//	}
//
//	// 회원 가입
//	public MemberDTO createMember(MemberDTO dto) {
//
//		dto = getDate(dto);
//
//		MemberEntity entity = new ModelMapper().map(dto, MemberEntity.class);
//
//		entity.setPassword(passwordEncoder.encode(entity.getPassword()));
//
//		entity = memberRepository.save(entity);
//
//		dto = new ModelMapper().map(entity, MemberDTO.class);
//
//		return dto;
//	}
//
//	// 현재 시간 적용
//	private MemberDTO getDate(MemberDTO memberDTO) {
//		Date date = new Date();
//
//		if (memberDTO.getCreateDate() == null) {
//			memberDTO.setCreateDate(date);
//		}
//
//		memberDTO.setUpdateDate(date);
//
//		return memberDTO;
//	}
//
//}


package kr.co.tj.member;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.transaction.Transactional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import kr.co.tj.sec.TokenProvider;

@Service
public class MemberService {

   @Autowired
   private MemberRepository memberRepository;

   @Autowired
   private BCryptPasswordEncoder passwordEncoder;

   @Autowired
   private TokenProvider tokenProvider;

   public String checkByUsername(String username) {

      MemberEntity entity = memberRepository.findByUsername(username);

      if (entity == null) {
         return "사용 가능";
      } else {
         return "사용 불가";
      }
   }

//   // 회원 비밀번호 수정
//   @Transactional
//   public MemberDTO updatePassword(MemberDTO memberDTO) {
//
//      MemberEntity entity = memberRepository.findByUsername(memberDTO.getUsername());
//
//      if (entity == null) {
//         throw new RuntimeException("에러가 발생했습니다.");
//      }
//
//      if (!passwordEncoder.matches(memberDTO.getOrgPassword(), entity.getPassword())) {
//
//         throw new RuntimeException("비밀번호 틀림");
//      }
//
//      // entity.setPassword(memberDTO.getPassword());
//      entity.setPassword(passwordEncoder.encode(entity.getPassword()));
//
//      memberDTO = getDate(memberDTO);
//
//      entity = memberRepository.save(entity);
//
//      memberDTO = new ModelMapper().map(entity, MemberDTO.class);
//
//      memberDTO.setId(null);
//      memberDTO.setPassword(null);
//
//      return memberDTO;
//
//   }
   
   // 회원 비밀번호 수정
   @Transactional
   public MemberDTO updatePassword(MemberDTO memberDTO) {

      MemberEntity entity = memberRepository.findByUsername(memberDTO.getUsername());

      if (entity == null) {
         throw new RuntimeException("에러가 발생했습니다.");
      }

      if (!passwordEncoder.matches(memberDTO.getOrgPassword(), entity.getPassword())) {

         throw new RuntimeException("비밀번호 틀림");
      }

      // entity.setPassword(memberDTO.getPassword());
      entity.setPassword(passwordEncoder.encode(memberDTO.getPassword()));

      memberDTO = getDate(memberDTO);

      entity = memberRepository.save(entity);

      memberDTO = new ModelMapper().map(entity, MemberDTO.class);

      memberDTO.setId(null);
      memberDTO.setPassword(null);

      return memberDTO;

   }

   // 회원 정보 수정
   @Transactional
   public MemberDTO updateMember(MemberDTO dto) {

      MemberEntity entity = memberRepository.findByUsername(dto.getUsername());

      if (entity == null) {
         return null;
      }
      
      System.out.println(dto.getPhoneNumber());

      if (!passwordEncoder.matches(dto.getPassword(), entity.getPassword())) {
         throw new RuntimeException("비밀번호가 다름.");
      }

      entity.setName(dto.getName());
      entity.setPhoneNumber(dto.getPhoneNumber());
      entity.setAddress(dto.getAddress());
      entity.setUpdateDate(new Date());
      
      System.out.println(entity);

      entity = memberRepository.save(entity);

      dto = new ModelMapper().map(entity, MemberDTO.class);

      dto.setId(null);
      dto.setPassword(null);

      return dto;
   }

   // 회원 삭제
//   @Transactional
//   public int delete(MemberDTO memberDTO) {
//
//      MemberEntity memberEntity = memberRepository.findByUsernameAndPassword(memberDTO.getUsername(),
//    		  passwordEncoder.encode(memberDTO.getPassword()));
//
//      if (memberEntity == null) {
//         return 404;
//      }
//
//      try {
//         memberRepository.delete(memberEntity);
//         return 200;
//      } catch (Exception e) {
//         // TODO Auto-generated catch block
//         e.printStackTrace();
//         return 500;
//      }
//   }
   @Transactional
   public int delete(MemberDTO memberDTO) {

      MemberEntity memberEntity = memberRepository.findByUsername(memberDTO.getUsername());

      if (memberEntity == null) {
         return 404;
      }
      
      if(!passwordEncoder.matches(memberDTO.getPassword(), memberEntity.getPassword())) {
			throw new RuntimeException("비밀번호가 다름");
		}

      try {
         memberRepository.delete(memberEntity);
         return 200;
      } catch (Exception e) {
         // TODO Auto-generated catch block
         e.printStackTrace();
         return 500;
      }
   }

   // 회원 정보 자세히 보기
   public MemberDTO findByUsername(String username) {

      if (username == null) {
         throw new RuntimeException("에러가 발생했습니다.");
      }

      MemberEntity entity = memberRepository.findByUsername(username);

      MemberDTO dto = new ModelMapper().map(entity, MemberDTO.class);
      dto.setId(null);
      dto.setPassword(null);

      return dto;
   }

   // 회원 목록
   public List<MemberDTO> findAll() {
      List<MemberEntity> memberEntity = memberRepository.findAll();
      List<MemberDTO> memberDTO = new ArrayList<>();

      for (MemberEntity e : memberEntity) {
         memberDTO.add(new ModelMapper().map(e, MemberDTO.class));
         ;
      }

      return memberDTO;
   }

   // 로그인
   public MemberDTO login(MemberDTO memberDTO) {

      MemberEntity memberEntity = memberRepository.findByUsername(memberDTO.getUsername());

      if (memberEntity == null) {
         throw new RuntimeException("회원 정보를 입력해주세요.");
      }

      if (!passwordEncoder.matches(memberDTO.getPassword(), memberEntity.getPassword())) {
         System.out.println(passwordEncoder.matches(memberDTO.getOrgPassword(), memberEntity.getPassword()));
         throw new RuntimeException("비밀번호 틀림");
      }

      String token = tokenProvider.create(memberEntity);
      memberDTO = new ModelMapper().map(memberEntity, MemberDTO.class);
      memberDTO.setToken(token);
      memberDTO.setId(null);
      memberDTO.setPassword(null);
      System.out.println(token);

      return memberDTO;
   }

   // 회원 가입
   public MemberDTO createMember(MemberDTO dto) {

      dto = getDate(dto);

      MemberEntity entity = new ModelMapper().map(dto, MemberEntity.class);

      entity.setPassword(passwordEncoder.encode(entity.getPassword()));

      entity = memberRepository.save(entity);

      dto = new ModelMapper().map(entity, MemberDTO.class);

      return dto;
   }

   // 현재 시간 적용
   private MemberDTO getDate(MemberDTO memberDTO) {
      Date date = new Date();

      if (memberDTO.getCreateDate() == null) {
         memberDTO.setCreateDate(date);
      }

      memberDTO.setUpdateDate(date);

      return memberDTO;
   }

}