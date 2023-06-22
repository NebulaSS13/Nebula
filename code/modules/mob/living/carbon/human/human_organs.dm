/mob/living/carbon/human/proc/update_eyes()
	var/obj/item/organ/internal/eyes/eyes = get_organ((species?.vision_organ || BP_EYES), /obj/item/organ/internal/eyes)
	if(eyes)
		eyes.update_colour()
		refresh_visible_overlays()

/mob/living/carbon/human/proc/get_bodypart_name(var/zone)
	var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, zone)
	return E?.name

/mob/living/carbon/human/proc/should_recheck_bad_external_organs()
	var/damage_this_tick = getToxLoss()
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
		if(species.check_vital_organ_missing(src))
			SET_STATUS_MAX(src, STAT_PARA, 5)
			if(vital_organ_missing_time)
				if(world.time >= vital_organ_missing_time)
					death()
			else
				vital_organ_missing_time = world.time + species.vital_organ_failure_death_delay
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

	handle_stance()
	handle_grasp()

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

/mob/living/carbon/human/proc/Check_Proppable_Object()
	for(var/turf/simulated/T in RANGE_TURFS(src, 1)) //we only care for non-space turfs
		if(T.density)	//walls work
			return 1

	for(var/obj/O in orange(1, src))
		if(O && O.density && O.anchored)
			return 1

	return 0

/mob/living/carbon/human/proc/handle_stance()
	set waitfor = FALSE // Can sleep in emotes.
	// Don't need to process any of this if they aren't standing anyways
	// unless their stance is damaged, and we want to check if they should stay down
	if (!stance_damage && (lying || resting) && (life_tick % 4) != 0)
		return

	stance_damage = 0

	// Buckled to a bed/chair. Stance damage is forced to 0 since they're sitting on something solid
	if (istype(buckled, /obj/structure/bed))
		return

	// Can't fall if nothing pulls you down
	if(!has_gravity())
		return

	var/limb_pain
	for(var/limb_tag in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, limb_tag)
		if(!E || !E.is_usable())
			stance_damage += 2 // let it fail even if just foot&leg
		else if (E.is_malfunctioning())
			//malfunctioning only happens intermittently so treat it as a missing limb when it procs
			stance_damage += 2
			if(prob(10))
				visible_message("\The [src]'s [E.name] [pick("twitches", "shudders")] and sparks!")
				spark_at(src, amount = 5, holder = src)
		else if (E.is_broken())
			stance_damage += 1
		else if (E.is_dislocated())
			stance_damage += 0.5

		if(E) limb_pain = E.can_feel_pain()

	// Canes and crutches help you stand (if the latter is ever added)
	// One cane mitigates a broken leg+foot, or a missing foot.
	// Two canes are needed for a lost leg. If you are missing both legs, canes aren't gonna help you.
	for(var/obj/item/cane/C in get_held_items())
		stance_damage -= 2

	if(MOVING_DELIBERATELY(src)) //you don't suffer as much if you aren't trying to run
		var/working_pair = 2
		var/obj/item/organ/external/LF = GET_EXTERNAL_ORGAN(src, BP_L_FOOT)
		var/obj/item/organ/external/LL = GET_EXTERNAL_ORGAN(src, BP_L_LEG)
		var/obj/item/organ/external/RF = GET_EXTERNAL_ORGAN(src, BP_R_FOOT)
		var/obj/item/organ/external/RL = GET_EXTERNAL_ORGAN(src, BP_R_LEG)
		if(!LL || !LF) //are we down a limb?
			working_pair -= 1
		else if((!LL.is_usable()) || (!LF.is_usable())) //if not, is it usable?
			working_pair -= 1
		if(!RL || !RF)
			working_pair -= 1
		else if((!RL.is_usable()) || (!RF.is_usable()))
			working_pair -= 1
		if(working_pair >= 1)
			stance_damage -= 1
			if(Check_Proppable_Object()) //it helps to lean on something if you've got another leg to stand on
				stance_damage -= 1

	var/list/objects_to_sit_on = list(
			/obj/item/stool,
			/obj/structure/bed,
		)

	for(var/type in objects_to_sit_on) //things that can't be climbed but can be propped-up-on
		if(locate(type) in src.loc)
			return

	// standing is poor
	if(stance_damage >= 4 || (stance_damage >= 2 && prob(2)) || (stance_damage >= 3 && prob(8)))
		if(!(lying || resting))
			if(limb_pain)
				emote("scream")
			custom_emote(VISIBLE_MESSAGE, "collapses!")
		SET_STATUS_MAX(src, STAT_WEAK, 3) //can't emote while weakened, apparently.

/mob/living/carbon/human/proc/handle_grasp()
	for(var/hand_slot in get_held_item_slots())
		var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(hand_slot)
		var/holding = inv_slot?.get_equipped_item()
		if(holding)
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, hand_slot)
			if((!E || !E.is_usable() || E.is_parent_dislocated()) && try_unequip(holding))
				grasp_damage_disarm(E)

/mob/living/carbon/human/proc/stance_damage_prone(var/obj/item/organ/external/affected)

	if(affected && (!BP_IS_PROSTHETIC(affected) || affected.is_robotic()))
		switch(affected.body_part)
			if(SLOT_FOOT_LEFT, SLOT_FOOT_RIGHT)
				if(!BP_IS_PROSTHETIC(affected))
					to_chat(src, SPAN_WARNING("You lose your footing as your [affected.name] spasms!"))
				else
					to_chat(src, SPAN_WARNING("You lose your footing as your [affected.name] [pick("twitches", "shudders")]!"))
			if(SLOT_LEG_LEFT, SLOT_LEG_RIGHT)
				if(!BP_IS_PROSTHETIC(affected))
					to_chat(src, SPAN_WARNING("Your [affected.name] buckles from the shock!"))
				else
					to_chat(src, SPAN_WARNING("You lose your balance as [affected.name] [pick("malfunctions", "freezes","shudders")]!"))
			else
				return
	SET_STATUS_MAX(src, STAT_WEAK, 4)

/mob/living/carbon/human/proc/grasp_damage_disarm(var/obj/item/organ/external/affected)

	var/list/drop_held_item_slots
	if(istype(affected))
		for(var/grasp_tag in (list(affected.organ_tag) | affected.children))
			var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(grasp_tag)
			if(inv_slot?.get_equipped_item())
				LAZYDISTINCTADD(drop_held_item_slots, inv_slot)
	else if(istype(affected, /datum/inventory_slot))
		drop_held_item_slots = list(affected)

	if(!LAZYLEN(drop_held_item_slots))
		return

	for(var/datum/inventory_slot/inv_slot in drop_held_item_slots)
		if(!try_unequip(inv_slot.get_equipped_item()))
			continue
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, inv_slot.slot_id)
		if(!E)
			continue
		if(E.is_robotic())
			var/decl/pronouns/G = get_pronouns()
			visible_message("<B>\The [src]</B> drops what [G.he] [G.is] holding, [G.his] [E.name] malfunctioning!")
			spark_at(src, 5, holder=src)
			continue

		var/grasp_name = E.name
		if((E.body_part in list(SLOT_ARM_LEFT, SLOT_ARM_RIGHT)) && LAZYLEN(E.children))
			var/obj/item/organ/external/hand = pick(E.children)
			grasp_name = hand.name

		if(E.can_feel_pain())
			var/emote_scream = pick("screams in pain", "lets out a sharp cry", "cries out")
			var/emote_scream_alt = pick("scream in pain", "let out a sharp cry", "cry out")
			visible_message(
				"<B>\The [src]</B> [emote_scream] and drops what they were holding in their [grasp_name]!",
				null,
				"You hear someone [emote_scream_alt]!"
			)
			custom_pain("The sharp pain in your [E.name] forces you to drop what you were holding in your [grasp_name]!", 30)
		else
			visible_message("<B>\The [src]</B> drops what they were holding in their [grasp_name]!")

/mob/living/carbon/human/proc/sync_organ_dna()
	for(var/obj/item/organ/O in get_organs())
		if(!BP_IS_PROSTHETIC(O))
			O.setup_as_organic(dna)
		else
			O.setup_as_prosthetic()

/mob/living/proc/is_asystole()
	return FALSE

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

/mob/living/carbon/human/proc/is_lung_ruptured()
	var/obj/item/organ/internal/L = GET_INTERNAL_ORGAN(src, BP_LUNGS)
	return L && L.is_bruised()

/mob/living/carbon/human/proc/rupture_lung()
	var/obj/item/organ/internal/lungs/L = get_organ(BP_LUNGS, /obj/item/organ/internal/lungs)
	if(L)
		L.rupture()

//Registers an organ and setup the organ hierachy properly.
//affected  : Parent organ if applicable.
//in_place  : If true, we're performing an in-place replacement, without triggering anything related to adding the organ in-game as part of surgery or else.
/mob/living/carbon/human/add_organ(obj/item/organ/O, obj/item/organ/external/affected, in_place, update_icon, detached)
	if(!(. = ..()))
		return
	if(!O.is_internal())
		refresh_modular_limb_verbs()

	//#TODO: wish we could invalidate the human icons to trigger a single update when the organ state changes multiple times in a row
	if(update_icon)
		update_inv_hands(FALSE)
		update_body(FALSE)
		update_bandages(FALSE)
		UpdateDamageIcon(FALSE)
		hud_reset()
		queue_icon_update() //Avoids calling icon updates 50 times when adding multiple organs

//Unregister and remove a given organ from the mob.
//drop_organ     : Once the organ is removed its dropped to the ground.
//detach         : Toggle the ORGAN_CUT_AWAY flag on the removed organ
//ignore_children: Skips recursively removing this organ's child organs.
//in_place       : If true we remove only the organ (no children items or implants) and avoid triggering mob changes and parent organs changes as much as possible.
//  Meant to be used for init and species transforms, without triggering any updates to mob state or anything related to losing a limb as part of surgery or combat.
/mob/living/carbon/human/remove_organ(obj/item/organ/O, drop_organ, detach, ignore_children,  in_place, update_icon)
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
