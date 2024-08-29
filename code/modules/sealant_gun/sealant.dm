/obj/item/sealant
	name = "glob of sealant"
	desc = "A blob of metal foam sealant."
	icon = 'icons/effects/sealant.dmi'
	icon_state = ICON_STATE_WORLD
	color = "#cccdcc"
	slowdown_general = 3
	canremove = FALSE
	slot_flags = SLOT_FULL_BODY

	var/foam_type = /obj/structure/foamedmetal
	var/splatted = FALSE // Used to prevent doubled effects if throwcode wonks up.
	var/hardened = FALSE // Set manually post-equip so that the blob can't be removed without breaking.
	var/static/list/splat_try_equip_slots = list(
		slot_head_str,
		BP_L_HAND,
		BP_R_HAND,
		slot_wear_mask_str,
		slot_wear_suit_str,
		slot_shoes_str
	)

/obj/item/sealant/get_equipment_tint()
	return TINT_BLIND

/obj/item/sealant/equipped(mob/user, slot)
	. = ..()
	if(hardened)
		break_apart(user)
	else
		to_chat(user, SPAN_DANGER("Hardened globs of metal foam stick to you!"))
		hardened = TRUE

/obj/item/sealant/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	break_apart(user)
	return TRUE

/obj/item/sealant/attackby(obj/item/used_item, mob/user)
	break_apart(user)
	return TRUE

/obj/item/sealant/dropped(mob/user)
	. = ..()
	break_apart()

/obj/item/sealant/proc/break_apart(var/mob/user)
	canremove = TRUE
	if(user)
		user.try_unequip(src, user.loc)
		user.visible_message(SPAN_NOTICE("\The [user] smashes \the [src]!"), SPAN_NOTICE("You smash \the [src]!"), SPAN_NOTICE("You hear a smashing sound."))
		user.setClickCooldown(1 SECOND)
	qdel(src)

/obj/item/sealant/Bump(atom/bumped, forced)
	. = ..()
	splat(bumped)

/obj/item/sealant/throw_impact(atom/hit_atom)
	. = ..()
	splat(hit_atom)

/obj/item/sealant/proc/splat(var/atom/target)
	if(splatted)
		return
	splatted = TRUE
	var/turf/target_turf = get_turf(target) || get_turf(src)
	if(target_turf)
		new /obj/effect/sealant(target_turf)
		if(isliving(target))
			var/mob/living/living_target = target
			for(var/slot in shuffle(splat_try_equip_slots))
				if(!living_target.get_equipped_item(slot))
					living_target.equip_to_slot_if_possible(src, slot)
					if(living_target.get_equipped_item(slot) == src)
						return
		if(!target_turf.density && !(locate(foam_type) in target_turf))
			new foam_type(target_turf)

	if(!QDELETED(src))
		qdel(src)

/obj/effect/sealant
	name = "sealant glob"
	desc = "A blob of metal foam sealant."
	icon = 'icons/effects/sealant.dmi'
	icon_state = "blank"
	layer = PROJECTILE_LAYER
	color = "#cccdcc"

/obj/effect/sealant/Initialize()
	. = ..()
	flick("blobsplat", src)
	QDEL_IN(src, 1 SECOND)
