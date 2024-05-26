/mob/living/proc/make_reagent(amount, reagent_type)
	if(stat != DEAD && reagents)
		var/limit = max(0, reagents.get_overdose(reagent_type) - REAGENT_VOLUME(reagents, reagent_type))
		add_to_reagents(reagent_type, min(amount, limit))

/mob/living/proc/handle_suit_punctures(var/damtype, var/damage, var/def_zone)

	// Tox and oxy don't matter to suits.
	if(damtype != BURN && damtype != BRUTE) return

	// The rig might soak this hit, if we're wearing one.
	var/obj/item/rig/rig = get_rig()
	if(rig)
		rig.take_hit(damage)

	// We may also be taking a suit breach.
	var/obj/item/clothing/suit/space/suit = get_equipped_item(slot_wear_suit_str)
	if(istype(suit))
		suit.create_breaches(damtype, damage)

/mob/living/take_damage(damage, damage_type = BRUTE, damage_flags, used_weapon, armor_pen = 0, target_zone, silent = FALSE, do_update_health = TRUE)

	if(status_flags & GODMODE)
		return FALSE

	if(!damage)
		return FALSE

	var/list/after_armor = modify_damage_by_armor(target_zone, damage, damage_type, damage_flags, src, armor_pen, silent)
	damage = after_armor[1]
	damage_type = after_armor[2]
	damage_flags = after_armor[3] // args modifications in case of parent calls

	if(!damage)
		return FALSE

	// Organs handle a subset of other types of damage.
	var/static/list/organ_relevant_damage_types = list(BRUTE, BURN, PAIN, CLONE)
	if((damage_type in organ_relevant_damage_types) && length(get_external_organs()))

		var/obj/item/organ/external/organ = get_organ(target_zone)
		if(!organ)
			if(isorgan(target_zone))
				organ = target_zone
			else
				if(!target_zone)
					if(damage_flags & DAM_DISPERSED)
						var/old_damage = damage
						var/tally
						silent = TRUE // Will damage a lot of organs, probably, so avoid spam.
						for(var/zone in organ_rel_size)
							tally += organ_rel_size[zone]
						for(var/zone in organ_rel_size)
							damage = old_damage * organ_rel_size[zone]/tally
							target_zone = zone
							. = .() || .
						return
					target_zone = ran_zone(target_zone, target = src)
				organ = GET_EXTERNAL_ORGAN(src, check_zone(target_zone, src))

		if(!istype(organ))
			return // This is reasonable and means the organ is missing.

		handle_suit_punctures(damage_type, damage, target_zone)

		if(damage > 15 && prob(damage*4) && organ.can_feel_pain())
			make_reagent(round(damage/10), /decl/material/liquid/adrenaline)

		var/datum/wound/created_wound
		damageoverlaytemp = 20
		switch(damage_type)
			if(BRUTE)
				created_wound = organ.take_external_damage(damage, 0, damage_flags, used_weapon)
			if(BURN)
				created_wound = organ.take_external_damage(0, damage, damage_flags, used_weapon)
			if(PAIN)
				organ.add_pain(damage)
			if(CLONE)
				organ.add_genetic_damage(damage)

		// Will set our damageoverlay icon to the next level, which will then be set back to the normal level the next mob.Life().
		update_health()
		BITSET(hud_updateflag, HEALTH_HUD)
		return created_wound

	switch(damage_type)
		if(BRUTE)
			return adjustBruteLoss(damage, do_update_health)
		if(BURN)
			if(MUTATION_COLD_RESISTANCE in mutations)
				return
			return adjustFireLoss(damage, do_update_health)
		if(TOX)
			return adjustToxLoss(damage, do_update_health)
		if(CLONE)
			return adjustCloneLoss(damage, do_update_health)
		if(OXY)
			return adjustOxyLoss(damage, do_update_health)
		if(PAIN)
			return adjustHalLoss(damage, do_update_health)
		if(IRRADIATE)
			return apply_radiation(damage)
		if(BRAIN)
			return adjustBrainLoss(damage, do_update_health)
		if(ELECTROCUTE)
			electrocute_act(damage, used_weapon, 1, target_zone)
	return 0

/mob/living/setBruteLoss(var/amount)
	take_damage((amount * 0.5)-get_damage(BRUTE))

/mob/living/getBruteLoss()
	return get_max_health() - current_health

/mob/living/adjustToxLoss(var/amount, var/do_update_health = TRUE)
	take_damage(amount * 0.5, do_update_health = do_update_health)

/mob/living/setToxLoss(var/amount)
	take_damage((amount * 0.5)-get_damage(BRUTE))

/mob/living/adjustFireLoss(var/amount, var/do_update_health = TRUE)
	take_damage(amount * 0.5, do_update_health = do_update_health)

/mob/living/setFireLoss(var/amount)
	take_damage((amount * 0.5)-get_damage(BRUTE))

/mob/living/adjustHalLoss(var/amount, var/do_update_health = TRUE)
	take_damage(amount * 0.5, do_update_health = do_update_health)

/mob/living/setHalLoss(var/amount)
	take_damage((amount * 0.5)-get_damage(BRUTE))
