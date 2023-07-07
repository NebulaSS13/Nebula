///////////////////////////////////////////////////////////////////////
//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = ITEM_SIZE_SMALL
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/hands/gloves_generic.dmi'
	siemens_coefficient = 0.75
	body_parts_covered = SLOT_HANDS
	slot_flags = SLOT_HANDS
	attack_verb = list("challenged")
	blood_overlay_type = "bloodyhands"
	bodytype_equip_flags = BODY_FLAG_HUMANOID
	var/obj/item/clothing/ring/covering_ring

/obj/item/clothing/gloves/update_clothing_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_gloves()

/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return

/obj/item/clothing/gloves/get_fibers()
	return "material from a pair of [name]."

/obj/item/clothing/gloves/mob_can_equip(mob/M, slot, disable_warning = 0, force = 0, ignore_equipped = 0)
	var/obj/item/clothing/ring/check_ring
	var/mob/living/carbon/human/H = M
	var/obj/item/gloves = M.get_equipped_item(slot_gloves_str)
	if(slot == slot_gloves_str && istype(H) && gloves)
		if(!ignore_equipped || gloves != src)
			check_ring = gloves
			if(!istype(check_ring) || !check_ring.can_fit_under_gloves || !H.try_unequip(check_ring, src))
				if(!disable_warning)
					to_chat(M, SPAN_WARNING("You are unable to wear \the [src] as \the [gloves] are in the way."))
				return FALSE
	. = ..()
	if(check_ring && check_ring != src)
		if(.)
			covering_ring = check_ring
			to_chat(M, SPAN_NOTICE("You slip \the [src] on over \the [covering_ring]."))
		else
			M.equip_to_slot_if_possible(check_ring, slot_gloves_str, disable_warning = TRUE)

/obj/item/clothing/gloves/Destroy()
	QDEL_NULL(covering_ring)
	. = ..()

/obj/item/clothing/gloves/equipped()
	. = ..()
	if(covering_ring)
		var/mob/living/carbon/human/H = loc
		if(istype(H) && H.get_equipped_item(slot_gloves_str) != src)
			H.equip_to_slot_if_possible(covering_ring, slot_gloves_str, disable_warning = TRUE)
		var/obj/item/gloves = H.get_equipped_item(slot_gloves_str)
		if(!istype(H) || (gloves != src && gloves != covering_ring))
			covering_ring.dropInto(get_turf(src))
			covering_ring = null

/obj/item/clothing/gloves/dropped(var/mob/user)
	..()
	var/mob/living/carbon/human/H = user
	if(covering_ring)
		if(istype(H))
			H.equip_to_slot_if_possible(covering_ring, slot_gloves_str, disable_warning = TRUE)
		if(!istype(H) || H.get_equipped_item(slot_gloves_str) != covering_ring)
			covering_ring.dropInto(loc)
		covering_ring = null
