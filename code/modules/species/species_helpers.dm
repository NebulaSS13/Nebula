var/global/list/stored_shock_by_ref = list()

/mob/living/proc/apply_stored_shock_to(var/mob/living/target)
	if(stored_shock_by_ref["\ref[src]"])
		target.electrocute_act(stored_shock_by_ref["\ref[src]"]*0.9, src)
		stored_shock_by_ref["\ref[src]"] = 0

/decl/species/proc/toggle_stance(var/mob/living/human/H)
	if(!H.incapacitated())
		H.pulling_punches = !H.pulling_punches
		to_chat(H, "<span class='notice'>You are now [H.pulling_punches ? "pulling your punches" : "not pulling your punches"].</span>")

/decl/species/proc/fluid_act(var/mob/living/human/H, var/datum/reagents/fluids)
	SHOULD_CALL_PARENT(TRUE)
	var/water = REAGENT_VOLUME(fluids, /decl/material/liquid/water)
	if(water >= 40 && H.get_damage(PAIN))
		H.heal_damage(PAIN, water_soothe_amount)
		if(prob(5))
			to_chat(H, SPAN_NOTICE("The water ripples gently over your skin in a soothing balm."))

/decl/species/proc/is_available_for_join()
	if(!(spawn_flags & SPECIES_CAN_JOIN))
		return FALSE
	else if(!isnull(max_players))
		var/player_count = 0
		for(var/mob/living/human/H in global.living_mob_list_)
			if(H.client && H.key && H.species == src)
				player_count++
				if(player_count >= max_players)
					return FALSE
	return TRUE

/decl/species/proc/check_background(var/datum/job/job, var/datum/preferences/prefs)
	. = TRUE

/decl/species/proc/get_digestion_product()
	return /decl/material/liquid/nutriment

/decl/species/proc/handle_post_species_pref_set(datum/preferences/pref)
	pref.skin_colour = default_bodytype.base_color
	pref.eye_colour = default_bodytype.base_eye_color
//	pref.hair_colour = default_bodytype.base_hair_color
//	pref.facial_hair_colour = default_bodytype.base_hair_color

/decl/species/proc/equip_default_fallback_uniform(var/mob/living/human/H)
	if(istype(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shirt/harness, slot_w_uniform_str)

/decl/species/proc/get_hazard_high_pressure(var/mob/living/human/H)
	return hazard_high_pressure

/decl/species/proc/get_warning_high_pressure(var/mob/living/human/H)
	return warning_high_pressure

/decl/species/proc/get_warning_low_pressure(var/mob/living/human/H)
	return warning_low_pressure

/decl/species/proc/get_hazard_low_pressure(var/mob/living/human/H)
	return hazard_low_pressure

/decl/species/proc/get_shock_vulnerability(var/mob/living/human/H)
	return shock_vulnerability

/decl/species/proc/adjust_status(mob/living/target, condition, amount)
	switch(condition)
		if(STAT_WEAK)
			return amount * weaken_mod
		if(STAT_STUN)
			return amount * stun_mod
		if(STAT_PARA)
			return amount * paralysis_mod
	return amount
