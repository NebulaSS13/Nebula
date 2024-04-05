/obj/item/stack/material/aerogel
	name = "aerogel"
	singular_name = "gel block"
	plural_name = "gel blocks"
	icon_state = "puck"
	plural_icon_state = "puck-mult"
	max_icon_state = "puck-max"
	stack_merge_type = /obj/item/stack/material/aerogel
	crafting_stack_type = /obj/item/stack/material/aerogel

// Aerogel melting point is below 0 as it is a physical container for gas; hack around that here.
/obj/item/stack/material/aerogel/ProcessAtomTemperature()
	return PROCESS_KILL
