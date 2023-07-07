/datum/inventory_slot/handcuffs
	slot_id = "Handcuffs"
	slot_id = slot_handcuffed_str
	skip_on_inventory_display = TRUE // Handcuffs have their own logic on examine.
	skip_on_strip_display = TRUE // Handcuffs are removed with their own button in the strip menu.
	requires_organ_tag = list(
		BP_L_HAND,
		BP_R_HAND
	)

/datum/inventory_slot/handcuffs/update_overlay(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	user.update_inv_handcuffed(redraw_mob)

/datum/inventory_slot/handcuffs/equipped(mob/living/user, obj/item/prop, var/silent = FALSE)
	. = ..()
	if(.)
		user.drop_held_items()

/datum/inventory_slot/handcuffs/unequipped(var/mob/living/user, var/obj/item/prop, var/redraw_mob = TRUE)
	. = ..()
	if(. && user.buckled?.buckle_require_restraints)
		user.buckled.unbuckle_mob()

/datum/inventory_slot/handcuffs/can_equip_to_slot(var/mob/user, var/obj/item/prop, var/disable_warning, var/ignore_equipped)
	. = ..() && istype(prop, /obj/item/handcuffs)

/datum/inventory_slot/handcuffs/get_examined_string(mob/owner, mob/user, distance, hideflags, decl/pronouns/pronouns)
	if(_holding)
		if(user == owner)
			return SPAN_WARNING("You are [html_icon(_holding)] restrained with \the [_holding]!")
		return SPAN_WARNING("[pronouns.He] [pronouns.is] [html_icon(_holding)] restrained with \the [_holding]!")
