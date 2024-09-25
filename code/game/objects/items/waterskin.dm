/obj/item/chems/waterskin
	name = "waterskin"
	desc = "A water-carrying vessel made from the dried stomach of some unfortunate animal."
	icon = 'icons/obj/items/waterskin.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/organic/leather/gut
	color = /decl/material/solid/organic/leather/gut::color
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	volume = 120
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	var/decl/material/stopper_material = /decl/material/solid/organic/cloth/hemp

/obj/item/chems/waterskin/proc/get_stopper_message()
	var/decl/material/stopper_material_instance = GET_DECL(stopper_material)
	return "You tie the neck of \the [src] closed with \a [stopper_material_instance.adjective_name] cord."

/obj/item/chems/waterskin/proc/get_unstopper_message()
	var/decl/material/stopper_material_instance = GET_DECL(stopper_material)
	return "You untie \the [stopper_material_instance.adjective_name] cord from around the neck of \the [src]."

/obj/item/chems/waterskin/proc/get_stopper_overlay()
	if(ATOM_IS_OPEN_CONTAINER(src))
		return null
	var/decl/material/stopper_material_instance = GET_DECL(stopper_material)
	return overlay_image(icon, "[icon_state]-stopper", stopper_material_instance.color, RESET_COLOR | RESET_ALPHA)

/obj/item/chems/waterskin/attack_self()
	. = ..()
	if(!.)
		if(ATOM_IS_OPEN_CONTAINER(src))
			to_chat(usr, SPAN_NOTICE(get_stopper_message()))
			atom_flags &= ~ATOM_FLAG_OPEN_CONTAINER
		else
			to_chat(usr, SPAN_NOTICE(get_unstopper_message()))
			atom_flags |= ATOM_FLAG_OPEN_CONTAINER
		update_icon()

/obj/item/chems/waterskin/on_update_icon() // TODO: filled/empty sprites
	. = ..() // cuts overlays
	var/image/stopper_overlay = get_stopper_overlay()
	if(stopper_overlay)
		add_overlay(stopper_overlay)

/obj/item/chems/waterskin/crafted
	desc = "A long and rather unwieldly water-carrying vessel."
	icon = 'icons/obj/items/waterskin_crafted.dmi'
	material = /decl/material/solid/organic/leather
	color = /decl/material/solid/organic/leather::color
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	stopper_material = /decl/material/solid/organic/wood/maple

/obj/item/chems/waterskin/crafted/get_stopper_message()
	var/decl/material/stopper_material_instance = GET_DECL(stopper_material)
	return "You insert \a [stopper_material_instance.adjective_name] stopper in the neck of \the [src]."

/obj/item/chems/waterskin/crafted/get_unstopper_message()
	var/decl/material/stopper_material_instance = GET_DECL(stopper_material)
	return "You remove \the [stopper_material_instance.adjective_name] stopper from the neck of \the [src]."

/obj/item/chems/waterskin/crafted/wine
	name = "wineskin"

/obj/item/chems/waterskin/crafted/wine/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/ethanol/wine, reagents?.maximum_volume)
