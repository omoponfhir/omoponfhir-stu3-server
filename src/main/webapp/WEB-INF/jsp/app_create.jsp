<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Application Setting - Create</title>
</head>
<body>
	<%
		String clientId = (String) request.getAttribute("client_id");
		if (clientId != null && !clientId.isEmpty()) {
	%>
	<p>Please Create Your App</p>
	<p>
	<form action="${base_url}/smart/app-new">
		<b>Application Name</b><br /> &nbsp;&nbsp;<input type="text" name="app_name" value="${app_name}"><br />
		<br /> 
		<b>Client-id</b><br />
		&nbsp;&nbsp;${client_id}<input type="hidden" name="client_id" value="${client_id}"><br />
		<br/ >
		<b>SMART Launch Uri</b><br />
		&nbsp;&nbsp;<input type="text" name="launch_uri"><br />
		<br />
		<b>Redirect URI</b><br /> &nbsp;&nbsp;<input type="text" name="redirect_uri"><br /> 
		<br /> 
		<b>App Type</b><br /> 
		&nbsp;&nbsp;<input type="radio" name="app_type" value="Provider">Provider<br /> 
		&nbsp;&nbsp;<input type="radio" name="app_type" value="Patient">Patient<br />
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
							<td style="border:1px solid grey;"><input type="checkbox" id="user_condition_r"
								name="user_condition_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">DocumentReference</td>
							<td style="border:1px solid grey;"><input type="checkbox" id="user_documentreference_r"
								name="user_documentreference_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Encounter</td>
							<td style="border:1px solid grey;"><input type="checkbox" id="user_encounter_r"
								name="user_encounter_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">MedicationStatement</td>
							<td style="border:1px solid grey;"><input type="checkbox"
								id="user_medicationstatement_r"
								name="user_medicationstatement_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">MedicationRequest</td>
							<td style="border:1px solid grey;"><input type="checkbox" id="user_medicationrequest_r"
								name="user_medicationrequest_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Observation</td>
							<td style="border:1px solid grey;"><input type="checkbox" id="user_observation_r"
								name="user_observation_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Patient</td>
							<td style="border:1px solid grey;"><input type="checkbox" id="user_patient_r"
								name="user_patient_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Procedure</td>
							<td style="border:1px solid grey;"><input type="checkbox" id="user_procedure_r"
								name="user_procedure_r"> read</td>
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
							<td style="border:1px solid grey;"><input type="checkbox" id="patient_condition_r"
								name="patient_condition_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">DocumentReference</td>
							<td style="border:1px solid grey;"><input type="checkbox" id="patient_documentreference_r"
								name="patient_documentreference_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Encounter</td>
							<td style="border:1px solid grey;"><input type="checkbox" id="patient_encounter_r"
								name="patient_encounter_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">MedicationStatement</td>
							<td style="border:1px solid grey;"><input type="checkbox"
								id="patient_medicationstatement_r"
								name="patient_medicationstatement_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">MedicationRequest</td>
							<td style="border:1px solid grey;"><input type="checkbox" id="patient_medicationrequest_r"
								name="patient_medicationrequest_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Observation</td>
							<td style="border:1px solid grey;"><input type="checkbox" id="patient_observation_r"
								name="patient_observation_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Patient</td>
							<td style="border:1px solid grey;"><input type="checkbox" id="patient_patient_r"
								name="patient_patient_r"> read</td>
						</tr>
						<tr>
							<td style="border:1px solid grey;">Procedure</td>
							<td style="border:1px solid grey;"><input type="checkbox" id="patient_procedure_r"
								name="patient_procedure_r"> read</td>
						</tr>
					</table></td>
			</tr>
		</table>
		<input type="submit" value="Create">
	</form>
	</p>
	<%
		} else {
	%>
	Unauthorized Access. <a href="${base_url}/smart/">Go to main page.</a>
	<%
		}
	%>
</body>
</html>