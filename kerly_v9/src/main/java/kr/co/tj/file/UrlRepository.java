package kr.co.tj.file;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UrlRepository extends JpaRepository<UrlEntity, Long> {

	UrlEntity save(UrlEntity entity);
}
