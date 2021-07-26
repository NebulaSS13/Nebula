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

/decl/hierarchy/outfit/New()
	..()
	backpack_overrides = backpack_overrides || list()

	if(is_hidden_category())
		return
	outfits_decls_by_type_[type] = src
	dd_insertObjectList(outfits_decls_, src)

/decl/hierarchy/outfit/proc/pre_equip(mob/living/carbon/human/H)
	if(flags & OUTFIT_RESET_EQUIPMENT)
		H.delete_inventory(TRUE)

/decl/hierarchy/outfit/proc/post_equip(mob/living/carbon/human/H)
	if(flags & OUTFIT_HAS_JETPACK)
		var/obj/item/tank/jetpack/J = locate(/obj/item/tank/jetpack) in H
		if(!J)
			return
		J.toggle()
		J.toggle_valve()

/decl/hierarchy/outfit/proc/equip(mob/living/carbon/human/H, var/rank, var/assignment, var/equip_adjustments)
	equip_base(H, equip_adjustments)

	rank = id_pda_assignment || rank
	assignment = id_pda_assignment || assignment || rank
	var/obj/item/card/id/W = equip_id(H, rank, assignment, equip_adjustments)
	if(W)
		rank = W.rank
		assignment = W.assignment
	equip_pda(H, rank, assignment, equip_adjustments)

	for(var/path in backpack_contents)
		var/number = backpack_contents[path]
		for(var/i=0,i<number,i++)
			H.equip_to_slot_or_store_or_drop(new path(H), slot_in_backpack_str)

	if(!(OUTFIT_ADJUSTMENT_SKIP_POST_EQUIP & equip_adjustments))
		post_equip(H)
	H.update_icon()
	if(W) // We set ID info last to ensure the ID photo is as correct as possible.
		H.set_id_info(W)
	return 1

/decl/hierarchy/outfit/proc/equip_base(mob/living/carbon/human/H, var/equip_adjustments)
	set waitfor = FALSE
	pre_equip(H)

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		H.equip_to_slot_or_del(new uniform(H),slot_w_uniform_str)
		if(!H.get_equipped_item(slot_w_uniform_str))
			H.species.equip_default_fallback_uniform(H)
	if(holster && H.w_uniform)
		var/obj/item/clothing/accessory/equip_holster = new holster
		H.w_uniform.attackby(H, equip_holster)
		if(equip_holster.loc != H.w_uniform)
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

	if((flags & OUTFIT_HAS_BACKPACK) && !(OUTFIT_ADJUSTMENT_SKIP_BACKPACK & equip_adjustments))
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
		if(flags & OUTFIT_EXTENDED_SURVIVAL)
			H.species.equip_survival_gear(H, /obj/item/storage/box/engineer)
		else if(H.client?.prefs?.survival_box_choice && global.survival_box_choices[H.client.prefs.survival_box_choice])
			var/decl/survival_box_option/box = global.survival_box_choices[H.client.prefs.survival_box_choice]
			H.species.equip_survival_gear(H, box.box_type)
		else
			H.species.equip_survival_gear(H)

	if(H.client?.prefs?.give_passport)
		global.using_map.create_passport(H)

/decl/hierarchy/outfit/proc/equip_id(var/mob/living/carbon/human/H, var/rank, var/assignment, var/equip_adjustments)
	if(!id_slot || !id_type)
		return
	if(OUTFIT_ADJUSTMENT_SKIP_ID_PDA & equip_adjustments)
		return
	var/obj/item/card/id/W = new id_type(H)
	if(id_desc)
		W.desc = id_desc
	if(rank)
		W.rank = rank
	if(assignment)
		W.assignment = assignment
	H.set_id_info(W)
	if(H.equip_to_slot_or_store_or_drop(W, id_slot))
		return W

/decl/hierarchy/outfit/proc/equip_pda(var/mob/living/carbon/human/H, var/rank, var/assignment, var/equip_adjustments)
	if(!pda_slot || !pda_type)
		return
	if(OUTFIT_ADJUSTMENT_SKIP_ID_PDA & equip_adjustments)
		return
	var/obj/item/modular_computer/pda/pda = new pda_type(H)
	if(H.equip_to_slot_or_store_or_drop(pda, pda_slot))
		return pda

/decl/hierarchy/outfit/dd_SortValue()
	return name
