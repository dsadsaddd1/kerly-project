package kr.co.tj.bookmark;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookmarkRepository extends JpaRepository<BookmarkEntity, Long>{

	void deleteByBid(Long bid);

	Optional<BookmarkEntity> findByBidAndUsername(Long bid, String username);

	Page<BookmarkEntity> findByUsername(String username, Pageable pageable);


}
