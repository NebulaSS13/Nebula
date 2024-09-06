/obj/item/get_alt_interactions(var/mob/user)
	. = ..()
	if(get_config_value(/decl/config/toggle/expanded_alt_interactions))
		LAZYADD(., list(
			/decl/interaction_handler/pick_up,
			/decl/interaction_handler/drop,
			/decl/interaction_handler/use
		))

/decl/interaction_handler/use
	name = "Use"
	expected_target_type = /obj/item

/decl/interaction_handler/use/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/item/I = target
	I.attack_self(user)

/decl/interaction_handler/pick_up
	name = "Pick Up"
	expected_target_type = /obj/item

/decl/interaction_handler/pick_up/invoked(atom/target, mob/user, obj/item/prop)
	target.attack_hand_with_interaction_checks(user)

/decl/interaction_handler/drop
	name = "Drop"
	expected_target_type = /obj/item
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION | INTERACTION_NEEDS_INVENTORY

/decl/interaction_handler/drop/invoked(atom/target, mob/user, obj/item/prop)
	user.try_unequip(target, user.loc)

/decl/interaction_handler/storage_open
	name = "Open Storage"
	expected_target_type = /atom
	incapacitation_flags = INCAPACITATION_DISRUPTED

/decl/interaction_handler/storage_open/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..() && (ishuman(user) || isrobot(user) || issmall(user)) && target?.storage

/decl/interaction_handler/storage_open/invoked(atom/target, mob/user, obj/item/prop)
	target?.storage?.open(user)

/decl/interaction_handler/wash_hands
	name = "Wash Hands"
	expected_target_type = /atom
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION

/decl/interaction_handler/wash_hands/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..() && target?.reagents?.has_reagent(/decl/material/liquid/water, 150)
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
		return

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
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/decl/interaction_handler/drink
	name = "Drink"
	expected_target_type = /atom
	interaction_flags = INTERACTION_NEEDS_PHYSICAL_INTERACTION

/decl/interaction_handler/drink/is_possible(atom/target, mob/user, obj/item/prop)
	return ..() && target?.reagents?.total_volume && user.check_has_mouth() && !istype(target, /obj/item)

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

	user.visible_message(
		SPAN_NOTICE("\The [user] drinks from \the [target]."),
		SPAN_NOTICE("You drink from \the [target].")
	)
	target.reagents.trans_to_mob(user, 5, CHEM_INGEST)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
