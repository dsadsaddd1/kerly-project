package kr.co.tj.item;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ItemRepository extends JpaRepository<ItemEntity, Long> {

	List<ItemEntity> findByUsername(String username);


	Page<ItemEntity> findByItemType(String itemType, Pageable pageable);

	List<ItemEntity> findByItemType(String itemType);


	Page<ItemEntity> findByUsername(String username, Pageable pageable);


	Page<ItemEntity> findByitemNameContaining(String keyword, Pageable pageable);

}
