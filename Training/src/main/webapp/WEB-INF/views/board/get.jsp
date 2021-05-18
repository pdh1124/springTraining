<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp"%>

<div class="card shadow mb-4">
	<div class="card-body">
		<div class="table-responsive">
			<div class="panel-heading">글 읽기</div>
			<div class="panel-body">	
				<div class="form-group">
					게시물번호 <input class="form-control" name="bno" value='<c:out value="${board.bno }"/>' readonly="readonly" >
				</div>
				
				<div class="form-group">
					<label>글 제목</label> 
					<input class="form-control" name="title" value='<c:out value="${board.title }"/>' readonly="readonly" >
				</div>
				
				<div class="form-group">
					글 내용 <textarea row="3" class="form-control" name="content" readonly="readonly"><c:out value="${board.content }" /></textarea>
				</div>
				
				<div class="form-group">
					<label>작성자</label> 
					<input class="form-control" name="writer" value='<c:out value="${board.writer }"/>' readonly="readonly" >
				</div>
				
				<button data-oper="modify"class="btn btn-warning">수정</button>
				<button data-oper="list" class="btn btn-info">목록</button>
				
				<form id="operForm" action="/board/modify" method="get">
					<input type="hidden" id="bno" name="bno" value="${board.bno }" />
					<input type="hidden" name="pageNum" value="${cri.pageNum }" />
					<input type="hidden" name="amount" value="${cri.amount }" />
					<input type="hidden" name="type" value="${cri.type }" />
					<input type="hidden" name="keyword" value="${cri.keyword }" />				
				</form>
			</div>
		</div>
	</div>
</div>

<!-- 댓글 목록 -->
<br />
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> 댓글 목록
				<button id="addReplyBtn" class="btn btn-primary btn-xs float-right">댓글 달기</button>
			</div>
			<br />
			<div class="panel-body">
				<ul class="chat">
					<li>테스트</li>
				</ul>
			</div> 
			<div class="panel-footer"></div>
		</div>
	</div>
</div>

<!-- 댓글을 입력할 모달 창 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			
			<div class="modal-header">
				<h4 class="modal-title" id="myModalLabel">댓글 창</h4>
			</div>
			
			<div class="modal-body">
				<div class="form-group">
					<label>댓글</label> 
					<input class="form-control" name="reply" value="새 댓글">
				</div>
				<div class="form-group">
					<label>작성자</label> 
					<input class="form-control" name="replyer" value="replyer">
				</div>
				<div class="form-group">
					<label>댓글 작성일</label> 
					<input class="form-control" name="replyDate" value="">
				</div>
			</div>
			
			<div class="modal-footer">
				<button id="modalModBtn" type="button" class="btn btnwarning">수정</button>
				<button id="modalRemoveBtn" type="button" class="btn btndanger">삭제</button>
				<button id="modalRegisterBtn" type="button" class="btn btnprimary">등록</button>
				<button id="modalCloseBtn" type="button" class="btn btndefault">닫기</button>
			</div>	
		</div>
	</div>
</div>

<%@ include file="../includes/footer.jsp"%>

<script>
	$(document).ready(function(){
		var operForm = $("#operForm");
		$('button[data-oper="modify"]').on("click", function(e) {
			operForm.attr("action", "/board/modify").submit();
		});
		$('button[data-oper="list"]').on("click", function(e) {
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list").submit();
		});
		
		var bnoValue = '<c:out value="${board.bno}" />';
		
		replyService.add({
			reply: "js test",
			replyer : "tester",
			bno : bnoValue
		}, function(result) {
			alert("result: " + result);
		});
		
		
		var modal = $("#myModal");
		var modalInputReplyDate = modal.find("input[name='replyDate']");
		var modalRegisterBtn = $("modalResgisterBtn");
		var modalInputReply = modal.find("input[name='reply']");
	});
</script>



<script type="text/javascript" src="/resources/js/reply.js"></script>