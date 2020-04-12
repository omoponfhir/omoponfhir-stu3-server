<%
	boolean disableIt = "app_view.jsp".equalsIgnoreCase(request.getParameter("file_name"))?true:false;
%>
<div id="non_system_data">
	<b>SMART Launch URI</b><br /> 
	&nbsp;&nbsp;<input <%if (disableIt) {out.print("disabled");} %> class="text ui-widget-content ui-corner-all" style="width: 70%;" type="text" name="launch_uri" value="${launch_uri}"><br /> <br /> 
	<b>Redirect URI</b><br /> 
	&nbsp;&nbsp;<input <%if (disableIt) {out.print("disabled");} %> class="text ui-widget-content ui-corner-all" style="width: 70%;" type="text" name="redirect_uri" value="${redirect_uri}"><br /> <br /> 
	<b>Standard Scopes</b> (user and patient scope only)<br /> 
	&nbsp;&nbsp;launch profile openid online_access launch/patient(only for patient type)<br /> <br />
</div>
<div id="system_data">
	<b>Public Key</b><br /> 
	&nbsp;&nbsp;<textarea <%if (disableIt) {out.print("disabled");} %> class="text ui-widget-content ui-corner-all" rows="7" cols="100" name="public_key">${public_key}</textarea><br /> <br /> 
</div>