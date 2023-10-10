//	Observer Pattern Implementation: Updated Icon
//		Registration type: /atom
//
//		Raised when: An /atom updates its icon via the on_update_icon() proc.
//
//		Arguments that the called proc should expect:
//			/atom: The atom who updated icon.
//
//      Refer to /atom update_icon() proc for event calling logic.

/decl/observ/updated_icon
	name = "Updated Icon"
	expected_type = /atom
