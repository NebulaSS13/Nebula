//	Observer Pattern Implementation: Shuttle Added
//		Registration type: /datum/shuttle (register for the global event only)
//
//		Raised when: After a shuttle is initialized.
//
//		Arguments that the called proc should expect:
//			/datum/shuttle/shuttle: the new shuttle

/decl/observ/shuttle_added
	name = "Shuttle Added"
	expected_type = /datum/shuttle

/*****************************
*  Shuttle Added Handling *
*****************************/

/datum/controller/subsystem/shuttle/initialize_shuttle()
	. = ..()
	if(.)
		events_repository.raise_event(/decl/observ/shuttle_added, .)
