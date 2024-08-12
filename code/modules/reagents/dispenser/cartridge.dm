/obj/item/chems/chem_disp_cartridge
	name = "cartridge"
	desc = "This goes in a chemical dispenser."
	icon = 'icons/obj/items/chem/chem_cartridge.dmi'
	icon_state = "cartridge"
	w_class = ITEM_SIZE_NORMAL
	volume = CARTRIDGE_VOLUME_LARGE
	amount_per_transfer_from_this = 50
	material = /decl/material/solid/stone/ceramic
	// Large, but inaccurate. Use a chem dispenser or beaker for accuracy.
	possible_transfer_amounts = @"[50,100]"

/obj/item/chems/chem_disp_cartridge/initialize_reagents(populate = TRUE)
	. = ..()
	if(populate && reagents.primary_reagent)
		setLabel(reagents.get_primary_reagent_name())

/obj/item/chems/chem_disp_cartridge/examine(mob/user)
	. = ..()
	to_chat(user, "It has a capacity of [volume] units.")
	if(reagents.total_volume <= 0)
		to_chat(user, "It is empty.")
	else
		to_chat(user, "It contains [reagents.total_volume] units of reagents.")
	if(!ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, "The cap is sealed.")

/obj/item/chems/chem_disp_cartridge/verb/verb_set_label(L as text)
	set name = "Set Cartridge Label"
	set category = "Object"
	set src in view(usr, 1)

	var/datum/extension/labels/lext = get_or_create_extension(src, /datum/extension/labels)
	if(lext)
		for(var/lab in lext.labels)
			lext.RemoveLabel(null, lab)
		if(length(L))
			lext.AttachLabel(null, L)

/obj/item/chems/chem_disp_cartridge/proc/setLabel(L, mob/user = null)
	var/datum/extension/labels/lext = get_or_create_extension(src, /datum/extension/labels)
	if(lext)
		for(var/lab in lext.labels)
			lext.RemoveLabel(null, lab)

		if(length(L))
			lext.AttachLabel(user, L)
		else if(user)
			to_chat(user, SPAN_NOTICE("You clear the label on \the [src]."))

/obj/item/chems/chem_disp_cartridge/attack_self()
	..()
	if (ATOM_IS_OPEN_CONTAINER(src))
		to_chat(usr, SPAN_NOTICE("You put the cap on \the [src]."))
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
	else
		to_chat(usr, SPAN_NOTICE("You take the cap off \the [src]."))
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER

/obj/item/chems/chem_disp_cartridge/afterattack(obj/target, mob/user, proximity_flag, click_parameters)
	if (ATOM_IS_OPEN_CONTAINER(src) && proximity_flag)
		if(standard_dispenser_refill(user, target))
			return TRUE
		if(standard_pour_into(user, target))
			return TRUE
		if(handle_eaten_by_mob(user, target) != EATEN_INVALID)
			return TRUE
		if(user.a_intent == I_HURT)
			if(standard_splash_mob(user,target))
				return TRUE
			if(reagents && reagents.total_volume)
				to_chat(user, SPAN_DANGER("You splash the contents of \the [src] onto \the [target]."))
				reagents.splash(target, reagents.total_volume) //FIXME: probably shouldn't throw the whole 500 units at the mob, since the bottle neck is a bottle neck.
				return TRUE
	return ..()
