/decl/interaction_handler/dip_item
	name = "Dip Into"
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEVER_AUTOMATIC

/decl/interaction_handler/dip_item/is_possible(atom/target, mob/user, obj/item/prop)
	return ..() && target != prop && target.reagents?.total_volume >= FLUID_MINIMUM_TRANSFER && istype(prop) && target.can_be_poured_from(user, prop)

/decl/interaction_handler/dip_item/invoked(atom/target, mob/user, obj/item/prop)
	user.visible_message(SPAN_NOTICE("\The [user] dips \the [prop] into \the [target.reagents.get_primary_reagent_name()]."))
	if(istype(prop, /obj/item/food) && isobj(target))
		var/obj/target_obj = target
		var/transferring = min(target_obj.get_food_default_transfer_amount(user), REAGENTS_FREE_SPACE(prop.reagents))
		if(transferring)
			target.reagents.trans_to_holder(prop.reagents, transferring)
	if(target.reagents?.total_volume >= FLUID_MINIMUM_TRANSFER)
		prop.fluid_act(target.reagents)
	return TRUE

/decl/interaction_handler/fill_from
	name = "Fill From"
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEVER_AUTOMATIC

/decl/interaction_handler/fill_from/is_possible(atom/target, mob/user, obj/item/prop)
	if(!(. = ..()))
		return
	if(target == prop || target.reagents?.total_volume < FLUID_PUDDLE)
		return FALSE
	if(!istype(prop) || (!isitem(target) && !istype(target, /obj/structure/reagent_dispensers)))
		return FALSE
	return target.can_be_poured_from(user, prop) && prop.can_be_poured_into(user, target)

/decl/interaction_handler/fill_from/invoked(atom/target, mob/user, obj/item/prop)
	if(isitem(target))
		var/obj/item/vessel = target
		return vessel.standard_pour_into(user, prop)
	if(istype(target, /obj/structure/reagent_dispensers))
		// Reagent dispensers have some wonky assumptions due to old UX around filling/emptying so we skip the atom flags check.
		return prop.standard_dispenser_refill(user, target, skip_container_check = TRUE)
	return FALSE

/decl/interaction_handler/empty_into
	name = "Pour Into"
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEVER_AUTOMATIC

/decl/interaction_handler/empty_into/is_possible(atom/target, mob/user, obj/item/prop)
	if(!(. = ..()))
		return
	if(target == prop || !istype(prop) || prop.reagents?.total_volume <= 0)
		return FALSE
	return target.can_be_poured_into(user, prop) && prop.can_be_poured_from(user, target)

/decl/interaction_handler/empty_into/invoked(atom/target, mob/user, obj/item/prop)
	prop.standard_pour_into(user, target)
	return TRUE

/decl/interaction_handler/wash_hands
	name = "Wash Hands"
	expected_target_type = /atom
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEVER_AUTOMATIC

/decl/interaction_handler/wash_hands/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..() && !istype(prop) && target?.reagents?.has_reagent(/decl/material/liquid/water, 150)
	if(.)
		for(var/hand_slot in user.get_held_item_slots())
			var/obj/item/organ/external/organ = user.get_organ(hand_slot)
			if(istype(organ) && organ.is_washable)
				return TRUE

/decl/interaction_handler/wash_hands/invoked(atom/target, mob/user, obj/item/prop)

	// Probably needs debounce and do_after() but showers and wading into water don't, so whatever.
	if(!target?.reagents?.has_reagent(/decl/material/liquid/water, 150)) // To avoid washing your hands in beakers.
		to_chat(user, SPAN_WARNING("\The [src] doesn't have enough water in it to wash your hands."))
		return

	var/found_hand = FALSE
	for(var/hand_slot in user.get_held_item_slots())
		var/obj/item/organ/external/organ = user.get_organ(hand_slot)
		if(istype(organ) && organ.is_washable)
			found_hand = TRUE
			break

	if(!found_hand)
		return FALSE

	var/decl/pronouns/pronouns = user.get_pronouns()
	if(isturf(target))
		var/turf/turf = target
		var/fluid = turf.get_fluid_name()
		user.visible_message(
			SPAN_NOTICE("\The [user] washes [pronouns.his] hands in \the [fluid]."),
			SPAN_NOTICE("You wash your hands in \the [fluid].")
		)
	else
		user.visible_message(
			SPAN_NOTICE("\The [user] washes [pronouns.his] hands in \the [target]."),
			SPAN_NOTICE("You wash your hands in \the [target].")
		)

	user.clean()
	playsound(user.loc, 'sound/effects/slosh.ogg', 25, 1)
	return TRUE

/decl/interaction_handler/drink
	name = "Drink"
	expected_target_type = /atom
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEVER_AUTOMATIC

/decl/interaction_handler/drink/is_possible(atom/target, mob/user, obj/item/prop)
	return ..() && !istype(prop) && target.can_drink_from(user)

/decl/interaction_handler/drink/invoked(atom/target, mob/user, obj/item/prop)

	// Items can be picked up and drunk from, this interaction is for turfs and structures.
	if(istype(target, /obj/item))
		return

	if(!user.check_has_mouth())
		target.show_food_no_mouth_message(user, user)
		return

	if(!target?.reagents?.total_volume)
		target.show_food_empty_message(user, EATING_METHOD_DRINK)
		return

	if(!user.can_eat_food_currently(null, user, EATING_METHOD_DRINK))
		return

	var/blocked = user.check_mouth_coverage()
	if(blocked)
		to_chat(user, SPAN_NOTICE("\The [blocked] is in the way!"))
		return

	var/fluid_name = "\the [target]"
	if(isturf(target))
		var/turf/target_turf = target
		fluid_name = "\the [target_turf.get_fluid_name()]"

	user.visible_message(
		SPAN_NOTICE("\The [user] drinks from [fluid_name]."),
		SPAN_NOTICE("You drink from [fluid_name].")
	)
	target.reagents.trans_to_mob(user, 5, CHEM_INGEST)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)
