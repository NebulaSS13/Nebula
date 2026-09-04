//	Observer Pattern Implementation: Entered
//		Registration type: /atom
//
//		Raised when: An /atom/movable instance has entered an atom.
//
//		Arguments that the called proc should expect:
//			/atom/entered: The atom that was entered
//			/atom/movable/enterer: The instance that entered the atom
//			/atom/old_loc: The atom the enterer came from
//

/decl/observ/entered
	name = "Entered"
	expected_type = /atom
	flags = OBSERVATION_NO_GLOBAL_REGISTRATIONS

/*******************
* Entered Handling *
*******************/

/atom/Entered(atom/movable/enterer, atom/old_loc)
	..()
	if(event_listeners?[/decl/observ/entered])
		raise_event_non_global(/decl/observ/entered, enterer, old_loc)
