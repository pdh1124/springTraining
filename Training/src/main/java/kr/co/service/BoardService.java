package kr.co.service;

import java.util.List;

import kr.co.domain.BoardAttachVO;
import kr.co.domain.BoardVO;
import kr.co.domain.Criteria;

public interface BoardService {
	
	public void register(BoardVO board);
	public BoardVO get(Long bno);
	public boolean modify(BoardVO board);
	public boolean remove(Long bno);
	public List<BoardVO> getList(Criteria cri);
	
	public int getTotal(Criteria cri);
	
	public List<BoardAttachVO> getAttachList(Long bno);
	
}
