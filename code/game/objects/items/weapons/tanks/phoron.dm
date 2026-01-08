/*
 * Phoron
 */
/obj/item/tank/phoron
	name = "phoron tank"
	desc = "Contains dangerous phoron. Do not inhale. Warning: extremely flammable."
	icon = 'icons/obj/items/tanks/tank_greyscaled.dmi'
	color = "#d3681a"
	gauge_icon = null
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = null	//they have no straps!
	starting_pressure = list(/decl/material/solid/phoron = 3*ONE_ATMOSPHERE)
