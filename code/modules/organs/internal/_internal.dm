/****************************************************
				INTERNAL ORGANS DEFINES
****************************************************/
/obj/item/organ/internal
	abstract_type = /obj/item/organ/internal
	scale_max_damage_to_species_health = TRUE

	// Damage healing vars (moved here from brains)
	/// Number of gradiations of damage we can recover in. ie. set to 10, we can recover up to the most recent 10% damage. Leave null to disable regen.
	var/damage_threshold_count = 5
	/// Max threshold before we stop regenerating without stabilizer.
	var/max_regeneration_cutoff_threshold = 3
	/// Min threshold at which we stop regenerating back to 0 damage. Null/0 to always respect thresholds.
	var/min_regeneration_cutoff_threshold
	/// Actual amount of health constituting one gradiation.
	var/damage_threshold_value

	var/tmp/alive_icon //icon to use when the organ is alive
	var/tmp/dead_icon // Icon to use when the organ has died.
	var/tmp/prosthetic_icon //Icon to use when the organ is robotic
	var/tmp/prosthetic_dead_icon //Icon to use when the organ is robotic and dead
	var/surface_accessible = FALSE
	var/relative_size = 25   // Relative size of the organ. Roughly % of space they take in the target projection :D
	var/min_bruised_damage = 10       // Damage before considered bruised
	var/damage_reduction = 0.5     //modifier for internal organ injury

	/// Whether or not we should try to transfer a brainmob when removed or replaced in a mob.
	var/transfer_brainmob_with_organ = FALSE

/obj/item/organ/internal/Initialize(mapload, material_key, datum/mob_snapshot/supplied_appearance, decl/bodytype/new_bodytype)
	if(!alive_icon)
		alive_icon = initial(icon_state)
	. = ..()
	set_max_damage(absolute_max_damage)

/obj/item/organ/internal/set_species(species_name)
	. = ..()
	if(species.organs_icon)
		icon = species.organs_icon

/obj/item/organ/internal/do_install(mob/living/human/target, obj/item/organ/external/affected, in_place, update_icon, detached)
	. = ..()

	if(!affected)
		log_warning("'[src]' called obj/item/organ/internal/do_install(), but its expected parent organ is null!")

	//The organ may only update and etc if its being attached, or isn't cut away.
	//Calls up the chain should have set the CUT_AWAY flag already
	if(status & ORGAN_CUT_AWAY)
		LAZYDISTINCTADD(affected.implants, src) //Add us to the detached organs list
		LAZYREMOVE(affected.internal_organs, src)
	else
		STOP_PROCESSING(SSobj, src)
		LAZYREMOVE(affected.implants, src) //Make sure we're not in the implant list anymore
		LAZYDISTINCTADD(affected.internal_organs, src)
		affected.cavity_max_w_class = max(affected.cavity_max_w_class, w_class)
		affected.update_internal_organs_cost()

/obj/item/organ/internal/do_uninstall(in_place, detach, ignore_children, update_icon)

	var/mob/living/victim = owner // cleared in parent proc

	//Make sure we're removed from whatever parent organ we have, either in a mob or not
	var/obj/item/organ/external/affected
	if(owner)
		affected = GET_EXTERNAL_ORGAN(owner, parent_organ)
	else if(istype(loc, /obj/item/organ/external))
		var/obj/item/organ/external/E = loc
		if(E.organ_tag == parent_organ)
			affected = E
	//We can be removed from a mob even if we have no parents, if we're in a detached state
	if(affected)
		LAZYREMOVE(affected.internal_organs, src)
		affected.update_internal_organs_cost()

	. = ..()

	//Remove it from the implants if we are fully removing, or add it to the implants if we are detaching
	if(affected)
		if((status & ORGAN_CUT_AWAY) && detach)
			LAZYDISTINCTADD(affected.implants, src)
		else
			LAZYREMOVE(affected.implants, src)

	if(transfer_brainmob_with_organ && istype(victim))
		transfer_key_to_brainmob(victim, update_brainmob = TRUE)

//#TODO: Remove rejuv hacks
/obj/item/organ/internal/remove_rejuv()
	do_uninstall()
	..()

/obj/item/organ/internal/is_usable()
	return ..() && !is_broken()

/obj/item/organ/internal/proc/getToxLoss()
	if(BP_IS_PROSTHETIC(src))
		return damage * 0.5
	return damage

/obj/item/organ/internal/proc/bruise()
	damage = max(damage, min_bruised_damage)

/obj/item/organ/internal/proc/is_bruised()
	return damage >= min_bruised_damage

/obj/item/organ/internal/set_max_damage(var/ndamage)
	. = ..()
	min_broken_damage = floor(0.75 * max_damage)
	min_bruised_damage = floor(0.25 * max_damage)
	if(damage_threshold_count > 0)
		damage_threshold_value = round(max_damage / damage_threshold_count)

/obj/item/organ/internal/take_general_damage(var/amount, var/silent = FALSE)
	take_internal_damage(amount, silent)

/obj/item/organ/internal/proc/take_internal_damage(amount, var/silent=0)
	if(BP_IS_PROSTHETIC(src))
		damage = clamp(src.damage + (amount * 0.8), 0, max_damage)
	else
		damage = clamp(src.damage + amount, 0, max_damage)

		//only show this if the organ is not robotic
		if(owner && can_feel_pain() && parent_organ && (amount > 5 || prob(10)))
			var/obj/item/organ/external/parent = GET_EXTERNAL_ORGAN(owner, parent_organ)
			if(parent && !silent)
				var/degree = ""
				if(is_bruised())
					degree = " a lot"
				if(damage < 5)
					degree = " a bit"
				owner.custom_pain("Something inside your [parent.name] hurts[degree].", amount, affecting = parent)

/obj/item/organ/internal/proc/get_visible_state()
	if(damage > max_damage)
		. = "bits and pieces of a destroyed "
	else if(is_broken())
		. = "broken "
	else if(is_bruised())
		. = "badly damaged "
	else if(damage > 5)
		. = "damaged "
	if(status & ORGAN_DEAD)
		if(can_recover())
			. = "decaying [.]"
		else
			. = "necrotic [.]"
	if(BP_IS_CRYSTAL(src))
		. = "crystalline "
	else if(BP_IS_PROSTHETIC(src))
		. = "mechanical "
	. = "[.][name]"

/obj/item/organ/internal/Process()
	SHOULD_CALL_PARENT(TRUE)
	..()
	if(owner && damage && !(status & ORGAN_DEAD))
		handle_damage_effects()

/obj/item/organ/internal/proc/has_limited_healing()
	return !min_regeneration_cutoff_threshold || past_damage_threshold(min_regeneration_cutoff_threshold)

/obj/item/organ/internal/proc/handle_damage_effects()
	SHOULD_CALL_PARENT(TRUE)
	if(organ_can_heal())

		// Determine the lowest our damage can go with the current state.
		// If we're under the min regeneration cutoff threshold, we can always heal to zero.
		// If we don't have one set, we can only heal to the nearest threshold value.
		var/min_heal_val = has_limited_healing() ? (get_current_damage_threshold() * damage_threshold_value) : 0

		// We clamp/round here so that we don't accidentally heal past the threshold and
		// cheat our way into a full second threshold of healing.
		damage = clamp(damage-get_organ_heal_amount(), min_heal_val, absolute_max_damage)

		// If we're within 1 damage of the nearest threshold (such as 0), round us down.
		// This should be removed when float-aware modulo comes in in 515, but for now is needed
		// as modulo only deals with integers, but organ regeneration is <= 0.3 by default.
		if(!(damage % damage_threshold_value))
			damage = round(damage)

/obj/item/organ/internal/proc/get_organ_heal_amount()
	if(damage >= min_broken_damage)
		return 0.1
	if(damage >= min_bruised_damage)
		return 0.2
	return 0.3

/obj/item/organ/internal/proc/organ_can_heal()
	// We cannot regenerate, period.
	if(!damage_threshold_count || !damage_threshold_value || BP_IS_PROSTHETIC(src))
		return FALSE
	// Our owner is under stress.
	if(owner.get_blood_oxygenation() < BLOOD_VOLUME_SAFE || GET_CHEMICAL_EFFECT(owner, CE_TOXIN) || owner.radiation || owner.is_asystole())
		return FALSE
	// If we haven't hit the regeneration cutoff point, heal.
	if(min_regeneration_cutoff_threshold && !past_damage_threshold(min_regeneration_cutoff_threshold))
		return TRUE
	// We have room to heal within this threshold, and we either:
	// - do not have a max cutoff threshold (point at which no further regeneration will occur)
	// - are not past our max cutoff threshold
	// - are dosed with stabilizer (ignores max cutoff threshold)
	if((damage % damage_threshold_value) && (!max_regeneration_cutoff_threshold || !past_damage_threshold(max_regeneration_cutoff_threshold) || GET_CHEMICAL_EFFECT(owner, CE_STABLE)))
		return TRUE
	return FALSE

/obj/item/organ/internal/proc/surgical_fix(mob/user)
	if(damage > min_broken_damage)
		var/scarring = damage/max_damage
		scarring = 1 - 0.3 * scarring ** 2 // Between ~15 and 30 percent loss
		var/new_max_dam = floor(scarring * max_damage)
		if(new_max_dam < max_damage)
			to_chat(user, SPAN_WARNING("Not every part of [src] could be saved; some dead tissue had to be removed, making it more susceptible to damage in the future."))
			set_max_damage(new_max_dam)
	heal_damage(damage)

/obj/item/organ/internal/proc/get_scarring_level()
	. = (absolute_max_damage - max_damage)/absolute_max_damage

/obj/item/organ/internal/get_scan_results()
	. = ..()
	var/scar_level = get_scarring_level()
	if(scar_level > 0.01)
		. += "[get_wound_severity(get_scarring_level())] scarring"

/obj/item/organ/internal/emp_act(severity)
	if(!BP_IS_PROSTHETIC(src))
		return
	switch (severity)
		if (1)
			take_internal_damage(16)
		if (2)
			take_internal_damage(9)
		if (3)
			take_internal_damage(6.5)

/obj/item/organ/internal/on_update_icon()
	. = ..()
	if(BP_IS_PROSTHETIC(src) && prosthetic_icon)
		icon_state = ((status & ORGAN_DEAD) && prosthetic_dead_icon) ? prosthetic_dead_icon : prosthetic_icon
	else
		icon_state = ((status & ORGAN_DEAD) && dead_icon) ? dead_icon : alive_icon

/obj/item/organ/internal/is_internal()
	return TRUE

// Damage recovery procs! Very exciting.
/obj/item/organ/internal/proc/get_current_damage_threshold()
	return damage_threshold_value > 0 ? round(damage / damage_threshold_value) : INFINITY

/obj/item/organ/internal/proc/past_damage_threshold(var/threshold)
	return (get_current_damage_threshold() > threshold)

/obj/item/organ/internal/on_add_effects()
	. = ..()
	if(parent_organ && owner)
		var/obj/item/organ/O = owner.get_organ(parent_organ)
		if(O)
			O.vital_to_owner = null

/obj/item/organ/internal/on_remove_effects(mob/living/last_owner)
	. = ..()
	if(parent_organ && last_owner)
		var/obj/item/organ/O = last_owner.get_organ(parent_organ)
		if(O)
			O.vital_to_owner = null

// Stub to allow brain interfaces to return their wrapped brainmob.
/obj/item/organ/internal/proc/get_brainmob(var/create_if_missing = FALSE)
	return

/obj/item/organ/internal/proc/transfer_key_to_brainmob(var/mob/living/M, var/update_brainmob = TRUE)
	var/mob/living/brainmob = get_brainmob(create_if_missing = TRUE)
	if(brainmob)
		transfer_key_from_mob_to_mob(M, brainmob)
		if(update_brainmob)
			brainmob.SetName(M.real_name)
			brainmob.real_name = M.real_name
			brainmob.languages = M.languages?.Copy()
			brainmob.default_language = M.default_language
			to_chat(brainmob, SPAN_NOTICE("You feel slightly disoriented. That's normal when you're just \a [initial(src.name)]."))
			RAISE_EVENT(/decl/observ/debrain, brainmob, src, M)
		return TRUE
	return FALSE

/obj/item/organ/internal/proc/get_synthetic_owner_name()
	return "Cyborg"

/obj/item/organ/internal/preserve_in_cryopod(var/obj/machinery/cryopod/pod)
	var/mob/living/brainmob = get_brainmob()
	return brainmob?.key

// This might need revisiting to stop people successfully implanting brains in groins and transferring minds.
/obj/item/organ/internal/do_install(mob/living/human/target, obj/item/organ/external/affected, in_place, update_icon, detached)
	. = ..()
	if(transfer_brainmob_with_organ && istype(owner))
		var/mob/living/brainmob = get_brainmob(create_if_missing = FALSE)
		if(brainmob?.key)
			transfer_key_from_mob_to_mob(brainmob, owner)
