/obj/item/smoker
	name = "smoker"
	desc = "A device used to calm insects down before harvesting from a hive."
	icon = 'mods/content/beekeeping/icons/smoker.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/steel

// TODO: consume reagents or charges? Unnecessary complexity?
/obj/item/smoker/resolve_attackby(atom/A, mob/user, click_params)

	if(!user.check_dexterity(get_required_attack_dexterity(user, A)))
		return TRUE

	var/smoked = FALSE
	if(has_extension(A, /datum/extension/insect_hive))
		var/datum/extension/insect_hive/hive = get_extension(A, /datum/extension/insect_hive)
		if(hive.smoked_by(user, A))
			smoked = TRUE

	if(!smoked && isturf(A))
		for(var/obj/effect/insect_swarm/swarm in A)
			swarm.was_smoked(smoke_time = 1 MINUTE)
			smoked = TRUE

	if(smoked)
		var/turf/smoked_turf = get_turf(A)
		if(smoked_turf)
			playsound(smoked_turf, 'sound/effects/refill.ogg', 25, 1)
			user.visible_message(SPAN_NOTICE("\The [user] douses \the [A] in smoke from \the [src]."))
			new /obj/effect/effect/smoke(smoked_turf, 2 SECONDS)
		return TRUE

	return ..()
