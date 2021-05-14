<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ include file="../includes/header.jsp"%>


<!-- DataTales Example -->
<div class="card shadow mb-4">
    <div class="card-body">
    	<div class="card-header py-3" align="right">
    		<button id="regBtn" style="color:green">글 작성</button>    	
    	</div>
        <div class="table-responsive">
            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>#번호</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>수정일</th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach var="board" items="${list }">
	                	<tr>
	                    	<td><c:out value="${board.bno }" /></td>
	                    	<td><a href="/board/get?bno=${board.bno }"><c:out value="${board.title }" /></a></td>	              
	                    	<td><c:out value="${board.writer }" /></td>
	                    	<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate }" /></td>
	                    	<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate }" /></td>
	                    </tr>
                	</c:forEach>  
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- 모달창  -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="ture">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header"></div>
			<div class="modal-body"></div>
			<div class="modal-footer">
				<button class="btn btn-primary" type="button" data-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>

<script>
$(document).ready(function() {
	
	//테이블의 기능 사용 및 미사용 선택	
	$('#dataTable').DataTable({
	    	"order" : [ [0, "desc"] ],  //오르내림차순
			"paging" : false,  //페이징 키고 끄기
			"bFilter" : false, //검색기능 키고 끄기
			"info" : false //현재 페이지와 게시물 수 표시 키고 끄기
	    });
	
	
	//글쓰기 버튼
	$('#regBtn').on("click", function() {
		self.location = "/board/register";
	});
	
	
	//글 등록할때 안내 모달창 띄우기
	var result = '<c:out value="${result}" />';
	
	checkModal(result);
	
	function checkModal(result) {
		if (result === '') {
			return;
		}
		if (parseInt(result) > 0) {
			$(".modal-body").html("게시글" + parseInt(result) + "번이 등록");
		} else if (result === "success") {
			$(".modal-body").html("게시글 수정이 완료되었습니다. " + result);
		}
		$("#myModal").modal("show");
	}

});
</script>

<%@ include file="../includes/footer.jsp"%>
