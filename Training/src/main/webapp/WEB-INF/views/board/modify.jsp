<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp"%>

<div class="card shadow mb-4">
	<div class="card-body">
		<div class="table-responsive">
			<div class="panel-heading"><strong style="font-size:24px">글 수정</strong></div>
			<div class="panel-body">
				<form role="form" action="/board/modify" method="post">
					
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /> 
						<input type="hidden" name="bno" value="${board.bno }" />
						<input type="hidden" name="pageNum" value="${cri.pageNum }">
						<input type="hidden" name="amount" value="${cri.amount }">
						<input type="hidden" name="type" value="${cri.type }">
						<input type="hidden" name="keyword" value="${cri.keyword }">
								
					<div class="form-group">
						<label>Title</label> 
						<input class="form-control" name="title" value='<c:out value="${board.title }"/>' >
					</div>
					
					<div class="form-group">
						<label>Text area</label> 
						<textarea row="3" class="form-control" name="content"><c:out value="${board.content }" /></textarea>
					</div>
					
					<div class="form-group">
						<label>writer</label> 
						<input class="form-control" name="writer" value='<c:out value="${board.writer }"/>' readonly="readonly">
					</div>
					
					<sec:authentication property="principal" var="pinfo" />
					<sec:authorize access="isAuthenticated()">
	
						<c:if test="${pinfo.username eq board.writer}">
							<button type="submit" data-oper="modify" class="btn btn-success">수정</button>
							<button type="submit" data-oper="remove" class="btn btn-danger">삭제</button>
						</c:if>
					</sec:authorize>
					<button type="submit" data-oper="list" class="btn btn-info">목록</button>
				</form>
			</div>
		</div>
	</div>
</div>

<br />
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">첨부파일</div>
			<div class="panel-body">
				<div class="form-group uploadDiv">
					파일 첨부 : <input type="file" name="uploadFile" multiple>
				</div>
				<div class="uploadResult">
					<ul></ul>
				</div>
			</div>
		</div>
	</div>
</div>

<%@ include file="../includes/footer.jsp"%>


<script>
	$(document).ready(function() {
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		$(document).ajaxSend(function(e,xhr,options) {
			xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
		});
		
		var formObj = $("form");
		
		$('button').on("click", function(e) {
			
			e.preventDefault();
			
			var operation = $(this).data("oper");
			
			console.log(operation);
			
			if(operation === 'remove') {
				formObj.attr("action", "/board/remove");
			} else if(operation === 'list') {
				formObj.attr("action", "/board/list").attr("method", "get");
				
				var pageNumTag = $("input[name='pageNum']");
				var amountTag = $("input[name='amount']");
				var typeTag = $("input[name='type']");
				var keywordTag = $("input[name='keyword']");
				
				formObj.empty();
				
				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(typeTag);
				formObj.append(keywordTag);
			} else if(operation === 'modify') {
				var str = "";
				$(".uploadResult ul li").each(function(i,obj) {
					var jobj = $(obj);
					
					console.dir(jobj);
					console.log("------------");
					console.log(jobj.data("filename"));
					
					str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
					str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
					str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "'>";
					str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "'>";
				});
				formObj.append(str)
			}
			formObj.submit();
		});
		
		//첨부파일 목록 표시
		(function() {
			var bno = '<c:out value="${board.bno}"/>';
			
			$.getJSON("/board/getAttachList", {bno:bno}, function(arr) {
				console.log(arr);
				var str = "";
				
				$(arr).each(function(i,attach) {
					var fileCallPath = encodeURIComponent(attach.uploadPath+"/"+attach.uuid+"_"+attach.fileName);
					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>";
					str += "<div>";
					str += "<img src='/resources/img/attach.png' width='20px'>";
					str += "<span>&nbsp;" + attach.fileName + "</span>&nbsp;&nbsp;";
					str += "<b data-file='" + fileCallPath + "' data-type='file'>[x]</b>";
					str += "</div>";
					str += "</li>";
				});
				$(".uploadResult ul").html(str);
			});
		})();
		
		
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880;
		
		function checkExtension(fileName, fileSize) {
			if(fileSize >= maxSize) {
				alert("파일 크기 초과");
				return false;
			}
			if(regex.test(fileName)) {
				alert("해당 종류의 파일은 업로드 불가.");
				return false;
			}
			return true;
		}
		
		$("input[type='file']").change(function(e) {
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;
			
			for(var i=0; i < files.length; i++) {
				if(!checkExtension(files[i].name, files[i].size)) {
					return false;
				}
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false,
				contentType:false,
				data:formData,
				type:'POST',
				dataType:'json',
				success:function(result) {
					console.log(result);
					showUploadResult(result);
					
				}
			});
		});
		
		//글쓰기 폼에 첨부파일을 등록할때 아래 목록으로 보이게 하기
		function showUploadResult(uploadResultArr) {
			if (!uploadResultArr || uploadResultArr.ength == 0) {
				return
			}
			
			var uploadUL = $(".uploadResult ul");
			var str = "";
			
			$(uploadResultArr).each(function(i, obj) {
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
				
				str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'>";
				str += "<div>";
				str += "<img src='/resources/img/attach.png' width='20px' height='20px'>";
				str += "<span>" + obj.fileName + "</span>";
				str += "<b data-file='" + fileCallPath + "' data-type='file'>[x]</b>";
				str += "</div>";
				str += "</li>";
			});
			uploadUL.append(str);
		}
		
		//[x]버튼을 클릭했을때 목록에서 지우기
		$(".uploadResult").on("click", "b", function(e) {
			console.log("delete file");
			
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			var targetLi = $(this).closest("li");
			
			$.ajax({
				url: '/deleteFile',
				data: {
					fileName: targetFile,
					type: type
				},
				dataType: 'text',
				type: 'POST',
				success: function(result) {
					alert(result);
					targetLi.remove();
				}
			})
		});
	});
</script>