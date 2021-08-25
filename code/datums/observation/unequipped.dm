//	Observer Pattern Implementation: Unequipped (dropped)
//		Registration type: /mob
//
//		Raised when: A mob unequips/drops an item.
//
//		Arguments that the called proc should expect:
//			/mob/equipped:  The mob that unequipped/dropped the item.
//			/obj/item/item: The unequipped item.

/decl/observ/mob_unequipped
	name = "Mob Unequipped"
	expected_type = /mob

//	Observer Pattern Implementation: Unequipped (dropped)
//		Registration type: /obj/item
//
//		Raised when: A mob unequips/drops an item.
//
//		Arguments that the called proc should expect:
//			/obj/item/item: The unequipped item.
//			/mob/equipped:  The mob that unequipped/dropped the item.

/decl/observ/item_unequipped
	name = "Item Unequipped"
	expected_type = /obj/item

/**********************
* Unequipped Handling *
**********************/

/obj/item/dropped(var/mob/user)
	. = ..()
	events_repository.raise_event(/decl/observ/mob_unequipped, user, src)
	events_repository.raise_event(/decl/observ/item_unequipped, src, user)
