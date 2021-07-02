/mob/living/carbon/human/proc/update_eyes()
	var/obj/item/organ/internal/eyes/eyes = get_internal_organ(species.vision_organ || BP_EYES)
	if(eyes)
		eyes.update_colour()
		refresh_visible_overlays()

/mob/living/carbon/human/proc/get_bodypart_name(var/zone)
	var/obj/item/organ/external/E = get_organ(zone)
	if(E) . = E.name

/mob/living/carbon/human/proc/recheck_bad_external_organs()
	var/damage_this_tick = getToxLoss()
	for(var/obj/item/organ/external/O in organs)
		damage_this_tick += O.burn_dam + O.brute_dam

	if(damage_this_tick > last_dam)
		. = TRUE
	last_dam = damage_this_tick

// Takes care of organ related updates, such as broken and missing limbs
/mob/living/carbon/human/proc/handle_organs()

	var/force_process = recheck_bad_external_organs()

	if(force_process)
		bad_external_organs.Cut()
		for(var/obj/item/organ/external/Ex in organs)
			bad_external_organs |= Ex

	//processing internal organs is pretty cheap, do that first.
	for(var/obj/item/organ/I in internal_organs)
		I.Process()

	handle_stance()
	handle_grasp()

	if(!force_process && !bad_external_organs.len)
		return

	for(var/obj/item/organ/external/E in bad_external_organs)
		if(!E)
			continue
		if(!E.need_process())
			bad_external_organs -= E
			continue
		else
			E.Process()

			if (!lying && !buckled && world.time - l_move_time < 15)
			//Moving around with fractured ribs won't do you any good
				if (prob(10) && !stat && can_feel_pain() && GET_CHEMICAL_EFFECT(src, CE_PAINKILLER) < 50 && E.is_broken() && E.internal_organs.len)
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
		var/obj/item/organ/external/E = organs_by_name[limb_tag]
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
		if(!organs_by_name[BP_L_LEG] || !organs_by_name[BP_L_FOOT]) //are we down a limb?
			working_pair -= 1
		else if((!organs_by_name[BP_L_LEG].is_usable()) || (!organs_by_name[BP_L_FOOT].is_usable())) //if not, is it usable?
			working_pair -= 1
		if(!organs_by_name[BP_R_LEG] || !organs_by_name[BP_R_FOOT])
			working_pair -= 1
		else if((!organs_by_name[BP_R_LEG].is_usable()) || (!organs_by_name[BP_R_FOOT].is_usable()))
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
	for(var/bp in held_item_slots)
		var/datum/inventory_slot/inv_slot = held_item_slots[bp]
		var/holding = inv_slot?.holding
		if(holding)
			var/obj/item/organ/external/E = organs_by_name[bp]
			if((!E || !E.is_usable() || E.is_parent_dislocated()) && unEquip(holding))
				grasp_damage_disarm(inv_slot)

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
		for(var/bp in (list(affected.organ_tag) | affected.children))
			var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, bp)
			if(inv_slot?.holding)
				LAZYDISTINCTADD(drop_held_item_slots, inv_slot)
	else if(istype(affected, /datum/inventory_slot))
		drop_held_item_slots = list(affected)

	if(!LAZYLEN(drop_held_item_slots))
		return

	for(var/datum/inventory_slot/inv_slot in drop_held_item_slots)
		if(!unEquip(inv_slot.holding))
			continue
		var/obj/item/organ/external/E = organs_by_name[inv_slot.slot_id]
		if(!E)
			continue
		if(E.is_robotic())
			var/decl/pronouns/G = get_pronouns()
			visible_message("<B>\The [src]</B> drops what [G.he] [G.is] holding, [G.his] [affected.name] malfunctioning!")
			spark_at(src, 5, holder=src)
			continue

		var/grasp_name = E.name
		if((E.body_part in list(SLOT_ARM_LEFT, SLOT_ARM_RIGHT)) && length(E.children))
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
	var/list/all_bits = internal_organs|organs
	for(var/obj/item/organ/O in all_bits)
		O.set_dna(dna)

/mob/living/proc/is_asystole()
	return FALSE

/mob/living/carbon/human/is_asystole()
	if(isSynthetic())
		var/obj/item/organ/internal/cell/C = get_internal_organ(BP_CELL)
		if(istype(C))
			if(!C.is_usable() || !C.percent())
				return TRUE
	else if(should_have_organ(BP_HEART))
		var/obj/item/organ/internal/heart/heart = get_internal_organ(BP_HEART)
		if(!istype(heart) || !heart.is_working())
			return TRUE
	return FALSE