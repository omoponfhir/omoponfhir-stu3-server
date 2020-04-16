
<%
String clientId = (String) request.getAttribute("client_id");
String appType = (String) request.getAttribute("app_type");
String scope = (String) request.getAttribute("scope");
String fileName = (String) request.getAttribute("file_name");
boolean disableIt = "app_view.jsp".equalsIgnoreCase(request.getParameter("file_name"))?true:false;
%>

<script>
function is_user_read_all_checked () {
	if ($("#user_condition_r").is(":checked") 
			&& $("#user_documentreference_r").is(":checked") 
			&& $("#user_encounter_r").is(":checked")
			&& $("#user_medicationstatement_r").is(":checked") 
			&& $("#user_medicationrequest_r").is(":checked") 
			&& $("#user_observation_r").is(":checked") 
			&& $("#user_patient_r").is(":checked") 
			&& $("#user_procedure_r").is(":checked")) {
		return true;
	}
	
	return false;
}

function is_user_write_all_checked () {
	if ($("#user_condition_w").is(":checked") 
			&& $("#user_documentreference_w").is(":checked") 
			&& $("#user_encounter_w").is(":checked")
			&& $("#user_medicationstatement_w").is(":checked") 
			&& $("#user_medicationrequest_w").is(":checked") 
			&& $("#user_observation_w").is(":checked") 
			&& $("#user_patient_w").is(":checked") 
			&& $("#user_procedure_w").is(":checked")) {
		return true;
	}
	
	return false;
}

function is_patient_read_all_checked () {
	if ($("#patient_condition_r").is(":checked") 
			&& $("#patient_documentreference_r").is(":checked") 
			&& $("#patient_encounter_r").is(":checked")
			&& $("#patient_medicationstatement_r").is(":checked") 
			&& $("#patient_medicationrequest_r").is(":checked") 
			&& $("#patient_observation_r").is(":checked") 
			&& $("#patient_patient_r").is(":checked") 
			&& $("#patient_procedure_r").is(":checked")) {
		return true;
	}
	
	return false;
}

function is_patient_write_all_checked () {
	if ($("#patient_condition_w").is(":checked") 
			&& $("#patient_documentreference_w").is(":checked") 
			&& $("#patient_encounter_w").is(":checked")
			&& $("#patient_medicationstatement_w").is(":checked") 
			&& $("#patient_medicationrequest_w").is(":checked") 
			&& $("#patient_observation_w").is(":checked") 
			&& $("#patient_patient_w").is(":checked") 
			&& $("#patient_procedure_w").is(":checked")) {
		return true;
	}
	
	return false;
}

function remove_user_all_from_selected () {
	var scopes = $("#selected_scopes").val();
	
	scopes = scopes.replace(/system\/([a-zA-Z]+|\*)\.(read|write|\*)/g, "");		
	scopes = scopes.replace(/user\/([a-zA-Z]+|\*)\.(read|write|\*)/g, "");
	$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim());
}

function update_user_r (scopes) {
	var typeName = "user";
	if ($("#app_type_radio_system").is(":checked")) {
		typeName = "system";
	}
	
	if ($("#all_user_r").is(":checked")) {
		if ($("#all_user_w").is(":checked")) {
			scopes = scopes.replace(typeName+"/*.write", "");
			scopes = scopes.replace(typeName+"/*.read", "");
			scopes = scopes.replace(typeName+"/*.*", "");
			scopes += " "+typeName+"/*.*";
		} else {
			scopes += " "+typeName+"/*.read";
		}
		return scopes;
	}
	
	if ($("#user_condition_r").is(":checked")) {
		$("#user_condition_r").prop("checked", true);
		scopes += " "+typeName+"/Condition.read";
	} else {
		$("#user_condition_r").prop("checked", false); 
	}
	if ($("#user_documentreference_r").is(":checked")) {
		$("#user_documentreference_r").prop("checked", true); 
		scopes += " "+typeName+"/DocumentReference.read";
	} else {
		$("#user_documentreference_r").prop("checked", false); 
	}
	if ($("#user_encounter_r").is(":checked")) {
		$("#user_encounter_r").prop("checked", true); 
		scopes += " "+typeName+"/Encounter.read";
	} else {
		$("#user_encounter_r").prop("checked", false); 
	}
	if ($("#user_medicationstatement_r").is(":checked")) {
		$("#user_medicationstatement_r").prop("checked", true); 
		scopes += " "+typeName+"/MedicationStatement.read";
	} else {
		$("#user_medicationstatement_r").prop("checked", false); 
	}
	if ($("#user_medicationrequest_r").is(":checked")) {
		$("#user_medicationrequest_r").prop("checked", true); 
		scopes += " "+typeName+"/MedicationRequest.read";
	} else {
		$("#user_medicationrequest_r").prop("checked", false); 
	}
	if ($("#user_observation_r").is(":checked")) {
		$("#user_observation_r").prop("checked", true); 
		scopes += " "+typeName+"/Observation.read";
	} else {
		$("#user_observation_r").prop("checked", false); 
	}
	if ($("#user_patient_r").is(":checked")) {
		$("#user_patient_r").prop("checked", true); 
		scopes += " "+typeName+"/Patient.read";
	} else {
		$("#user_patient_r").prop("checked", false); 
	}
	if ($("#user_procedure_r").is(":checked")) {
		$("#user_procedure_r").prop("checked", true); 
		scopes += " "+typeName+"/Procedure.read";
	} else {
		$("#user_procedure_r").prop("checked", false); 
	}
	
	return scopes;
}

function update_user_w (scopes) {
	var typeName = "user";
	if ($("#app_type_radio_system").is(":checked")) {
		typeName = "system";
	}

	if ($("#all_user_w").is(":checked")) {
		if ($("#all_user_r").is(":checked")) {
			scopes = scopes.replace(typeName+"/*.read", "");
			scopes = scopes.replace(typeName+"/*.write", "");
			scopes = scopes.replace(typeName+"/*.*", "");
			scopes += " "+typeName+"/*.*";
		} else {
			scopes += " "+typeName+"/*.write";
		}
		return scopes;
	}

	if ($("#user_condition_w").is(":checked")) {
		$("#user_condition_w").prop("checked", true);
		scopes += " "+typeName+"/Condition.write";
	} else {
		$("#user_condition_w").prop("checked", false); 
	}
	if ($("#user_documentreference_w").is(":checked")) {
		$("#user_documentreference_w").prop("checked", true); 
		scopes += " "+typeName+"/DocumentReference.write";
	} else {
		$("#user_documentreference_w").prop("checked", false); 
	}
	if ($("#user_encounter_w").is(":checked")) {
		$("#user_encounter_w").prop("checked", true); 
		scopes += " "+typeName+"/Encounter.write";
	} else {
		$("#user_encounter_w").prop("checked", false); 
	}
	if ($("#user_medicationstatement_w").is(":checked")) {
		$("#user_medicationstatement_w").prop("checked", true); 
		scopes += " "+typeName+"/MedicationStatement.write";
	} else {
		$("#user_medicationstatement_w").prop("checked", false); 
	}
	if ($("#user_medicationrequest_w").is(":checked")) {
		$("#user_medicationrequest_w").prop("checked", true); 
		scopes += " "+typeName+"/MedicationRequest.write";
	} else {
		$("#user_medicationrequest_w").prop("checked", false); 
	}
	if ($("#user_observation_w").is(":checked")) {
		$("#user_observation_w").prop("checked", true); 
		scopes += " "+typeName+"/Observation.write";
	} else {
		$("#user_observation_w").prop("checked", false); 
	}
	if ($("#user_patient_w").is(":checked")) {
		$("#user_patient_w").prop("checked", true); 
		scopes += " "+typeName+"/Patient.write";
	} else {
		$("#user_patient_w").prop("checked", false); 
	}
	if ($("#user_procedure_w").is(":checked")) {
		$("#user_procedure_w").prop("checked", true); 
		scopes += " "+typeName+"/Procedure.write";
	} else {
		$("#user_procedure_w").prop("checked", false); 
	}
	
	return scopes;
}

// for patient scope
function remove_patient_all_from_selected () {
	var scopes = $("#selected_scopes").val();
	scopes = scopes.replace(/patient\/([a-zA-Z]+|\*)\.(read|write|\*)/g, "");
	$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim());
}

function update_patient_r (scopes) {
	if ($("#all_patient_r").is(":checked")) {
		scopes += " patient/*.read";
		return scopes;
	}
	
	if ($("#patient_condition_r").is(":checked")) {
		$("#patient_condition_r").prop("checked", true);
		scopes += " patient/Condition.read";
	} else {
		$("#patient_condition_r").prop("checked", false); 
	}
	if ($("#patient_documentreference_r").is(":checked")) {
		$("#patient_documentreference_r").prop("checked", true); 
		scopes += " patient/DocumentReference.read";
	} else {
		$("#patient_documentreference_r").prop("checked", false); 
	}
	if ($("#patient_encounter_r").is(":checked")) {
		$("#patient_encounter_r").prop("checked", true); 
		scopes += " patient/Encounter.read";
	} else {
		$("#patient_encounter_r").prop("checked", false); 
	}
	if ($("#patient_medicationstatement_r").is(":checked")) {
		$("#patient_medicationstatement_r").prop("checked", true); 
		scopes += " patient/MedicationStatement.read";
	} else {
		$("#patient_medicationstatement_r").prop("checked", false); 
	}
	if ($("#patient_medicationrequest_r").is(":checked")) {
		$("#patient_medicationrequest_r").prop("checked", true); 
		scopes += " patient/MedicationRequest.read";
	} else {
		$("#patient_medicationrequest_r").prop("checked", false); 
	}
	if ($("#patient_observation_r").is(":checked")) {
		$("#patient_observation_r").prop("checked", true); 
		scopes += " patient/Observation.read";
	} else {
		$("#patient_observation_r").prop("checked", false); 
	}
	if ($("#patient_patient_r").is(":checked")) {
		$("#patient_patient_r").prop("checked", true); 
		scopes += " patient/Patient.read";
	} else {
		$("#patient_patient_r").prop("checked", false); 
	}
	if ($("#patient_procedure_r").is(":checked")) {
		$("#patient_procedure_r").prop("checked", true); 
		scopes += " patient/Procedure.read";
	} else {
		$("#patient_procedure_r").prop("checked", false); 
	}
	
	return scopes;
}

function update_patient_w (scopes) {
	if ($("#all_patient_w").is(":checked")) {
		scopes += " patient/*.write";
		return scopes;
	}

	if ($("#patient_condition_w").is(":checked")) {
		$("#patient_condition_w").prop("checked", true);
		scopes += " patient/Condition.write";
	} else {
		$("#patient_condition_w").prop("checked", false); 
	}
	if ($("#patient_documentreference_w").is(":checked")) {
		$("#patient_documentreference_w").prop("checked", true); 
		scopes += " patient/DocumentReference.write";
	} else {
		$("#patient_documentreference_w").prop("checked", false); 
	}
	if ($("#patient_encounter_w").is(":checked")) {
		$("#patient_encounter_w").prop("checked", true); 
		scopes += " patient/Encounter.write";
	} else {
		$("#patient_encounter_w").prop("checked", false); 
	}
	if ($("#patient_medicationstatement_w").is(":checked")) {
		$("#patient_medicationstatement_w").prop("checked", true); 
		scopes += " patient/MedicationStatement.write";
	} else {
		$("#patient_medicationstatement_w").prop("checked", false); 
	}
	if ($("#patient_medicationrequest_w").is(":checked")) {
		$("#patient_medicationrequest_w").prop("checked", true); 
		scopes += " patient/MedicationRequest.write";
	} else {
		$("#patient_medicationrequest_w").prop("checked", false); 
	}
	if ($("#patient_observation_w").is(":checked")) {
		$("#patient_observation_w").prop("checked", true); 
		scopes += " patient/Observation.write";
	} else {
		$("#patient_observation_w").prop("checked", false); 
	}
	if ($("#patient_patient_w").is(":checked")) {
		$("#patient_patient_w").prop("checked", true); 
		scopes += " patient/Patient.write";
	} else {
		$("#patient_patient_w").prop("checked", false); 
	}
	if ($("#patient_procedure_w").is(":checked")) {
		$("#patient_procedure_w").prop("checked", true); 
		scopes += " patient/Procedure.write";
	} else {
		$("#patient_procedure_w").prop("checked", false); 
	}
	
	return scopes;
}

function init_selected_scopes() {
	remove_user_all_from_selected();
	remove_patient_all_from_selected();
	var scopes = $("#selected_scopes").val();
	
	scopes = update_user_r(scopes);
	scopes = update_user_w(scopes);
	scopes = update_patient_r(scopes);
	scopes = update_patient_w(scopes);
	
	$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim());	
}

function update_scope_table_from_scope(scopes) {
	var typeName = "user";
	if ($("#app_type_radio_system").is(":checked")) {
		typeName = "system";
	}

	if (scopes.includes(typeName+"/*.*")) {
		$("#all_user_r").prop("checked", true);
		$("#all_user_w").prop("checked", true);
	}

	if (scopes.includes(typeName+"/*.read")) {
		$("#all_user_r").prop("checked", true);
	}

	if (scopes.includes(typeName+"/*.write")) {
		$("#all_user_w").prop("checked", true);
	}

	if (scopes.includes("patient/*.*")) {
		$("#all_patient_r").prop("checked", true);
		$("#all_patient_w").prop("checked", true);
	}

	if (scopes.includes("patient/*.read")) {
		$("#all_patient_r").prop("checked", true);
	}

	if (scopes.includes("patient/*.write")) {
		$("#all_patient_w").prop("checked", true);
	}

	if (scopes.includes(typeName+"/Condition.read") 
			|| scopes.includes(typeName+"/Condition.*")) {
		$("#user_condition_r").prop("checked", true);
	}
	 
	if (scopes.includes(typeName+"/DocumentReference.read") 
			|| scopes.includes(typeName+"/DocumentReference.*")) {
		$("#user_documentreference_r").prop("checked", true);
	}
	
	if (scopes.includes(typeName+"/Encounter.read") 
			|| scopes.includes(typeName+"/Encounter.*")) {
		$("#user_encounter_r").prop("checked", true);
	}
	
	if (scopes.includes(typeName+"/MedicationStatement.read") 
			|| scopes.includes(typeName+"/MedicationStatement.*")) {
		$("#user_medicationstatement_r").prop("checked", true);
	}
	
	if (scopes.includes(typeName+"/MedicationRequest.read") 
			|| scopes.includes(typeName+"/MedicationRequest.*")) {
		$("#user_medicationrequest_r").prop("checked", true);
	}
	
	if (scopes.includes(typeName+"/Observation.read") 
			|| scopes.includes(typeName+"/Observation.*")) {
		$("#user_observation_r").prop("checked", true);
	}
	
	if (scopes.includes(typeName+"/Patient.read") 
			|| scopes.includes(typeName+"/Patient.*")) {
		$("#user_patient_r").prop("checked", true);
	}
	
	if (scopes.includes(typeName+"/Procedure.read") 
			|| scopes.includes(typeName+"/Procedure.*")) {
		$("#user_procedure_r").prop("checked", true);
	}
	
	if (scopes.includes(typeName+"/Condition.write") 
			|| scopes.includes(typeName+"/Condition.*")) {
		$("#user_condition_w").prop("checked", true);
	}
	 
	if (scopes.includes(typeName+"/DocumentReference.write") 
			|| scopes.includes(typeName+"/DocumentReference.*")) {
		$("#user_documentreference_w").prop("checked", true);
	}
	
	if (scopes.includes(typeName+"/Encounter.write") 
			|| scopes.includes(typeName+"/Encounter.*")) {
		$("#user_encounter_w").prop("checked", true);
	}
	
	if (scopes.includes(typeName+"/MedicationStatement.write") 
			|| scopes.includes(typeName+"/MedicationStatement.*")) {
		$("#user_medicationstatement_w").prop("checked", true);
	}
	
	if (scopes.includes(typeName+"/MedicationRequest.write") 
			|| scopes.includes(typeName+"/MedicationRequest.*")) {
		$("#user_medicationrequest_w").prop("checked", true);
	}
	
	if (scopes.includes(typeName+"/Observation.write") 
			|| scopes.includes(typeName+"/Observation.*")) {
		$("#user_observation_w").prop("checked", true);
	}
	
	if (scopes.includes(typeName+"/Patient.write") 
			|| scopes.includes(typeName+"/Patient.*")) {
		$("#user_patient_w").prop("checked", true);
	}
	
	if (scopes.includes(typeName+"/Procedure.write") 
			|| scopes.includes(typeName+"/Procedure.*")) {
		$("#user_procedure_w").prop("checked", true);
	}

	// for patient
	if (scopes.includes("patient/Condition.read") 
			|| scopes.includes("patient/Condition.*")) {
		$("#patient_condition_r").prop("checked", true);
	}
	
	if (scopes.includes("patient/DocumentReference.read") 
			|| scopes.includes("patient/DocumentReference.*")) {
		$("#patient_documentreference_r").prop("checked", true);
	}
	
	if (scopes.includes("patient/Encounter.read") 
			|| scopes.includes("patient/Encounter.*")) {
		$("#patient_encounter_r").prop("checked", true);
	}
	
	if (scopes.includes("patient/MedicationStatement.read") 
			|| scopes.includes("patient/MedicationStatement.*")) {
		$("#patient_medicationstatement_r").prop("checked", true);
	}
	
	if (scopes.includes("patient/MedicationRequest.read") 
			|| scopes.includes("patient/MedicationRequest.*")) {
		$("#patient_medicationrequest_r").prop("checked", true);
	}
	
	if (scopes.includes("patient/Observation.read") 
			|| scopes.includes("patient/Observation.*")) {
		$("#patient_observation_r").prop("checked", true);
	}
	
	if (scopes.includes("patient/Patient.read") 
			|| scopes.includes("patient/Patient.*")) {
		$("#patient_patient_r").prop("checked", true);
	}
	
	if (scopes.includes("patient/Procedure.read") 
			|| scopes.includes("patient/Procedure.*")) {
		$("#patient_procedure_r").prop("checked", true);
	}
	
	if (scopes.includes("patient/Condition.write") 
			|| scopes.includes("patient/Condition.*")) {
		$("#patient_condition_w").prop("checked", true);
	}
	
	if (scopes.includes("patient/DocumentReference.write") 
			|| scopes.includes("patient/DocumentReference.*")) {
		$("#patient_documentreference_w").prop("checked", true);
	}
	
	if (scopes.includes("patient/Encounter.write") 
			|| scopes.includes("patient/Encounter.*")) {
		$("#patient_encounter_w").prop("checked", true);
	}
	
	if (scopes.includes("patient/MedicationStatement.write") 
			|| scopes.includes("patient/MedicationStatement.*")) {
		$("#patient_medicationstatement_w").prop("checked", true);
	}
	
	if (scopes.includes("patient/MedicationRequest.write") 
			|| scopes.includes("patient/MedicationRequest.*")) {
		$("#patient_medicationrequest_w").prop("checked", true);
	}
	
	if (scopes.includes("patient/Observation.write") 
			|| scopes.includes("patient/Observation.*")) {
		$("#patient_observation_w").prop("checked", true);
	}
	
	if (scopes.includes("patient/Patient.write")) {
		$("#patient_patient_w").prop("checked", true);
	}
	
	if (scopes.includes("patient/Procedure.write")) {
		$("#patient_procedure_w").prop("checked", true);
	}

}

$(document).ready(function() {
	// update scope tables with scope parameter.
	update_scope_table_from_scope("<%=scope%>");
	
	$( function() {
	    $( "input[type='checkbox']" ).checkboxradio({
	      icon: false
	    });
	});
	
	$( function() {
	    $( "input[type='radio']" ).checkboxradio({
	      icon: false
	    });
	});
	
	// init for first load.
	init_selected_scopes();
	
	// follows are for app type changes.
	$("input[id^='app_type_radio_']").change(function() {
		init_selected_scopes();
		
		if ($("#app_type_radio_system").is(":checked")) {
			var scopes = $("#selected_scopes").val();
			scopes = scopes.replace(/patient\/([a-zA-Z]+|\*)\.(read|write|\*)/g, "");
			scopes = scopes.replace("user", "system");
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim());
		} else {
			var scopes = $("#selected_scopes").val();
			scopes = scopes.replace(/system\/([a-zA-Z]+|\*)\.(read|write|\*)/g, "");
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim());
		}
	});
	
	$("#all_user_r").change(function() {
		var typeName = "user";
		if ($("#app_type_radio_system").is(":checked")) {
			typeName = "system";
		}

		remove_user_all_from_selected();
		var scopes  = $("#selected_scopes").val();

		if ($("#all_user_r").is(":checked") && $("#all_user_w").is(":checked")) {
			$("#user_condition_r").prop("checked", true); 
			$("#user_documentreference_r").prop("checked", true); 
			$("#user_encounter_r").prop("checked", true);
			$("#user_medicationstatement_r").prop("checked", true); 
			$("#user_medicationrequest_r").prop("checked", true); 
			$("#user_observation_r").prop("checked", true); 
			$("#user_patient_r").prop("checked", true); 
			$("#user_procedure_r").prop("checked", true);

			$("#user_condition_w").prop("checked", true); 
			$("#user_documentreference_w").prop("checked", true); 
			$("#user_encounter_w").prop("checked", true);
			$("#user_medicationstatement_w").prop("checked", true); 
			$("#user_medicationrequest_w").prop("checked", true); 
			$("#user_observation_w").prop("checked", true); 
			$("#user_patient_w").prop("checked", true); 
			$("#user_procedure_w").prop("checked", true);

			scopes += " "+typeName+"/*.*";
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
			
			$("input[type='checkbox']").checkboxradio("refresh");

			return;			
		}
		
		if ($("#all_user_r").is(":checked")) {
			$("#user_condition_r").prop("checked", true); 
			$("#user_documentreference_r").prop("checked", true); 
			$("#user_encounter_r").prop("checked", true);
			$("#user_medicationstatement_r").prop("checked", true); 
			$("#user_medicationrequest_r").prop("checked", true); 
			$("#user_observation_r").prop("checked", true); 
			$("#user_patient_r").prop("checked", true); 
			$("#user_procedure_r").prop("checked", true);

			scopes += " "+typeName+"/*.read";
		} else {
			$("#user_condition_r").prop("checked", false); 
			$("#user_documentreference_r").prop("checked", false); 
			$("#user_encounter_r").prop("checked", false);
			$("#user_medicationstatement_r").prop("checked", false); 
			$("#user_medicationrequest_r").prop("checked", false); 
			$("#user_observation_r").prop("checked", false); 
			$("#user_patient_r").prop("checked", false); 
			$("#user_procedure_r").prop("checked", false);
		}
		
		scopes = update_user_w(scopes);

		$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
		
		$("input[type='checkbox']").checkboxradio("refresh");
	});

	$("#all_user_w").change(function() {
		var typeName = "user";
		if ($("#app_type_radio_system").is(":checked")) {
			typeName = "system";
		}

		remove_user_all_from_selected();
		var scopes  = $("#selected_scopes").val();

		if ($("#all_user_r").is(":checked") && $("#all_user_w").is(":checked")) {
			$("#user_condition_r").prop("checked", true); 
			$("#user_documentreference_r").prop("checked", true); 
			$("#user_encounter_r").prop("checked", true);
			$("#user_medicationstatement_r").prop("checked", true); 
			$("#user_medicationrequest_r").prop("checked", true); 
			$("#user_observation_r").prop("checked", true); 
			$("#user_patient_r").prop("checked", true); 
			$("#user_procedure_r").prop("checked", true);

			$("#user_condition_w").prop("checked", true); 
			$("#user_documentreference_w").prop("checked", true); 
			$("#user_encounter_w").prop("checked", true);
			$("#user_medicationstatement_w").prop("checked", true); 
			$("#user_medicationrequest_w").prop("checked", true); 
			$("#user_observation_w").prop("checked", true); 
			$("#user_patient_w").prop("checked", true); 
			$("#user_procedure_w").prop("checked", true);

			scopes += " "+typeName+"/*.*";
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
			
			$("input[type='checkbox']").checkboxradio("refresh");

			return;			
		}
		
		if ($("#all_user_w").is(":checked")) {
			$("#user_condition_w").prop("checked", true); 
			$("#user_documentreference_w").prop("checked", true); 
			$("#user_encounter_w").prop("checked", true);
			$("#user_medicationstatement_w").prop("checked", true); 
			$("#user_medicationrequest_w").prop("checked", true); 
			$("#user_observation_w").prop("checked", true); 
			$("#user_patient_w").prop("checked", true); 
			$("#user_procedure_w").prop("checked", true);
			
			scopes += " "+typeName+"/*.write";
		} else {
			$("#user_condition_w").prop("checked", false); 
			$("#user_documentreference_w").prop("checked", false); 
			$("#user_encounter_w").prop("checked", false);
			$("#user_medicationstatement_w").prop("checked", false); 
			$("#user_medicationrequest_w").prop("checked", false); 
			$("#user_observation_w").prop("checked", false); 
			$("#user_patient_w").prop("checked", false); 
			$("#user_procedure_w").prop("checked", false);
		}
		
		scopes = update_user_r(scopes);

		$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
		
		$("input[type='checkbox']").checkboxradio("refresh");
	});
	
	$("input[id^='user_']").change(function() {
		var typeName = "user";
		if ($("#app_type_radio_system").is(":checked")) {
			typeName = "system";
		}

		remove_user_all_from_selected();
		var scopes  = $("#selected_scopes").val();
		
		if ($("#all_user_r").is(":checked") && $("#all_user_w").is(":checked")) {
			$("#user_condition_r").prop("checked", true); 
			$("#user_documentreference_r").prop("checked", true); 
			$("#user_encounter_r").prop("checked", true);
			$("#user_medicationstatement_r").prop("checked", true); 
			$("#user_medicationrequest_r").prop("checked", true); 
			$("#user_observation_r").prop("checked", true); 
			$("#user_patient_r").prop("checked", true); 
			$("#user_procedure_r").prop("checked", true);

			$("#user_condition_w").prop("checked", true); 
			$("#user_documentreference_w").prop("checked", true); 
			$("#user_encounter_w").prop("checked", true);
			$("#user_medicationstatement_w").prop("checked", true); 
			$("#user_medicationrequest_w").prop("checked", true); 
			$("#user_observation_w").prop("checked", true); 
			$("#user_patient_w").prop("checked", true); 
			$("#user_procedure_w").prop("checked", true);

			scopes += " "+typeName+"/*.*";
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
			
			$("input[type='checkbox']").checkboxradio("refresh");

			return;			
		}

		if ($("#all_user_r").is(":checked")) {
			$("#user_condition_r").prop("checked", true); 
			$("#user_documentreference_r").prop("checked", true); 
			$("#user_encounter_r").prop("checked", true);
			$("#user_medicationstatement_r").prop("checked", true); 
			$("#user_medicationrequest_r").prop("checked", true); 
			$("#user_observation_r").prop("checked", true); 
			$("#user_patient_r").prop("checked", true); 
			$("#user_procedure_r").prop("checked", true);

			scopes += " "+typeName+"/*.read";
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
		} else {
			scopes = update_user_r(scopes);
			
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
		}
		
		if ($("#all_user_w").is(":checked")) {
			$("#user_condition_w").prop("checked", true); 
			$("#user_documentreference_w").prop("checked", true); 
			$("#user_encounter_w").prop("checked", true);
			$("#user_medicationstatement_w").prop("checked", true); 
			$("#user_medicationrequest_w").prop("checked", true); 
			$("#user_observation_w").prop("checked", true); 
			$("#user_patient_w").prop("checked", true); 
			$("#user_procedure_w").prop("checked", true);
			
			scopes += " "+typeName+"/*.write";
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
		} else {
			scopes = update_user_w(scopes);
			
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
		}
		
		$("input[type='checkbox']").checkboxradio("refresh");

	});
	
	// for patient scopes
	$("#all_patient_r").change(function() {
		remove_patient_all_from_selected();
		var scopes  = $("#selected_scopes").val();

		if ($("#all_patient_r").is(":checked") && $("#all_patient_w").is(":checked")) {
			$("#patient_condition_r").prop("checked", true); 
			$("#patient_documentreference_r").prop("checked", true); 
			$("#patient_encounter_r").prop("checked", true);
			$("#patient_medicationstatement_r").prop("checked", true); 
			$("#patient_medicationrequest_r").prop("checked", true); 
			$("#patient_observation_r").prop("checked", true); 
			$("#patient_patient_r").prop("checked", true); 
			$("#patient_procedure_r").prop("checked", true);

			$("#patient_condition_w").prop("checked", true); 
			$("#patient_documentreference_w").prop("checked", true); 
			$("#patient_encounter_w").prop("checked", true);
			$("#patient_medicationstatement_w").prop("checked", true); 
			$("#patient_medicationrequest_w").prop("checked", true); 
			$("#patient_observation_w").prop("checked", true); 
			$("#patient_patient_w").prop("checked", true); 
			$("#patient_procedure_w").prop("checked", true);

			scopes += " patient/*.*";
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
			
			$("input[type='checkbox']").checkboxradio("refresh");

			return;			
		}
		
		if ($("#all_patient_r").is(":checked")) {
			$("#patient_condition_r").prop("checked", true); 
			$("#patient_documentreference_r").prop("checked", true); 
			$("#patient_encounter_r").prop("checked", true);
			$("#patient_medicationstatement_r").prop("checked", true); 
			$("#patient_medicationrequest_r").prop("checked", true); 
			$("#patient_observation_r").prop("checked", true); 
			$("#patient_patient_r").prop("checked", true); 
			$("#patient_procedure_r").prop("checked", true);

			scopes += " patient/*.read";
		} else {
			$("#patient_condition_r").prop("checked", false); 
			$("#patient_documentreference_r").prop("checked", false); 
			$("#patient_encounter_r").prop("checked", false);
			$("#patient_medicationstatement_r").prop("checked", false); 
			$("#patient_medicationrequest_r").prop("checked", false); 
			$("#patient_observation_r").prop("checked", false); 
			$("#patient_patient_r").prop("checked", false); 
			$("#patient_procedure_r").prop("checked", false);
		}
		
		scopes = update_patient_w(scopes);

		$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
		
		$("input[type='checkbox']").checkboxradio("refresh");
	});

	$("#all_patient_w").change(function() {
		remove_patient_all_from_selected();
		var scopes  = $("#selected_scopes").val();

		if ($("#all_patient_r").is(":checked") && $("#all_patient_w").is(":checked")) {
			$("#patient_condition_r").prop("checked", true); 
			$("#patient_documentreference_r").prop("checked", true); 
			$("#patient_encounter_r").prop("checked", true);
			$("#patient_medicationstatement_r").prop("checked", true); 
			$("#patient_medicationrequest_r").prop("checked", true); 
			$("#patient_observation_r").prop("checked", true); 
			$("#patient_patient_r").prop("checked", true); 
			$("#patient_procedure_r").prop("checked", true);

			$("#patient_condition_w").prop("checked", true); 
			$("#patient_documentreference_w").prop("checked", true); 
			$("#patient_encounter_w").prop("checked", true);
			$("#patient_medicationstatement_w").prop("checked", true); 
			$("#patient_medicationrequest_w").prop("checked", true); 
			$("#patient_observation_w").prop("checked", true); 
			$("#patient_patient_w").prop("checked", true); 
			$("#patient_procedure_w").prop("checked", true);

			scopes += " patient/*.*";
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
			
			$("input[type='checkbox']").checkboxradio("refresh");

			return;			
		}
		
		if ($("#all_patient_w").is(":checked")) {
			$("#patient_condition_w").prop("checked", true); 
			$("#patient_documentreference_w").prop("checked", true); 
			$("#patient_encounter_w").prop("checked", true);
			$("#patient_medicationstatement_w").prop("checked", true); 
			$("#patient_medicationrequest_w").prop("checked", true); 
			$("#patient_observation_w").prop("checked", true); 
			$("#patient_patient_w").prop("checked", true); 
			$("#patient_procedure_w").prop("checked", true);
			
			scopes += " patient/*.write";
		} else {
			$("#patient_condition_w").prop("checked", false); 
			$("#patient_documentreference_w").prop("checked", false); 
			$("#patient_encounter_w").prop("checked", false);
			$("#patient_medicationstatement_w").prop("checked", false); 
			$("#patient_medicationrequest_w").prop("checked", false); 
			$("#patient_observation_w").prop("checked", false); 
			$("#patient_patient_w").prop("checked", false); 
			$("#patient_procedure_w").prop("checked", false);
		}
		
		scopes = update_patient_r(scopes);

		$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
		
		$("input[type='checkbox']").checkboxradio("refresh");
	});
	
	$("input[id^='patient_']").change(function() {
		remove_patient_all_from_selected();
		var scopes  = $("#selected_scopes").val();
		
		if ($("#all_patient_r").is(":checked") && $("#all_patient_w").is(":checked")) {
			$("#patient_condition_r").prop("checked", true); 
			$("#patient_documentreference_r").prop("checked", true); 
			$("#patient_encounter_r").prop("checked", true);
			$("#patient_medicationstatement_r").prop("checked", true); 
			$("#patient_medicationrequest_r").prop("checked", true); 
			$("#patient_observation_r").prop("checked", true); 
			$("#patient_patient_r").prop("checked", true); 
			$("#patient_procedure_r").prop("checked", true);

			$("#patient_condition_w").prop("checked", true); 
			$("#patient_documentreference_w").prop("checked", true); 
			$("#patient_encounter_w").prop("checked", true);
			$("#patient_medicationstatement_w").prop("checked", true); 
			$("#patient_medicationrequest_w").prop("checked", true); 
			$("#patient_observation_w").prop("checked", true); 
			$("#patient_patient_w").prop("checked", true); 
			$("#patient_procedure_w").prop("checked", true);

			scopes += " patient/*.*";
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
			
			$("input[type='checkbox']").checkboxradio("refresh");

			return;			
		}

		if ($("#all_patient_r").is(":checked")) {
			$("#patient_condition_r").prop("checked", true); 
			$("#patient_documentreference_r").prop("checked", true); 
			$("#patient_encounter_r").prop("checked", true);
			$("#patient_medicationstatement_r").prop("checked", true); 
			$("#patient_medicationrequest_r").prop("checked", true); 
			$("#patient_observation_r").prop("checked", true); 
			$("#patient_patient_r").prop("checked", true); 
			$("#patient_procedure_r").prop("checked", true);

			scopes += " patient/*.read";
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
		} else {
			scopes = update_patient_r(scopes);
			
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
		}
		
		if ($("#all_patient_w").is(":checked")) {
			$("#patient_condition_w").prop("checked", true); 
			$("#patient_documentreference_w").prop("checked", true); 
			$("#patient_encounter_w").prop("checked", true);
			$("#patient_medicationstatement_w").prop("checked", true); 
			$("#patient_medicationrequest_w").prop("checked", true); 
			$("#patient_observation_w").prop("checked", true); 
			$("#patient_patient_w").prop("checked", true); 
			$("#patient_procedure_w").prop("checked", true);
			
			scopes += " patient/*.write";
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
		} else {
			scopes = update_patient_w(scopes);
			
			$("#selected_scopes").val(scopes.replace(/\s+/g,' ').trim())
		}
		
		$("input[type='checkbox']").checkboxradio("refresh");

	});
	
});
</script>

<b>Selected Scopes</b><br/>
<textarea id="selected_scopes" name="selected_scopes" class="text ui-widget-content ui-corner-all" style="width: 70%;" rows="7" readonly></textarea>

<table style="border:0; width: 70%;">
	<tr>
		<th id="user_or_system_scope_head">
			Scope
		</th>
		<th id="patient_scope_head">Patient Scopes</th>
	</tr>
	<tr>
		<td valign="top">
			<table style="width: 100%; border: 1px solid grey; border-collapse: collapse;">
				<tr>
					<td style="border: 1px solid grey; padding: 5px;"><b><i>All Resources</i></b></td>
					<td style="border: 1px solid grey; padding: 5px;">
						<label for="all_user_r">read
							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="all_user_r" name="all_user_r" > 
						</label>
						<label for="all_user_w">write
							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="all_user_w" name="all_user_w" >
						</label>
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid grey; padding: 5px;">Condition</td>
					<td style="border: 1px solid grey; padding: 5px;">
						<label for="user_condition_r">read
							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_condition_r" name="user_condition_r" > 
						</label>
						<label for="user_condition_w">write
							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_condition_w" name="user_condition_w" >
						</label>
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid grey; padding: 5px;">DocumentReference</td>
					<td style="border: 1px solid grey; padding: 5px;">
						<label for="user_documentreference_r">read
							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_documentreference_r" name="user_documentreference_r" >
						</label>
						<label for="user_documentreference_w">write
 							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_documentreference_w" name="user_documentreference_w" >
 						</label>
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid grey; padding: 5px;">Encounter</td>
					<td style="border: 1px solid grey; padding: 5px;">
						<label for="user_encounter_r">read
							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_encounter_r" name="user_encounter_r" >  
						</label>
 						<label for="user_encounter_w">write	
 							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_encounter_w" name="user_encounter_w" >
 						</label>
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid grey; padding: 5px;">MedicationStatement</td>
					<td style="border: 1px solid grey; padding: 5px;">
						<label for="user_medicationstatement_r">read
							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_medicationstatement_r" name="user_medicationstatement_r" >
						</label>
 						<label for="user_medicationstatement_w"> write
 							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_medicationstatement_w" name="user_medicationstatement_w" >
 						</label>
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid grey; padding: 5px;">MedicationRequest</td>
					<td style="border: 1px solid grey; padding: 5px;">
						<label for="user_medicationrequest_r">read
							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_medicationrequest_r" name="user_medicationrequest_r" > 
						</label>
 						<label for="user_medicationrequest_w"> write
 							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_medicationrequest_w" name="user_medicationrequest_w" >
 						</label>
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid grey; padding: 5px;">Observation</td>
					<td style="border: 1px solid grey; padding: 5px;">
						<label for="user_observation_r">read
							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_observation_r" name="user_observation_r" >
						</label> 
 						<label for="user_observation_w">write
 							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_observation_w" name="user_observation_w" > 
 						</label>
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid grey; padding: 5px;">Patient</td>
					<td style="border: 1px solid grey; padding: 5px;">
						<label for="user_patient_r">read
							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_patient_r" name="user_patient_r" >
						</label>
 						<label for="user_patient_w">write
 							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_patient_w" name="user_patient_w" >
 						</label>
					</td>
				</tr>
				<tr>
					<td style="border: 1px solid grey; padding: 5px;">Procedure</td>
					<td style="border: 1px solid grey; padding: 5px;">
						<label for="user_procedure_r">read
							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_procedure_r" name="user_procedure_r" > 
						</label>
 						<label for="user_procedure_w">write
 							<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="user_procedure_w" name="user_procedure_w" >
 						</label>
					</td>
				</tr>
			</table>
	</td>
	<td valign="top" id="patient_scope_content">
		<table style="width: 100%; padding: 2px; border: 1px solid grey; border-collapse: collapse;">
			<tr>
				<td style="border: 1px solid grey; padding: 5px;"><b><i>All Resource</i></b></td>
				<td style="border: 1px solid grey; padding: 5px;">
					<label for="all_patient_r">read
						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="all_patient_r" name="all_patient_r" > 
					</label>
					<label for="all_patient_w">write
						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="all_patient_w" name="all_patient_w" >
					</label>
				</td>
			</tr>
			<tr>
				<td style="border: 1px solid grey; padding: 5px;">Condition</td>
				<td style="border: 1px solid grey; padding: 5px;">
					<label for="patient_condition_r">read 
						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_condition_r" name="patient_condition_r" >
					</label>
 					<label for="patient_condition_w">write
 						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_condition_w" name="patient_condition_w" >
 					</label>
				</td>
			</tr>
			<tr>
				<td style="border: 1px solid grey; padding: 5px;">DocumentReference</td>
				<td style="border: 1px solid grey; padding: 5px;">
					<label for="patient_documentreference_r">read
						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_documentreference_r" name="patient_documentreference_r" > 
					</label>
					<label for="patient_documentreference_w">write
 						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_documentreference_w" name="patient_documentreference_w" >
 					</label>
				</td>
			</tr>
			<tr>
				<td style="border: 1px solid grey; padding: 5px;">Encounter</td>
				<td style="border: 1px solid grey; padding: 5px;">
					<label for="patient_encounter_r">read
						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_encounter_r" name="patient_encounter_r" >
					</label>
 					<label for="patient_encounter_w">write
 						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_encounter_w" name="patient_encounter_w" >
 					</label>
				</td>
			</tr>
			<tr>
				<td style="border: 1px solid grey; padding: 5px;">MedicationStatement</td>
				<td style="border: 1px solid grey; padding: 5px;">
					<label for="patient_medicationstatement_r">read
						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_medicationstatement_r" name="patient_medicationstatement_r" > 
					</label>
 					<label for="patient_medicationstatement_w">write
 						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_medicationstatement_w" name="patient_medicationstatement_w" >
 					</label>
				</td>
			</tr>
			<tr>
				<td style="border: 1px solid grey; padding: 5px;">MedicationRequest</td>
				<td style="border: 1px solid grey; padding: 5px;">
					<label for="patient_medicationrequest_r">read
						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_medicationrequest_r" name="patient_medicationrequest_r" >
					</label>
 					<label for="patient_medicationrequest_w">write
 						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_medicationrequest_w" name="patient_medicationrequest_w" >
 					</label>
				</td>
			</tr>
			<tr>
				<td style="border: 1px solid grey; padding: 5px;">Observation</td>
				<td style="border: 1px solid grey; padding: 5px;">
					<label for="patient_observation_r">read
						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_observation_r" name="patient_observation_r" >
					</label>
 					<label for="patient_observation_w">write
 						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_observation_w" name="patient_observation_w" >
 					</label>
				</td>
			</tr>
			<tr>
				<td style="border: 1px solid grey; padding: 5px;">Patient</td>
				<td style="border: 1px solid grey; padding: 5px;">
					<label for="patient_patient_r">read
						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_patient_r" name="patient_patient_r" >
					</label>
 					<label for="patient_patient_w">write
 						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_patient_w" name="patient_patient_w" >
 					</label>
				</td>
			</tr>
			<tr>
				<td style="border: 1px solid grey; padding: 5px;">Procedure</td>
				<td style="border: 1px solid grey; padding: 5px;">
					<label for="patient_procedure_r">read
						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_procedure_r" name="patient_procedure_r" >
					</label>
 					<label for="patient_procedure_w">write
 						<input <%if (disableIt) {out.print("disabled");} %> type="checkbox" id="patient_procedure_w" name="patient_procedure_w" >
 					</label>
				</td>
			</tr>
		</table>
	</td>
	</tr>
</table>
