package edu.gatech.chai.omoponfhir.smart.servlet;

public class TokenResponse {
	private String access_token;
	private String token_type = "Bearer";
	private Long expires_in;
	private String scope;
	private String patient;

	public TokenResponse() {
	}

	public TokenResponse(String accessToken, Long expiresIn, String scope) {
		this.access_token = accessToken;
		this.token_type = "Bearer";
		this.expires_in = expiresIn;
		this.scope = scope;
	}

	public String getAccessToken() {
		return this.access_token;
	}

	public void setAccessToken(String accessToken) {
		this.access_token = accessToken;
	}

	public String getTokenType() {
		return this.token_type;
	}

	public void setTokenType(String tokenType) {
		this.token_type = tokenType;
	}

	public Long getExpiresIn() {
		return this.expires_in;
	}

	public void setExpiresIn(Long expiresIn) {
		this.expires_in = expiresIn;
	}

	public String getScope() {
		return this.scope;
	}

	public void setScope(String scope) {
		this.scope = scope;
	}
	
	public String getPatient() {
		return this.patient;
	}
	
	public void setPatient(String patient) {
		this.patient = patient;
	}
	
	public String toString() {
		return "{"
				+ "\"access_token\": \"" + access_token + "\", "
				+ "\"token_type\": \"" + token_type + "\", "
				+ "\"expires_in\": " + expires_in + ", "
				+ "\"scope\": \"" + scope + "\", "
				+ "\"patient\": \"" + patient + "\"" 
				+ "}";
	}
}