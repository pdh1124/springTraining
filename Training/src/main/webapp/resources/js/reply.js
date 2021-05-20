console.log("Reply module....55");

//ajax처리
var replyService = (function() {
	//댓글 생성
	function add(reply, callback, error) {
		console.log("add reply......");
		
		$.ajax({
			type: 'post',
			url: '/replies/new',
			data: JSON.stringify(reply),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr) {
				if(callback) {
					callback(result)
				}
			},
			error: function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}
	
	//댓글목록 가져오기
	function getList(param, callback, error) {
		console.log("getList......");
		
		var bno = param.bno;
		var page = param.page || 1;
		
		$.getJSON("/replies/pages/" + bno + "/" + page + ".json",
			function(data) {
				if(callback) {
					callback(data.replyCnt, data.list);
				}
			}).fail(function(xhr, status, err) {
				if(error) {
					error(er);
				}
			});
	}
	
	//시간을 연원일시분초로 나오도록 바꾸는 함수
	function displayTime(timeValue) {
		var today = new Date();
		var gap = today.getTime() - timeValue;
		var dateObj = new Date(timeValue);
		var str = "";
		
		if(gap<(1000*60*60*24)) {
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
			return [ (hh>9?'':'0')+hh, ':', (mi>9?'':'0')+mi, ':',(ss>9?'':'0')+ss].join('');
		} else {
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth()+1;
			var dd = dateObj.getDate();
			
			return [yy,'/',(mm>9?'':'0')+mm,'/',(dd>9?'':'0')+dd].join('');
		}
	}
	
	//수정처리
	function update(reply, callback, error) {
		console.log("rno: " + reply.rno);
		$.ajax({
			type: 'put',
			url: '/replies/' + reply.rno,
			data: JSON.stringify(reply),
			contentType: "application/json;charset=utf-8",
			success: function(result, status, xhr) {
				if(callback) {
					callback(result);
				}
			},
			error: function(xhr, status, er) {
				if(error){
					error(er);
				}
			}
		})
	}
	
	//댓글읽기
	function get(rno, callback, error) {
		$.get("/replies/" + rno + ".json", function(result) {
			if(callback) {
				callback(result);
			}
		}).fail(function(xhr, status, er) {
			if(error) {
				error(er);
			}
		})
	}
	
	//삭제처리
	function remove(rno, callback, error) {
		$.ajax({
			type: 'delete',
			url: '/replies/' + rno,
			success: function(deleteResult, status, xhr) {
				if(callback) {
					callback(deleteResult);
				}
			},
			error: function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}
	
	return {
		add: add,
		getList:getList,
		displayTime:displayTime,
		update:update,
		get:get,
		remove:remove
	};
})();
