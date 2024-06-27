//this proc returns the Siemens coefficient of electrical resistivity for a particular external organ.
/mob/living/proc/get_siemens_coefficient_organ(var/obj/item/organ/external/def_zone)
	if (!def_zone)
		return 1.0

	var/siemens_coefficient = max(get_species()?.get_shock_vulnerability(src), 0)
	for(var/slot in global.standard_clothing_slots)
		var/obj/item/clothing/C = get_equipped_item(slot)
		if(istype(C) && (C.body_parts_covered & def_zone.body_part)) // Is that body part being targeted covered?
			siemens_coefficient *= C.siemens_coefficient

	return siemens_coefficient

//Electrical shock
/mob/living/proc/apply_shock(var/shock_damage, var/def_zone, var/base_siemens_coeff = 1.0)

	var/list/shock_organs = get_external_organs()
	if(!length(shock_organs))
		// TODO: check armor or Siemen's coefficient for non-human mobs
		apply_damage(shock_damage, BURN, used_weapon = "Electrocution")
		return

	var/obj/item/organ/external/initial_organ = GET_EXTERNAL_ORGAN(src, check_zone(def_zone, src))
	if(!initial_organ)
		initial_organ = pick(shock_organs)

	var/obj/item/organ/external/floor_organ
	if(!current_posture?.prone)
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
	if(!length(to_shock))
		return 0

	shock_damage /= length(to_shock)
	shock_damage = round(shock_damage, 0.1)

	for(var/obj/item/organ/external/E in to_shock)
		var/actual_shock_damage = max(1, round(shock_damage * base_siemens_coeff * get_siemens_coefficient_organ(E)))
		if(actual_shock_damage)
			apply_damage(shock_damage, BURN, E.organ_tag, used_weapon="Electrocution")
			. += actual_shock_damage

	if(. > 10)
		local_emp(initial_organ, 3)

/mob/living/proc/trace_shock(var/obj/item/organ/external/init, var/obj/item/organ/external/floor)

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

/mob/living/proc/local_emp(var/list/limbs, var/severity = 2)
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
