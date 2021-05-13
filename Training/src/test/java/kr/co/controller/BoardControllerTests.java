package kr.co.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml", 
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml"}) 
@Log4j
@WebAppConfiguration
public class BoardControllerTests {
	
	@Setter(onMethod_ = @Autowired)
	private WebApplicationContext ctx; //웹으로 프로그램을 테스트하기 위한 객체이다.
	private MockMvc mockMvc; //mvc 모델 모형 객체이다.
	
	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	 
//	@Test
//	public void testList() throws Exception {
//				 log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/list")).andReturn().getModelAndView().getModelMap());
//	}
	
//	@Test
//	public void testRegister() throws Exception {
//		String result = mockMvc.perform(MockMvcRequestBuilders.post("/board/register")
//				.param("title","테스트 testRegister")
//				.param("content", "테스트 testRegister")
//				.param("writer", "user 테스터"))
//				.andReturn().getModelAndView().getViewName();
//	}
	
//	@Test
//	public void testGet() throws Exception {
//		log.info(mockMvc.perform(MockMvcRequestBuilders.get("/board/get")
//				.param("bno", "3"))
//				.andReturn().getModelAndView().getModelMap());
//	}
	
//	@Test
//	public void testModify() throws Exception {
//		String result = mockMvc.perform(MockMvcRequestBuilders.post("/board/modify")
//								.param("bno", "1")
//								.param("title", "수정된 테스트 새글 제목")
//								.param("content", "수정된 테스트 새글 내용")
//								.param("writer", "user"))
//				.andReturn().getModelAndView().getViewName();
//		
//		log.info(result);
//	} 
	
	@Test
	public void testRemove() throws Exception {
		String result = mockMvc.perform(MockMvcRequestBuilders.post("/board/remove")
				.param("bno", "4"))
				.andReturn().getModelAndView().getViewName();
		
		log.info(result);
	}
}
