package kr.co.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.domain.BoardAttachVO;
import kr.co.domain.BoardVO;
import kr.co.domain.Criteria;
import kr.co.mapper.BoardAttachMapper;
import kr.co.mapper.BoardMapper;
import kr.co.mapper.ReplyMapper;
//import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
//@AllArgsConstructor
public class BoardServiceImp implements BoardService {
	
	@Setter(onMethod_ = @Autowired) 
	private BoardMapper mapper;  
	  
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper replyMapper; 
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	@Transactional
	@Override
	public void register(BoardVO board) {
		log.info("register....." + board);
		mapper.insertSelectKey(board);
		
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}
		
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get......" + bno);
		return mapper.read(bno);
	}
	
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		log.info("modify......" + board);
		
		attachMapper.deleteAll(board.getBno());
		
		boolean modifyResult = false;
		modifyResult = mapper.update(board) == 1;
		
		int attachList = 0;
		if(board.getAttachList() != null) {
			attachList = board.getAttachList().size();
		}
		if(modifyResult && attachList > 0) {
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		return modifyResult;
	}
	
	@Transactional
	@Override
	public boolean remove(Long bno) {
		log.info("remove......" + bno);
		replyMapper.deleteAll(bno);
		attachMapper.deleteAll(bno);
		return (mapper.delete(bno)) == 1;
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("getList......");
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		log.info("get Total Count......");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get Attach list by bno" + bno);
		return attachMapper.findByBno(bno);
	}	

}
