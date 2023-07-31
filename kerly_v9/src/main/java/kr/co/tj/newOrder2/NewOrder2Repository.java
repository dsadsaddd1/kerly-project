package kr.co.tj.newOrder2;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NewOrder2Repository extends JpaRepository<NewOrder2Entity, Long>{

	Page<NewOrder2Entity> findByUsername(String username, Pageable pageable);

	Page<NewOrder2Entity> findById(Long id, Pageable pageable);

}
