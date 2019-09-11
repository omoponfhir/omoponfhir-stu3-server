/*******************************************************************************
 * Copyright (c) 2019 Georgia Tech Research Institute
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *******************************************************************************/
package edu.gatech.chai.omoponfhir.smart.servlet;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.security.SecureRandom;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.crypto.spec.SecretKeySpec;
//import javax.servlet.annotation.WebServlet;
import javax.xml.bind.DatatypeConverter;

import org.apache.commons.codec.binary.Base64;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.ModelAndView;

import edu.gatech.chai.omoponfhir.smart.dao.SmartOnFhirAppImpl;
import edu.gatech.chai.omoponfhir.smart.dao.SmartOnFhirSessionImpl;
import edu.gatech.chai.omoponfhir.smart.model.SmartOnFhirAppEntry;
import edu.gatech.chai.omoponfhir.smart.model.SmartOnFhirAppListContainer;
import edu.gatech.chai.omoponfhir.smart.model.SmartOnFhirSessionEntry;
import io.jsonwebtoken.Header;
import io.jsonwebtoken.JwtBuilder;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

/**
 * auth/ implementation for SMART on FHIR support for authentication
 * 
 */

@Controller
@SessionAttributes("oauth2attr")
public class SmartAuthServicesController {
	private static final long serialVersionUID = 1L;
	final static Logger logger = LoggerFactory.getLogger(SmartAuthServicesController.class);

	private String client_id;
	private String client_secret;
	private String jwtSecret;
	private String smartStyleUrl;
	private boolean simEhr;

	private String baseUrl = "";

	@Autowired
	protected SmartOnFhirAppImpl smartOnFhirApp;

	@Autowired
	protected SmartOnFhirSessionImpl smartOnFhirSession;

	public static final int timeout_min = 5;

	public SmartAuthServicesController() {
		super();

		String serverBaseUrl = System.getenv("SERVERBASE_URL");
		if (serverBaseUrl != null && !serverBaseUrl.isEmpty()) {
			if (serverBaseUrl.endsWith("/")) {
				serverBaseUrl = serverBaseUrl.substring(0, serverBaseUrl.length() - 2);
			}

			int lastSlashIndex = serverBaseUrl.lastIndexOf("/");
			if (lastSlashIndex > 0) {
				baseUrl = serverBaseUrl.substring(0, lastSlashIndex);
			}
		}

		client_id = System.getenv("SMART_CLIENTID");
		client_secret = System.getenv("SMART_CLIENTSECRET");

		if (client_id == null)
			client_id = "client_id";
		if (client_secret == null)
			client_secret = "client_secret";

		jwtSecret = System.getenv("JWT_SECRET");
		if (jwtSecret == null) {
			jwtSecret = "thisismysecret";
		}

		smartStyleUrl = System.getenv("SMART_STYLE_URL");
		if (smartStyleUrl == null) {
			smartStyleUrl = "http://localhost/smart-style.json";
		}

		simEhr = false;
	}

//	@ModelAttribute("oauth2attr")
//	public JSONObject oauth2attr() {
//		return new JSONObject();
//	}

	private JSONObject decodeJWT(String jwtToken) {
		String[] jwtSplitted = jwtToken.split("\\.");

		String jwtBodyBase64 = jwtSplitted[1];
		String jwtBody = new String(Base64.decodeBase64(jwtBodyBase64));

		return new JSONObject(jwtBody);
	}

	private String getPatientIdFromJWT(String code) {
		JSONObject jwtBodyJson = decodeJWT(code);
		if (jwtBodyJson.has("context")) {
			JSONObject context = jwtBodyJson.getJSONObject("context");
			if (context.has("patient")) {
				return context.getString("patient");
			}
		}

		return null;
	}

	private String getPatientFromLaunchContext(String launchContext) {
		if (launchContext == null || launchContext.isEmpty()) {
			return null;
		}

		String launchCode = new String(Base64.decodeBase64(launchContext));
		logger.debug("Launch Code:" + launchCode);

		// decode the code.
		JSONObject codeJson = new JSONObject(launchCode);
		JSONObject decodedCode = SmartLauncherCodec.decode(codeJson);
		if (decodedCode.has("patient")) {
			return decodedCode.getString("patient");
		}

		return null;
	}

	private String generateJWT(String launchContext, String scope, SmartOnFhirAppEntry smartApp) {
		SignatureAlgorithm signatureAlgorithm = SignatureAlgorithm.HS256;

		long nowMillis = System.currentTimeMillis();
		Date now = new Date(nowMillis);
		Date expiration = new Date(nowMillis + 300000); // 5m later

		byte[] apiKeySecretBytes = DatatypeConverter.parseBase64Binary(jwtSecret);
		Key signingKey = new SecretKeySpec(apiKeySecretBytes, signatureAlgorithm.getJcaName());

		JSONObject payload = new JSONObject();
		JSONObject context = new JSONObject();
		context.put("need_patient_banner", !simEhr);
		context.put("smart_style_url", smartStyleUrl);

		String patientId = getPatientFromLaunchContext(launchContext);
		if (patientId != null && !patientId.isEmpty())
			context.put("patient", patientId);

		payload.put("context", context);
		payload.put("client_id", smartApp.getAppId());
		payload.put("scope", scope);
		payload.put("iat", now.getTime() / 1000);
		payload.put("exp", expiration.getTime() / 1000);

		JwtBuilder jwtBuilder = Jwts.builder().setHeaderParam(Header.TYPE, Header.JWT_TYPE)
				.setPayload(payload.toString()).signWith(signatureAlgorithm, signingKey);
		return jwtBuilder.compact();
	}

	private String encodeValue(String value) throws UnsupportedEncodingException {
		return URLEncoder.encode(value, StandardCharsets.UTF_8.toString());
	}

	@GetMapping(value = "/authorize")
	public ModelAndView authorize(@RequestParam(name = "launch", required = false) String launchContext,
			@RequestParam(name = "response_type", required = false) String responseType,
			@RequestParam(name = "client_id", required = false) String clientId,
			@RequestParam(name = "redirect_uri", required = true) String redirectUri,
			@RequestParam(name = "scope", required = false) String scope,
			@RequestParam(name = "aud", required = false) String aud,
			@RequestParam(name = "state", required = false) String state, ModelMap model) {

		String errorDesc;
		String error;

		// Alway pass this information so that JSP can route to correct endpoint
		model.addAttribute("base_url", baseUrl);

		SmartOnFhirAppEntry smartApp = smartOnFhirApp.getSmartOnFhirApp(clientId);
		if (smartApp == null) {
			// Invalid client-id. We shour send with bad request.
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid client_id");
		}

		if (!redirectUri.equals(smartApp.getRedirectUri())) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid redirect_url");
		}

		if (responseType == null || !"code".equals(responseType)) {
			try {
				error = "unsupported_response_type";
				errorDesc = encodeValue(
						"The authorization server does not support obtaining an authorization code using this method");
				model.addAttribute("error", error);
				model.addAttribute("error_description", errorDesc);
				model.addAttribute("state", state);
				return new ModelAndView("redirect:" + redirectUri, model);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
				throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Internal Error", e);
			}
		}

		// We should use the client Id and check the scope to decide if
		// we want to authenticate this app request.
		// But, for now, we authenticate this.
		// TODO: connect to Authenticate server to authenticate the app.
		// One idea is to use Google or Facebook.
		//
		// For now, we expect the public app. client_id is required.
		// http://www.hl7.org/fhir/smart-app-launch/#step-3-app-exchanges-authorization-code-for-access-token

		// scope check. We need to make sure if this app has these scopes registered.
		// But, for this simulation, we allow everything.
		// If scope has launch, it should have launchContext as it's launched from EHR
		// If scope has launch/patient, then we need to run patient browser
		// If scope has launch/encounter, then we need to run encounter browser
		if (scope == null || scope.isEmpty()) {
			try {
				error = "invalid_scope";
				errorDesc = encodeValue("The requested scope is invalid, unknown, or malformed");
				model.addAttribute("error", error);
				model.addAttribute("error_description", errorDesc);
				model.addAttribute("state", state);
				return new ModelAndView("redirect:" + redirectUri, model);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
				throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Internal Error", e);
			}
		}

		if (scope.contains("launch") && launchContext == null) {
			try {
				error = "invalid_request";
				errorDesc = encodeValue(
						"The request is missing a required parameter, includes an invalid parameter value, includes a parameter more than once, or is otherwise malformed");
				model.addAttribute("error", error);
				model.addAttribute("error_description", errorDesc);
				model.addAttribute("state", state);
				return new ModelAndView("redirect:" + redirectUri, model);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
				throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Internal Error", e);
			}
		}

		// Check the scope.
		String[] scopeEntries = scope.split(" ");
		String myScope = smartApp.getScope();
		for (String scopeEntry : scopeEntries) {
			if (!myScope.contains(scopeEntry)) {
				// Out of scope
				try {
					logger.info("scope, " + scopeEntry + ", is not valid");
					error = "invalid_scope";
					errorDesc = encodeValue("The requested scope is invalid, unknown, or malformed");
					model.addAttribute("error", error);
					model.addAttribute("error_description", errorDesc);
					model.addAttribute("state", state);
					return new ModelAndView("redirect:" + redirectUri, model);
				} catch (UnsupportedEncodingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Internal Error", e);
				}
			}
		}

		// The launchContext, if exists, contains a context to resolve this to
		// patient, encounter, provider, etc. We used the encoding that smart on fhir
		// launcher is using.
		if (launchContext != null && !launchContext.isEmpty()) {
			String launchCode = new String(Base64.decodeBase64(launchContext));
			logger.debug("Launch Code:" + launchCode);

			// decode the code.
			JSONObject codeJson = new JSONObject(launchCode);
			JSONObject decodedCode = SmartLauncherCodec.decode(codeJson);
			if (decodedCode.has("launch_ehr") && "1".equals(decodedCode.getString("launch_ehr"))) {
				// We are launching in EHR mode.
				// Do something here if you need to do anything
			}

			if (decodedCode.has("sim_ehr") && "1".equals(decodedCode.getString("sim_ehr"))) {
				simEhr = true;

				// We are simulating EHR.
				if (decodedCode.has("auth_error")) {
					// Auth error simulation is requested.
					// Return error as requested.
					error = decodedCode.getString("auth_error");
					errorDesc = SmartLauncherCodec.getSimErrorDesc(error);
					model.addAttribute("error", error);
					model.addAttribute("error_description", errorDesc);
					model.addAttribute("state", state);
					return new ModelAndView("redirect:" + redirectUri, model);
				}
			}
//
//			patientId = decodedCode.getString("patient");
		} else {
			// TODO: Handle patient choose
		}

		// redirect to authentication page.
		model.addAttribute("auth_request_validated", true);
		model.addAttribute("launch", launchContext);
		model.addAttribute("response_type", responseType);
		model.addAttribute("client_id", clientId);
		model.addAttribute("redirect_uri", redirectUri);
		model.addAttribute("scope", scope);
		model.addAttribute("aud", aud);
		model.addAttribute("state", state);

//		SmartAuthRequest authRequest = new SmartAuthRequest();
//		authRequest.setAppEntry(smartApp);
//		authRequest.setLaunchContext(launchContext);
//		authRequest.setState(state);
//		authRequest.setScope(scope);
//		authRequest.setServerBaseUrl(baseUrl);		
//		return new ModelAndView("authenticate", "request", authRequest);

		return new ModelAndView("authenticate", model);
	}

	private static final SecureRandom secureRandom = new SecureRandom(); // threadsafe
	private static final java.util.Base64.Encoder base64Encoder = java.util.Base64.getUrlEncoder(); // threadsafe

	public static String generateNewToken() {
		byte[] randomBytes = new byte[24];
		secureRandom.nextBytes(randomBytes);
		return base64Encoder.encodeToString(randomBytes);
	}

	@RequestMapping(value = "/token", method = RequestMethod.POST, produces = "application/json")
	@ResponseBody
//	public String token(
	public ResponseEntity<TokenResponse> token(@RequestParam(name = "grant_type", required = true) String grantType,
			@RequestParam(name = "code", required = true) String code,
			@RequestParam(name = "redirect_uri", required = true) String redirectUri,
			@RequestParam(name = "client_id", required = true) String appId,
			@RequestParam(name = "refresh_token", required = false) String refreshCode,
			@RequestParam(name = "scope", required = false) String scope, Model model) {

//		// Alway pass this information so that JSP can route to correct endpoint
//		model.addAttribute("base_url", baseUrl);

		logger.debug(
				"Token Requested:\ncode: " + code + "\nredirect_uri:" + redirectUri + "\nclient_id:" + appId + "\n");
		if (!"authorization_code".equals(grantType) && !"refresh_token".equals(grantType)) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "unsupported_grant_type");
		}

		SmartOnFhirAppEntry smartApp;
		SmartOnFhirSessionEntry smartSession;
		// If this is refresh token request, we handle it differently,
		if ("refresh_token".equals(grantType)) {
			// if refresh_token does not exist, we return error.
			if (refreshCode == null || refreshCode.isEmpty()) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid_request");
			}

			smartSession = smartOnFhirSession.getSmartOnFhirAppByRefreshToken(refreshCode);
			if (smartSession == null) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid_grant");
			}

			appId = smartSession.getAppId();
			code = smartSession.getAuthorizationCode();
			smartApp = smartOnFhirApp.getSmartOnFhirApp(appId);
		} else {
			smartApp = smartOnFhirApp.getSmartOnFhirApp(appId, redirectUri);
			if (smartApp == null) {
				// Invalid client-id. We should send with bad request.
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid_request");
			}
			smartSession = smartOnFhirSession.getSmartOnFhirSession(appId, code);
			if (smartSession == null) {
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid_request");
			}
		}

		Long now = (new Date()).getTime();
		Long expire = smartSession.getAuthCodeExpirationDT().getTime();
		if (expire <= now) {
			logger.info("Authorization for session-id: " + smartSession.getSessionId() + " is expired");

			// Expired. 400 respond with invalid_grant
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid_grant");
		}

		// See if token is expired.
		if (smartSession.getAccessTokenExpirationDT() != null) {
			expire = smartSession.getAccessTokenExpirationDT().getTime();
			if (expire <= now) {
				logger.info("Access Token for session-id: " + smartSession.getSessionId() + " is expired");

				// Expired. 400 respond with invalid_grant
				throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid_grant");
			}
		}

		// generate access_token if needed.
		TokenResponse tokenResponse = new TokenResponse();

		String accessToken = smartSession.getAccessToken();
		String refreshToken = smartSession.getRefreshToken();
		Long expiration;
		if (accessToken == null || accessToken.isEmpty()) {
			boolean exists = true;
			while (exists) {
				accessToken = SmartAuthServicesController.generateNewToken();
				if (smartOnFhirSession.getSmartOnFhirAppByToken(accessToken) == null)
					exists = false;
			}
			smartOnFhirSession.putAccessCode(appId, code, accessToken);

			// We only change the refresh token
			exists = true;
			while (exists) {
				refreshToken = SmartAuthServicesController.generateNewToken();
				if (smartOnFhirSession.getSmartOnFhirAppByRefreshToken(refreshToken) == null)
					exists = false;
			}
			smartOnFhirSession.putRefereshCode(appId, code, refreshToken);
			expiration = (long) SmartAuthServicesController.timeout_min * 60;
		} else {
			expiration = (now - expire) / 1000;
		}

		tokenResponse.setAccessToken(accessToken);
		tokenResponse.setRefreshToken(refreshToken);
		tokenResponse.setExpiresIn(expiration);
		tokenResponse.setScope(smartApp.getScope());
		tokenResponse.setTokenType("Bearer");

		String patient = getPatientIdFromJWT(smartSession.getAuthorizationCode());
		if (patient != null && !patient.isEmpty()) {
			tokenResponse.setPatient(patient);
		}

		logger.debug("token: responding with " + tokenResponse.toString());

		return new ResponseEntity<TokenResponse>(tokenResponse, HttpStatus.OK);
//		return tokenResponse.toString();
	}

	@PostMapping(value = "/introspect")
	public ResponseEntity<IntrospectResponse> introspect(@RequestParam(name = "token", required = true) String token,
			Model model) {

		SmartOnFhirSessionEntry smartSession = smartOnFhirSession.getSmartOnFhirAppByToken(token);
		if (smartSession == null) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid Token");
		}

		SmartOnFhirAppEntry smartApp = smartOnFhirApp.getSmartOnFhirApp(smartSession.getAppId());
		if (smartApp == null) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid Token");
		}

		Long now = (new Date()).getTime();
		Long expire = smartSession.getAccessTokenExpirationDT().getTime();
		if (expire <= now) {
			// Expired. 400 respond with invalid_grant
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid_grant");
		}

		IntrospectResponse introspectResponse = new IntrospectResponse(true, smartApp.getScope());
		introspectResponse.setExp(expire / 1000);
		introspectResponse.setTokenType("Bearer");

		return new ResponseEntity<IntrospectResponse>(introspectResponse, HttpStatus.OK);
	}

	@PostMapping(value = "/after-auth")
	public ModelAndView afterAuth(@RequestParam(name = "launch", required = false) String launchContext,
			@RequestParam(name = "response_type", required = false) String responseType,
			@RequestParam(name = "client_id", required = false) String clientId,
			@RequestParam(name = "redirect_uri", required = true) String redirectUri,
			@RequestParam(name = "scope", required = false) String scope,
			@RequestParam(name = "aud", required = false) String aud,
			@RequestParam(name = "state", required = false) String state, ModelMap model) {
		String error, errorDesc;

//		// Alway pass this information so that JSP can route to correct endpoint
//		model.addAttribute("base_url", baseUrl);
		model.remove("base_url");

//		if (oauth2attr == null || !oauth2attr.has("client_id") || !oauth2attr.has("redirect_uri")) {
//			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid request");
//		}

		if (clientId == null || clientId.isEmpty() || redirectUri == null || redirectUri.isEmpty()) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "invalid_request");
		}

		SmartOnFhirAppEntry smartApp = smartOnFhirApp.getSmartOnFhirApp(clientId);

		// Check if an authorization already exists for this session.
		// Get all the sessions for this client and see if any session has a same
		// patient id. We already checked scope in authorize().
		boolean createNewSession = false;
		SmartOnFhirSessionEntry sessionEntry = null;
		List<SmartOnFhirSessionEntry> smartSessions = smartOnFhirSession.getSmartOnFhirSessionsByAppId(clientId);
		for (SmartOnFhirSessionEntry entry : smartSessions) {
			if (entry.getAccessToken().equals(clientId)) {
				String patientInCode = getPatientIdFromJWT(entry.getAuthorizationCode());
				String patientInContext = getPatientFromLaunchContext(launchContext);
				if (patientInCode != null && !patientInCode.isEmpty() && patientInContext != null
						&& !patientInContext.isEmpty()) {
					if (patientInCode.equals(patientInContext)) {
						sessionEntry = entry;
						createNewSession = true;
						logger.debug("There is an existing session for this patient, " + patientInCode
								+ ", with client-id: " + clientId);
						break;
					}
				}
			}
		}

		// Create a session for this authorization.
		if (sessionEntry == null) {
			String code = generateJWT(launchContext, scope, smartApp);
			if (code == null || code.isEmpty()) {
				try {
					error = "server_error";
					errorDesc = encodeValue("Internal Server Error");
					model.addAttribute("error", error);
					model.addAttribute("error_description", errorDesc);
					return new ModelAndView("redirect:" + smartApp.getRedirectUri(), model);
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
					throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Internal Error", e);
				}
			}

			sessionEntry = new SmartOnFhirSessionEntry();
			String uuid = "";
			boolean exists = true;
			while (exists) {
				uuid = UUID.randomUUID().toString();
				exists = smartOnFhirSession.exists(uuid);
			}
			sessionEntry.setSessionId(uuid);
			sessionEntry.setAuthorizationCode(code);
			sessionEntry.setAppId(smartApp.getAppId());
		}
		sessionEntry.setState(state);

		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MINUTE, SmartAuthServicesController.timeout_min);
		java.sql.Date expiresIn = new java.sql.Date(calendar.getTimeInMillis());
		sessionEntry.setAuthCodeExpirationDT(expiresIn);

		if (createNewSession) {
			smartOnFhirSession.save(sessionEntry);
		} else {
			smartOnFhirSession.update(sessionEntry);
		}

		model.addAttribute("code", sessionEntry.getAuthorizationCode());
		model.addAttribute("state", state);
		return new ModelAndView("redirect:" + smartApp.getRedirectUri(), model);
	}

	@GetMapping(value = "/app-create")
	public String appCreate(Model model) {
		String uuid = "";
		boolean exists = true;

		// Alway pass this information so that JSP can route to correct endpoint
		model.addAttribute("base_url", baseUrl);

		while (exists) {
			uuid = UUID.randomUUID().toString();
			exists = smartOnFhirApp.exists(uuid);
		}

		model.addAttribute("client_id", uuid);

		return "app_create";
	}

	private void populateModel(Model model, SmartOnFhirAppEntry appEntry) {
		model.addAttribute("client_id", appEntry.getAppId());
		model.addAttribute("scope", appEntry.getScope());
		model.addAttribute("app_type", appEntry.getAppType());
		model.addAttribute("redirect_uri", appEntry.getRedirectUri());
		model.addAttribute("launch_uri", appEntry.getLaunchUri());
		model.addAttribute("app_name", appEntry.getAppName());
	}

	private String makeScope(String appType, String user_condition_r, String user_documentreference_r,
			String user_encounter_r, String user_medicationstatement_r, String user_medicationrequest_r,
			String user_observation_r, String user_patient_r, String user_procedure_r, String patient_condition_r,
			String patient_documentreference_r, String patient_encounter_r, String patient_medicationstatement_r,
			String patient_medicationrequest_r, String patient_observation_r, String patient_patient_r,
			String patient_procedure_r) {
		String scope = "launch profile openid online_access ";
		if ("Patient".equals(appType))
			scope += "launch/patient ";
		if (user_condition_r != null)
			scope += "user/Condition.read ";
		if (user_documentreference_r != null)
			scope += "user/DocumentReference.read ";
		if (user_encounter_r != null)
			scope += "user/Encounter.read ";
		if (user_medicationstatement_r != null)
			scope += "user/MedicationStatement.read ";
		if (user_medicationrequest_r != null)
			scope += "user/MedicationRequest.read ";
		if (user_observation_r != null)
			scope += "user/Observation.read ";
		if (user_patient_r != null)
			scope += "user/Patient.read ";
		if (user_procedure_r != null)
			scope += "user/Procedure.read ";
		if (patient_condition_r != null)
			scope += "patient/Condition.read ";
		if (patient_documentreference_r != null)
			scope += "patient/DocumentReference.read ";
		if (patient_encounter_r != null)
			scope += "patient/Encounter.read ";
		if (patient_medicationstatement_r != null)
			scope += "patient/MedicationStatement.read ";
		if (patient_medicationrequest_r != null)
			scope += "patient/MedicationRequest.read ";
		if (patient_observation_r != null)
			scope += "patient/Observation.read ";
		if (patient_patient_r != null)
			scope += "patient/Patient.read ";
		if (patient_procedure_r != null)
			scope += "patient/Procedure.read ";

		return scope.trim();
	}

	@RequestMapping(value = "/app-new")
	public String appNew(@RequestParam(name = "client_id", required = true) String appId,
			@RequestParam(name = "app_type", required = true) String appType,
			@RequestParam(name = "redirect_uri", required = true) String redirectUri,
			@RequestParam(name = "launch_uri", required = false) String launchUri,
			@RequestParam(name = "app_name", required = true) String appName,
			@RequestParam(name = "user_condition_r", required = false) String user_condition_r,
			@RequestParam(name = "user_documentreference_r", required = false) String user_documentreference_r,
			@RequestParam(name = "user_encounter_r", required = false) String user_encounter_r,
			@RequestParam(name = "user_medicationstatement_r", required = false) String user_medicationstatement_r,
			@RequestParam(name = "user_medicationrequest_r", required = false) String user_medicationrequest_r,
			@RequestParam(name = "user_observation_r", required = false) String user_observation_r,
			@RequestParam(name = "user_patient_r", required = false) String user_patient_r,
			@RequestParam(name = "user_procedure_r", required = false) String user_procedure_r,
			@RequestParam(name = "patient_condition_r", required = false) String patient_condition_r,
			@RequestParam(name = "patient_documentreference_r", required = false) String patient_documentreference_r,
			@RequestParam(name = "patient_encounter_r", required = false) String patient_encounter_r,
			@RequestParam(name = "patient_medicationstatement_r", required = false) String patient_medicationstatement_r,
			@RequestParam(name = "patient_medicationrequest_r", required = false) String patient_medicationrequest_r,
			@RequestParam(name = "patient_observation_r", required = false) String patient_observation_r,
			@RequestParam(name = "patient_patient_r", required = false) String patient_patient_r,
			@RequestParam(name = "patient_procedure_r", required = false) String patient_procedure_r, Model model) {

		// Alway pass this information so that JSP can route to correct endpoint
		model.addAttribute("base_url", baseUrl);

		String scope = makeScope(appType, user_condition_r, user_documentreference_r, user_encounter_r,
				user_medicationstatement_r, user_medicationrequest_r, user_observation_r, user_patient_r,
				user_procedure_r, patient_condition_r, patient_documentreference_r, patient_encounter_r,
				patient_medicationstatement_r, patient_medicationrequest_r, patient_observation_r, patient_patient_r,
				patient_procedure_r);

		SmartOnFhirAppEntry appEntry = new SmartOnFhirAppEntry();
		appEntry.setAppId(appId);
		appEntry.setScope(scope.trim());
		appEntry.setAppType(appType);
		appEntry.setRedirectUri(redirectUri);
		appEntry.setLaunchUri(launchUri);
		appEntry.setAppName(appName);

		smartOnFhirApp.save(appEntry);

		populateModel(model, appEntry);
		return "app_view";
	}

	@RequestMapping(value = "/app-update")
	public String appUpdate(@RequestParam(name = "client_id", required = true) String appId,
			@RequestParam(name = "app_type", required = true) String appType,
			@RequestParam(name = "redirect_uri", required = true) String redirectUri,
			@RequestParam(name = "launch_uri", required = false) String launchUri,
			@RequestParam(name = "app_name", required = true) String appName,
			@RequestParam(name = "user_condition_r", required = false) String user_condition_r,
			@RequestParam(name = "user_documentreference_r", required = false) String user_documentreference_r,
			@RequestParam(name = "user_encounter_r", required = false) String user_encounter_r,
			@RequestParam(name = "user_medicationstatement_r", required = false) String user_medicationstatement_r,
			@RequestParam(name = "user_medicationrequest_r", required = false) String user_medicationrequest_r,
			@RequestParam(name = "user_observation_r", required = false) String user_observation_r,
			@RequestParam(name = "user_patient_r", required = false) String user_patient_r,
			@RequestParam(name = "user_procedure_r", required = false) String user_procedure_r,
			@RequestParam(name = "patient_condition_r", required = false) String patient_condition_r,
			@RequestParam(name = "patient_documentreference_r", required = false) String patient_documentreference_r,
			@RequestParam(name = "patient_encounter_r", required = false) String patient_encounter_r,
			@RequestParam(name = "patient_medicationstatement_r", required = false) String patient_medicationstatement_r,
			@RequestParam(name = "patient_medicationrequest_r", required = false) String patient_medicationrequest_r,
			@RequestParam(name = "patient_observation_r", required = false) String patient_observation_r,
			@RequestParam(name = "patient_patient_r", required = false) String patient_patient_r,
			@RequestParam(name = "patient_procedure_r", required = false) String patient_procedure_r, Model model) {

		// Alway pass this information so that JSP can route to correct endpoint
		model.addAttribute("base_url", baseUrl);

		String scope = makeScope(appType, user_condition_r, user_documentreference_r, user_encounter_r,
				user_medicationstatement_r, user_medicationrequest_r, user_observation_r, user_patient_r,
				user_procedure_r, patient_condition_r, patient_documentreference_r, patient_encounter_r,
				patient_medicationstatement_r, patient_medicationrequest_r, patient_observation_r, patient_patient_r,
				patient_procedure_r);

		SmartOnFhirAppEntry appEntry = smartOnFhirApp.getSmartOnFhirApp(appId);
		if (appEntry == null) {
			model.addAttribute("error", "Invaid client Id");
			return "error";
		}

		appEntry.setAppId(appId);
		appEntry.setScope(scope);
		appEntry.setAppType(appType);
		appEntry.setRedirectUri(redirectUri);
		appEntry.setLaunchUri(launchUri);
		appEntry.setAppName(appName);

		smartOnFhirApp.update(appEntry);

		populateModel(model, appEntry);
		return "app_view";
	}

	@GetMapping(value = "/app-edit")
	public String appEdit(@RequestParam(name = "client_id", required = true) String appId, Model model) {

		// Alway pass this information so that JSP can route to correct endpoint
		model.addAttribute("base_url", baseUrl);

		SmartOnFhirAppEntry appEntry = smartOnFhirApp.getSmartOnFhirApp(appId);
		if (appEntry == null) {
			model.addAttribute("error", "Invaid client Id");
			return "error";
		}

		populateModel(model, appEntry);
		return "app_edit";
	}

	@GetMapping(value = "/app-view")
	public String appView(@RequestParam(name = "client_id", required = true) String appId, Model model) {
		SmartOnFhirAppEntry appEntry = smartOnFhirApp.getSmartOnFhirApp(appId);
		populateModel(model, appEntry);

		// Alway pass this information so that JSP can route to correct endpoint
		model.addAttribute("base_url", baseUrl);

		return "app_view";
	}

	@DeleteMapping(value = "/app-delete")
	public String appDelete(@RequestParam(name = "client_id", required = true) String appId, Model model) {
		smartOnFhirApp.delete(appId);

		// Alway pass this information so that JSP can route to correct endpoint
		model.addAttribute("base_url", baseUrl);

		return goIndex(model);
	}

	@GetMapping(value = "/app-launch")
	public ModelAndView appLaunch(@RequestParam(name = "client_id", required = true) String appId,
			@RequestParam(name = "patient_id", required = true) String patientId, ModelMap model) {

		// Alway pass this information so that JSP can route to correct endpoint
//		model.addAttribute("base_url", baseUrl);
		model.remove("base_url");

		SmartOnFhirAppEntry smartApp = smartOnFhirApp.getSmartOnFhirApp(appId);

		// Create launch context
		JSONObject launchContextJson = new JSONObject();
		launchContextJson.put("patient", patientId);

		JSONObject launchContextEncoded = SmartLauncherCodec.encode(launchContextJson);

		String launchContext = Base64.encodeBase64String(launchContextEncoded.toString().getBytes());
		String iss = System.getenv("SERVERBASE_URL");
		if (iss == null || iss.isEmpty()) {
			iss = "http://localhost:8080/fhir";
		}

		model.addAttribute("iss", iss);
		model.addAttribute("launch", launchContext);
		return new ModelAndView("redirect:" + smartApp.getLaunchUri(), model);
	}

//	@GetMapping(value = "/register")
//	public String register(@RequestParam(name = "client_id", required = false) String appId,
//			@RequestParam(name = "scope", required = false) String scope,
//			@RequestParam(name = "type", required = false) String type,
//			@RequestParam(name = "redirect_uri", required = false) String redirectUri,
//			@RequestParam(name = "launch_uri", required = false) String launchUri,
//			@RequestParam(name = "app_name", required = false) String appName, Model model) {
//
//		if (appId == null || !appId.isEmpty()) {
//			String uuid = "";
//			boolean exists = true;
//			while (exists) {
//				uuid = UUID.randomUUID().toString();
//				exists = smartOnFhirApp.exists(uuid);
//			}
//
//			model.addAttribute("client_id", uuid);
//
//			return "app";
//		}
//
//		SmartOnFhirAppEntry appEntry = new SmartOnFhirAppEntry();
//		appEntry.setAppId(appId);
//		appEntry.setAppName(appName);
//		appEntry.setAppType(type);
//		appEntry.setScope(scope);
//		appEntry.setRedirectUri(redirectUri);
//		appEntry.setLaunchUri(launchUri);
//
//		smartOnFhirApp.save(appEntry);
//
//		model.addAttribute("app_entry", appEntry);
//		return "portal";
//	}

	@GetMapping(value = "")
	public String goIndex(Model model) {
		// Alway pass this information so that JSP can route to correct endpoint
		model.addAttribute("base_url", baseUrl);

		List<SmartOnFhirAppEntry> appEntries = smartOnFhirApp.get();

		SmartOnFhirAppListContainer appList = new SmartOnFhirAppListContainer();
		appList.setAppEntries(appEntries);
		model.addAttribute("appList", appList);

		return "index";
	}

}
