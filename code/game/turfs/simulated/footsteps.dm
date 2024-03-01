/proc/get_footstep_for_mob(var/footstep_type, var/mob/living/caller)
	. = istype(caller) && caller.get_mob_footstep(footstep_type)
	if(!.)
		var/decl/footsteps/FS = GET_DECL(footstep_type)
		. = pick(FS.footstep_sounds)

/turf/proc/get_footstep_sound(var/mob/caller)

	for(var/obj/structure/S in contents)
		if(S.footstep_type)
			return get_footstep_for_mob(S.footstep_type, caller)

	if(check_fluid_depth(10) && !is_flooded(TRUE))
		return get_footstep_for_mob(/decl/footsteps/water, caller)

	if(footstep_type)
		return get_footstep_for_mob(footstep_type, caller)

	if(is_plating())
		return get_footstep_for_mob(/decl/footsteps/plating, caller)

/turf/simulated/floor/get_footstep_sound(var/mob/caller)
	. = ..() || get_footstep_for_mob(get_flooring()?.footstep_type || /decl/footsteps/blank, caller)

/mob/living/carbon/human/proc/has_footsteps()
	if(species.silent_steps || buckled || lying || throwing)
		return //people flying, lying down or sitting do not step

	var/obj/item/shoes = get_equipped_item(slot_shoes_str)
	if(shoes && (shoes.item_flags & ITEM_FLAG_SILENT))
		return // quiet shoes

	if(!has_organ(BP_L_FOOT) && !has_organ(BP_R_FOOT))
		return //no feet no footsteps

	return TRUE

/mob/living/proc/handle_footsteps()
	return

/mob/living/carbon/human/handle_footsteps()
	step_count++
	if(!has_footsteps())
		return

	 //every other turf makes a sound
	if((step_count % 2) && !MOVING_DELIBERATELY(src))
		return

	// don't need to step as often when you hop around
	if((step_count % 3) && !has_gravity())
		return

	var/turf/T = get_turf(src)
	if(!T)
		return

	var/footsound = T.get_footstep_sound(src)
	if(!footsound)
		return

	var/range = world.view - 2
	var/volume = 70
	if(MOVING_DELIBERATELY(src))
		volume -= 45
		range -= 0.333
	var/obj/item/clothing/shoes/shoes = get_equipped_item(slot_shoes_str)
	if(istype(shoes))
		volume *= shoes.footstep_volume_mod
		range  *= shoes.footstep_range_mod
	else if(!shoes)
		volume -= 60
		range -= 0.333

	range  = round(range)
	volume = round(volume)
	if(volume > 0 && range > 0)
		playsound(T, footsound, volume, 1, range)
