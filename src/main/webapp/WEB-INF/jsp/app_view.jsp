<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Application Setting - View</title>
</head>
<body>
	<%
		String clientId = (String) request.getAttribute("client_id");
		String appName = (String) request.getAttribute("app_name");
		String appType = (String) request.getAttribute("app_type");
		String scope = (String) request.getAttribute("scope");
		if (clientId != null && !clientId.isEmpty() && appName != null && !appName.isEmpty() &&
			appType != null && !appType.isEmpty() && scope != null && !scope.isEmpty()) {
	%>
	<p>Your App Information</p>
	<p>
		<b>Application Name</b><br /> 
		&nbsp;&nbsp;${app_name}<br />
		<br /> 
	<%
		String launchUri = (String) request.getAttribute("launch_uri");
		if (launchUri != null && !launchUri.isEmpty()) {
	%>	
		<form action="${base_url}/smart/app-launch">
			<input type="submit" value="Launch App"> patient id: <input type="text" name="patient_id"> 
			<input type="hidden" name="client_id" value="${client_id}">
		</form>
		<br />
	<% } %>
		<b>Client-id</b><br />
		&nbsp;&nbsp;${client_id}<br />
		<br/ >
		<b>SMART Launch Uri</b><br />
		&nbsp;&nbsp;${launch_uri}<br />
		<br />
		<b>Redirect URI</b><br /> 
		&nbsp;&nbsp;${redirect_uri}<br /> 
		<br /> 
		<b>App Type</b><br /> 
	<% if ("Provider".equals(appType)) { %>
		&nbsp;&nbsp;<input type="radio" name="app_type" checked="checked" value="Provider" disabled>Provider<br />
		&nbsp;&nbsp;<input type="radio" name="app_type" value="Patient" disabled>Patient<br />
	<% } else { %> 
		&nbsp;&nbsp;<input type="radio" name="app_type" value="Provider" disabled>Provider<br />
		&nbsp;&nbsp;<input type="radio" name="app_type" checked="checked" value="Patient" disabled>Patient<br />
	<% } %> 
		<br /> 
		<b>Standard Scopes</b><br /> 
		&nbsp;&nbsp;launch profile openid online_access launch/patient(only for patient type)<br /> 
		<br />
		<table border=0 width="70%" >
			<tr>
				<td><b>User Scopes:</b>
					<table width="100%" cellpadding="2" style="border:1px solid grey; border-collapse:collapse;">
						<tr>
							<th style="border:1px solid grey;">Resource</th>
							<th style="border:1px solid grey;">Scope</th>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Condition</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/Condition.read")) { %>
								<input type="checkbox" id="user_condtion_r" name="user_condtion_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="user_condtion_r" name="user_condtion_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">DocumentReference</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/DocumentReference.read")) { %>
								<input type="checkbox" id="user_documentreference_r" name="user_documentreference_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="user_documentreference_r" name="user_documentreference_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Encounter</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/Encounter.read")) { %>
								<input type="checkbox" id="user_encounter_r" name="user_encounter_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="user_encounter_r" name="user_encounter_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">MedicationStatement</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/MedicationStatement.read")) { %>
								<input type="checkbox" id="user_medicationstatement_r" name="user_medicationstatement_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="user_medicationstatement_r" name="user_medicationstatement_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">MedicationRequest</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/MedicationRequest.read")) { %>
								<input type="checkbox" id="user_medicationrequest_r" name="user_medicationrequest_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="user_medicationrequest_r" name="user_medicationrequest_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Observation</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/Observation.read")) { %>
								<input type="checkbox" id="user_observation_r" name="user_observation_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="user_observation_r" name="user_observation_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Patient</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/Patient.read")) { %>
								<input type="checkbox" id="user_patient_r" name="user_patient_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="user_patient_r" name="user_patient_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Procedure</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/Patient.read")) { %>
								<input type="checkbox" id="user_procedure_r" name="user_procedure_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="user_procedure_r" name="user_procedure_r" disabled> read
	<% } %>
							</td>
						</tr>
					</table></td>
				<td><b>Patient Scopes:</b>
					<table width="100%" cellpadding="2" style="border:1px solid grey; border-collapse:collapse;">
						<tr>
							<th style="border:1px solid grey;">Resource</th>
							<th style="border:1px solid grey;">Scope</th>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Condition</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/Condition.read")) { %>
								<input type="checkbox" id="patient_condtion_r" name="patient_condtion_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="patient_condtion_r" name="patient_condtion_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">DocumentReference</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/DocumentReference.read")) { %>
								<input type="checkbox" id="patient_documentreference_r" name="patient_documentreference_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="patient_documentreference_r" name="patient_documentreference_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Encounter</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/Encounter.read")) { %>
								<input type="checkbox" id="patient_encounter_r" name="patient_encounter_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="patient_encounter_r" name="patient_encounter_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">MedicationStatement</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/MedicationStatement.read")) { %>
								<input type="checkbox" id="patient_medicationstatement_r" name="patient_medicationstatement_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="patient_medicationstatement_r" name="patient_medicationstatement_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">MedicationRequest</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/MedicationRequest.read")) { %>
								<input type="checkbox" id="patient_medicationrequest_r" name="patient_medicationrequest_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="patient_medicationrequest_r" name="patient_medicationrequest_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Observation</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/Observation.read")) { %>
								<input type="checkbox" id="patient_observation_r" name="patient_observation_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="patient_observation_r" name="patient_observation_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Patient</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/Patient.read")) { %>
								<input type="checkbox" id="patient_patient_r" name="patient_patient_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="patient_patient_r" name="patient_patient_r" disabled> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Procedure</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/Procedure.read")) { %>
								<input type="checkbox" id="patient_procedure_r" name="patient_procedure_r" checked disabled> read
	<% } else { %>
								<input type="checkbox" id="patient_procedure_r" name="patient_procedure_r" disabled> read
	<% } %>
							</td>
						</tr>
					</table></td>
			</tr>
		</table>
	</p>
	
	<button onclick="window.location.href='${base_url}/smart/app-delete/?client_id=${client_id}';">Delete</button>
	<button onclick="window.location.href='${base_url}/smart/app-edit/?client_id=${client_id}';">Edit</button>
	<%
		} else {
	%>
	Unauthorized Access
	<%
		}
	%>
</body>
</html>