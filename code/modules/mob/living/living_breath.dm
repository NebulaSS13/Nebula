/mob/living/proc/handle_breathing()
	if(should_breathe() && need_breathe())
		try_breathe()
		return TRUE
	return FALSE

/mob/living/proc/need_breathe()
	if(has_genetic_condition(GENE_COND_NO_BREATH))
		return FALSE
	var/decl/bodytype/root_bodytype = get_bodytype()
	if(!root_bodytype || !root_bodytype.breathing_organ || !should_have_organ(root_bodytype.breathing_organ))
		return FALSE
	return TRUE

/mob/living/proc/should_breathe()
	return ((life_tick % 2) == 0 || failed_last_breath || is_asystole())

// These procs all have a lung organ as an argument to avoid having to do repeated get_bodytype and get_organ calls.
// It's a small optimization but it adds up if you have a lot of mobs breathing.

/// This proc contains all of the logic for returning a gasmix datum to be used in other breath-related code.
/// Does not necessarily involve inhaling at all; that's obtain_new_breath()'s job.
/mob/living/proc/get_breath(obj/item/organ/internal/lungs/lungs)
	// Handle optional pre-breath logic. If it returns TRUE, skip the breath entirely.
	if(handle_pre_breath(lungs))
		return null
	return obtain_new_breath(lungs)

/// Return a gasmix representing newly-inhaled air.
/mob/living/proc/obtain_new_breath(obj/item/organ/internal/lungs/lungs)
	var/static/datum/gas_mixture/vacuum = new //avoid having to create a new gas mixture for each breath in space
	//Okay, we can breathe, now check if we can get air
	var/volume_needed = get_breath_volume()
	//First check for air from internals, then the local environment, then use vacuum
	return get_breath_from_internal(volume_needed) || get_breath_from_environment(volume_needed) || vacuum

/// Handles pre-breath checks. If this proc returns TRUE, breathing is skipped that tick.
/mob/living/proc/handle_pre_breath(obj/item/organ/internal/lungs/lungs)
	//Check if we can breathe at all
	if(handle_drowning() || (is_asystole() && !GET_CHEMICAL_EFFECT(src, CE_STABLE) && lungs.active_breathing)) //crit aka circulatory shock
		. = TRUE
	else if(suffocation_counter > 0)
		// We aren't drowning or in asystole, but something else is suffocating us, so lower the counter and don't take a breath
		suffocation_counter--
		. = TRUE
	if(.)
		// Gasp on average every 10 ticks
		if (prob(10) && !is_asystole() && lungs.active_breathing)
			INVOKE_ASYNC(src, PROC_REF(emote), /decl/emote/audible/gasp)
		return TRUE
	return FALSE // not handled, proceed with breathing

/mob/living/proc/try_breathe()
	var/decl/bodytype/root_bodytype = get_bodytype()
	if(!root_bodytype?.breathing_organ)
		return
	var/obj/item/organ/internal/lungs/lungs = get_organ(root_bodytype.breathing_organ, /obj/item/organ/internal/lungs)
	var/datum/gas_mixture/breath = get_breath(lungs)
	//if breath is null or vacuum, the lungs will handle it for us
	failed_last_breath = (!lungs || nervous_system_failure()) ? TRUE : lungs.handle_owner_breath(breath)
	handle_post_breath(breath)

/mob/living/proc/get_breath_from_environment(var/volume_needed=STD_BREATH_VOLUME, var/atom/location = src.loc)

	if(volume_needed <= 0)
		return

	// First handle being in a submerged environment.
	var/datum/gas_mixture/breath
	if(is_flooded(current_posture.prone))
		var/turf/my_turf = get_turf(src)

		//Can we get air from the turf above us?
		var/can_breathe_air_above = FALSE
		if(my_turf == location)
			if(!current_posture.prone && my_turf.above && !my_turf.above.is_flooded() && my_turf.above.is_open() && can_overcome_gravity())
				location = my_turf.above
				can_breathe_air_above = TRUE

		// If not, are we capable of breathing water?
		if(!can_breathe_air_above)
			breath = new
			if(!can_drown())
				breath.volume = volume_needed
				breath.temperature = my_turf.temperature
				// TODO: species-breathable gas instead of oxygen default. Maybe base it on the reagents being breathed
				breath.adjust_gas(/decl/material/gas/oxygen, ONE_ATMOSPHERE*volume_needed/(R_IDEAL_GAS_EQUATION*T20C))
				my_turf.show_bubbles()
			return breath

	// Otherwise, handle breathing normally.
	var/datum/gas_mixture/environment
	if(location)
		environment = location.return_air()
	if(environment)
		breath = environment.remove_volume(volume_needed)
		handle_chemical_smoke(environment) //handle chemical smoke while we're at it
	if(breath && breath.total_moles)
		//handle mask filtering
		var/obj/item/clothing/mask/M = get_equipped_item(slot_wear_mask_str)
		if(istype(M) && breath)
			var/datum/gas_mixture/filtered = M.filter_air(breath)
			location.assume_air(filtered)
		return breath

/mob/living/proc/get_breath_from_internal(var/volume_needed=STD_BREATH_VOLUME) //hopefully this will allow overrides to specify a different default volume without breaking any cases where volume is passed in.
	var/old_internals = get_internals()
	if(old_internals)
		var/obj/item/tank/rig_supply
		var/obj/item/rig/rig = get_rig()
		if(rig && !rig.offline && (rig.air_supply && old_internals == rig.air_supply))
			rig_supply = rig.air_supply
		if(!rig_supply)
			if(!(old_internals in contents))
				set_internals(null)
			else
				check_for_airtight_internals()
	var/obj/item/tank/new_internals = get_internals()
	refresh_hud_element(HUD_INTERNALS)
	if(istype(new_internals))
		return new_internals.remove_air_volume(volume_needed)

//Handle possble chem smoke effect
/mob/living/proc/handle_chemical_smoke(var/datum/gas_mixture/environment)
	var/decl/species/my_species = get_species()
	if(my_species && environment?.return_pressure() < my_species.breath_pressure/5)
		return //pressure is too low to even breathe in.

	for(var/slot in global.standard_headgear_slots)
		var/obj/item/gear = get_equipped_item(slot)
		if(istype(gear) && (gear.item_flags & ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT))
			return

	for(var/obj/effect/effect/smoke/chem/smoke in view(1, src))
		if(smoke.reagents.total_volume)
			smoke.reagents.trans_to_mob(src, 5, CHEM_INGEST, copy = 1)
			smoke.reagents.trans_to_mob(src, 5, CHEM_INJECT, copy = 1)
			// I dunno, maybe the reagents enter the blood stream through the lungs?
			break // If they breathe in the nasty stuff once, no need to continue checking

/mob/living/proc/get_breath_volume()
	. = STD_BREATH_VOLUME
	var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
	if(heart && !heart.open)
		. *= (!BP_IS_PROSTHETIC(heart)) ? get_pulse()/PULSE_NORM : 1.5

/mob/living/proc/handle_post_breath(datum/gas_mixture/breath)
	if(!breath)
		return

	var/datum/gas_mixture/loc_air = loc?.return_air()
	if(!loc_air)
		return

	//by default, exhale
	var/obj/item/tank/my_internals = get_internals()
	if(my_internals)
		var/datum/gas_mixture/internals_air = my_internals.return_air()
		if(internals_air && (internals_air.return_pressure() < loc_air.return_pressure())) // based on the assumption it has a one-way valve for gas release
			internals_air.merge(breath)
			return
	if(loc)
		loc.merge_exhaled_volume(breath)
