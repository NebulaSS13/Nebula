// Glass shards

/obj/item/shard
	name = "shard"
	icon = 'icons/obj/items/shards.dmi'
	desc = "Made of nothing. How does this even exist?" // set based on material, if this desc is visible it's a bug (shards default to being made of glass)
	icon_state = "large"
	randpixel = 8
	sharp = 1
	edge = 1
	w_class = ITEM_SIZE_SMALL
	material_force_multiplier = 0.12 // 6 with hardness 30 (glass)
	thrown_material_force_multiplier = 0.1 // 3 with weight 30 (glass)
	item_state = "shard-glass"
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	material = /decl/material/solid/glass
	applies_material_colour = TRUE
	applies_material_name = TRUE
	unbreakable = 1 //It's already broken.
	item_flags = ITEM_FLAG_CAN_HIDE_IN_SHOES
	var/has_handle

/obj/item/shard/attack(mob/living/M, mob/living/user, var/target_zone)
	. = ..()
	if(. && !has_handle)
		var/mob/living/carbon/human/H = user
		if(istype(H) && !H.gloves && !(H.species.species_flags & SPECIES_FLAG_NO_MINOR_CUT))
			var/obj/item/organ/external/hand = H.get_organ(H.get_active_held_item_slot())
			if(istype(hand) && !BP_IS_PROSTHETIC(hand))
				to_chat(H, SPAN_DANGER("You slice your hand on \the [src]!"))
				hand.take_external_damage(rand(5,10), used_weapon = src)

/obj/item/shard/set_material(var/new_material)
	..(new_material)
	if(!istype(material))
		return

	icon_state = "[material.shard_icon][pick("large", "medium", "small")]"
	update_icon()

	if(material.shard_type)
		SetName("[material.solid_name] [material.shard_type]")
		desc = "A small piece of [material.solid_name]. It looks sharp, you wouldn't want to step on it barefoot. Could probably be used as ... a throwing weapon?"
		switch(material.shard_type)
			if(SHARD_SPLINTER, SHARD_SHRAPNEL)
				gender = PLURAL
			else
				gender = NEUTER
	else
		qdel(src)

/obj/item/shard/on_update_icon()
	if(material)
		color = material.color
		// 1-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat visible at 0.51 opacity
		alpha = 255 * (1 - (1 - material.opacity)*(1 - material.opacity))
	else
		color = "#ffffff"
		alpha = 255

/obj/item/shard/attackby(obj/item/W, mob/user)
	if(isWelder(W) && material.shard_can_repair)
		var/obj/item/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			material.place_sheet(get_turf(src))
			qdel(src)
			return
	if(istype(W, /obj/item/stack/cable_coil))

		if(!material || (material.shard_type in list(SHARD_SPLINTER, SHARD_SHRAPNEL)))
			to_chat(user, SPAN_WARNING("\The [src] is not suitable for using as a shank."))
			return
		if(has_handle)
			to_chat(user, SPAN_WARNING("\The [src] already has a handle."))
			return
		var/obj/item/stack/cable_coil/cable = W
		if(cable.use(3))
			to_chat(user, SPAN_NOTICE("You wind some cable around the thick end of \the [src]."))
			has_handle = cable.color
			SetName("[material.solid_name] shank")
			update_icon()
			return
		to_chat(user, SPAN_WARNING("You need 3 or more units of cable to give \the [src] a handle."))
		return
	return ..()

/obj/item/shard/on_update_icon()
	overlays.Cut()
	. = ..()
	if(has_handle)
		var/image/I = image(icon, "handle")
		I.appearance_flags |= RESET_COLOR
		I.color = has_handle
		overlays += I

/obj/item/shard/Crossed(atom/movable/AM)
	..()
	if(isliving(AM))
		var/mob/M = AM

		if(M.buckled) //wheelchairs, office chairs, rollerbeds
			return

		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle metal shards with sounds
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.siemens_coefficient<0.5 || (H.species.species_flags & (SPECIES_FLAG_NO_EMBED|SPECIES_FLAG_NO_MINOR_CUT))) //Thick skin.
				return

			if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & SLOT_FEET) ) )
				return

			to_chat(M, "<span class='danger'>You step on \the [src]!</span>")

			var/list/check = list(BP_L_FOOT, BP_R_FOOT)
			while(check.len)
				var/picked = pick(check)
				var/obj/item/organ/external/affecting = H.get_organ(picked)
				if(affecting)
					if(BP_IS_PROSTHETIC(affecting))
						return
					affecting.take_external_damage(5, 0)
					H.updatehealth()
					if(affecting.can_feel_pain())
						H.Weaken(3)
					return
				check -= picked
			return

// Preset types - left here for the code that uses them
/obj/item/shard/borosilicate
	material = /decl/material/solid/glass/borosilicate

/obj/item/shard/shrapnel
	name = "shrapnel"
	material = /decl/material/solid/metal/steel
	w_class = ITEM_SIZE_TINY	//it's real small

/obj/item/shard/plastic
	material = /decl/material/solid/plastic
	w_class = ITEM_SIZE_TINY