/mob/living/carbon/human/proc/update_eyes(update_icons = TRUE)
	var/obj/item/organ/internal/eyes/eyes = get_organ((get_bodytype()?.vision_organ || BP_EYES), /obj/item/organ/internal/eyes)
	if(eyes)
		eyes.update_colour()
		if(update_icons)
			queue_icon_update()

/mob/living/carbon/human/proc/get_bodypart_name(var/zone)
	var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, zone)
	return E?.name

/mob/living/carbon/human/proc/should_recheck_bad_external_organs()
	var/damage_this_tick = get_damage(TOX)
	for(var/obj/item/organ/external/O in get_external_organs())
		damage_this_tick += O.burn_dam + O.brute_dam

	if(damage_this_tick > last_dam)
		. = TRUE
	last_dam = damage_this_tick

/mob/living/carbon/human/proc/recheck_bad_external_organs()
	LAZYCLEARLIST(bad_external_organs)
	for(var/obj/item/organ/external/E in get_external_organs())
		if(E.need_process())
			LAZYDISTINCTADD(bad_external_organs, E)

// Takes care of organ related updates, such as broken and missing limbs
/mob/living/carbon/human/proc/handle_organs()

	// Check for the presence (or lack of) vital organs like the brain.
	// Set a timer after this point, since we want a little bit of
	// wiggle room before the body dies for good (brain transplants).
	if(stat != DEAD)
		var/decl/bodytype/root_bodytype = get_bodytype()
		if(root_bodytype.check_vital_organ_missing(src))
			SET_STATUS_MAX(src, STAT_PARA, 5)
			if(vital_organ_missing_time)
				if(world.time >= vital_organ_missing_time)
					death()
			else
				vital_organ_missing_time = world.time + root_bodytype.vital_organ_failure_death_delay
		else
			vital_organ_missing_time = null

	//processing internal organs is pretty cheap, do that first.
	for(var/obj/item/organ/I in internal_organs)
		I.Process()

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

			if (!lying && !buckled && world.time - l_move_time < 15)
			//Moving around with fractured ribs won't do you any good
				if (prob(10) && !stat && can_feel_pain() && GET_CHEMICAL_EFFECT(src, CE_PAINKILLER) < 50 && E.is_broken() && LAZYLEN(E.internal_organs))
					custom_pain("Pain jolts through your broken [E.encased ? E.encased : E.name], staggering you!", 50, affecting = E)
					drop_held_items()
					SET_STATUS_MAX(src, STAT_STUN, 2)

				//Moving makes open wounds get infected much faster
				for(var/datum/wound/W in E.wounds)
					if (W.infection_check())
						W.germ_level += 1

/mob/living/carbon/human/is_asystole()
	if(isSynthetic())
		var/obj/item/organ/internal/cell/C = get_organ(BP_CELL, /obj/item/organ/internal/cell)
		if(!C || !C.is_usable() || !C.percent())
			return TRUE
	else if(should_have_organ(BP_HEART))
		var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
		if(!istype(heart) || !heart.is_working())
			return TRUE
	return FALSE

//Registers an organ and setup the organ hierachy properly.
//affected  : Parent organ if applicable.
//in_place  : If true, we're performing an in-place replacement, without triggering anything related to adding the organ in-game as part of surgery or else.
/mob/living/carbon/human/add_organ(obj/item/organ/O, obj/item/organ/external/affected, in_place, update_icon, detached, skip_health_update = FALSE)
	if(!(. = ..()))
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
/mob/living/carbon/human/remove_organ(obj/item/organ/O, drop_organ, detach, ignore_children,  in_place, update_icon, skip_health_update = FALSE)
	if(!(. = ..()))
		return
	if(!O.is_internal())
		refresh_modular_limb_verbs()
		LAZYREMOVE(bad_external_organs, O)

	//#TODO: wish we could invalidate the human icons to trigger a single update when the organ state changes multiple times in a row
	if(update_icon)
		regenerate_body_icon = TRUE
		hud_reset()
		queue_icon_update() //Avoids calling icon updates 50 times when removing multiple organs

/mob/living/carbon/human/on_lost_organ(var/obj/item/organ/O)
	if(!(. = ..()))
		return
	//Move some blood over to the organ
	if(!BP_IS_PROSTHETIC(O) && O.species && O.reagents?.total_volume < 5)
		vessel.trans_to(O, 5 - O.reagents.total_volume, 1, 1)

/mob/living/carbon/human/delete_organs()
	. = ..()
	LAZYCLEARLIST(bad_external_organs)
