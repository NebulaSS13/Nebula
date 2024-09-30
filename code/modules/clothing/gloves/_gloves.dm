///////////////////////////////////////////////////////////////////////
//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	desc = "A pair of gloves. They don't look special in any way."
	gender = PLURAL
	w_class = ITEM_SIZE_SMALL
	color = COLOR_WHITE
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/hands/gloves_generic.dmi'
	siemens_coefficient = 0.75
	body_parts_covered = SLOT_HANDS
	slot_flags = SLOT_HANDS
	attack_verb = list("challenged")
	blood_overlay_type = "bloodyhands"
	bodytype_equip_flags = BODY_EQUIP_FLAG_HUMANOID
	fallback_slot = slot_gloves_str
	var/obj/item/clothing/gloves/ring/covering_ring

/obj/item/clothing/gloves/get_associated_equipment_slots()
	. = ..()
	LAZYDISTINCTADD(., slot_gloves_str)

/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return

/obj/item/clothing/gloves/get_fibers()
	return "material from a pair of [name]."

/obj/item/clothing/gloves/mob_can_equip(mob/user, slot, disable_warning = FALSE, force = FALSE, ignore_equipped = FALSE)
	var/obj/item/clothing/gloves/ring/check_ring
	var/obj/item/gloves = user?.get_equipped_item(slot_gloves_str)
	if(slot == slot_gloves_str && gloves)
		if(!ignore_equipped && gloves != src)
			check_ring = gloves
			if(!istype(check_ring) || !check_ring.can_fit_under_gloves || !user.try_unequip(check_ring, src))
				if(!disable_warning)
					to_chat(user, SPAN_WARNING("You are unable to wear \the [src] as \the [gloves] are in the way."))
				return FALSE
	. = ..()
	if(check_ring && check_ring != src)
		if(.)
			covering_ring = check_ring
			to_chat(user, SPAN_NOTICE("You slip \the [src] on over \the [covering_ring]."))
		else
			user.equip_to_slot_if_possible(check_ring, slot_gloves_str, disable_warning = TRUE)

/obj/item/clothing/gloves/Destroy()
	QDEL_NULL(covering_ring)
	. = ..()

/obj/item/clothing/gloves/equipped()
	. = ..()
	if(covering_ring)
		var/mob/living/human/H = loc
		if(istype(H) && H.get_equipped_item(slot_gloves_str) != src)
			H.equip_to_slot_if_possible(covering_ring, slot_gloves_str, disable_warning = TRUE)
		var/obj/item/gloves = H.get_equipped_item(slot_gloves_str)
		if(!istype(H) || (gloves != src && gloves != covering_ring))
			covering_ring.dropInto(get_turf(src))
			covering_ring = null

/obj/item/clothing/gloves/dropped(var/mob/user)
	..()
	var/mob/living/human/H = user
	if(covering_ring)
		if(istype(H))
			H.equip_to_slot_if_possible(covering_ring, slot_gloves_str, disable_warning = TRUE)
		if(!istype(H) || H.get_equipped_item(slot_gloves_str) != covering_ring)
			covering_ring.dropInto(loc)
		covering_ring = null
