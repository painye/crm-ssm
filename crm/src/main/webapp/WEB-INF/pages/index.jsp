<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
	<script type="text/javascript">
		window.location.href = "settings/qx/user/login.html";
	</script>
</body>
</html>