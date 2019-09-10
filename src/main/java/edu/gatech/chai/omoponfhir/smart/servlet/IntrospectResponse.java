package edu.gatech.chai.omoponfhir.smart.servlet;

import com.fasterxml.jackson.annotation.JsonProperty;

public class IntrospectResponse {
	private boolean active;
	private String scope;
	private Long exp;
	private String token_type;
	
	public IntrospectResponse() {}

	public IntrospectResponse(boolean active, String scope) {
		this.active = active;
		this.scope = scope;
	}
	
	@JsonProperty("active")
	public boolean getActive() {
		return this.active;
	}
	
	@JsonProperty("active")
	public void setActive(boolean active) {
		this.active = active;
	}

	@JsonProperty("scope")
	public String getScope() {
		return this.scope;
	}
	
	@JsonProperty("scope")
	public void setScope(String scope) {
		this.scope = scope;
	}
	
	@JsonProperty("exp")
	public Long getExp() {
		return this.exp;
	}
	
	@JsonProperty("exp")
	public void setExp(Long exp) {
		this.exp = exp;
	}
	
	@JsonProperty("token_type")
	public String getTokenType() {
		return this.token_type;
	}
	
	@JsonProperty("token_type")
	public void setTokenType(String token_type) {
		this.token_type = token_type;
	}
}