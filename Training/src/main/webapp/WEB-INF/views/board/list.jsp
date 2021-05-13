<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ include file="../includes/header.jsp"%>


<h1 class="h3 mb-2 text-gray-800">Tables</h1>
<p class="mb-4">DataTables is a third party plugin that is used to generate the demo table below.
    For more information about DataTables, please visit the <a target="_blank"
        href="https://datatables.net">official DataTables documentation</a>.</p>

<!-- DataTales Example -->
<div class="card shadow mb-4">
    <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">DataTables Example</h6>
    </div>
    <div class="card-body">
    	<div class="card-header py-3" align="right">
    		<button id="regBtn" style="color:green">write</button>    	
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
	                    	<td><c:out value="${board.title }" /></td>
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

<%@ include file="../includes/footer.jsp"%>

<script>
	$(document).ready(function() {
		$('#dataTable').DataTable({
			"order" : [[0,"desc"]],
			"paging" : false,
			"bfilter" : false,
			"info" : false
		})
		
		$('#regBtn').on("click", function() {
			self.location = "/board/register";
		});
	});
</script>