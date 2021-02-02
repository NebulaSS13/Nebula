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
	bodytype_restricted = list(BODYTYPE_HUMANOID)
	var/obj/item/clothing/ring/covering_ring

/obj/item/clothing/gloves/update_clothing_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_gloves()

/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return

/obj/item/clothing/gloves/get_fibers()
	return "material from a pair of [name]."

/obj/item/clothing/gloves/mob_can_equip(mob/M, slot, disable_warning = 0, force = 0)
	var/obj/item/clothing/ring/check_ring
	var/mob/living/carbon/human/H = M
	if(slot == slot_gloves_str && istype(H) && H.gloves)
		check_ring = H.gloves
		if(!istype(check_ring) || !check_ring.can_fit_under_gloves || !H.unEquip(check_ring, src))
			to_chat(M, SPAN_WARNING("You are unable to wear \the [src] as \the [H.gloves] are in the way."))
			return FALSE
	. = ..()
	if(check_ring)
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
		if(istype(H) && H.gloves != src)
			H.equip_to_slot_if_possible(covering_ring, slot_gloves_str, disable_warning = TRUE)
		if(!istype(H) || (H.gloves != src && H.gloves != covering_ring))
			covering_ring.dropInto(get_turf(src))
			covering_ring = null

/obj/item/clothing/gloves/dropped(var/mob/user)
	..()
	var/mob/living/carbon/human/H = user
	if(covering_ring)
		if(istype(H))
			H.equip_to_slot_if_possible(covering_ring, slot_gloves_str, disable_warning = TRUE)
		if(!istype(H) || H.gloves != covering_ring)
			covering_ring.dropInto(loc)
		covering_ring = null
