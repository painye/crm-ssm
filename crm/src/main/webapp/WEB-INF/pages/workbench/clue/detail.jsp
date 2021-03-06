<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		// $(".remarkDiv").mouseover(function(){
		// 	$(this).children("div").children("div").show();
		// });

		$("#remarkListDiv").on("mouseover", ".remarkDiv", function () {
			$(this).children("div").children("div").show();
		})

		// $(".remarkDiv").mouseout(function(){
		// 	$(this).children("div").children("div").hide();
		// });

		$("#remarkListDiv").on("mouseout", ".remarkDiv", function () {
			$(this).children("div").children("div").hide();
		})

		// $(".myHref").mouseover(function(){
		// 	$(this).children("span").css("color","red");
		// });

		$("#remarkListDiv").on("mouseover", ".myHref", function () {
			$(this).children("span").css("color","red");
		})

		// $(".myHref").mouseout(function(){
		// 	$(this).children("span").css("color","#E6E6E6");
		// });

		$("#remarkListDiv").on("mouseout", ".myHref", function () {
			$(this).children("span").css("color","E6E6E6");
		})


		//为保存线索备注绑定事件
		$("#saveCreateClueRemarkBtn").click(function () {
			var noteContent= $.trim($("#remark").val());
			var clueId = '${clue.id}';

			$.ajax({
				url:"workbench/clue/addClueRemark.do",
				data:{
					noteContent:noteContent,
					clueId:clueId
				},
				dataType:"json",
				type:"post",
				success:function (data) {
					var html="";
					if(data.code=="1"){
						$("#remark").val("");
						html+='<div id="div_'+data.retObject.id+'" class="remarkDiv" style="height: 60px;">';
						html+='	<img title="${sessionScope.sessionUser.name}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html+='				<div style="position: relative; top: -40px; left: 40px;" >';
						html+='				<h5 id="h5_'+data.retObject.id+'">'+data.retObject.noteContent+'</h5>';
						html+='				<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b>' ;
						html+='	<small id="s_'+data.retObject.id+'" style="color: gray;"> '+data.retObject.createTime+' 由${sessionScope.sessionUser.name}';
						html+='			创建</small>';
						html+='			<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html+='<a class="myHref" name="editClueRemarkBtn" remarkId="'+data.retObject.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
						html+='	&nbsp;&nbsp;&nbsp;&nbsp;';
						html+='<a class="myHref" name="deleteClueRemarkBtn" remarkId="'+data.retObject.id+'" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
						html+='	</div>';
						html+='	</div>	';
						html+='	</div>';

						$("#remarkDiv").before(html);
					}else{
						alert(data.message);
					}

				}
			})
		})

		//为删除线索备注绑定事件
		$("#remarkListDiv").on("click", "a[name='deleteClueRemarkBtn']", function () {
			var id=$(this).attr("remarkId");

			$.ajax({
				url:"workbench/clue/deleteClueRemark.do",
				data:{
					id:id
				},
				dataType:"json",
				type:"post",
				success:function (data) {
					 if(data.code == "1"){
					 	$("#div_"+id).remove();
					 }else{
					 	alert(data.message);
					 }
				}
			})
		})

		//为修改线索备注绑定事件
		$("#remarkListDiv").on("click", "a[name='editClueRemarkBtn']", function () {
			var id=$(this).attr("remarkId");
			var noteContent =$("#h5_"+id).html();

			//打开修改线索的模态窗口
			$("#editRemarkModal").modal("show");
			$("#remarkId").val(id);
			$("#noteContent").html(noteContent);
		})

		//为保存修改线索备注绑定事件
		$("#updateRemarkBtn").click(function () {
			var id=$("#remarkId").val();
			var noteContent = $("#noteContent").val();

			$.ajax({
				url:"workbench/clue/editClueRemark.do",
				data:{
					id:id,
					noteContent:noteContent
				},
				dataType:"json",
				type:"post",
				success:function (data) {
					if(data.code == "1"){
						$("#h5_"+id).html(noteContent);
						$("#s_"+id).html(data.retObject.editTime+" 由"+"${sessionScope.sessionUser.name} 修改");
						$("#editRemarkModal").modal("hide");
					}else{
						alert(data.message);
					}

				}
			})
		})

		//为模糊查询市场活动绑定事件
		$("#searchActivityBtn").click(function () {
			var activityName = $("#activityName").val();
			var clueId = '${clue.id}';
			$.ajax({
				url:"workbench/clue/queryActivityByName.do",
				data:{
					activityName:activityName,
					clueId:clueId
				},
				dataType:"json",
				type:"post",
				success: function (data) {
					html = "";
					if(data.code=="1"){
						$.each(data.retObject, function (index, object) {
							html+='	<tr>';
							html+='	<td><input value="'+object.id+'" type="checkbox"/></td>';
							html+='			<td>'+object.name+'</td>';
							html+='			<td>'+object.startdate+'</td>';
							html+='			<td>'+object.enddate+'</td> ';
							html+='	<td>'+object.owner+'</td>';
							html+='	</tr>';
						})
						$("#activityListTbody").html(html);
					}else{
						alert(data.message);
					}
				}
			})
		})

		//为全选按钮绑定事件
		$("#checkAll").click(function () {
			$("#activityListTbody input[type='checkbox']").prop("checked", this.checked);
		})

		//全选触发全选按钮
		$("#activityListTbody").on("click", "input[type='checkbox']", function () {
			if($("#activityListTbody input[type='checkbox']").size() == $("#activityListTbody input[type='checkbox']:checked").size()){
				$("#checkAll").prop("checked", true);
			}else{
				$("#checkAll").prop("checked", false);
			}
		})

		//为“关联市场活动”按钮绑定事件
		$("#clueAndActivityBtn").click(function () {
			//清空模态窗口
			$("#activityName").val("");
			$("#activityListTbody").html("");

			$("#bundModal").modal("show");
		})

		//为关联按钮绑定事件
		$("#bundBtn").click(function () {
			//封装参数
			var checkedActivity=$("#activityListTbody input[type='checkbox']:checked");
			if(checkedActivity.size()==0){
				alert("请至少选择一条市场活动进行关联");
				return;
			}
			var id="?clueId="+'${clue.id}';
			$.each(checkedActivity, function (index, object) {
				id+="&activityId="+object.value;
			})

			//发送请求
			$.ajax({
				url:"workbench/clue/addActivityClueRelations.do"+id,
				data:{},
				dataType:"json",
				type:"post",
				success:function (data) {
					if(data.code == "1"){
						$("#bundModal").modal("hide");
						var html="";
						$.each(data.retObject, function (index, object) {
							html+='	<tr>';
							html+='		<td>'+object.name+'</td>';
							html+='		<td>'+object.startdate+'</td>';
							html+='	<td>'+object.enddate+'</td>';
							html+='	<td>'+object.owner+'</td>';
							html+='		<td><a activityId="'+object.id+'" href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
							html+='	</tr>';
						})
						$("#relatedActivityTbody").append(html);
					}else{
						alert(data.message);
					}

				}
			})

		})

	});
	
</script>

</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
	<%-- 备注的id --%>
	<input type="hidden" id="remarkId">
	<div class="modal-dialog" role="document" style="width: 40%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">修改备注</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<div class="form-group">
						<label for="noteContent" class="col-sm-2 control-label">内容</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="noteContent"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
			</div>
		</div>
	</div>
</div>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="activityName" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
							<button type="button" id="searchActivityBtn">搜索</button>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="checkAll"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id = "activityListTbody">
<%--							<tr>--%>
<%--								<td><input type="checkbox"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
<%--							<tr>--%>
<%--								<td><input type="checkbox"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="bundBtn">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='convert.html';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkListDiv" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

<%--		<!-- 备注1 -->--%>
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
<%--		--%>
			<c:forEach items="${clueRemarkList}" var="remark">
				<div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
						<img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
						<div style="position: relative; top: -40px; left: 40px;" >
							<h5 id="h5_${remark.id}">${remark.noteContent}</h5>
							<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b>
							<small id="s_${remark.id}" style="color: gray;"> ${remark.editFlag=='1'?remark.editTime:remark.createTime} 由${remark.editFlag=='1'?remark.editBy:remark.createBy}
							${remark.editFlag=='1'?'修改':'创建'}</small>
							<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
								<a class="myHref" name="editClueRemarkBtn" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<a class="myHref" name="deleteClueRemarkBtn" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
							</div>
						</div>
				</div>
			</c:forEach>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveCreateClueRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="relatedActivityTbody">
<%--						<tr>--%>
<%--							<td>发传单</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
<%--						</tr>--%>
<%--						<tr>--%>
<%--							<td>发传单</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
<%--						</tr>--%>
					<c:forEach items="${activityList}" var="activity">
						<tr>
							<td>${activity.name}</td>
							<td>${activity.startdate}</td>
							<td>${activity.enddate}</td>
							<td>${activity.owner}</td>
							<td><a activityId="${activity.id}" href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="clueAndActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>