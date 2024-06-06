/mob/living/carbon/human/get_life_damage_types()
	var/static/list/life_damage_types = list(
		BRAIN
	)
	return life_damage_types

//Updates the mob's health from organs and mob damage variables
/mob/living/carbon/human/update_health()
	. = ..()
	//TODO: fix husking
	if(. && stat == DEAD && (get_damage(BRUTE) - get_damage(BURN)) < get_config_value(/decl/config/num/health_health_threshold_dead))
		make_husked()

/mob/living/carbon/human/adjustBrainLoss(var/amount, var/do_update_health = TRUE)
	if(!(status_flags & GODMODE) && should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/sponge = GET_INTERNAL_ORGAN(src, BP_BRAIN)
		if(sponge)
			sponge.take_internal_damage(amount)
	..()

/mob/living/carbon/human/setBrainLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/sponge = GET_INTERNAL_ORGAN(src, BP_BRAIN)
		if(sponge)
			sponge.damage = min(max(amount, 0),sponge.species.total_health)
			update_health()

/mob/living/carbon/human/getBrainLoss()
	if(status_flags & GODMODE)	return 0	//godmode
	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/sponge = GET_INTERNAL_ORGAN(src, BP_BRAIN)
		if(sponge)
			if(sponge.status & ORGAN_DEAD)
				return sponge.species.total_health
			else
				return sponge.damage
		else
			return species.total_health
	return 0

//Straight pain values, not affected by painkillers etc
/mob/living/carbon/human/getHalLoss()
	if(isnull(last_pain))
		last_pain = 0
		for(var/obj/item/organ/external/E in get_external_organs())
			last_pain += E.get_pain()
	return last_pain

/mob/living/carbon/human/setHalLoss(var/amount)
	take_damage(get_damage(PAIN)-amount, PAIN)

/mob/living/carbon/human/adjustHalLoss(var/amount, var/do_update_health = TRUE)
	var/heal = (amount < 0)
	amount = abs(amount)
	var/list/limbs = get_external_organs()
	if(LAZYLEN(limbs))
		var/list/pick_organs = limbs.Copy()
		while(amount > 0 && pick_organs.len)
			var/obj/item/organ/external/E = pick(pick_organs)
			pick_organs -= E
			if(!istype(E))
				continue

			if(heal)
				amount -= E.remove_pain(amount)
			else
				amount -= E.add_pain(amount)
	BITSET(hud_updateflag, HEALTH_HUD)
	if(do_update_health)
		update_health()

//These procs fetch a cumulative total damage from all organs
/mob/living/carbon/human/getBruteLoss()
	var/amount = 0
	for(var/obj/item/organ/external/O in get_external_organs())
		if(BP_IS_PROSTHETIC(O) && !O.is_vital_to_owner())
			continue //robot limbs don't count towards shock and crit
		amount += O.brute_dam
	return amount

/mob/living/carbon/human/getFireLoss()
	var/amount = 0
	for(var/obj/item/organ/external/O in get_external_organs())
		if(BP_IS_PROSTHETIC(O) && !O.is_vital_to_owner())
			continue //robot limbs don't count towards shock and crit
		amount += O.burn_dam
	return amount

/mob/living/carbon/human/adjustBruteLoss(var/amount, var/do_update_health = TRUE)
	SHOULD_CALL_PARENT(FALSE) // take/heal overall call update_health regardless of arg
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)
	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/adjustFireLoss(var/amount, var/do_update_health = TRUE)
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)
	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/getCloneLoss()
	var/amount = 0
	for(var/obj/item/organ/external/E in get_external_organs())
		amount += E.get_genetic_damage()
	return amount

/mob/living/carbon/human/setCloneLoss(var/amount)
	take_damage(get_damage(CLONE)-amount, CLONE)

/mob/living/carbon/human/adjustCloneLoss(var/amount, var/do_update_health = TRUE)
	var/heal = amount < 0
	amount = abs(amount)
	var/list/limbs = get_external_organs()
	if(LAZYLEN(limbs))
		var/list/pick_organs = limbs.Copy()
		while(amount > 0 && pick_organs.len)
			var/obj/item/organ/external/E = pick(pick_organs)
			pick_organs -= E
			if(heal)
				amount -= E.remove_genetic_damage(amount)
			else
				amount -= E.add_genetic_damage(amount)
	BITSET(hud_updateflag, HEALTH_HUD)
	..()

/mob/living/carbon/human/proc/getOxyLossPercent()
	return (get_damage(OXY) / species.total_health) * 100

/mob/living/carbon/human/getOxyLoss()
	if(need_breathe())
		var/obj/item/organ/internal/lungs/breathe_organ = get_organ(get_bodytype().breathing_organ, /obj/item/organ/internal/lungs)
		return breathe_organ ? breathe_organ.oxygen_deprivation : species.total_health
	return 0

/mob/living/carbon/human/setOxyLoss(var/amount)
	take_damage(amount - get_damage(OXY), OXY)

/mob/living/carbon/human/adjustOxyLoss(var/damage, var/do_update_health = TRUE)
	. = FALSE
	if(need_breathe())
		var/obj/item/organ/internal/lungs/breathe_organ = get_organ(get_bodytype().breathing_organ, /obj/item/organ/internal/lungs)
		if(breathe_organ)
			breathe_organ.adjust_oxygen_deprivation(damage)
			BITSET(hud_updateflag, HEALTH_HUD)
			. = TRUE
	..(do_update_health = FALSE) // Oxyloss cannot directly kill humans

/mob/living/carbon/human/getToxLoss()
	if((species.species_flags & SPECIES_FLAG_NO_POISON) || isSynthetic())
		return 0
	var/amount = 0
	for(var/obj/item/organ/internal/I in get_internal_organs())
		amount += I.getToxLoss()
	return amount

/mob/living/carbon/human/setToxLoss(var/amount)
	if(!(species.species_flags & SPECIES_FLAG_NO_POISON) && !isSynthetic())
		take_damage(get_damage(TOX)-amount, TOX)

// TODO: better internal organ damage procs.
/mob/living/carbon/human/adjustToxLoss(var/amount, var/do_update_health = TRUE)

	if((species.species_flags & SPECIES_FLAG_NO_POISON) || isSynthetic())
		return

	var/heal = amount < 0
	amount = abs(amount)

	if (!heal)
		amount *= get_toxin_resistance()
		var/antitox = GET_CHEMICAL_EFFECT(src, CE_ANTITOX)
		if(antitox)
			amount *= 1 - antitox * 0.25

	var/list/pick_organs = get_internal_organs()
	if(!LAZYLEN(pick_organs))
		return
	pick_organs = shuffle(pick_organs.Copy())

	// Prioritize damaging our filtration organs first.
	for(var/organ in list(BP_KIDNEYS, BP_LIVER))
		var/obj/item/organ/internal/lump = GET_INTERNAL_ORGAN(src, organ)
		if(lump)
			pick_organs -= lump
			pick_organs.Insert(1, lump)

	// Move the brain to the very end since damage to it is vastly more dangerous
	// (and isn't technically counted as toxloss) than general organ damage.
	var/obj/item/organ/internal/brain = GET_INTERNAL_ORGAN(src, BP_BRAIN)
	if(brain)
		pick_organs -= brain
		pick_organs += brain

	for(var/internal in pick_organs)
		var/obj/item/organ/internal/I = internal
		if(amount <= 0)
			break
		if(heal)
			if(I.damage < amount)
				amount -= I.damage
				I.damage = 0
			else
				I.damage -= amount
				amount = 0
		else
			var/cap_dam = I.max_damage - I.damage
			if(amount >= cap_dam)
				I.take_internal_damage(cap_dam, silent=TRUE)
				amount -= cap_dam
			else
				I.take_internal_damage(amount, silent=TRUE)
				amount = 0

	if(do_update_health)
		update_health()

/mob/living/carbon/human/proc/can_autoheal(var/dam_type)
	if(!species || !dam_type)
		return FALSE
	if(dam_type == BRUTE || dam_type == BURN)
		return(get_damage(dam_type) < species.total_health / 2)
	return FALSE

////////////////////////////////////////////

//Returns a list of damaged organs
/mob/living/carbon/human/proc/get_damaged_organs(var/brute, var/burn)
	var/list/obj/item/organ/external/parts = list()
	for(var/obj/item/organ/external/O in get_external_organs())
		if((brute && O.brute_dam) || (burn && O.burn_dam))
			parts += O
	return parts

//Returns a list of damageable organs
/mob/living/carbon/human/proc/get_damageable_organs()
	var/list/obj/item/organ/external/parts = list()
	for(var/obj/item/organ/external/O in get_external_organs())
		if(O.is_damageable())
			parts += O
	return parts

//Heals ONE external organ, organ gets randomly selected from damaged ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/heal_organ_damage(var/brute, var/burn, var/affect_robo = FALSE, var/update_health = TRUE)
	var/list/obj/item/organ/external/parts = get_damaged_organs(brute,burn)
	if(!parts.len)	return
	var/obj/item/organ/external/picked = pick(parts)
	if(picked.heal_organ_damage(brute,burn,robo_repair = affect_robo))
		BITSET(hud_updateflag, HEALTH_HUD)
	update_health()


//TODO reorganize damage procs so that there is a clean API for damaging living mobs

/*
In most cases it makes more sense to use take_damage() instead! And make sure to check armour if applicable.
*/
//Damages ONE external organ, organ gets randomly selected from damagable ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/take_organ_damage(var/brute = 0, var/burn = 0, var/bypass_armour = FALSE, var/override_droplimb)
	var/list/parts = get_damageable_organs()
	if(!length(parts))
		return
	var/obj/item/organ/external/picked = pick(parts)
	if(picked.take_external_damage(brute, burn, override_droplimb = override_droplimb))
		BITSET(hud_updateflag, HEALTH_HUD)
	update_health()

//Heal MANY external organs, in random order
/mob/living/carbon/human/heal_overall_damage(var/brute, var/burn)
	var/list/obj/item/organ/external/parts = get_damaged_organs(brute,burn)

	while(parts.len && (brute>0 || burn>0) )
		var/obj/item/organ/external/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		picked.heal_organ_damage(brute,burn)

		brute -= (brute_was-picked.brute_dam)
		burn -= (burn_was-picked.burn_dam)

		parts -= picked
	update_health()
	BITSET(hud_updateflag, HEALTH_HUD)

// damage MANY external organs, in random order
/mob/living/carbon/human/take_overall_damage(var/brute, var/burn, var/sharp = 0, var/edge = 0, var/used_weapon = null)
	if(status_flags & GODMODE)
		return	//godmode

	var/list/obj/item/organ/external/parts = get_damageable_organs()
	if(!parts.len)
		return

	var/dam_flags = (sharp? DAM_SHARP : 0)|(edge? DAM_EDGE : 0)
	var/brute_avg = brute / parts.len
	var/burn_avg = burn / parts.len
	for(var/obj/item/organ/external/E in parts)
		if(QDELETED(E))
			continue
		if(E.owner != src)
			continue // The code below may affect the children of an organ.

		if(brute_avg)
			take_damage(damage = brute_avg, damage_type = BRUTE, damage_flags = dam_flags, used_weapon = used_weapon, target_zone = E.organ_tag)
		if(burn_avg)
			take_damage(damage = burn_avg, damage_type = BURN, damage_flags = dam_flags, used_weapon = used_weapon, target_zone = E.organ_tag)

	update_health()
	BITSET(hud_updateflag, HEALTH_HUD)

/*
This function restores all organs.
*/
/mob/living/carbon/human/restore_all_organs(var/ignore_organ_aspects)
	get_bodytype()?.create_missing_organs(src) // root body part should never be missing on a mob
	for(var/bodypart in global.all_limb_tags_by_depth)
		var/obj/item/organ/external/current_organ = GET_EXTERNAL_ORGAN(src, bodypart)
		if(current_organ)
			current_organ.rejuvenate(ignore_organ_aspects)
	recheck_bad_external_organs()
	verbs -= /mob/living/carbon/human/proc/undislocate

// Find out in how much pain the mob is at the moment.
/mob/living/carbon/human/proc/get_shock()

	if (!can_feel_pain())
		return 0

	var/traumatic_shock = get_damage(PAIN)
	traumatic_shock -= GET_CHEMICAL_EFFECT(src, CE_PAINKILLER)

	if(stat == UNCONSCIOUS)
		traumatic_shock *= 0.6
	return max(0,traumatic_shock)

//Electrical shock

/mob/living/carbon/human/apply_shock(var/shock_damage, var/def_zone, var/base_siemens_coeff = 1.0)
	var/obj/item/organ/external/initial_organ = GET_EXTERNAL_ORGAN(src, check_zone(def_zone, src))
	if(!initial_organ)
		initial_organ = pick(get_external_organs())

	var/obj/item/organ/external/floor_organ

	if(!current_posture.prone)
		var/list/obj/item/organ/external/standing = list()
		for(var/limb_tag in list(BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, limb_tag)
			if(E && E.is_usable())
				standing[E.organ_tag] = E
		if((def_zone == BP_L_FOOT || def_zone == BP_L_LEG) && standing[BP_L_FOOT])
			floor_organ = standing[BP_L_FOOT]
		if((def_zone == BP_R_FOOT || def_zone == BP_R_LEG) && standing[BP_R_FOOT])
			floor_organ = standing[BP_R_FOOT]
		else
			floor_organ = standing[pick(standing)]

	if(!floor_organ)
		floor_organ = pick(get_external_organs())

	var/list/obj/item/organ/external/to_shock = trace_shock(initial_organ, floor_organ)

	if(to_shock && to_shock.len)
		shock_damage /= to_shock.len
		shock_damage = round(shock_damage, 0.1)
	else
		return 0

	var/total_damage = 0

	for(var/obj/item/organ/external/E in to_shock)
		total_damage += ..(shock_damage, E.organ_tag, base_siemens_coeff * get_siemens_coefficient_organ(E))

	if(total_damage > 10)
		local_emp(initial_organ, 3)

	return total_damage

/mob/living/carbon/human/proc/trace_shock(var/obj/item/organ/external/init, var/obj/item/organ/external/floor)
	var/list/obj/item/organ/external/traced_organs = list(floor)

	if(!init)
		return

	if(!floor || init == floor)
		return list(init)

	for(var/obj/item/organ/external/E in list(floor, init))
		while(E && E.parent_organ)
			var/candidate = GET_EXTERNAL_ORGAN(src, E.parent_organ)
			if(!candidate || (candidate in traced_organs))
				break // Organ parenthood is not guaranteed to be a tree
			E = candidate
			traced_organs += E
			if(E == init)
				return traced_organs

	return traced_organs

/mob/living/carbon/human/proc/local_emp(var/list/limbs, var/severity = 2)
	if(!islist(limbs))
		limbs = list(limbs)

	var/list/EMP = list()
	for(var/obj/item/organ/external/limb in limbs)
		EMP += limb
		if(LAZYLEN(limb.internal_organs))
			EMP += limb.internal_organs
		if(LAZYLEN(limb.implants))
			EMP += limb.implants
	for(var/atom/E in EMP)
		E.emp_act(severity)
