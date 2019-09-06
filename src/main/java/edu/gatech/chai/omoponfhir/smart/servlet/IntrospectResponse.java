package edu.gatech.chai.omoponfhir.smart.servlet;

import com.fasterxml.jackson.annotation.JsonProperty;

public class IntrospectResponse {
	@JsonProperty("active")
	private boolean active;

	@JsonProperty("scope")
	private String scope;

	@JsonProperty("exp")
	private Long exp;
	
	public IntrospectResponse() {}

	public IntrospectResponse(boolean active, String scope) {
		this.active = active;
		this.scope = scope;
	}
	
	public boolean getActive() {
		return this.active;
	}
	
	public void setActive(boolean active) {
		this.active = active;
	}

	public String getScope() {
		return this.scope;
	}
	
	public void setScope(String scope) {
		this.scope = scope;
	}
	
	public Long getExp() {
		return this.exp;
	}
	
	public void setExp(Long exp) {
		this.exp = exp;
	}
}