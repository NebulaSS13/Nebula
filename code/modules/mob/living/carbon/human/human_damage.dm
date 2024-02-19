/mob/living/carbon/human/proc/get_suffocation_percent()
	return (get_damage(OXY) / species.total_health) * 100

// Special override as humans ignore body damage.
/mob/living/carbon/human/get_total_life_damage()
	return get_brain_damage()

//Updates the mob's health from organs and mob damage variables
/mob/living/carbon/human/update_health()
	..()
	//TODO: fix husking
	if(stat == DEAD && (get_max_health() - get_damage(/decl/damage_handler/burn)) < get_config_value(/decl/config/num/health_health_threshold_dead))
		make_husked()

/mob/living/carbon/human/adjust_brain_damage(var/amount)
	if(!(status_flags & GODMODE) && should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/sponge = GET_INTERNAL_ORGAN(src, BP_BRAIN)
		if(sponge)
			sponge.take_damage(amount, TOX)
	..()

/mob/living/carbon/human/set_brain_damage(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/sponge = GET_INTERNAL_ORGAN(src, BP_BRAIN)
		if(sponge)
			sponge.organ_damage = min(max(amount, 0),sponge.species.total_health)
			update_health()

/mob/living/carbon/human/get_brain_damage()
	if(status_flags & GODMODE)	return 0	//godmode
	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/sponge = GET_INTERNAL_ORGAN(src, BP_BRAIN)
		if(sponge)
			if(sponge.status & ORGAN_DEAD)
				return sponge.species.total_health
			else
				return sponge.organ_damage
		else
			return species.total_health
	return 0

/mob/living/carbon/human/proc/can_autoheal(var/dam_type)
	if(!species || !dam_type) return FALSE
	if(dam_type == BRUTE)
		return(get_damage(BRUTE) < species.total_health / 2)
	else if(dam_type == BURN)
		return(get_damage(BURN) < species.total_health / 2)
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

	if(!lying)
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
