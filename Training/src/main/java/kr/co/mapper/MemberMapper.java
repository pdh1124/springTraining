package kr.co.mapper;

import kr.co.domain.MemberVO;

public interface MemberMapper {
	public MemberVO read(String userid);
	
	public MemberVO register(String userid, String userpw, String username);
}
