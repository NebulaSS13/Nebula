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
