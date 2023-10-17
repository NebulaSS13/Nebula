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
	var/flags = OUTFIT_RESET_EQUIPMENT

/decl/hierarchy/outfit/Initialize()
	. = ..()
	backpack_overrides = backpack_overrides || list()
	if(!INSTANCE_IS_ABSTRACT(src))
		outfits_decls_by_type_[type] = src
		dd_insertObjectList(outfits_decls_, src)

/decl/hierarchy/outfit/proc/pre_equip(mob/living/equipping)
	if(flags & OUTFIT_RESET_EQUIPMENT)
		equipping.delete_inventory(TRUE)

/decl/hierarchy/outfit/proc/post_equip(mob/living/equipping)
	if(flags & OUTFIT_HAS_JETPACK)
		var/obj/item/tank/jetpack/J = locate(/obj/item/tank/jetpack) in equipping
		if(!J)
			return
		J.toggle()
		J.toggle_valve()

/decl/hierarchy/outfit/proc/equip_outfit(mob/living/equipping, rank, alt_title, equip_adjustments)
	equip_base(equipping, equip_adjustments)
	equip_id(equipping, rank, alt_title, null, equip_adjustments)
	for(var/path in backpack_contents)
		var/number = backpack_contents[path]
		for(var/i=0,i<number,i++)
			equipping.equip_to_slot_or_store_or_drop(new path(equipping), slot_in_backpack_str)
	if(!(OUTFIT_ADJUSTMENT_SKIP_POST_EQUIP & equip_adjustments))
		post_equip(equipping)
	return TRUE

/decl/hierarchy/outfit/proc/equip_base(mob/living/equipping, equip_adjustments)
	set waitfor = FALSE
	pre_equip(equipping)

	var/decl/species/my_species = equipping.get_species()

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		equipping.equip_to_slot_or_del(new uniform(equipping),slot_w_uniform_str)
		if(!equipping.get_equipped_item(slot_w_uniform_str))
			if(my_species)
				my_species.equip_default_fallback_uniform(equipping)

		var/obj/item/equip_uniform = equipping.get_equipped_item(slot_w_uniform_str)
		if(holster && equip_uniform)
			var/obj/item/clothing/accessory/equip_holster = new holster
			equip_uniform.attackby(equip_holster, equipping)
			if(equip_holster.loc != equip_uniform && !QDELETED(equip_holster))
				qdel(equip_holster)

	if(suit)
		equipping.equip_to_slot_or_del(new suit(equipping),slot_wear_suit_str)
	if(back)
		equipping.equip_to_slot_or_del(new back(equipping),slot_back_str)
	if(belt)
		equipping.equip_to_slot_or_del(new belt(equipping),slot_belt_str)
	if(gloves)
		equipping.equip_to_slot_or_del(new gloves(equipping),slot_gloves_str)
	if(shoes)
		equipping.equip_to_slot_or_del(new shoes(equipping),slot_shoes_str)
	if(mask)
		equipping.equip_to_slot_or_del(new mask(equipping),slot_wear_mask_str)
	if(head)
		equipping.equip_to_slot_or_del(new head(equipping),slot_head_str)
	if(l_ear)
		var/l_ear_path = (OUTFIT_ADJUSTMENT_PLAIN_HEADSET & equip_adjustments) && ispath(l_ear, /obj/item/radio/headset) ? /obj/item/radio/headset : l_ear
		equipping.equip_to_slot_or_del(new l_ear_path(equipping),slot_l_ear_str)
	if(r_ear)
		var/r_ear_path = (OUTFIT_ADJUSTMENT_PLAIN_HEADSET & equip_adjustments) && ispath(r_ear, /obj/item/radio/headset) ? /obj/item/radio/headset : r_ear
		equipping.equip_to_slot_or_del(new r_ear_path(equipping),slot_r_ear_str)
	if(glasses)
		equipping.equip_to_slot_or_del(new glasses(equipping),slot_glasses_str)
	if(id)
		equipping.equip_to_slot_or_del(new id(equipping),slot_wear_id_str)
	if(l_pocket)
		equipping.equip_to_slot_or_del(new l_pocket(equipping),slot_l_store_str)
	if(r_pocket)
		equipping.equip_to_slot_or_del(new r_pocket(equipping),slot_r_store_str)
	if(suit_store)
		equipping.equip_to_slot_or_del(new suit_store(equipping),slot_s_store_str)
	for(var/hand in hands)
		equipping.put_in_hands(new hand(equipping))

	if((flags & OUTFIT_HAS_BACKPACK) && !(OUTFIT_ADJUSTMENT_SKIP_BACKPACK & equip_adjustments))
		var/decl/backpack_outfit/bo
		var/metadata

		var/mob/living/carbon/human/equipping_human = equipping
		if(ishuman(equipping_human) && equipping_human.backpack_setup)
			bo = equipping_human.backpack_setup.backpack
			metadata = equipping_human.backpack_setup.metadata
		else
			bo = get_default_outfit_backpack()

		var/override_type = backpack_overrides[bo.type]
		var/backpack = bo.spawn_backpack(equipping, metadata, override_type)

		if(backpack)
			if(back)
				if(!equipping.put_in_hands(backpack))
					equipping.equip_to_appropriate_slot(backpack)
			else
				equipping.equip_to_slot_or_del(backpack, slot_back_str)

	if(my_species && !(OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR & equip_adjustments))
		if(flags & OUTFIT_EXTENDED_SURVIVAL)
			my_species.equip_survival_gear(equipping, /obj/item/storage/box/engineer)
		else if(equipping.client?.prefs?.survival_box_choice && global.survival_box_choices[equipping.client.prefs.survival_box_choice])
			var/decl/survival_box_option/box = global.survival_box_choices[equipping.client.prefs.survival_box_choice]
			my_species.equip_survival_gear(equipping, box.box_type)
		else
			my_species.equip_survival_gear(equipping)

	if(equipping.client?.prefs?.give_passport)
		global.using_map.create_passport(equipping)

/decl/hierarchy/outfit/proc/equip_id(var/mob/living/equipping, var/rank, var/alt_title, var/datum/job/job, var/equip_adjustments)
	if(!id_slot || !id_type)
		return
	if(OUTFIT_ADJUSTMENT_SKIP_ID_PDA & equip_adjustments)
		return
	var/obj/item/card/id/W = new id_type(equipping)
	if(id_desc)
		W.desc = id_desc
	if(rank)
		W.rank = rank
	if(alt_title)
		W.assignment = alt_title
	if(job)
		if(!W.assignment)
			W.assignment = job.title
		LAZYDISTINCTADD(W.access, job.get_access())
		if(!W.detail_color)
			W.detail_color = job.selection_color
			W.update_icon()
	equipping.update_icon()
	equipping.set_id_info(W)

	if(equipping.mind?.initial_account)
		W.associated_account_number = equipping.mind.initial_account.account_number

	equip_pda(equipping, equip_adjustments)
	if(equipping.equip_to_slot_or_store_or_drop(W, id_slot))
		return W

/decl/hierarchy/outfit/proc/equip_pda(var/mob/living/equipping, var/equip_adjustments)
	if(!pda_slot || !pda_type)
		return
	if(OUTFIT_ADJUSTMENT_SKIP_ID_PDA & equip_adjustments)
		return
	var/obj/item/modular_computer/pda/pda = new pda_type(equipping)
	if(equipping.equip_to_slot_or_store_or_drop(pda, pda_slot))
		return pda

/decl/hierarchy/outfit/dd_SortValue()
	return name
