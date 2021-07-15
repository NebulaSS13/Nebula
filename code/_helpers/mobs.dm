/atom/movable/proc/get_mob()
	return

/obj/vehicle/train/get_mob()
	return buckled_mob

/mob/get_mob()
	return src

/mob/living/bot/mulebot/get_mob()
	if(load && istype(load, /mob/living))
		return list(src, load)
	return src

//helper for inverting armor blocked values into a multiplier
#define blocked_mult(blocked) max(1 - (blocked/100), 0)

/proc/mobs_in_view(var/range, var/source)
	var/list/mobs = list()
	for(var/atom/movable/AM in view(range, source))
		var/M = AM.get_mob()
		if(M)
			mobs += M

	return mobs

/proc/random_hair_style(gender, species)
	species = species || global.using_map.default_species
	var/h_style = "Bald"

	var/decl/species/mob_species = get_species_by_key(species)
	var/list/valid_hairstyles = mob_species.get_hair_styles()
	if(valid_hairstyles.len)
		h_style = pick(valid_hairstyles)

	return h_style

/proc/random_facial_hair_style(gender, var/species)
	species = species || global.using_map.default_species
	var/f_style = "Shaved"
	var/decl/species/mob_species = get_species_by_key(species)
	var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(gender)
	if(valid_facialhairstyles.len)
		f_style = pick(valid_facialhairstyles)
		return f_style

/proc/random_name(gender, species)
	if(species)
		var/decl/species/current_species = get_species_by_key(species)
		if(current_species) 
			var/decl/cultural_info/current_culture = GET_DECL(current_species.default_cultural_info[TAG_CULTURE])
			if(current_culture)
				return current_culture.get_random_name(null, gender)
	return capitalize(pick(gender == FEMALE ? global.first_names_female : global.first_names_male)) + " " + capitalize(pick(global.last_names))

/proc/random_skin_tone(var/decl/species/current_species)
	var/species_tone = current_species ? 35 - current_species.max_skin_tone() : -185
	switch(pick(60;"caucasian", 15;"afroamerican", 10;"african", 10;"latino", 5;"albino"))
		if("caucasian")		. = -10
		if("afroamerican")	. = -115
		if("african")		. = -165
		if("latino")		. = -55
		if("albino")		. = 34
		else				. = rand(species_tone,34)

	return min(max(. + rand(-25, 25), species_tone), 34)

/proc/skintone2racedescription(tone)
	switch (tone)
		if(30 to INFINITY)		return "albino"
		if(20 to 30)			return "pale"
		if(5 to 15)				return "light skinned"
		if(-10 to 5)			return "white"
		if(-25 to -10)			return "tan"
		if(-45 to -25)			return "darker skinned"
		if(-65 to -45)			return "brown"
		if(-INFINITY to -65)	return "black"
		else					return "unknown"

/proc/RoundHealth(health)
	var/list/icon_states = icon_states('icons/mob/hud_med.dmi')
	for(var/icon_state in icon_states)
		if(health >= text2num(icon_state))
			return icon_state
	return icon_states[icon_states.len] // If we had no match, return the last element

//checks whether this item is a module of the robot it is located in.
/proc/is_robot_module(var/obj/item/thing)
	if(!thing)
		return FALSE
	if(istype(thing.loc, /mob/living/exosuit))
		return FALSE
	if(!istype(thing.loc, /mob/living/silicon/robot))
		return FALSE
	var/mob/living/silicon/robot/R = thing.loc
	return (thing in R.module.equipment)

/proc/get_exposed_defense_zone(var/atom/movable/target)
	return pick(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT, BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG, BP_CHEST, BP_GROIN)

/proc/do_mob(mob/user , mob/target, time = 30, target_zone = 0, uninterruptible = 0, progress = 1, var/incapacitation_flags = INCAPACITATION_DEFAULT)
	if(!user || !target)
		return 0
	var/user_loc = user.loc

	var/drifting = 0
	if(!user.Process_Spacemove(0) && user.inertia_dir)
		drifting = 1

	var/target_loc = target.loc

	var/holding = user.get_active_hand()
	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, time, target)

	var/endtime = world.time+time
	var/starttime = world.time
	. = 1
	while (world.time < endtime)
		sleep(1)
		if (progress)
			progbar.update(world.time - starttime)
		if(!user || !target)
			. = 0
			break
		if(uninterruptible)
			continue

		if(drifting && !user.inertia_dir)
			drifting = 0
			user_loc = user.loc

		if(QDELETED(user) || user.incapacitated(incapacitation_flags) || (!drifting && user.loc != user_loc))
			. = 0
			break

		if(QDELETED(target) || target.loc != target_loc)
			. = 0
			break

		if(user.get_active_hand() != holding)
			. = 0
			break

		if(target_zone && user.zone_sel.selecting != target_zone)
			. = 0
			break

	if (progbar)
		qdel(progbar)

/proc/do_after(mob/user, delay, atom/target = null, needhand = 1, progress = 1, var/incapacitation_flags = INCAPACITATION_DEFAULT, var/same_direction = 0, var/can_move = 0)
	if(!user)
		return 0
	var/atom/target_loc = null
	var/target_type = null

	var/original_dir = user.dir

	if(target)
		target_loc = target.loc
		target_type = target.type

	var/atom/original_loc = user.loc

	var/drifting = 0
	if(!user.Process_Spacemove(0) && user.inertia_dir)
		drifting = 1

	var/holding = user.get_active_hand()

	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, delay, target)

	var/endtime = world.time + delay
	var/starttime = world.time
	. = 1
	while (world.time < endtime)
		sleep(1)
		if (progress)
			progbar.update(world.time - starttime)

		if(drifting && !user.inertia_dir)
			drifting = 0
			original_loc = user.loc

		if(QDELETED(user) || user.incapacitated(incapacitation_flags) || (!drifting && user.loc != original_loc && !can_move) || (same_direction && user.dir != original_dir))
			. = 0
			break

		if(target_loc && (QDELETED(target) || target_loc != target.loc || target_type != target.type))
			. = 0
			break

		if(needhand)
			if(user.get_active_hand() != holding)
				. = 0
				break

	if (progbar)
		qdel(progbar)

/proc/able_mobs_in_oview(var/origin)
	var/list/mobs = list()
	for(var/mob/living/M in oview(origin)) // Only living mobs are considered able.
		if(!M.is_physically_disabled())
			mobs += M
	return mobs

// Returns true if M was not already in the dead mob list
/mob/proc/switch_from_living_to_dead_mob_list()
	remove_from_living_mob_list()
	. = add_to_dead_mob_list()

// Returns true if M was not already in the living mob list
/mob/proc/switch_from_dead_to_living_mob_list()
	remove_from_dead_mob_list()
	. = add_to_living_mob_list()

// Returns true if the mob was in neither the dead or living list
/mob/proc/add_to_living_mob_list()
	return FALSE
/mob/living/add_to_living_mob_list()
	if((src in global.living_mob_list_) || (src in global.dead_mob_list_))
		return FALSE
	global.living_mob_list_ += src
	return TRUE

// Returns true if the mob was removed from the living list
/mob/proc/remove_from_living_mob_list()
	return global.living_mob_list_.Remove(src)

// Returns true if the mob was in neither the dead or living list
/mob/proc/add_to_dead_mob_list()
	return FALSE
/mob/living/add_to_dead_mob_list()
	if((src in global.living_mob_list_) || (src in global.dead_mob_list_))
		return FALSE
	global.dead_mob_list_ += src
	return TRUE

// Returns true if the mob was removed form the dead list
/mob/proc/remove_from_dead_mob_list()
	return global.dead_mob_list_.Remove(src)

//Find a dead mob with a brain and client.
/proc/find_dead_player(var/find_key, var/include_observers = 0)
	if(isnull(find_key))
		return

	var/mob/selected = null

	if(include_observers)
		for(var/mob/M in global.player_list)
			if((M.stat != DEAD) || (!M.client))
				continue
			if(M.ckey == find_key)
				selected = M
				break
	else
		for(var/mob/living/M in global.player_list)
			//Dead people only thanks!
			if((M.stat != DEAD) || (!M.client))
				continue
			//They need a brain!
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.should_have_organ(BP_BRAIN) && !H.has_brain())
					continue
			if(M.ckey == find_key)
				selected = M
				break
	return selected

/proc/damflags_to_strings(damflags)
	var/list/res = list()
	if(damflags & DAM_SHARP)
		res += "sharp"
	if(damflags & DAM_EDGE)
		res += "edge"
	if(damflags & DAM_LASER)
		res += "laser"
	if(damflags & DAM_BULLET)
		res += "bullet"
	if(damflags & DAM_EXPLODE)
		res += "explode"
	if(damflags & DAM_DISPERSED)
		res += "dispersed"
	if(damflags & DAM_BIO)
		res += "bio"
	return english_list(res)

/proc/get_effective_view(var/client/C)
	var/val = C ? C.view : world.view
	if(isnum(val))
		return val
	if(istext(val))
		var/list/vals = splittext(val, "x")
		return FLOOR(max(text2num(vals[1]), text2num(vals[2]))/2)
	return 0

// If all of these flags are present, it should come out at exactly 1. Yes, this
// is horrible. TODO: unify coverage flags with limbs and use organ_rel_size.
var/global/list/bodypart_coverage_cache = list()

/proc/get_percentage_body_cover(var/checking_flags)
	var/key = "[checking_flags]"
	if(isnull(global.bodypart_coverage_cache[key]))
		var/coverage = 0
		if(checking_flags & SLOT_FULL_BODY)
			coverage = 1
		else
			if(checking_flags & SLOT_HEAD)
				coverage += 0.1
			if(checking_flags & SLOT_FACE)
				coverage += 0.05
			if(checking_flags & SLOT_EYES)
				coverage += 0.05
			if(checking_flags & SLOT_UPPER_BODY)
				coverage += 0.15
			if(checking_flags & SLOT_LOWER_BODY)
				coverage += 0.15
			if(checking_flags & SLOT_LEG_LEFT)
				coverage += 0.075
			if(checking_flags & SLOT_LEG_RIGHT)
				coverage += 0.075
			if(checking_flags & SLOT_FOOT_LEFT)
				coverage += 0.05
			if(checking_flags & SLOT_FOOT_RIGHT)
				coverage += 0.05
			if(checking_flags & SLOT_ARM_LEFT)
				coverage += 0.075
			if(checking_flags & SLOT_ARM_RIGHT)
				coverage += 0.075
			if(checking_flags & SLOT_HAND_LEFT)
				coverage += 0.05
			if(checking_flags & SLOT_HAND_RIGHT)
				coverage += 0.05
		global.bodypart_coverage_cache[key] = coverage
	. = global.bodypart_coverage_cache[key]

/proc/get_sorted_mob_list()
	. = sortTim(SSmobs.mob_list.Copy(), /proc/cmp_name_asc)
	. = sortTim(., /proc/cmp_mob_sortvalue_asc)
