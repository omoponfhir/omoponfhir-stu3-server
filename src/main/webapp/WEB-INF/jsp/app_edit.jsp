<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Application Setting - Edit</title>
</head>
<body>
	<%
		String clientId = (String) request.getAttribute("client_id");
		String appType = (String) request.getAttribute("app_type");
		String scope = (String) request.getAttribute("scope");
		if (clientId != null && !clientId.isEmpty()) {
	%>
	<p>Please Create Your App</p>
	<p>
	<form action="/smart/app-update">
		<b>Application Name</b><br /> &nbsp;&nbsp;<input type="text" name="app_name" value="${app_name}"><br />
		<br /> 
		<b>Client-id</b><br />
		&nbsp;&nbsp;${client_id}<input type="hidden" name="client_id" value="${client_id}"><br />
		<br/ >
		<b>SMART Launch Uri</b><br />
		&nbsp;&nbsp;<input type="text" name="launch_uri" value="${launch_uri}"><br />
		<br />
		<b>Redirect URI</b><br /> &nbsp;&nbsp;<input type="text" name="redirect_uri" value="${redirect_uri}"><br /> 
		<br /> 
		<b>App Type</b><br /> 
	<% if ("Provider".equals(appType)) { %>
		&nbsp;&nbsp;<input type="radio" name="app_type" checked="checked" value="Provider">Provider<br />
		&nbsp;&nbsp;<input type="radio" name="app_type" value="Patient">Patient<br />
	<% } else { %> 
		&nbsp;&nbsp;<input type="radio" name="app_type" value="Provider">Provider<br />
		&nbsp;&nbsp;<input type="radio" name="app_type" checked="checked" value="Patient">Patient<br />
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
								<input type="checkbox" id="user_condition_r" name="user_condition_r" checked> read
	<% } else { %>
								<input type="checkbox" id="user_condition_r" name="user_condition_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">DocumentReference</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/DocumentReference.read")) { %>
								<input type="checkbox" id="user_documentreference_r" name="user_documentreference_r" checked> read
	<% } else { %>
								<input type="checkbox" id="user_documentreference_r" name="user_documentreference_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Encounter</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/Encounter.read")) { %>
								<input type="checkbox" id="user_encounter_r" name="user_encounter_r" checked> read
	<% } else { %>
								<input type="checkbox" id="user_encounter_r" name="user_encounter_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">MedicationStatement</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/MedicationStatement.read")) { %>
								<input type="checkbox" id="user_medicationstatement_r" name="user_medicationstatement_r" checked> read
	<% } else { %>
								<input type="checkbox" id="user_medicationstatement_r" name="user_medicationstatement_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">MedicationRequest</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/MedicationRequest.read")) { %>
								<input type="checkbox" id="user_medicationrequest_r" name="user_medicationrequest_r" checked> read
	<% } else { %>
								<input type="checkbox" id="user_medicationrequest_r" name="user_medicationrequest_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Observation</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/Observation.read")) { %>
								<input type="checkbox" id="user_observation_r" name="user_observation_r" checked> read
	<% } else { %>
								<input type="checkbox" id="user_observation_r" name="user_observation_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Patient</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/Patient.read")) { %>
								<input type="checkbox" id="user_patient_r" name="user_patient_r" checked> read
	<% } else { %>
								<input type="checkbox" id="user_patient_r" name="user_patient_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Procedure</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("user/Procedure.read")) { %>
								<input type="checkbox" id="user_procedure_r" name="user_procedure_r" checked> read
	<% } else { %>
								<input type="checkbox" id="user_procedure_r" name="user_procedure_r"> read
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
								<input type="checkbox" id="patient_condition_r" name="patient_condition_r" checked> read
	<% } else { %>
								<input type="checkbox" id="patient_condition_r" name="patient_condition_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">DocumentReference</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/DocumentReference.read")) { %>
								<input type="checkbox" id="patient_documentreference_r" name="patient_documentreference_r" checked> read
	<% } else { %>
								<input type="checkbox" id="patient_documentreference_r" name="patient_documentreference_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Encounter</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/Encounter.read")) { %>
								<input type="checkbox" id="patient_encounter_r" name="patient_encounter_r" checked> read
	<% } else { %>
								<input type="checkbox" id="patient_encounter_r" name="patient_encounter_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">MedicationStatement</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/MedicationStatement.read")) { %>
								<input type="checkbox" id="patient_medicationstatement_r" name="patient_medicationstatement_r" checked> read
	<% } else { %>
								<input type="checkbox" id="patient_medicationstatement_r" name="patient_medicationstatement_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">MedicationRequest</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/MedicationRequest.read")) { %>
								<input type="checkbox" id="patient_medicationrequest_r" name="patient_medicationrequest_r" checked> read
	<% } else { %>
								<input type="checkbox" id="patient_medicationrequest_r" name="patient_medicationrequest_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Observation</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/Observation.read")) { %>
								<input type="checkbox" id="patient_observation_r" name="patient_observation_r" checked> read
	<% } else { %>
								<input type="checkbox" id="patient_observation_r" name="patient_observation_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Patient</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/Patient.read")) { %>
								<input type="checkbox" id="patient_patient_r" name="patient_patient_r" checked> read
	<% } else { %>
								<input type="checkbox" id="patient_patient_r" name="patient_patient_r"> read
	<% } %>
							</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Procedure</td>
							<td style="border:1px solid grey;">
	<% if (scope.contains("patient/Procedure.read")) { %>
								<input type="checkbox" id="patient_procedure_r" name="patient_procedure_r" checked> read
	<% } else { %>
								<input type="checkbox" id="patient_procedure_r" name="patient_procedure_r"> read
	<% } %>
							</td>
						</tr>
					</table></td>
			</tr>
		</table>
		<br/>
		<input type="submit" value="Save">
	</form>
	</p>
	<%
		} else {
	%>
	Unauthorized Access
	<%
		}
	%>
</body>
</html>