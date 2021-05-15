package kr.co.mapper;

import java.util.List;

import kr.co.domain.BoardVO;
import kr.co.domain.Criteria;

public interface BoardMapper {
	
	public List<BoardVO> getList();
	
	public void insert(BoardVO board);
	public void insertSelectKey(BoardVO board);
	public BoardVO read(Long bno);
	public int delete(Long bno);
	public int update(BoardVO board);
	
	public List<BoardVO> getListWithPaging(Criteria cri);
}