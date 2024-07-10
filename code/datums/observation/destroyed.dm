//	Observer Pattern Implementation: Destroyed
//		Registration type: /datum
//
//		Raised when: A /datum instance is destroyed.
//
//		Arguments that the called proc should expect:
//			/datum/destroyed_instance: The instance that was destroyed.

/decl/observ/destroyed
	name = "Destroyed"
	flags = OBSERVATION_NO_GLOBAL_REGISTRATIONS
