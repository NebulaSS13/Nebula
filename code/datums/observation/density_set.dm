//	Observer Pattern Implementation: Density Set
//		Registration type: /atom
//
//		Raised when: An /atom changes density using the set_density() proc.
//
//		Arguments that the called proc should expect:
//			/atom/density_changer: The instance that changed density.
//			/old_density: The density before the change.
//			/new_density: The density after the change.



/decl/observ/density_set
	name = "Density Set"
	expected_type = /atom

/*******************
* Density Handling *
*******************/
/atom/set_density(new_density)
	var/old_density = density
	. = ..()
	if(density != old_density)
		events_repository.raise_event(/decl/observ/density_set, src, old_density, density)
