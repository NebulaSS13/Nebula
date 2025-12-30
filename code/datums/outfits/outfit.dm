/decl/outfit
	abstract_type = /decl/outfit
	var/name       = "Naked And Afraid"
	var/uniform    = null
	var/suit       = null
	var/back       = null
	var/belt       = null
	var/gloves     = null
	var/shoes      = null
	var/head       = null
	var/mask       = null
	var/l_ear      = null
	var/r_ear      = null
	var/glasses    = null
	var/id         = null
	var/l_pocket   = null
	var/r_pocket   = null
	var/suit_store = null
	var/holster    = null
	/// Linear list of types. Will attempt to place items in hands.
	var/list/hands
	//. An associative list in list(path=count,otherpath=count) format. Will attempt to place items in storage.
	var/list/backpack_contents

	var/id_type
	var/id_desc
	var/id_slot

	var/pda_type
	var/pda_slot

	var/id_pda_assignment

	var/list/backpack_overrides
	var/outfit_flags = OUTFIT_RESET_EQUIPMENT

/decl/outfit/Initialize()
	. = ..()
	backpack_overrides = backpack_overrides || list()

// Used for slightly cleaner code around multi-equip records.
/decl/outfit/proc/resolve_equip_to_list(check_type)
	if(islist(check_type))
		return check_type
	if(ispath(check_type))
		return list(check_type)
	return null

/decl/outfit/validate()
	. = ..()

	for(var/check_type in list(uniform, suit, back, belt, gloves, shoes, head, mask, l_ear, r_ear, glasses, id, l_pocket, r_pocket, suit_store, pda_type, id_type))
		for(var/obj/item/thing as anything in resolve_equip_to_list(check_type))
			if(TYPE_IS_ABSTRACT(thing))
				. += "equipment includes abstract type '[thing]'"

	for(var/check_type in hands)
		var/obj/item/thing = check_type
		if(isnull(thing))
			continue
		if(TYPE_IS_ABSTRACT(thing))
			. += "hands includes abstract type '[thing]'"

	for(var/check_type in backpack_contents)
		var/obj/item/thing = check_type
		if(isnull(thing))
			continue
		if(TYPE_IS_ABSTRACT(thing))
			. += "backpack includes abstract type '[thing]'"

	if(uniform && (outfit_flags & OUTFIT_HAS_VITALS_SENSOR))
		var/list/uniforms = resolve_equip_to_list(uniform)
		if(!length(uniforms))
			. += "outfit is flagged for sensors, but has no uniform"
		else
			var/succeeded = FALSE
			var/obj/item/sensor = new /obj/item/clothing/sensor/vitals
			for(var/thing in uniforms)
				if(!ispath(thing, /obj/item/clothing))
					. += "outfit is flagged for sensors, but uniform [thing] cannot take accessories"
				if(thing)
					var/obj/item/clothing/wear_uniform = new thing // sadly we need to read a list
					if(wear_uniform.can_attach_accessory(sensor))
						succeeded = TRUE
					if(!QDELETED(wear_uniform))
						qdel(wear_uniform)
					if(succeeded)
						break
			if(!QDELETED(sensor))
				qdel(sensor)
			if(!succeeded)
				. += "outfit is flagged for sensors, but uniform does not accept sensors"

/decl/outfit/proc/pre_equip(mob/living/wearer)
	if(outfit_flags & OUTFIT_RESET_EQUIPMENT)
		wearer.delete_inventory(TRUE)

/decl/outfit/proc/post_equip(mob/living/wearer)
	if(outfit_flags & OUTFIT_HAS_JETPACK)
		var/obj/item/tank/jetpack/J = locate(/obj/item/tank/jetpack) in wearer
		if(!J)
			return
		J.toggle()
		J.toggle_valve()

/decl/outfit/proc/equip_outfit(mob/living/wearer, assignment, equip_adjustments, datum/job/job, datum/mil_rank/rank)
	equip_base(wearer, equip_adjustments)
	equip_id(wearer, assignment, equip_adjustments, job, rank)
	for(var/path in backpack_contents)
		var/number = max(1, backpack_contents[path])
		for(var/i = 1 to number)
			wearer.equip_to_slot_or_store_or_drop(new path(wearer), slot_in_backpack_str)

	if(!(OUTFIT_ADJUSTMENT_SKIP_POST_EQUIP & equip_adjustments))
		post_equip(wearer)

	if(outfit_flags & OUTFIT_HAS_VITALS_SENSOR)
		try_equip_vitals_sensor(wearer)

	return 1

/decl/outfit/proc/try_equip_vitals_sensor(mob/living/wearer)
	// Find an appropriate slot for the sensor.
	var/obj/item/clothing/sensor/vitals/sensor = new
	for(var/check_slot in global.vitals_sensor_equip_slots)
		if(!wearer.get_inventory_slot_datum(check_slot))
			continue
		var/obj/item/clothing/equipped = wearer.get_equipped_item(check_slot)
		if(istype(equipped) && !(locate(/obj/item/clothing/sensor/vitals) in equipped.accessories) && equipped.can_attach_accessory(sensor))
			equipped.attach_accessory(null, sensor)
			break
	// As a fallback dump the sensor into hands or storage.
	if(!istype(sensor.loc, /obj/item/clothing))
		wearer.put_in_hands_or_store_or_drop(sensor)

/decl/outfit/proc/try_equip(mob/living/wearer, equip_type, equip_slot)

	// Equip as base item.
	var/obj/item/thing = wearer.get_equipped_item(equip_slot)
	if(!istype(thing))
		return wearer.equip_to_slot_or_del(new equip_type(wearer), equip_slot)

	// Equip as accessory.
	if(istype(thing, /obj/item/clothing))
		var/obj/item/new_kit = new equip_type(wearer)
		thing.attackby(new_kit, wearer)
		if(new_kit.loc != thing && !QDELETED(new_kit))
			qdel(new_kit)
			return FALSE
		return TRUE

	return FALSE

/decl/outfit/proc/equip_base(mob/living/wearer, var/equip_adjustments)
	set waitfor = FALSE
	pre_equip(wearer)

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		for(var/uniform_type in resolve_equip_to_list(uniform))
			try_equip(wearer, uniform_type, slot_w_uniform_str)

		if(!wearer.get_equipped_item(slot_w_uniform_str))
			wearer.get_species()?.equip_default_fallback_uniform(wearer)

		var/obj/item/equip_uniform = wearer.get_equipped_item(slot_w_uniform_str)
		if(holster && equip_uniform)
			var/obj/item/clothing/equip_holster = new holster
			equip_uniform.attackby(equip_holster, wearer)
			if(equip_holster.loc != equip_uniform && !QDELETED(equip_holster))
				qdel(equip_holster)

	if(l_ear)
		for(var/l_ear_type in resolve_equip_to_list(l_ear))
			var/l_ear_path = (OUTFIT_ADJUSTMENT_PLAIN_HEADSET & equip_adjustments) && ispath(l_ear_type, /obj/item/radio/headset) ? /obj/item/radio/headset : l_ear_type
			try_equip(wearer, l_ear_path, slot_l_ear_str)
	if(r_ear)
		for(var/r_ear_type in resolve_equip_to_list(r_ear))
			var/r_ear_path = (OUTFIT_ADJUSTMENT_PLAIN_HEADSET & equip_adjustments) && ispath(r_ear_type, /obj/item/radio/headset) ? /obj/item/radio/headset : r_ear_type
			try_equip(wearer, r_ear_path, slot_r_ear_str)

	// Ears, backpack and uniforms are handled individually.
	var/list/slot_to_gear  = list(
		(slot_wear_suit_str) = resolve_equip_to_list(suit),
		(slot_back_str)      = resolve_equip_to_list(back),
		(slot_belt_str)      = resolve_equip_to_list(belt),
		(slot_gloves_str)    = resolve_equip_to_list(gloves),
		(slot_shoes_str)     = resolve_equip_to_list(shoes),
		(slot_wear_mask_str) = resolve_equip_to_list(mask),
		(slot_head_str)      = resolve_equip_to_list(head),
		(slot_glasses_str)   = resolve_equip_to_list(glasses),
		(slot_wear_id_str)   = resolve_equip_to_list(id),
		(slot_l_store_str)   = resolve_equip_to_list(l_pocket),
		(slot_r_store_str)   = resolve_equip_to_list(r_pocket),
		(slot_s_store_str)   = resolve_equip_to_list(suit_store)
	)

	for(var/slot in slot_to_gear)
		var/list/slot_data = slot_to_gear[slot]
		if(slot_data)
			for(var/gear_type in slot_data)
				try_equip(wearer, gear_type, slot)

	for(var/hand in hands)
		wearer.put_in_hands(new hand(wearer))

	if((outfit_flags & OUTFIT_HAS_BACKPACK) && !(OUTFIT_ADJUSTMENT_SKIP_BACKPACK & equip_adjustments))
		var/decl/backpack_outfit/backpack_option
		var/metadata

		if(wearer.backpack_setup)
			backpack_option = wearer.backpack_setup.backpack
			metadata = wearer.backpack_setup.metadata
		else
			backpack_option = get_default_outfit_backpack()

		var/override_type = backpack_overrides[backpack_option.type]
		var/backpack = backpack_option.spawn_backpack(wearer, metadata, override_type)

		if(backpack)
			if(back)
				if(!wearer.put_in_hands(backpack))
					wearer.equip_to_appropriate_slot(backpack)
			else
				wearer.equip_to_slot_or_del(backpack, slot_back_str)

	var/decl/species/wearer_species = wearer.get_species()
	if(wearer_species && !(OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR & equip_adjustments))
		var/decl/survival_box_option/chosen_survival_box = wearer?.client?.prefs.survival_box_choice
		if(chosen_survival_box?.box_type)
			if(outfit_flags & OUTFIT_EXTENDED_SURVIVAL)
				wearer_species.equip_survival_gear(wearer, /obj/item/box/engineer)
			else
				wearer_species.equip_survival_gear(wearer, chosen_survival_box.box_type)

	if(wearer.client?.prefs?.give_passport)
		global.using_map.create_passport(wearer)

/decl/outfit/proc/equip_id(mob/living/wearer, assignment, equip_adjustments, datum/job/job, datum/mil_rank/rank)
	if(!id_slot || !id_type)
		return
	if(OUTFIT_ADJUSTMENT_SKIP_ID_PDA & equip_adjustments)
		return
	var/obj/item/card/id/id_card = new id_type(wearer)
	if(id_desc)
		id_card.desc = id_desc
	if(assignment)
		id_card.assignment = assignment
	if(job)
		id_card.position = job.title
		LAZYDISTINCTADD(id_card.access, job.get_access())
		if(!id_card.detail_color)
			id_card.detail_color = job.selection_color
			id_card.update_icon()
	wearer.update_icon()
	wearer.set_id_info(id_card)
	equip_pda(wearer, id_pda_assignment || assignment, equip_adjustments)
	if(wearer.equip_to_slot_or_store_or_drop(id_card, id_slot))
		return id_card

/decl/outfit/proc/equip_pda(var/mob/living/wearer, var/label_assignment, var/equip_adjustments)
	if(!pda_slot || !pda_type)
		return
	if(OUTFIT_ADJUSTMENT_SKIP_ID_PDA & equip_adjustments)
		return
	var/obj/item/modular_computer/pda/pda = new pda_type(wearer)
	pda.set_owner_rank_job(wearer.real_name, label_assignment)
	if(wearer.equip_to_slot_or_store_or_drop(pda, pda_slot))
		return pda

/decl/outfit/dd_SortValue()
	return name
