<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Authentication</title>
</head>
<body>
<%
	boolean validate = (boolean) request.getAttribute("auth_request_validated");
	if (validate) {
%>
	<p>In real world, user authentication should happen here. We just
		authenticate all as we are simulation authentication. Plerase just
		click authenticate button</p>
	<button type="button" onClick="redirect()">Authenticate!</button>
	<script>
		function redirect() {
			var url = "http://www.(url).com";
			window.location.href = "/smart/after-auth"
		}
	</script>
<%  } else { %>
	<p>Unauthorized Access</p>
<%  } %>
</body>
</html>