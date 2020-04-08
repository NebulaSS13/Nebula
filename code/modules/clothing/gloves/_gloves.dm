///////////////////////////////////////////////////////////////////////
//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/clothing/obj_hands.dmi'
	siemens_coefficient = 0.75
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	blood_overlay_type = "bloodyhands"
	bodytype_restricted = list(BODYTYPE_HUMANOID)

	var/obj/item/clothing/ring/ring = null		//Covered ring
	var/mob/living/carbon/human/wearer = null	//Used for covered rings when dropping

/obj/item/clothing/gloves/update_clothing_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_gloves()

/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return

/obj/item/clothing/gloves/get_fibers()
	return "material from a pair of [name]."

/obj/item/clothing/gloves/mob_can_equip(mob/user)
	var/mob/living/carbon/human/H = user
	if(istype(H.gloves, /obj/item/clothing/ring))
		ring = H.gloves
		if(!ring.undergloves)
			to_chat(user, "You are unable to wear \the [src] as \the [H.gloves] are in the way.")
			ring = null
			return FALSE
		if(!H.unEquip(ring, src))//Remove the ring (or other under-glove item in the hand slot?) so you can put on the gloves.
			ring = null
			return FALSE
	if(!..())
		if(ring) //Put the ring back on if the check fails.
			if(H.equip_to_slot_if_possible(ring, slot_gloves))
				src.ring = null
		return FALSE
	if (ring)
		to_chat(user, "You slip \the [src] on over \the [ring].")
	wearer = H //TODO clean this when magboots are cleaned
	return TRUE

/obj/item/clothing/gloves/dropped()
	..()
	if(!wearer)
		return
	var/mob/living/carbon/human/H = wearer
	if(ring && istype(H))
		if(!H.equip_to_slot_if_possible(ring, slot_gloves))
			ring.dropInto(loc)
		src.ring = null
	wearer = null
