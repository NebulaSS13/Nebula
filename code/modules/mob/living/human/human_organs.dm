/// organ-related variables, see organ.dm and human_organs.dm, shouldn't be accessed directly
/mob/living/human
	/// organs we check until they are good.
	var/list/bad_external_organs
	/// organs grouped by category, largely used for stance calc
	var/list/organs_by_category
	/// organs indexed by organ_tag
	var/list/organs_by_tag
	/// unassociated list of internal organs
	var/tmp/list/internal_organs
	/// unassociated list of external organs
	var/tmp/list/external_organs

/mob/living/human/get_organ(var/organ_tag, var/expected_type = /obj/item/organ)
	RETURN_TYPE(expected_type)
	var/obj/item/organ = LAZYACCESS(organs_by_tag, organ_tag)
	if(!expected_type || istype(organ, expected_type))
		return organ

/mob/living/human/get_external_organs()
	return external_organs

/mob/living/human/get_internal_organs()
	return internal_organs

/mob/living/human/has_organs()
	return (LAZYLEN(external_organs) + LAZYLEN(internal_organs)) > 0

/mob/living/human/has_external_organs()
	return LAZYLEN(external_organs) > 0

/mob/living/human/has_internal_organs()
	return LAZYLEN(internal_organs) > 0

/mob/living/human/get_organs_by_categories(var/list/categories)
	for(var/organ_cat in categories)
		if(organ_cat in organs_by_category)
			LAZYDISTINCTADD(., organs_by_category[organ_cat])

//Deletes all references to organs
/mob/living/human/delete_organs()
	..()
	organs_by_tag = null
	internal_organs = null
	external_organs = null
	organs_by_category = null
	LAZYCLEARLIST(bad_external_organs)

//Registers an organ and setup the organ hierachy properly.
//affected  : Parent organ if applicable.
//in_place  : If true, we're performing an in-place replacement, without triggering anything related to adding the organ in-game as part of surgery or else.
/mob/living/human/add_organ(obj/item/organ/O, obj/item/organ/external/affected, in_place, update_icon, detached, skip_health_update = FALSE)

	var/obj/item/organ/existing = LAZYACCESS(organs_by_tag, O.organ_tag)
	if(existing && O != existing)
		CRASH("mob/living/human/add_organ(): '[O]' tried to overwrite [src]'s existing organ '[existing]' in slot '[O.organ_tag]'!")
	if(O.parent_organ && !LAZYACCESS(organs_by_tag, O.parent_organ))
		CRASH("mob/living/human/add_organ(): Tried to add an internal organ to a non-existing parent external organ!")

	//We don't add internal organs to the lists if we're detached
	if(O.is_internal() && !detached)
		LAZYSET(organs_by_tag, O.organ_tag, O)
		LAZYDISTINCTADD(internal_organs, O)
	//External organs must always be in the organ list even when detached. Otherwise icon updates won't show the limb, and limb attach surgeries won't work
	else if(!O.is_internal())
		LAZYSET(organs_by_tag, O.organ_tag, O)
		LAZYDISTINCTADD(external_organs, O)

	// Update our organ category lists, if neeed.
	if(O.organ_category)
		LAZYINITLIST(organs_by_category)
		LAZYDISTINCTADD(organs_by_category[O.organ_category], O)

	. = ..()
	if(!.)
		return

	if(!O.is_internal())
		refresh_modular_limb_verbs()

	//#TODO: wish we could invalidate the human icons to trigger a single update when the organ state changes multiple times in a row
	if(update_icon)
		update_inhand_overlays(FALSE)
		update_body(FALSE)
		update_bandages(FALSE)
		update_damage_overlays(FALSE)
		hud_reset()
		queue_icon_update() //Avoids calling icon updates 50 times when adding multiple organs

//Unregister and remove a given organ from the mob.
//drop_organ     : Once the organ is removed its dropped to the ground.
//detach         : Toggle the ORGAN_CUT_AWAY flag on the removed organ
//ignore_children: Skips recursively removing this organ's child organs.
//in_place       : If true we remove only the organ (no children items or implants) and avoid triggering mob changes and parent organs changes as much as possible.
//  Meant to be used for init and species transforms, without triggering any updates to mob state or anything related to losing a limb as part of surgery or combat.
/mob/living/human/remove_organ(var/obj/item/organ/O, var/drop_organ = TRUE, var/detach = TRUE, var/ignore_children = FALSE,  var/in_place = FALSE, var/update_icon = TRUE, var/skip_health_update = FALSE)
	if(istype(O) && !in_place && O.is_vital_to_owner() && usr)
		admin_attack_log(usr, src, "Removed a vital organ ([src]).", "Had a vital organ ([src]) removed.", "removed a vital organ ([src]) from")
	if(!(. = ..()))
		return
	LAZYREMOVE(organs_by_tag, O.organ_tag)
	if(O.is_internal())
		LAZYREMOVE(internal_organs, O)
	else
		LAZYREMOVE(external_organs, O)

	// Update our organ category lists, if neeed.
	if(O.organ_category && islist(organs_by_category))
		organs_by_category[O.organ_category] -= O
		if(LAZYLEN(organs_by_category[O.organ_category]) <= 0)
			LAZYREMOVE(organs_by_category, O.organ_category)

	if(!O.is_internal())
		refresh_modular_limb_verbs()
		LAZYREMOVE(bad_external_organs, O)

	//#TODO: wish we could invalidate the human icons to trigger a single update when the organ state changes multiple times in a row
	if(update_icon)
		regenerate_body_icon = TRUE
		hud_reset()
		queue_icon_update() //Avoids calling icon updates 50 times when removing multiple organs

/mob/living/human/get_bodytype()
	RETURN_TYPE(/decl/bodytype)
	// If the root organ ever changes/isn't always the chest, this will need to be changed.
	return get_organ(BP_CHEST, /obj/item/organ)?.bodytype

/mob/living/human/proc/get_bodypart_name(var/zone)
	var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, zone)
	return E?.name

/mob/living/human/proc/should_recheck_bad_external_organs()
	var/damage_this_tick = get_damage(TOX)
	for(var/obj/item/organ/external/O in get_external_organs())
		damage_this_tick += O.burn_dam + O.brute_dam

	if(damage_this_tick > last_dam)
		. = TRUE
	last_dam = damage_this_tick

/mob/living/human/proc/recheck_bad_external_organs()
	LAZYCLEARLIST(bad_external_organs)
	for(var/obj/item/organ/external/E in get_external_organs())
		if(E.need_process())
			LAZYDISTINCTADD(bad_external_organs, E)

/mob/living/human/proc/check_vital_organ_missing()
	return get_bodytype()?.check_vital_organ_missing(src)

/mob/living/human/proc/process_internal_organs()
	for(var/obj/item/organ/I in internal_organs)
		I.Process()

// Takes care of organ related updates, such as broken and missing limbs
/mob/living/human/proc/handle_organs()

	// Check for the presence (or lack of) vital organs like the brain.
	// Set a timer after this point, since we want a little bit of
	// wiggle room before the body dies for good (brain transplants).
	if(stat != DEAD)
		if(check_vital_organ_missing())
			SET_STATUS_MAX(src, STAT_PARA, 5)
			if(vital_organ_missing_time)
				if(world.time >= vital_organ_missing_time)
					death()
			else
				vital_organ_missing_time = world.time + max(get_bodytype()?.vital_organ_failure_death_delay, 5 SECONDS)
		else
			vital_organ_missing_time = null

	//processing internal organs is pretty cheap, do that first.
	process_internal_organs()

	var/force_process = should_recheck_bad_external_organs()

	if(force_process)
		recheck_bad_external_organs()
		for(var/obj/item/organ/external/Ex in get_external_organs())
			LAZYDISTINCTADD(bad_external_organs, Ex)

	if(!force_process && !LAZYLEN(bad_external_organs))
		return

	for(var/obj/item/organ/external/E in bad_external_organs)
		if(!E)
			continue
		if(!E.need_process())
			LAZYREMOVE(bad_external_organs, E)
			continue
		else
			E.Process()

			if(!current_posture.prone && !buckled && world.time - l_move_time < 15)
			//Moving around with fractured ribs won't do you any good
				if (prob(10) && !stat && can_feel_pain() && GET_CHEMICAL_EFFECT(src, CE_PAINKILLER) < 50 && E.is_broken() && LAZYLEN(E.internal_organs))
					custom_pain("Pain jolts through your broken [E.encased ? E.encased : E.name], staggering you!", 50, affecting = E)
					drop_held_items()
					SET_STATUS_MAX(src, STAT_STUN, 2)

				//Moving makes open wounds get infected much faster
				for(var/datum/wound/W in E.wounds)
					if (W.infection_check())
						W.germ_level += 1

/mob/living/human/proc/Check_Proppable_Object()
	for(var/turf/T as anything in RANGE_TURFS(src, 1)) //we only care for non-space turfs
		if(T.density && T.simulated)	//walls work
			return 1

	for(var/obj/O in orange(1, src))
		if(O && O.density && O.anchored)
			return 1

	return 0

/mob/living/human/on_lost_organ(var/obj/item/organ/O)
	if(!(. = ..()))
		return
	//Move some blood over to the organ
	if(!BP_IS_PROSTHETIC(O) && O.species && O.reagents?.total_volume < 5)
		vessel.trans_to(O, 5 - O.reagents.total_volume, 1, 1)
