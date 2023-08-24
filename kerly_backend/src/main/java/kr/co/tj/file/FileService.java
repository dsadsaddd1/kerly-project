//package kr.co.tj.file;
//
//import java.util.Optional;
//import java.util.UUID;
//
//import javax.transaction.Transactional;
//
//import org.springframework.beans.factory.annotation.Autowired;
//
//import org.springframework.stereotype.Service;
//
//@Service
//public class FileService {
//
//	@Autowired
//	private FileRepository fileRepository;
//
//	public FileEntity uploadFile(byte[] bytes, FileDTO dto) {
//		FileEntity entity = FileEntity.builder().bytes(bytes)
//				.bytes(bytes)
//				.bid(dto.getBid())
//				.originalName(dto.getOriginalName())
//				.savedName(dto.getSavedName())
//				.uploadDate(dto.getUploadDate())
//				.uploaderId(dto.getUploaderId())
//				.build();
//		return fileRepository.save(entity);
//	}
//
//	public byte[] fintById(Long id) {
//		Optional<FileEntity> fileEntity = fileRepository.findById(id);
//		if (fileEntity.isPresent()) {
//			FileEntity entity = fileEntity.get();
//			return entity.getBytes();
//		}
//		return null;
//	}
//
//	public static String makeFilename(String orgFilename) {
//
//		String uid = UUID.randomUUID().toString();
//		String savedName = uid + "_" + orgFilename;
//
//		return savedName;
//	}
//
//	public byte[] fintByBid(Long bid) {
//		Optional<FileEntity> fileEntity = fileRepository.findByBid(bid);
//		if (fileEntity.isPresent()) {
//			FileEntity entity = fileEntity.get();
//			return entity.getBytes();
//		}
//		return null;
//	}
//
//	@Transactional
//	public void delete(Long bid) {
//		// TODO Auto-generated method stub
//		fileRepository.deleteByBid(bid);
//	}
//
//}

package kr.co.tj.file;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import javax.transaction.Transactional;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Service;

import kr.co.tj.member.MemberDTO;
import kr.co.tj.member.MemberEntity;
import kr.co.tj.member.MemberRepository;

@Service
public class FileService {

   @Autowired
   private FileRepository fileRepository;

   @Autowired
   private UrlRepository urlRepository;

   public UrlDTO urlUpload(UrlDTO urlDTO) {

      UrlEntity entity = new ModelMapper().map(urlDTO, UrlEntity.class);

      entity = urlRepository.save(entity);

      return new ModelMapper().map(entity, UrlDTO.class);
   }

   public FileEntity uploadFile(byte[] bytes, FileDTO dto) {
      FileEntity entity = FileEntity.builder().bytes(bytes).bytes(bytes).bid(dto.getBid())
            .originalName(dto.getOriginalName()).savedName(dto.getSavedName()).uploadDate(dto.getUploadDate())
            .uploaderId(dto.getUploaderId()).itemName(dto.getItemName()).itemType(dto.getItemType()).build();
      return fileRepository.save(entity);
   }

   public byte[] fintById(Long id) {
      Optional<FileEntity> fileEntity = fileRepository.findById(id);
      if (fileEntity.isPresent()) {
         FileEntity entity = fileEntity.get();
         return entity.getBytes();
      }
      return null;
   }

   public static String makeFilename(String orgFilename) {

      String uid = UUID.randomUUID().toString();
      String savedName = uid + "_" + orgFilename;

      return savedName;
   }

   public byte[] fintByBid(Long bid) {
      Optional<FileEntity> fileEntity = fileRepository.findByBid(bid);
      if (fileEntity.isPresent()) {
         FileEntity entity = fileEntity.get();
         return entity.getBytes();
      }
      return null;
   }

   @Transactional
   public void delete(Long bid) {
      
      fileRepository.deleteByBid(bid);
   }


   public UrlDTO findById(Long id) {

      Optional<UrlEntity> optional = urlRepository.findById(id);

      UrlEntity entity = optional.get();
      return new ModelMapper().map(entity, UrlDTO.class);

   }

   public void urlDelete(Long id) {

      urlRepository.deleteById(id);
   }

   public List<UrlDTO> findAll() {
       List<UrlEntity> urlEntity = urlRepository.findAll();
         List<UrlDTO> urlDTO = new ArrayList<>();

         for (UrlEntity e : urlEntity) {
            urlDTO.add(new ModelMapper().map(e, UrlDTO.class));
            ;
         }

         return urlDTO;
   }


}
