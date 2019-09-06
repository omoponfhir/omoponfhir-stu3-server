<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html>
<head>
<meta charset="UTF-8">
<title>SMART on FHIR Lite Platform</title>
</head>
<body>
<p><b>This page simulates SMART on FHIR App Launch</b></p>
<p><a href="/smart/app-create/">Click here to create a new application</a></p><br/>
<p>Registered Applications:</p>

<c:forEach items="${appList.appEntries}" var = "appEntry">
	<a href="/smart/app-view/?client_id=${appEntry.appId}">${appEntry.appName}</a><br/><br/>
</c:forEach>

</body>
</html>