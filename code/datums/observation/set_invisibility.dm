//	Observer Pattern Implementation: Invisibility Set
//		Registration type: /atom
//
//		Raised when: An atom's invisiblity value is changed.
//
//		Arguments that the called proc should expect:
//			/atom/invisibilee:  The atom that had its invisibility set
//			/old_invisibility: invisibility before the change
//			/new_invisibility: invisibility after the change

/decl/observ/invisibility_set
	name = "Invisibility Set"
	expected_type = /atom

/*****************************
* Invisibility Set Handling *
*****************************/

/atom/proc/set_invisibility(var/new_invisibility = 0)
	var/old_invisibility = invisibility
	if(old_invisibility != new_invisibility)
		invisibility = new_invisibility
		events_repository.raise_event(/decl/observ/invisibility_set, src, old_invisibility, new_invisibility)
		update_above()
