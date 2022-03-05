<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
	request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
	<base href="<%=basePath%>">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<!--分页查询插件-->

<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){
		//绑定创建活动的按钮
		$("#createActivityBtn").click(function () {
			//重置表单
			$("#createActivityForm").get(0).reset();
			//显示模态窗口
			$("#createActivityModal").modal("show");
		})

		//绑定保存按钮的事件
		$("#saveCreateActivityBtn").click(function () {
			var owner = $("#create-marketActivityOwner").val();
			var name = $.trim($("#create-marketActivityName").val());
			var startDate = $("#create-startDate").val();
			var endDate = $("#create-endDate").val();
			var cost = $.trim($("#create-cost").val());
			var description = $.trim($("#create-description").val());
			//表单验证
			if(owner == ""){
				alert("所有者不能为空");
				return;
			}
			if(name == ""){
				alert("活动名称不能为空");
				return;
			}
			if(startDate !=""&&endDate!=""){
				if(startDate>endDate){
					alert("结束日期不能比开始日期小");
					return;
				}
			}
			//正则表达式,非负整数
			var regExp=/^(([1-9]\d*)|0)$/;
			if(!regExp.test(cost)){
				alert("成本只能是非负整数")
			}
			//非负请求
			$.ajax({
				url : "workbench/activity/createActivity.do",
				data:{
					"owner": owner,
					"name": name,
					"startdate": startDate,
					"enddate" :endDate,
					"cost" :cost,
					"description" :description
				},
				dataType : "json",
				type : "post",
				success : function (data) {
					if(data.code == 1){
						//保存成功
						queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination("getOption", 'rowsPerPage'));
						//关闭模态窗口
						$("#createActivityModal").modal("hide");
						queryActivityByConditionForPage(1, 10);
					}else{
						alert("保存失败");
					}
				}
			});
		})

		//当容器创建完成之后，对容器调用日历函数
		$(".myDate").datetimepicker({
			language : "zh-CN",
			format : "yyyy-mm-dd",
			minView: 'month',
			initialDate : new Date(),	//初始化显示的日期
			autoclose : true,//选择完日期之后是否默认关闭
			todayBtn: true,
			clearBtn : true
		});

		queryActivityByConditionForPage(1,10);

		//为查询按钮绑定事件
        $("#queryActivityByConditionBtn").click(function () {
			queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination("getOption", 'rowsPerPage'));
		});

        //为全选事件绑定
		$("#checkAll").click(function () {
			$("#tbody input[type = 'checkbox']").prop('checked', this.checked);
		})


		//添加全部勾选事件触发全选按钮
		$("#tbody").on("click", "input[type='checkbox']", function(){
			if($("#tbody input[type='checkbox']").size()==$("#tbody input[type='checkbox']:checked").size()){
				$("#checkAll").prop("checked", true);
			}else{
				$("#checkAll").prop("checked", false);
			}
		});

		//为删除按钮绑定事件
		$("#deleteActivity").click(function () {
			var checkedActivity = $("#tbody input[type='checkBox']:checked");
			var ids = "";
			if(checkedActivity.size()==0){
				alert("请选择要删除的市场活动");
			}
			if(window.confirm("确定删除这些活动吗")) {
				$.each(checkedActivity, function (index, object) {
					if (index == checkedActivity.size() - 1) {
						ids += object.value;
					} else {
						ids += object.value + "&ids=";
					}
				})
				var url = "workbench/activity/deleteCheckedActivity.do?ids=" + ids;

				$.ajax({
					url: url,
					Type: "post",
					dataType: "json",
					success: function (data) {
						if (data.code == '1') {
							queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination("getOption", 'rowsPerPage'));
						} else {
							alert(data.message);
						}
					}
				})
			}
		});

		//为修改市场活动绑定事件
		$("#editActivity").click(function () {
			var checkIds = $("#tbody input[type='checkbox']:checked")
			if(checkIds.size()==0){
				alert("请选择您要修改的市场活动");
			}else if(checkIds.size()>1) {
				alert("只能选择一个市场活动进行修改");
			}
			//打开修改的模态窗口
			$("#editActivityModal").modal("show");
			var id=checkIds.val();
			$.ajax({
				url:"workbench/activity/queryActivityById.do",
				data:{
					id:id
				},
				dataType:"json",
				type:"post",
				success:function (data) {
					$("#hideEditId").val(data.id);
					$("#edit-marketActivityName").val(data.name);
					//会自动与下拉框中所出现的userList进行匹配，显示其姓名
					$("#edit-marketActivityOwner").val(data.owner);
					$("#edit-startdate").val(data.startdate);
					$("#edit-enddate").val(data.enddate);
					$("#edit-cost").val(data.cost);
					$("#edit-description").val(data.description);
				}
			})
		});

		//为修改市场活动的模态窗口的更新按钮绑定事件
		$("#editActivityBtn").click(function () {
			//先获取需要传递的参数
			var id=$("#hideEditId").val();
			var name=$.trim($("#edit-marketActivityName").val());
			var owner=$.trim($("#edit-marketActivityOwner").val());
			var startdate = $.trim($("#edit-startdate").val());
			var enddate=$.trim($("#edit-enddate").val());
			var cost=$.trim($("#edit-cost").val());
			var description=$.trim($("#edit-description").val());

			$.ajax({
				url:"workbench/activity/editActivity.do",
				data:{
					id: id ,
					name: name ,
					owner: owner ,
					startdate: startdate ,
					enddate: enddate ,
					cost: cost ,
					description: description
				},
				dataType:"json",
				type:"post",
				success : function (data) {
					if(data.code=='1'){
						//修改成功
						$("#editActivityModal").modal("hide");
						queryActivityByConditionForPage($("#demo_pag1").bs_pagination('getOption', 'currentPage'), $("#demo_pag1").bs_pagination("getOption", "rowsPerPage"));
					}else{
						alert(data.message);
					}

				}
			})
		});

		//绑定批量全部导出按钮的事件
		$("#exportActivityAllBtn").click(function () {
			window.location.href="workbench/activity/exportAllActivity.do";

		});

		// 选择导出文件绑定事件
		$("#exportActivityXzBtn").click(function () {
			var url = "workbench/activity/queryCheckedActivityById.do?id="
			var checkedId = $("#tbody input[type='checkbox']:checked");
			if(checkedId.size()==0){
				alert("请选择您想要下载的信息");
				return ;
			}
			var id="";
			$.each(checkedId, function (index, object) {
				id += object.value+"&id=";
			})
			id = id.substr(0, id.length-4)
			window.location.href=url+id;
		})

		//为上传文件导入按钮模态窗口绑定事件
		$("#importActivityBtn").click(function () {
			var activityFileName = $("#activityFile").val();
			var suffix = activityFileName.substr(activityFileName.indexOf(".")+1).toLowerCase();
			if(suffix!="xls"){
				alert("请选择xls格式的文件");
				return;
			}
			//获取文件本身
			var activityFile = $("#activityFile").get(0).files[0];
			if(activityFile.size>5*1024*1024){
				alert("文件不能大于5m");
				return;
			}

			var formData =new FormData();
			formData.append("activityFile", activityFile)

			//发送请求
			$.ajax({
				url : "workbench/activity/addActivityByList.do",
				processData:false,
				contentType:false,
				data: formData,
				dataType:"json",
				type : "post",
				success : function (data) {
					if(data.code=='1'){
						alert(data.message);
						$("#importActivityModal").modal("hide");
						queryActivityByConditionForPage(1,  $("#demo_pag1").bs_pagination("getOption", "rowsPerPage"));
					}else{
						alert(data.message);

					}

				}
			})


		})
	});




	function queryActivityByConditionForPage(pageNo,pageSize ) {
		var name = $.trim($("#query-name").val());
		var owner = $.trim($("#query-owner").val());
		var startDate = $.trim($("#query-startDate").val());
		var endDate = $.trim($("#query-endDate").val());

		$.ajax({
			url : "workbench/activity/queryActivityByConditionForPage.do",
			data:{
				name:name,
				owner:owner,
				startDate:startDate,
				endDate:endDate,
				pageNo:pageNo,
				pageSize:pageSize
			},
			dataType: "json",
			type:"post",
			success : function (data) {
				$("#totalRowsB").text(data.totalRows);
				var html="";
				$.each(data.activityList, function(index, object) {
					html+='  <tr class="active">';
					html+='  		<td><input type="checkbox" value="'+object.id+'"/></td>';
					html+='  		<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/queryActivityRemarkByActivityId.do?id='+object.id+'\';">'+object.name+'</a></td>';
					html+='  <td>'+object.owner+'</td>';
					html+='  <td>'+object.startdate+'</td>';
					html+='  <td>'+object.enddate+'</td>';
					html+='  </tr>';
				})
				$("#tbody").html(html);

				//计算总页数
				var totalPages=1;
				if(data.totalRows%pageSize==0){
					totalPages=parseInt(data.totalRows/pageSize);
				}else
				{
					totalPages=parseInt(data.totalRows/pageSize)+1;
				}

				//取消全选按钮
				$("#checkAll").prop("checked", false);

				//调用分页插件
				$("#demo_pag1").bs_pagination({
					currentPage:pageNo,  //当前页，相当于pageNO
					rowsPerPage: pageSize, //pageSize
					totalRows:data.totalRows,
					totalPages: totalPages,
					visiblePageLinks: 5, //最多可以显示的卡片数
					showGoToPage: true,
					showRowsPerPage: true,
					showRowInfo:true,
					//页面发生变化的时候，再次调用分页函数
					onChangePage: function (event, pageObj) {
						queryActivityByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
					}
				})
			}
		});
	}

</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="createActivityForm" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								  <c:forEach items="${userList}" var="u">
									  <option value="${u.id}">${u.name}</option>
								  </c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="create-startDate">
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="create-endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="hidden" id="hideEditId">
								<select class="form-control" id="edit-marketActivityOwner">
								 <c:forEach items="${userList}" var="u">
									 <option value="${u.id}">${u.name}</option>
								 </c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startdate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="edit-startdate" value="2020-10-10">
							</div>
							<label for="edit-enddate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="edit-enddate" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="editActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control myDate" type="text" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control myDate" type="text" id="query-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryActivityByConditionBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivity"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivity"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tbody">
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>2020-10-10</td>--%>
<%--                            <td>2020-10-20</td>--%>
<%--                        </tr>--%>

					</tbody>
				</table>
				<div id="demo_pag1"></div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 30px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB"></b>条记录</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--					<div class="btn-group">--%>
<%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--							10--%>
<%--							<span class="caret"></span>--%>
<%--						</button>--%>
<%--						<ul class="dropdown-menu" role="menu">--%>
<%--							<li><a href="#">20</a></li>--%>
<%--							<li><a href="#">30</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">首页</a></li>--%>
<%--							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">下一页</a></li>--%>
<%--							<li class="disabled"><a href="#">末页</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>
<%--			</div>--%>
			
		</div>
		
	</div>
</body>
</html>