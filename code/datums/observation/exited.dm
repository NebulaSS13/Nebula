//	Observer Pattern Implementation: Exited
//		Registration type: /atom
//
//		Raised when: An /atom/movable instance has exited an atom.
//
//		Arguments that the called proc should expect:
//			/atom/entered: The atom that was exited from
//			/atom/movable/enterer: The instance that exited the atom
//			/atom/new_loc: The atom the exitee is now residing in
//

/decl/observ/exited
	name = "Exited"
	expected_type = /atom
	flags = OBSERVATION_NO_GLOBAL_REGISTRATIONS

/******************
* Exited Handling *
******************/

/atom/Exited(atom/movable/exitee, atom/new_loc)
	. = ..()
	if(event_listeners?[/decl/observ/exited])
		raise_event_non_global(/decl/observ/exited, exitee, new_loc)
