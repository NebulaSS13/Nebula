/decl/special_role/proc/equip_role(var/mob/living/human/player)

	SHOULD_CALL_PARENT(TRUE)

	if(!istype(player))
		return FALSE

	if (required_language)
		player.add_language(required_language)
		player.set_default_language(required_language)

	// This could use work.
	if(flags & ANTAG_CLEAR_EQUIPMENT)
		for(var/obj/item/thing in player.contents)
			if(player.canUnEquip(thing))
				qdel(thing)
		//mainly for nonhuman antag compatibility. Should not effect item spawning.
		player.species.equip_survival_gear(player)

	if(default_outfit)
		var/decl/outfit/outfit = GET_DECL(default_outfit)
		outfit.equip_outfit(player)

	if(default_access)
		var/obj/item/card/id/id = player.get_equipped_item(slot_wear_id_str)
		if(id)
			LAZYDISTINCTADD(id.access, default_access)

	if(rig_type)
		equip_rig(rig_type, player)

	return TRUE

/decl/special_role/proc/unequip_role(var/mob/living/human/player)
	return istype(player)

/decl/special_role/proc/equip_rig(var/rig_type, var/mob/living/human/player)
	set waitfor = FALSE
	if(istype(player) && ispath(rig_type))
		var/obj/item/rig/rig = new rig_type(player)
		rig.seal_delay = 0
		player.put_in_hands(rig)
		player.equip_to_slot_or_del(rig,slot_back_str)
		if(rig)
			rig.visible_name = player.real_name
			rig.toggle_seals(src,1)
			rig.seal_delay = initial(rig.seal_delay)
			if(rig.air_supply)
				player.set_internals(rig.air_supply)
		return rig