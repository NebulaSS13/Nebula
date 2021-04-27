//	Observer Pattern Implementation: Logged Out
//		Registration type: /mob
//
//		Raised when: A mob logs out (client either logged out or was moved to another mob)
//
//		Arguments that the called proc should expect:
//			/mob/leaver:    The mob that has logged out
//			/client/client: The mob's client

/decl/observ/logged_out
	name = "Logged Out"
	expected_type = /mob
