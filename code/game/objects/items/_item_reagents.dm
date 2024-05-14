/obj/item/proc/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target) // This goes into afterattack
	if(!istype(target) || (target.atom_flags & ATOM_FLAG_OPEN_CONTAINER))
		return 0

	if(!target.reagents || !target.reagents.total_volume)
		to_chat(user, SPAN_NOTICE("[target] is empty."))
		return 1

	if(reagents && !REAGENTS_FREE_SPACE(reagents))
		to_chat(user, SPAN_NOTICE("[src] is full."))
		return 1

	var/trans = target.reagents.trans_to_obj(src, target.amount_dispensed)
	to_chat(user, SPAN_NOTICE("You fill [src] with [trans] units of the contents of [target]."))
	return 1

/obj/item/proc/standard_splash_mob(var/mob/user, var/mob/target) // This goes into afterattack
	if(!istype(target))
		return

	if(user.a_intent == I_HELP)
		to_chat(user, SPAN_NOTICE("You can't splash people on help intent."))
		return 1

	if(!reagents || !reagents.total_volume)
		to_chat(user, SPAN_NOTICE("[src] is empty."))
		return 1

	if(target.reagents && !REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, SPAN_NOTICE("[target] is full."))
		return 1

	var/contained = REAGENT_LIST(src)

	admin_attack_log(user, target, "Used \the [name] containing [contained] to splash the victim.", "Was splashed by \the [name] containing [contained].", "used \the [name] containing [contained] to splash")
	user.visible_message( \
		SPAN_DANGER("\The [target] has been splashed with the contents of \the [src] by \the [user]!"), \
		SPAN_DANGER("You splash \the [target] with the contents of \the [src]."))

	reagents.splash(target, reagents.total_volume)
	return 1


/obj/item/proc/standard_pour_into(mob/user, atom/target, amount = 5) // This goes into afterattack and yes, it's atom-level
	if(!target.reagents)
		return 0

	// Ensure we don't splash beakers and similar containers.
	if(!ATOM_IS_OPEN_CONTAINER(target) && istype(target, /obj/item/chems))
		to_chat(user, SPAN_NOTICE("\The [target] is closed."))
		return 1
	// Otherwise don't care about splashing.
	else if(!ATOM_IS_OPEN_CONTAINER(target))
		return 0

	if(!reagents || !reagents.total_volume)
		to_chat(user, SPAN_NOTICE("[src] is empty."))
		return 1

	if(!REAGENTS_FREE_SPACE(target.reagents))
		to_chat(user, SPAN_NOTICE("[target] is full."))
		return 1

	var/trans = reagents.trans_to(target, amount)
	playsound(src, 'sound/effects/pour.ogg', 25, 1)
	to_chat(user, SPAN_NOTICE("You transfer [trans] unit\s of the solution to \the [target].  \The [src] now contains [src.reagents.total_volume] units."))
	return 1