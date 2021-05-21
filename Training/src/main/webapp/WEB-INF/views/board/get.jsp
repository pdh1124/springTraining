<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp"%>

<div class="card shadow mb-4">
	<div class="card-body">
		<div class="table-responsive">
			<div class="panel-heading"><strong style="font-size:24px">글 읽기</strong></div>
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
				
				<sec:authentication property="principal" var="pinfo" />
				<sec:authorize access="isAuthenticated()">
					<c:if test="${pinfo.username eq board.writer }">
						<button data-oper="modify" class="btn btn-warning">수정</button>
					</c:if>
				</sec:authorize>
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

<!-- 첨부파일 -->
<br />
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">첨부파일</div>
			<div class="panel-body">
				<div class="uploadResult">
					<ul></ul>
				</div>
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
				<sec:authorize access="isAuthenticated()">
					<button id="addReplyBtn" class="btn btn-primary btn-xs float-right">댓글 달기</button>
				</sec:authorize>
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

<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>
	$(document).ready(function(){
		
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		$(document).ajaxSend(function(e,xhr,options) {
			xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
		});
		
		
		var operForm = $("#operForm");
		$('button[data-oper="modify"]').on("click", function(e) {
			operForm.attr("action", "/board/modify").submit();
		});
		
		$('button[data-oper="list"]').on("click", function(e) {
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list").submit();
		});
		
		var bnoValue = '<c:out value="${board.bno}" />';
		
		/*replyService.add({
			reply: "js test",
			replyer : "tester",
			bno : bnoValue
		}, function(result) {
			alert("result: " + result);
		});*/
		
		var replyer = null;
		<sec:authorize access="isAuthenticated()">
			replyer='${pinfo.username}';
		</sec:authorize>
		
		var modal = $("#myModal");
		var modalRegisterBtn = $("#modalRegisterBtn");
		var modalInputReply = modal.find("input[name='reply']");
		var modalInputReplyer = modal.find("input[name='replyer']");
		var modalInputReplyDate = modal.find("input[name='replyDate']");
	
		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");
		
		//댓글 달기 버튼을 눌렀을 때 모달창이 보이는 명령
		$("#addReplyBtn").on("click",function(e) {
			modal.find("input").val("");
			
			modal.find("input[name='replyer']").val(replyer);
			modal.find("input[name='replyer']").attr("readonly","readonly");
			
			modalInputReplyDate.closest("div").hide();
			modal.find("button[id != 'modalCloseBtn']").hide();
			modalRegisterBtn.show();
			$("#myModal").modal("show");
		});
		
		//닫기버튼을 눌렀을때 모달찰이 닫히는 명령
		$("#modalCloseBtn").on("click", function(e) {
			modal.modal("hide");
		});
		
		//등록버튼을 눌렀을때 등록되는 명령
		modalRegisterBtn.on("click", function(e) {
			var reply = {
					reply: modalInputReply.val(),
					replyer: modalInputReplyer.val(),
					bno: bnoValue
			};
			
			var reply_con=modalInputReply.val();console.log("reply_con:"+reply_con);
      		 if(reply_con=="") {
       			return;
    		 };
			
			replyService.add(reply, function(result) {
				alert(result);
				modal.find("input").val("");
				modal.modal("hide");
				showList(-1);
			});
		});
		
		/*replyService.getList({
			bno: bnoValue,
			page: 1
		}, function(list) {
			for (var i = 0, len = list.length || 0; i < len; i++) {
				console.log(list[i]);
			}
		});*/
		
		//댓글 모달창에서 수정 버튼을 눌렀을때 동작하는 부분
		modalModBtn.on("click", function(e) {
			var originalReplyer = modalInputReplyer.val();
			var reply = {
					rno: modal.data("rno"),
					reply: modalInputReply.val(),
					replyer : originalReplyer
			};
			
			if(!replyer) {
				alert("로그인 후 수정 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			if(replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 수정 가능");
				modal.modal("hide");
				return;
			}
			
			replyService.update(reply, function(result) {
				alert(result);
				modal.modal("hide");
				showList(-1);
			});
		});
		
		//댓글 모달창에서 삭제버튼 눌렀을때 삭제 되는 기능
		modalRemoveBtn.on("click", function(e) {
			var rno = modal.data("rno");
			var originalReplyer = modalInputReplyer.val();
			
			if(!replyer) {
				alert("로그인 후 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			if(replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 삭제 가능");
				modal.modal("hide");
				return;
			}
			replyService.remove(rno, originalReplyer, function(result) {
				alert(result);
				modal.modal("hide");
				showList(-1);
			});
		});
		
		//댓글을 클릭하면 수정하는 기능
		$(".chat").on("click", "li", function(e) {
			var rno = $(this).data("rno");
			console.log(rno);
			
			replyService.get(rno,function(reply) {
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer).attr("readonly","readonly");
				modalInputReplyDate.closest("div").show();
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
				
				modal.data("rno",reply.rno);
				
				modal.find("button[id != 'modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				
				$("#myModal").modal("show");
			})
		});	
		
		//상세페이지 댓글 구현
		var replyUL = $(".chat");
		
		function showList(page) {
			replyService.getList({
				bno: bnoValue,
				page: page || 1
			}, 
			function(replyCnt, list) {
				
				console.log("replyCnt: " + replyCnt);
				
				if(page == -1) {
					pageNum = Math.ceil(replyCnt/10.0);
					console.log("page: " + pageNum);
					showList(pageNum);
					return;
				}
				
				var str = "";
				if(list == null || list.length == 0) {
					replyUL.html("");
					return;
				}
				for(var i = 0, len = list.length || 0; i <len; i++) {
					str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
					str += "<div>";
					str += "<div class='header'>";
					str += "<strong class='primary-font'>" + list[i].replyer + "</strong>";
					str += "<small class='float-sm-right'>" + replyService.displayTime(list[i].replyDate) + "</small>";
					str += "</div>";
					str += "<p>" + list[i].reply + "</p>";
					str += "</div>";
					str += "</li>";
				}
				replyUL.html(str);
				showReplyPage(replyCnt);
			})
		}
		showList(1);
		
		//댓글 페이징 처리
		var pageNum = 1;
		var replyPageFooter = $(".panel-footer");
		
		function showReplyPage(replyCnt) {
			var endNum = Math.ceil(pageNum/10.0) * 10;
			var startNum = endNum - 9;
			var prev = startNum != 1;
			var next = false;
			
			if(endNum * 10 >= replyCnt) {
				endNum = Math.ceil(replyCnt / 10.0);
			}
			if(endNum * 10 < replyCnt) {
				next = true;
			}
			var str = "<ul class='pagination justify-content-center'>"; 
			if(prev) {
				str += "<li class='page-item'>";
				str += "<a class='page-link' href='" + (startNum - 1) + "'>이전</a>";
				str += "</li>";
			}
			for(var i = startNum; i <= endNum; i++) {
				var active = pageNum == i ? "active" : "";
				str += "<li class='page-item " + active + "'>";
				str += "<a class='page-link' href='" + i + "'>" + i + "</a>";
				str += "</li>";
			}
			if(next) {
				str += "<li class='page-item'>";
				str += "<a class='page-link' href='" + (endNum + 1) + "'>다음</a>";
				str += "</li>";
			}
			str += "</ul>";
			console.log(str);
			replyPageFooter.html(str);
		}
		
		replyPageFooter.on("click", "li a", function(e) {
			e.preventDefault();
			var targetPageNum = $(this).attr("href");
			pageNum = targetPageNum;
			showList(pageNum);
		});
		
		//첨부파일 목록 표시
		(function() {
			var bno = '<c:out value="${board.bno}"/>';
			
			$.getJSON("/board/getAttachList", {bno:bno}, function(arr) {
				console.log(arr);
				var str = "";
				
				$(arr).each(function(i,attach) {
					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'>";
					str += "<div>";
					str += "<img src='/resources/img/attach.png' width='20px'>";
					str += "<span>&nbsp;" + attach.fileName + "</span><br />";
					str += "</div>";
					str += "</li>";
				});
				$(".uploadResult ul").html(str);
			});
		})();
		
		//첨부파일 클릭시 다운로드 처리
		$(".uploadResult").on("click", "li", function(e) {
			console.log("download file");
			
			var liObj = $(this);
			var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));
			
			self.location = "/download?fileName=" + path;
		})
	});
</script>