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
				</form>
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
	});
</script>