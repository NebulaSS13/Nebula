/obj/item/chems/chem_disp_cartridge
	name = "cartridge"
	desc = "This goes in a chemical dispenser."
	icon = 'icons/obj/items/chem/chem_cartridge.dmi'
	icon_state = "cartridge"
	w_class = ITEM_SIZE_NORMAL
	chem_volume = CARTRIDGE_VOLUME_LARGE
	amount_per_transfer_from_this = 50
	material = /decl/material/solid/stone/ceramic
	// Large, but inaccurate. Use a chem dispenser or beaker for accuracy.
	possible_transfer_amounts = @"[50,100]"
	var/_reagent_label

/obj/item/chems/chem_disp_cartridge/Initialize()
	. = ..()
	var/decl/material/primary_reagent = istype(reagents) && reagents.get_primary_reagent_decl()
	if(primary_reagent && !_reagent_label)
		_reagent_label = primary_reagent.name
	if(_reagent_label)
		setLabel(_reagent_label)

/obj/item/chems/chem_disp_cartridge/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	. += "It has a capacity of [REAGENT_MAXIMUM_VOLUME(reagents)] unit\s."
	if(REAGENT_TOTAL_VOLUME(reagents) <= 0)
		. += "It is empty."
	else
		. += "It contains [REAGENT_TOTAL_VOLUME(reagents)] unit\s of reagents."
	if(!ATOM_IS_OPEN_CONTAINER(src))
		. += "The cap is sealed."

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

/obj/item/chems/chem_disp_cartridge/attack_self(mob/user)
	if((. = ..()))
		return
	if (ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, SPAN_NOTICE("You put the cap on \the [src]."))
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
	else
		to_chat(user, SPAN_NOTICE("You take the cap off \the [src]."))
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER

/obj/item/chems/chem_disp_cartridge/afterattack(obj/target, mob/user, proximity_flag, click_parameters)
	if (ATOM_IS_OPEN_CONTAINER(src) && proximity_flag)
		if(standard_dispenser_refill(user, target))
			return TRUE
		if(standard_pour_into(user, target))
			return TRUE
		if(handle_eaten_by_mob(user, target) != EATEN_INVALID)
			return TRUE
		if(user.check_intent(I_FLAG_HARM))
			if(standard_splash_mob(user,target))
				return TRUE
			var/total_vol = REAGENT_TOTAL_VOLUME(reagents)
			if(reagents && total_vol)
				to_chat(user, SPAN_DANGER("You splash the contents of \the [src] onto \the [target]."))
				reagents.splash(target, total_vol) //FIXME: probably shouldn't throw the whole 500 units at the mob, since the bottle neck is a bottle neck.
				return TRUE
	return ..()
