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
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	drop_sound = 'sound/foley/singletooldrop1.ogg'

	var/handle_color
	var/static/valid_colours = list(COLOR_RED, COLOR_MAROON, COLOR_SEDONA, PIPE_COLOR_YELLOW, COLOR_BABY_BLUE)

/obj/item/wirecutters/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_WIRECUTTERS = TOOL_QUALITY_DEFAULT))

/obj/item/wirecutters/on_update_icon()
	. = ..()
	if(!handle_color)
		handle_color = pick(valid_colours)
	add_overlay(overlay_image(icon, "[get_world_inventory_state()]_handle", handle_color, flags=RESET_COLOR))

/obj/item/wirecutters/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay)
		overlay.color = handle_color
	. = ..()

/obj/item/wirecutters/get_on_belt_overlay()
	var/image/ret = ..()
	if(ret)
		ret.color = handle_color
	return ret

/obj/item/wirecutters/attack(mob/living/carbon/C, mob/user)
	var/obj/item/handcuffs/cable/cuffs = C.get_equipped_item(slot_handcuffed_str)
	if(istype(C) && user.a_intent == I_HELP && (istype(cuffs)))
		usr.visible_message("\The [usr] cuts \the [C]'s restraints with \the [src]!",\
		"You cut \the [C]'s restraints with \the [src]!",\
		"You hear cable being cut.")
		C.try_unequip(cuffs)
		qdel(cuffs)
		if(C.buckled && C.buckled.buckle_require_restraints)
			C.buckled.unbuckle_mob()
		C.update_equipment_overlay(slot_handcuffed_str)
		return
	else
		..()