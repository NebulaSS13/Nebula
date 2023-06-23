/obj/item/organ/external/head
	organ_tag = BP_HEAD
	name = "head"
	slot_flags = SLOT_LOWER_BODY
	max_damage = 75
	min_broken_damage = 35
	w_class = ITEM_SIZE_NORMAL
	cavity_max_w_class = ITEM_SIZE_SMALL
	body_part = SLOT_HEAD
	parent_organ = BP_CHEST
	joint = "jaw"
	amputation_point = "neck"
	encased = "skull"
	artery_name = "carotid artery"
	cavity_name = "cranial"

	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_HEALS_OVERKILL | ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_DISLOCATE

	var/draw_eyes = TRUE
	var/glowing_eyes = FALSE
	var/can_intake_reagents = TRUE
	var/has_lips = TRUE
	var/forehead_graffiti
	var/graffiti_style

/obj/item/organ/external/head/proc/get_eye_overlay()
	if(glowing_eyes || owner?.has_chemical_effect(CE_GLOWINGEYES, 1))
		var/obj/item/organ/internal/eyes/eyes = owner.get_organ((owner.get_bodytype().vision_organ || BP_EYES), /obj/item/organ/internal/eyes)
		if(eyes)
			return eyes.get_special_overlay()

/obj/item/organ/external/head/proc/get_eyes()
	var/obj/item/organ/internal/eyes/eyes = owner.get_organ((owner.get_bodytype().vision_organ || BP_EYES), /obj/item/organ/internal/eyes)
	if(eyes)
		return eyes.get_onhead_icon()

/obj/item/organ/external/head/examine(mob/user)
	. = ..()

	if(forehead_graffiti && graffiti_style)
		to_chat(user, "<span class='notice'>It has \"[forehead_graffiti]\" written on it in [graffiti_style]!</span>")

/obj/item/organ/external/head/proc/write_on(var/mob/penman, var/style)
	var/head_name = name
	var/atom/target = src
	if(owner)
		head_name = "[owner]'s [name]"
		target = owner

	if(forehead_graffiti)
		to_chat(penman, "<span class='notice'>There is no room left to write on [head_name]!</span>")
		return

	var/graffiti = sanitize_safe(input(penman, "Enter a message to write on [head_name]:") as text|null, MAX_NAME_LEN)
	if(graffiti)
		if(!target.Adjacent(penman))
			to_chat(penman, "<span class='notice'>[head_name] is too far away.</span>")
			return

		if(owner && owner.check_head_coverage())
			to_chat(penman, "<span class='notice'>[head_name] is covered up.</span>")
			return

		penman.visible_message("<span class='warning'>[penman] begins writing something on [head_name]!</span>", "You begin writing something on [head_name].")

		if(do_after(penman, 3 SECONDS, target))
			if(owner && owner.check_head_coverage())
				to_chat(penman, "<span class='notice'>[head_name] is covered up.</span>")
				return

			penman.visible_message("<span class='warning'>[penman] writes something on [head_name]!</span>", "You write something on [head_name].")
			forehead_graffiti = graffiti
			graffiti_style = style

/obj/item/organ/external/head/get_agony_multiplier()
	return (owner && owner.headcheck(organ_tag)) ? 1.50 : 1

/obj/item/organ/external/head/set_bodytype(decl/bodytype/new_bodytype, override_material = null)
	. = ..()
	has_lips = bodytype.appearance_flags & HAS_LIPS
	can_intake_reagents = !(bodytype.body_flags & BODY_FLAG_NO_EAT)
	draw_eyes = bodytype.has_eyes

/obj/item/organ/external/head/take_external_damage(brute, burn, damage_flags, used_weapon, override_droplimb)
	. = ..()
	if (!(status & ORGAN_DISFIGURED))
		if (brute_dam > 40)
			if (prob(50))
				disfigure(BRUTE)
		if (burn_dam > 40)
			disfigure(BURN)

/obj/item/organ/external/head/on_update_icon()

	..()

	if(owner)
		// Base eye icon.
		if(draw_eyes)
			var/icon/I = get_eyes()
			if(I)
				overlays |= I
				mob_icon.Blend(I, ICON_OVERLAY)

			// Floating eyes or other effects.
			var/image/eye_glow = get_eye_overlay()
			if(eye_glow)
				overlays |= eye_glow

		if(owner.lip_style && (bodytype.appearance_flags & HAS_LIPS))
			var/icon/lip_icon = new/icon(bodytype.get_lip_icon(owner) || 'icons/mob/human_races/species/lips.dmi', "lipstick_s")
			lip_icon.Blend(owner.lip_style, ICON_MULTIPLY)
			overlays |= lip_icon
			mob_icon.Blend(lip_icon, ICON_OVERLAY)

		overlays |= get_hair_icon()

	return mob_icon

/obj/item/organ/external/head/proc/get_hair_icon()
	var/image/res = image(bodytype.icon_template,"")
	if(!owner)
		return res

	if(owner.f_style)
		var/decl/sprite_accessory/facial_hair_style = GET_DECL(owner.f_style)
		if(facial_hair_style?.accessory_is_available(owner, species, bodytype.bodytype_flag, owner.gender))
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(owner.facial_hair_colour && facial_hair_style.do_colouration)
				facial_s.Blend(owner.facial_hair_colour, facial_hair_style.blend)
			res.overlays |= facial_s

	if(owner.h_style)
		var/decl/sprite_accessory/hair/hair_style = GET_DECL(owner.h_style)
		var/obj/item/head = owner.get_equipped_item(slot_head_str)
		if(head && (head.flags_inv & BLOCK_HEAD_HAIR))
			if(!(hair_style.flags & VERY_SHORT))
				hair_style = GET_DECL(/decl/sprite_accessory/hair/short)
		if(hair_style?.accessory_is_available(owner, species, bodytype.bodytype_flag, owner.gender))
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration && hair_colour)
				hair_s.Blend(hair_colour, hair_style.blend)
			res.overlays |= hair_s

	for (var/M in markings)
		var/decl/sprite_accessory/marking/mark_style = GET_DECL(M)
		if (mark_style.draw_target == MARKING_TARGET_HAIR)

			var/mark_color
			if (!mark_style.do_colouration && owner.h_style)
				var/decl/sprite_accessory/hair/hair_style = GET_DECL(owner.h_style)
				if ((~hair_style.flags & HAIR_BALD) && hair_colour)
					mark_color = hair_colour
				else //only baseline human skin tones; others will need species vars for coloration
					mark_color = rgb(200 + skin_tone, 150 + skin_tone, 123 + skin_tone)
			else
				mark_color = markings[M]
			res.overlays |= mark_style.get_cached_marking_icon(bodytype, icon_state, mark_color)
			icon_cache_key += "[M][mark_color]"

	return res

/obj/item/organ/external/head/no_eyes
	draw_eyes = FALSE
