package kr.co.tj.file;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;


public interface FileRepository extends JpaRepository<FileEntity, Long> {

	Optional<FileEntity> findByBid(Long bid);

	void deleteByBid(Long bid);

	List<FileEntity> findAllByItemType(String itemType);

//	List<FileEntity> findByBid(Long bid);

//	List<FileEntity> findByBid2(Long bid);


	

}
