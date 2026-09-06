/obj/item/proc/standard_dispenser_refill(mob/user, obj/structure/target, skip_container_check = FALSE) // This goes into afterattack
	if(!istype(target) || isnull(target.get_reagent_amount_dispensed()) || (!skip_container_check && (target.atom_flags & ATOM_FLAG_OPEN_CONTAINER)))
		return FALSE

	if(!target.reagents || !REAGENT_TOTAL_VOLUME(target.reagents))
		to_chat(user, SPAN_NOTICE("[target] is empty of reagents."))
		return TRUE

	if(reagents && !REAGENTS_FREE_SPACE(reagents))
		to_chat(user, SPAN_NOTICE("[src] is full of reagents."))
		return TRUE

	var/trans = target.reagents.trans_to_obj(src, target.get_reagent_amount_dispensed())
	to_chat(user, SPAN_NOTICE("You fill [src] with [trans] units of the contents of [target]."))
	return TRUE

/obj/item/proc/standard_splash_mob(var/mob/user, var/mob/target) // This goes into afterattack
	if(!istype(target))
		return FALSE

	if(user.check_intent(I_FLAG_HELP))
		to_chat(user, SPAN_NOTICE("You can't splash people on help intent."))
		return TRUE

	if(!reagents || !REAGENT_TOTAL_VOLUME(reagents))
		to_chat(user, SPAN_NOTICE("[src] is empty of reagents."))
		return TRUE

	if(target.reagents && !REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, SPAN_NOTICE("[target] is full of reagents."))
		return TRUE

	var/contained = REAGENT_LIST(reagents)

	admin_attack_log(user, target, "Used \the [name] containing [contained] to splash the victim.", "Was splashed by \the [name] containing [contained].", "used \the [name] containing [contained] to splash")
	user.visible_message( \
		SPAN_DANGER("\The [target] has been splashed with the contents of \the [src] by \the [user]!"), \
		SPAN_DANGER("You splash \the [target] with the contents of \the [src]."))

	reagents.splash(target, REAGENT_TOTAL_VOLUME(reagents))
	return TRUE

/obj/item/proc/standard_pour_into(mob/user, atom/target, amount = 5) // This goes into afterattack and yes, it's atom-level
	if(!target.reagents)
		return FALSE

	if(!target.can_be_poured_into(src))
		// Ensure we don't splash beakers and similar containers.
		if(istype(target, /obj/item/chems))
			to_chat(user, SPAN_NOTICE("\The [target] is closed."))
			return TRUE
		// Otherwise don't care about splashing.
		return FALSE

	if(!can_be_poured_from(user, target))
		return TRUE // don't splash if we can't pour

	if(!reagents || !REAGENT_TOTAL_VOLUME(reagents))
		to_chat(user, SPAN_NOTICE("[src] is empty of reagents."))
		return TRUE

	if(!REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, SPAN_NOTICE("[target] is full of reagents."))
		return TRUE

	var/liquid_volumes = REAGENT_LIQUID_VOLUMES(reagents)
	var/had_liquids = length(liquid_volumes)
	var/transferred_amount = reagents.trans_to(target, amount)

	if(had_liquids)
		playsound(src, 'sound/effects/pour.ogg', 25, 1)
	else
		// Sounds more like pouring small pellets or dust.
		playsound(src, 'sound/effects/refill.ogg', 25, 1)
	to_chat(user, SPAN_NOTICE("You transfer [transferred_amount] unit\s of the solution to \the [target]. \The [src] now contains [REAGENT_TOTAL_VOLUME(reagents)] unit\s."))
	return TRUE
