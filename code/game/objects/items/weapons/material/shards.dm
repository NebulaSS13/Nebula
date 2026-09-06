// Glass shards

/obj/item/shard
	name = SHARD_SHARD
	icon = 'icons/obj/items/shards.dmi'
	desc = "Made of nothing. How does this even exist?" // set based on material, if this desc is visible it's a bug (shards default to being made of glass)
	icon_state = "large"
	randpixel = 8
	sharp = TRUE
	edge = TRUE
	w_class = ITEM_SIZE_SMALL
	item_state = "shard-glass"
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	material = /decl/material/solid/glass
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME
	item_flags = ITEM_FLAG_CAN_HIDE_IN_SHOES
	var/has_handle = FALSE

/obj/item/shard/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SCALPEL = TOOL_QUALITY_BAD))

/obj/item/shard/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	. = ..()
	if(. && !has_handle && ishuman(user))
		var/mob/living/human/H = user
		if(!H.get_equipped_item(slot_gloves_str) && !(H.species.species_flags & SPECIES_FLAG_NO_MINOR_CUT))
			var/obj/item/organ/external/hand = GET_EXTERNAL_ORGAN(H, H.get_active_held_item_slot())
			if(istype(hand) && !BP_IS_PROSTHETIC(hand))
				to_chat(H, SPAN_DANGER("You slice your hand on \the [src]!"))
				hand.take_damage(rand(5,10), inflicter = src)

/obj/item/shard/set_material(var/new_material)
	..(new_material)
	if(!istype(material))
		return

	icon_state = "[material.shard_icon][pick("large", "medium", "small")]"
	update_icon()

	if(material.shard_name)
		SetName("[material.solid_name] [material.shard_name]")
		desc = "A small piece of [material.solid_name]. It looks sharp, you wouldn't want to step on it barefoot. Could probably be used as ... a throwing weapon?"
		switch(material.shard_name)
			if(SHARD_SPLINTER, SHARD_SHRAPNEL)
				gender = PLURAL
			else
				gender = NEUTER
	else
		qdel(src)

/obj/item/shard/on_update_icon()
	. = ..()
	// 1-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat visible at 0.51 opacity
	alpha = 255 * (material ? (1 - (1 - material.opacity)**2) : 1)
	if(has_handle)
		add_overlay(overlay_image(icon, "handle", has_handle, RESET_COLOR))

/obj/item/shard/attackby(obj/item/used_item, mob/user)
	if(IS_WELDER(used_item) && material.shard_can_repair)
		var/obj/item/weldingtool/welder = used_item
		if(welder.weld(0, user))
			material.create_object(get_turf(src))
			qdel(src)
			return TRUE
	if(istype(used_item, /obj/item/stack/cable_coil))

		if(!material || (material.shard_name in list(SHARD_SPLINTER, SHARD_SHRAPNEL)))
			to_chat(user, SPAN_WARNING("\The [src] is not suitable for using as a shank."))
			return TRUE
		if(has_handle)
			to_chat(user, SPAN_WARNING("\The [src] already has a handle."))
			return TRUE
		var/obj/item/stack/cable_coil/cable = used_item
		if(cable.use(3))
			to_chat(user, SPAN_NOTICE("You wind some cable around the thick end of \the [src]."))
			has_handle = cable.color
			SetName("[material.solid_name] shank")
			update_icon()
			return TRUE
		to_chat(user, SPAN_WARNING("You need 3 or more units of cable to give \the [src] a handle."))
		return TRUE
	return ..()

/obj/item/shard/Crossed(atom/movable/AM)
	..()
	if(!isliving(AM))
		return

	var/mob/living/victim = AM
	if(victim.buckled) //wheelchairs, office chairs, rollerbeds
		return
	if(victim.immune_to_floor_hazards())
		return

	playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle metal shards with sounds

	var/decl/species/walker_species = victim.get_species()
	if(walker_species?.species_flags & (SPECIES_FLAG_NO_EMBED|SPECIES_FLAG_NO_MINOR_CUT)) //Thick skin.
		return

	var/obj/item/shoes = victim.get_equipped_item(slot_shoes_str)
	var/obj/item/suit = victim.get_equipped_item(slot_wear_suit_str)
	if(shoes || (suit && (suit.body_parts_covered & SLOT_FEET)))
		return

	var/list/check = list(BP_L_FOOT, BP_R_FOOT)
	while(check.len)
		var/picked = pick_n_take(check)
		var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(victim, picked)
		if(!affecting || BP_IS_PROSTHETIC(affecting))
			continue
		to_chat(victim, SPAN_DANGER("You step on \the [src]!"))
		affecting.take_damage(5)
		if(affecting.can_feel_pain())
			SET_STATUS_MAX(victim, STAT_WEAK, 3)
		return

//Prevent the shard from being allowed to shatter
/obj/item/shard/check_health(var/lastdamage = null, var/lastdamtype = null, var/lastdamflags = 0, var/consumed = FALSE)
	if(current_health > 0 || !can_take_damage())
		return //If invincible, or if we're not dead yet, skip
	if(lastdamtype == BURN)
		handle_melting()
		return
	physically_destroyed()

/obj/item/shard/shatter(consumed)
	physically_destroyed()

/obj/item/shard/can_take_wear_damage()
	return FALSE

// Preset types - left here for the code that uses them
/obj/item/shard/borosilicate
	material = /decl/material/solid/glass/borosilicate

/obj/item/shard/shrapnel
	name = "shrapnel"
	material = /decl/material/solid/metal/steel
	w_class = ITEM_SIZE_TINY	//it's real small

/obj/item/shard/plastic
	material = /decl/material/solid/organic/plastic
	w_class = ITEM_SIZE_TINY