//	Observer Pattern Implementation: Atom Examined
//		Registration type: /atom
//
//		Raised when: A mob examines an atom.
//
//		Arguments that the called proc should expect:
//			/mob/examiner:  The mob that examined the atom.
//			/atom/examined: The examined atom.

/decl/observ/atom_examined
	name = "Atom Examined"
	expected_type = /atom

//	Observer Pattern Implementation: Mob Examining
//		Registration type: /mob
//
//		Raised when: A mob examines an atom.
//
//		Arguments that the called proc should expect:
//			/atom/examined: The examined atom.
//			/mob/examiner:  The mob that examined the atom.

/decl/observ/mob_examining
	name = "Mob Examining"
	expected_type = /mob