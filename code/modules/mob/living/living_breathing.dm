
//Start of a breath chain, calls breathe()
#define MOB_BREATH_DELAY 2
/mob/living/proc/handle_breathing()
	if((life_tick % MOB_BREATH_DELAY) == 0 || failed_last_breath || is_asystole()) //First, resolve location and get a breath
		breathe()
#undef MOB_BREATH_DELAY

/mob/living/proc/breathe(var/active_breathe = TRUE)

	if(!need_breathe()) return

	var/datum/gas_mixture/breath = null

	//First, check if we can breathe at all
	if(handle_drowning() || (is_asystole() && !GET_CHEMICAL_EFFECT(src, CE_STABLE) && active_breathe)) //crit aka circulatory shock
		losebreath = max(2, losebreath + 1)

	if(losebreath > 0) //Suffocating so do not take a breath
		losebreath--
		if (prob(10) && !is_asystole() && active_breathe) //Gasp per 10 ticks? Sounds about right.
			INVOKE_ASYNC(src, .proc/emote, "gasp")
	else
		//Okay, we can breathe, now check if we can get air
		var/volume_needed = get_breath_volume()
		breath = get_breath_from_internal(volume_needed) //First, check for air from internals
		if(!breath)
			breath = get_breath_from_environment(volume_needed) //No breath from internals so let's try to get air from our location
		if(!breath)
			var/static/datum/gas_mixture/vacuum //avoid having to create a new gas mixture for each breath in space
			if(!vacuum) vacuum = new

			breath = vacuum //still nothing? must be vacuum

	handle_breath(breath)
	handle_post_breath(breath)

/mob/living/proc/get_breath_from_environment(var/volume_needed=STD_BREATH_VOLUME, var/atom/location = src.loc)
	if(volume_needed <= 0)
		return
	var/datum/gas_mixture/environment = location?.return_air()
	var/datum/gas_mixture/breath
	if(environment)
		breath = environment.remove_volume(volume_needed)
		handle_chemical_smoke(environment) //handle chemical smoke while we're at it
	if(breath?.total_moles)
		//handle mask filtering
		var/obj/item/clothing/mask/M = get_equipped_item(slot_wear_mask_str)
		if(istype(M) && breath)
			var/datum/gas_mixture/filtered = M.filter_air(breath)
			location.assume_air(filtered)
		return breath

/mob/living/proc/get_breath_volume()
	return STD_BREATH_VOLUME

/mob/living/proc/handle_breath(datum/gas_mixture/breath)
	return

/mob/living/proc/handle_post_breath(datum/gas_mixture/breath)
	if(!breath)
		return
	var/obj/item/tank/internal = get_internals()
	//by default, exhale
	var/datum/gas_mixture/internals_air = internal?.return_air()
	var/datum/gas_mixture/loc_air = loc?.return_air()
	if(internals_air && (internals_air.return_pressure() < loc_air.return_pressure())) // based on the assumption it has a one-way valve for gas release
		internals_air.merge(breath)
	else
		loc_air?.merge(breath)

/mob/living/proc/need_breathe()
	var/decl/species/my_species = get_species()
	return my_species?.breathing_organ && should_have_organ(my_species.breathing_organ)

//Handle possble chem smoke effect
/mob/living/proc/handle_chemical_smoke(var/datum/gas_mixture/environment)
	var/decl/species/my_species = get_species()
	if(my_species && environment.return_pressure() < my_species.breath_pressure/5)
		return //pressure is too low to even breathe in.
	var/obj/item/mask = get_equipped_item(slot_wear_mask_str)
	if(mask && (mask.item_flags & ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT))
		return

	for(var/obj/effect/effect/smoke/chem/smoke in view(1, src))
		if(smoke.reagents.total_volume)
			smoke.reagents.trans_to_mob(src, 5, CHEM_INGEST, copy = 1)
			smoke.reagents.trans_to_mob(src, 5, CHEM_INJECT, copy = 1)
			// I dunno, maybe the reagents enter the blood stream through the lungs?
			break // If they breathe in the nasty stuff once, no need to continue checking
