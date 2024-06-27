/datum/ability_handler/grafadreka
	var/spit_projectile_type = /obj/item/projectile/drake_spit
	var/next_spit = 0

/datum/ability_handler/grafadreka/hatchling
	spit_projectile_type = /obj/item/projectile/drake_spit/weak

/datum/ability_handler/grafadreka/do_ranged_invocation(mob/user, atom/target)
	if(!istype(user) || user.a_intent != I_HURT || user.incapacitated() || !isatom(target))
		return FALSE
	if(world.time < next_spit)
		to_chat(user, SPAN_WARNING("You cannot spit again so soon!"))
		return TRUE
	if(!drake_spend_sap(user, 1))
		to_chat(user, SPAN_WARNING("You do not have enough sap stored to spit!"))
		return TRUE
	next_spit = world.time + 3 SECONDS
	user.visible_message(SPAN_DANGER("\The [user] spits at \the [target]!"))
	var/obj/item/projectile/spit = new spit_projectile_type(get_turf(user))
	if(spit)
		playsound(user, spit.fire_sound, 100, 1)
		spit.launch(target, user.get_target_zone(), user)
	return TRUE

/datum/ability_handler/grafadreka/do_melee_invocation(mob/user, atom/target)

	if(!istype(user) || user.incapacitated() || !isatom(target) || !target.Adjacent(user))
		return FALSE

	// Nibbles
	if(user.a_intent == I_HURT)
		if(isliving(target))
			return handle_dismemberment(user, target)
		if(istype(target, /obj/item/organ))
			return handle_organ_destruction(user, target)

	// Healing
	if(user.a_intent == I_HELP && isliving(target))
		return handle_wound_cleaning(user, target)

	return FALSE
