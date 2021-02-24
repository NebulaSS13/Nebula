/obj/item/wirecutters
	name = "wirecutters"
	desc = "A special pair of pliers with cutting edges. Various brackets and manipulators built into the handle allow it to repair severed wiring."
	icon = 'icons/obj/items/tool/wirecutters.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_SMALL
	origin_tech = "{'materials':1,'engineering':1}"
	material = /decl/material/solid/metal/steel
	center_of_mass = @"{'x':18,'y':10}"
	attack_verb = list("pinched", "nipped")
	sharp = 1
	edge = 1
	applies_material_colour = TRUE

	var/handle_color
	var/global/valid_colours = list(COLOR_RED, COLOR_MAROON, COLOR_SEDONA, PIPE_COLOR_YELLOW, COLOR_BABY_BLUE)

/obj/item/wirecutters/on_update_icon()
	. = ..()
	if(!handle_color)
		handle_color = pick(valid_colours)
	overlays += overlay_image(icon, "[get_world_inventory_state()]_handle", handle_color, flags=RESET_COLOR)

/obj/item/wirecutters/experimental_mob_overlay()
	var/image/res = ..()
	if(res)
		res.color = handle_color
	return res

/obj/item/wirecutters/get_on_belt_overlay()
	var/image/res = ..()
	if(res)
		res.color = handle_color
	return res

/obj/item/wirecutters/attack(mob/living/carbon/C, mob/user)
	if(istype(C) && user.a_intent == I_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/handcuffs/cable)))
		usr.visible_message("\The [usr] cuts \the [C]'s restraints with \the [src]!",\
		"You cut \the [C]'s restraints with \the [src]!",\
		"You hear cable being cut.")
		C.handcuffed = null
		if(C.buckled && C.buckled.buckle_require_restraints)
			C.buckled.unbuckle_mob()
		C.update_inv_handcuffed()
		return
	else
		..()