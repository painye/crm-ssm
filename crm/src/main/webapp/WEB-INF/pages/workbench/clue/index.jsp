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


		//为创建按钮绑定事件
		$("#createClueBtn").click(function () {
			//显示模态窗口
			$("#createClueModal").modal("show")
		});


		//为创建线索的模态窗口的保存按钮绑定事件
		$("#saveClueBtn").click(function () {
			//收集参数
			var fullname=$.trim($("#create-fullname").val());
			var appellation=$.trim($("#create-appellation").val());
			var owner=$.trim($("#create-owner").val());
			var company=$.trim($("#create-company").val());
			var job=$.trim($("#create-job").val());
			var email=$.trim($("#create-email").val());
			var phone=$.trim($("#create-phone").val());
			var website=$.trim($("#create-website").val());
			var mphone=$.trim($("#create-mphone").val());
			var state=$.trim($("#create-state").val());
			var source=$.trim($("#create-source").val());
			var description=$.trim($("#create-description").val());
			var contactSummary=$.trim($("#create-contactSummary").val());
			var nextContactTime=$.trim($("#create-nextContactTime").val());
			var address=$.trim($("#create-address").val());

			//表单验证
			if(company==""){
				alert("公司名称不能为空");
				return;
			}
			if(fullname == ""){
				alert(("姓名不能为空"))
				return;
			}

			//发送请求
			$.ajax({
				url:"workbench/clue/saveCreateClue.do",
				data:{
					fullname: fullname,
					appellation: appellation,
					owner: owner,
					company: company,
					job: job,
					email: email,
					phone: phone,
					website: website,
					mphone: mphone,
					state: state,
					source: source,
					description: description,
					contactSummary: contactSummary,
					nextContactTime: nextContactTime,
					address: address
				},
				dataType:"json",
				type:"post",
				success: function (data) {
					if(data.code=="1"){
						queryClueByConditionForPage(1,  $("#demo_pag1").bs_pagination("getOption", "rowsPerPage"));
						$("#createClueModal").modal("hide");
					}else{
						alert(data.message);
					}

				}
			})
		});

		queryClueByConditionForPage(1, 10);
		
	});

	function queryClueByConditionForPage(pageNo, pageSize) {
		var fullname = $.trim($("#searchFullname").val());
		var company = $.trim($("#searchCompany").val());
		var owner = $.trim($("#searchOwner").val());
		var source = $.trim($("#searchSource").val());
		var state =$.trim($("#searchState").val());

		$.ajax({
			url:"workbench/clue/queryClueByConditionForPage.do",
			data:{
				fullname:fullname,
				company:company,
				owner:owner,
				source:source,
				state:state,
				pageNo:pageNo,
				pageSize:pageSize

			},
			dataType: "json",
			type:"post",
			success:function (data) {
				var html="";
				$.each(data.clueList, function (index, object) {
					html+= ' <tr>';
					html+= ' <td><input type="checkbox" value="'+object.id+'"/></td>';
					html+= ' 		<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'detail.html\';">'+object.fullname+object.appellation+'</a></td>';
					html+= ' <td>'+object.company+'</td>';
					html+= ' <td>'+object.phone+'</td>';
					html+= ' <td>'+object.mphone+'</td>';
					html+= ' <td>'+object.source+'</td>';
					html+= ' <td>'+object.owner+'</td>';
					html+= ' <td>'+object.state+'</td>';
					html+= ' </tr>		';
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
						queryClueByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
					}
				})
			}
		});

	}
	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
									<c:forEach items="${users}" var="user">
										<option id="${user.id}" value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
									<c:forEach items="${appellations}" var="appellation">
										<option id="${appellation.id}" value="${appellation.id}">${appellation.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
<%--								  <option></option>--%>
<%--								  <option>试图联系</option>--%>
<%--								  <option>将来联系</option>--%>
<%--								  <option>已联系</option>--%>
<%--								  <option>虚假线索</option>--%>
<%--								  <option>丢失线索</option>--%>
<%--								  <option>未联系</option>--%>
<%--								  <option>需要条件</option>--%>
									<c:forEach items="${clueStates}" var="clueState">
										<option id="${clueState.id}" value="${clueState.id}">${clueState.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
<%--								  <option></option>--%>
<%--								  <option>广告</option>--%>
<%--								  <option>推销电话</option>--%>
<%--								  <option>员工介绍</option>--%>
<%--								  <option>外部介绍</option>--%>
<%--								  <option>在线商场</option>--%>
<%--								  <option>合作伙伴</option>--%>
<%--								  <option>公开媒介</option>--%>
<%--								  <option>销售邮件</option>--%>
<%--								  <option>合作伙伴研讨会</option>--%>
<%--								  <option>内部研讨会</option>--%>
<%--								  <option>交易会</option>--%>
<%--								  <option>web下载</option>--%>
<%--								  <option>web调研</option>--%>
<%--								  <option>聊天</option>--%>
									<c:forEach items="${sources}" var="source">
										<option id="${source.id}" value="${source.id}">${source.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control myDate" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveClueBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
<%--								  <option>zhangsan</option>--%>
<%--								  <option>lisi</option>--%>
<%--								  <option>wangwu</option>--%>
									<c:forEach items="${users}" var="user">
										<option id="${user.id}" value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
<%--								  <option></option>--%>
<%--								  <option selected>先生</option>--%>
<%--								  <option>夫人</option>--%>
<%--								  <option>女士</option>--%>
<%--								  <option>博士</option>--%>
<%--								  <option>教授</option>--%>
									<c:forEach items="${appellations}" var="appellation">
										<option id="${appellation.id}" value="${appellation.id}">${appellation.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
<%--								  <option></option>--%>
<%--								  <option>试图联系</option>--%>
<%--								  <option>将来联系</option>--%>
<%--								  <option selected>已联系</option>--%>
<%--								  <option>虚假线索</option>--%>
<%--								  <option>丢失线索</option>--%>
<%--								  <option>未联系</option>--%>
<%--								  <option>需要条件</option>--%>
									<c:forEach items="${clueStates}" var="clueState">
										<option id="${clueState.id}" value="${clueState.id}">${clueState.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
<%--								  <option></option>--%>
<%--								  <option selected>广告</option>--%>
<%--								  <option>推销电话</option>--%>
<%--								  <option>员工介绍</option>--%>
<%--								  <option>外部介绍</option>--%>
<%--								  <option>在线商场</option>--%>
<%--								  <option>合作伙伴</option>--%>
<%--								  <option>公开媒介</option>--%>
<%--								  <option>销售邮件</option>--%>
<%--								  <option>合作伙伴研讨会</option>--%>
<%--								  <option>内部研讨会</option>--%>
<%--								  <option>交易会</option>--%>
<%--								  <option>web下载</option>--%>
<%--								  <option>web调研</option>--%>
<%--								  <option>聊天</option>--%>
									<c:forEach items="${sources}" var="source">
										<option id="${source.id}" value="${source.id}">${source.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input class="form-control" id="searchFullname" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" id="searchCompany" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >线索来源</div>
					  <select class="form-control" id="searchSource">
<%--					  	  <option></option>--%>
<%--					  	  <option>广告</option>--%>
<%--						  <option>推销电话</option>--%>
<%--						  <option>员工介绍</option>--%>
<%--						  <option>外部介绍</option>--%>
<%--						  <option>在线商场</option>--%>
<%--						  <option>合作伙伴</option>--%>
<%--						  <option>公开媒介</option>--%>
<%--						  <option>销售邮件</option>--%>
<%--						  <option>合作伙伴研讨会</option>--%>
<%--						  <option>内部研讨会</option>--%>
<%--						  <option>交易会</option>--%>
<%--						  <option>web下载</option>--%>
<%--						  <option>web调研</option>--%>
<%--						  <option>聊天</option>--%>
							<option></option>
							<c:forEach items="${sources}" var="source">
								<option id="${source.id}" value="${source.id}">${source.text}</option>
							</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="searchOwner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="searchState">
<%--					  	<option></option>--%>
<%--					  	<option>试图联系</option>--%>
<%--					  	<option>将来联系</option>--%>
<%--					  	<option>已联系</option>--%>
<%--					  	<option>虚假线索</option>--%>
<%--					  	<option>丢失线索</option>--%>
<%--					  	<option>未联系</option>--%>
<%--					  	<option>需要条件</option>--%>
						<option></option>
						<c:forEach items="${clueStates}" var="clueState">
							<option id="${clueState.id}">${clueState.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="submit" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tbody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>12345678901</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>已联系</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">李四先生</a></td>--%>
<%--                            <td>动力节点</td>--%>
<%--                            <td>010-84846003</td>--%>
<%--                            <td>12345678901</td>--%>
<%--                            <td>广告</td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>已联系</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="demo_pag1"></div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 60px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
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