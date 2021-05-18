package kr.co.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.co.domain.BoardVO;
import kr.co.domain.Criteria;
import kr.co.domain.ReplyVO;

public interface ReplyMapper {
	
	public int insert(BoardVO vo);
	public ReplyVO read(Long rno);
	public int delete(Long rno);
	public int update(ReplyVO reply);
	public List<ReplyVO> getListWithPaging(@Param("cri") Criteria cri, @Param("bno") Long bno);
	public int insert(ReplyVO vo);
	
	
}
