/obj/item/chems/waterskin
	name = "waterskin"
	desc = "A water-carrying vessel made from the dried stomach of some unfortunate animal."
	icon = 'icons/obj/items/waterskin.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/organic/leather/gut
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	volume = 120
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME

/obj/item/chems/waterskin/attack_self()
	. = ..()
	if(!.)
		if(ATOM_IS_OPEN_CONTAINER(src))
			to_chat(usr, SPAN_NOTICE("You cork \the [src]."))
			atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
		else
			to_chat(usr, SPAN_NOTICE("You remove the cork from \the [src]."))
			atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		update_icon() // TODO: filled/empty and corked/uncorked sprites

/obj/item/chems/waterskin/crafted
	desc = "A long and rather unwieldly water-carrying vessel."
	material = /decl/material/solid/organic/leather
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

/obj/item/chems/waterskin/crafted/wine
	name = "wineskin"

/obj/item/chems/waterskin/crafted/wine/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/ethanol/wine, reagents?.maximum_volume)
