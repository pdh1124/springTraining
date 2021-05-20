package kr.co.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.co.domain.Criteria;
import kr.co.domain.ReplyPageDTO;
import kr.co.domain.ReplyVO;

public interface ReplyService {
	public int register(ReplyVO vo);
	public ReplyVO get(Long rno);
	public int remove(Long rno);
	public int modify(ReplyVO reply);
	public List<ReplyVO> getList(@Param("cri") Criteria cri, @Param("bno") Long bno);
	
	public ReplyPageDTO getListPage(Criteria cri, Long bno);
	
}
