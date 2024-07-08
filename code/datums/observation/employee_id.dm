/**
 * Observer Pattern Implementation: Employee ID Reassigned
 *
 * Raised when: A card's assignment is changed in the ID card modification program.
 *
 * Arguments that the called proc should expect:
 *     /obj/item/card/id: The card that was reassigned.
 */
/decl/observ/employee_id_reassigned
	name = "Employee ID Reassigned"

//	Observer Pattern Implementation: Employee ID Terminated
//		Registration type: /obj/item/card/id
//
//		Raised when: A card is terminated in the ID card modification program.
//
//		Arguments that the called proc should expect:
//			/area/shuttle: The shuttle the crate was sold on.
//			/obj/structure/closet/crate/sold: The crate that was sold.

/decl/observ/employee_id_terminated
	name = "Employee ID Terminated"
