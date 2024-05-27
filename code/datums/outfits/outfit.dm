var/global/list/outfits_decls_
var/global/list/outfits_decls_root_
var/global/list/outfits_decls_by_type_

/proc/outfit_by_type(var/outfit_type)
	if(!outfits_decls_root_)
		init_outfit_decls()
	return outfits_decls_by_type_[outfit_type]

/proc/outfits()
	if(!outfits_decls_root_)
		init_outfit_decls()
	return outfits_decls_

/proc/init_outfit_decls()
	if(outfits_decls_root_)
		return
	outfits_decls_ = list()
	outfits_decls_by_type_ = list()
	outfits_decls_root_ = GET_DECL(/decl/hierarchy/outfit)

/decl/hierarchy/outfit
	name = "Naked"
	abstract_type = /decl/hierarchy/outfit
	expected_type = /decl/hierarchy/outfit

	var/uniform = null
	var/suit = null
	var/back = null
	var/belt = null
	var/gloves = null
	var/shoes = null
	var/head = null
	var/mask = null
	var/l_ear = null
	var/r_ear = null
	var/glasses = null
	var/id = null
	var/l_pocket = null
	var/r_pocket = null
	var/suit_store = null
	var/holster = null
	var/list/hands
	var/list/backpack_contents = list() // In the list(path=count,otherpath=count) format

	var/id_type
	var/id_desc
	var/id_slot

	var/pda_type
	var/pda_slot

	var/id_pda_assignment

	var/list/backpack_overrides
	var/outfit_flags = OUTFIT_RESET_EQUIPMENT

/decl/hierarchy/outfit/Initialize()
	. = ..()
	backpack_overrides = backpack_overrides || list()
	if(!INSTANCE_IS_ABSTRACT(src))
		outfits_decls_by_type_[type] = src
		dd_insertObjectList(outfits_decls_, src)

// This proc is structured slightly strangely because I will be adding pants to it.
/decl/hierarchy/outfit/validate()
	. = ..()
	if(uniform && (outfit_flags & OUTFIT_HAS_VITALS_SENSOR))
		if(!ispath(uniform, /obj/item/clothing))
			. += "outfit is flagged for sensors, but uniform cannot take accessories"
		var/succeeded = FALSE
		var/obj/item/sensor = new /obj/item/clothing/sensor/vitals
		if(uniform)
			var/obj/item/clothing/wear_uniform = new uniform // sadly we need to read a list
			if(wear_uniform.can_attach_accessory(sensor))
				succeeded = TRUE
			qdel(wear_uniform)
		if(!succeeded)
			. += "outfit is flagged for sensors, but uniform does not accept sensors"
		qdel(sensor)

/decl/hierarchy/outfit/proc/pre_equip(mob/living/carbon/human/H)
	if(outfit_flags & OUTFIT_RESET_EQUIPMENT)
		H.delete_inventory(TRUE)

/decl/hierarchy/outfit/proc/post_equip(mob/living/carbon/human/H)
	if(outfit_flags & OUTFIT_HAS_JETPACK)
		var/obj/item/tank/jetpack/J = locate(/obj/item/tank/jetpack) in H
		if(!J)
			return
		J.toggle()
		J.toggle_valve()

/decl/hierarchy/outfit/proc/equip_outfit(mob/living/carbon/human/H, assignment, equip_adjustments, datum/job/job, datum/mil_rank/rank)
	equip_base(H, equip_adjustments)
	equip_id(H, assignment, equip_adjustments, job, rank)
	for(var/path in backpack_contents)
		var/number = backpack_contents[path]
		for(var/i=0,i<number,i++)
			H.equip_to_slot_or_store_or_drop(new path(H), slot_in_backpack_str)

	if(!(OUTFIT_ADJUSTMENT_SKIP_POST_EQUIP & equip_adjustments))
		post_equip(H)

	if(outfit_flags & OUTFIT_HAS_VITALS_SENSOR)
		try_equip_vitals_sensor(H)

	return 1

/decl/hierarchy/outfit/proc/try_equip_vitals_sensor(mob/living/carbon/human/H)

	// Check if they already have one.
	for(var/check_slot in global.vitals_sensor_equip_slots)
		var/obj/item/clothing/equipped = H.get_equipped_item(check_slot)
		if(istype(equipped) && (locate(/obj/item/clothing/sensor/vitals) in equipped.accessories))
			return

	// Check if one has been spawned or dropped by previous equip procs.
	var/turf/working_turf = get_turf(H)
	var/obj/item/clothing/sensor/vitals/sensor = (locate() in get_turf(H)) || (locate() in H.get_held_items()) || new(working_turf)
	if(ismob(sensor.loc))
		var/mob/M = sensor.loc
		M.drop_from_inventory(sensor)

	// Try to equip it to something.
	for(var/check_slot in global.vitals_sensor_equip_slots)
		var/obj/item/clothing/equipped = H.get_equipped_item(check_slot)
		if(istype(equipped) && !(locate(/obj/item/clothing/sensor/vitals) in equipped.accessories) && equipped.can_attach_accessory(sensor))
			equipped.attach_accessory(null, sensor)
			break

	// If we failed, put it in their hands.
	if(isturf(sensor.loc))
		H.put_in_hands(sensor)

/decl/hierarchy/outfit/proc/equip_base(mob/living/carbon/human/H, var/equip_adjustments)
	set waitfor = FALSE
	pre_equip(H)

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		H.equip_to_slot_or_del(new uniform(H),slot_w_uniform_str)
		if(!H.get_equipped_item(slot_w_uniform_str))
			H.species.equip_default_fallback_uniform(H)

		var/obj/item/equip_uniform = H.get_equipped_item(slot_w_uniform_str)
		if(holster && equip_uniform)
			var/obj/item/clothing/equip_holster = new holster
			equip_uniform.attackby(equip_holster, H)
			if(equip_holster.loc != equip_uniform && !QDELETED(equip_holster))
				qdel(equip_holster)

	if(suit)
		H.equip_to_slot_or_del(new suit(H),slot_wear_suit_str)
	if(back)
		H.equip_to_slot_or_del(new back(H),slot_back_str)
	if(belt)
		H.equip_to_slot_or_del(new belt(H),slot_belt_str)
	if(gloves)
		H.equip_to_slot_or_del(new gloves(H),slot_gloves_str)
	if(shoes)
		H.equip_to_slot_or_del(new shoes(H),slot_shoes_str)
	if(mask)
		H.equip_to_slot_or_del(new mask(H),slot_wear_mask_str)
	if(head)
		H.equip_to_slot_or_del(new head(H),slot_head_str)
	if(l_ear)
		var/l_ear_path = (OUTFIT_ADJUSTMENT_PLAIN_HEADSET & equip_adjustments) && ispath(l_ear, /obj/item/radio/headset) ? /obj/item/radio/headset : l_ear
		H.equip_to_slot_or_del(new l_ear_path(H),slot_l_ear_str)
	if(r_ear)
		var/r_ear_path = (OUTFIT_ADJUSTMENT_PLAIN_HEADSET & equip_adjustments) && ispath(r_ear, /obj/item/radio/headset) ? /obj/item/radio/headset : r_ear
		H.equip_to_slot_or_del(new r_ear_path(H),slot_r_ear_str)
	if(glasses)
		H.equip_to_slot_or_del(new glasses(H),slot_glasses_str)
	if(id)
		H.equip_to_slot_or_del(new id(H),slot_wear_id_str)
	if(l_pocket)
		H.equip_to_slot_or_del(new l_pocket(H),slot_l_store_str)
	if(r_pocket)
		H.equip_to_slot_or_del(new r_pocket(H),slot_r_store_str)
	if(suit_store)
		H.equip_to_slot_or_del(new suit_store(H),slot_s_store_str)
	for(var/hand in hands)
		H.put_in_hands(new hand(H))

	if((outfit_flags & OUTFIT_HAS_BACKPACK) && !(OUTFIT_ADJUSTMENT_SKIP_BACKPACK & equip_adjustments))
		var/decl/backpack_outfit/bo
		var/metadata

		if(H.backpack_setup)
			bo = H.backpack_setup.backpack
			metadata = H.backpack_setup.metadata
		else
			bo = get_default_outfit_backpack()

		var/override_type = backpack_overrides[bo.type]
		var/backpack = bo.spawn_backpack(H, metadata, override_type)

		if(backpack)
			if(back)
				if(!H.put_in_hands(backpack))
					H.equip_to_appropriate_slot(backpack)
			else
				H.equip_to_slot_or_del(backpack, slot_back_str)

	if(H.species && !(OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR & equip_adjustments))
		var/decl/survival_box_option/chosen_survival_box = H?.client?.prefs.survival_box_choice
		if(chosen_survival_box?.box_type)
			if(outfit_flags & OUTFIT_EXTENDED_SURVIVAL)
				H.species.equip_survival_gear(H, /obj/item/box/engineer)
			else
				H.species.equip_survival_gear(H, chosen_survival_box.box_type)

	if(H.client?.prefs?.give_passport)
		global.using_map.create_passport(H)

/decl/hierarchy/outfit/proc/equip_id(mob/living/carbon/human/H, assignment, equip_adjustments, datum/job/job, datum/mil_rank/rank)
	if(!id_slot || !id_type)
		return
	if(OUTFIT_ADJUSTMENT_SKIP_ID_PDA & equip_adjustments)
		return
	var/obj/item/card/id/W = new id_type(H)
	if(id_desc)
		W.desc = id_desc
	if(assignment)
		W.assignment = assignment
	if(job)
		W.position = job.title
		LAZYDISTINCTADD(W.access, job.get_access())
		if(!W.detail_color)
			W.detail_color = job.selection_color
			W.update_icon()
	H.update_icon()
	H.set_id_info(W)
	if(H.mind?.initial_account)
		W.associated_account_number = H.mind.initial_account.account_number
	equip_pda(H, assignment, equip_adjustments)
	if(H.equip_to_slot_or_store_or_drop(W, id_slot))
		return W

/decl/hierarchy/outfit/proc/equip_pda(var/mob/living/carbon/human/H, var/assignment, var/equip_adjustments)
	if(!pda_slot || !pda_type)
		return
	if(OUTFIT_ADJUSTMENT_SKIP_ID_PDA & equip_adjustments)
		return
	var/obj/item/modular_computer/pda/pda = new pda_type(H)
	if(H.equip_to_slot_or_store_or_drop(pda, pda_slot))
		return pda

/decl/hierarchy/outfit/dd_SortValue()
	return name
