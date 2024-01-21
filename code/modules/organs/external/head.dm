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

	var/glowing_eyes = FALSE
	var/can_intake_reagents = TRUE
	var/has_lips = TRUE
	var/forehead_graffiti
	var/graffiti_style

/obj/item/organ/external/head/proc/get_organ_eyes_overlay()
	if(!glowing_eyes && !owner?.has_chemical_effect(CE_GLOWINGEYES, 1))
		return
	var/obj/item/organ/internal/eyes/eyes = get_eyes_organ()
	var/icon/eyes_icon = eyes?.get_onhead_icon() // refreshes cache key
	if(!eyes_icon)
		return
	var/cache_key = "[eyes.last_eye_cache_key]-glow"
	if(!global.eye_icon_cache[cache_key])
		global.eye_icon_cache[cache_key] = emissive_overlay(eyes_icon, "")
	return global.eye_icon_cache[cache_key]

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

/obj/item/organ/external/head/set_bodytype(decl/bodytype/new_bodytype, override_material = null, apply_to_internal_organs = TRUE)
	. = ..()
	has_lips = (bodytype.appearance_flags & HAS_LIPS)
	can_intake_reagents = !(bodytype.body_flags & BODY_FLAG_NO_EAT)

/obj/item/organ/external/head/take_external_damage(brute, burn, damage_flags, used_weapon, override_droplimb)
	. = ..()
	if (!(status & ORGAN_DISFIGURED))
		if (brute_dam > 40)
			if (prob(50))
				disfigure(BRUTE)
		if (burn_dam > 40)
			disfigure(BURN)

/obj/item/organ/external/head/proc/get_eyes_organ()
	RETURN_TYPE(/obj/item/organ/internal/eyes)
	if(owner)
		return owner.get_organ((owner.get_bodytype().vision_organ || BP_EYES), /obj/item/organ/internal/eyes)
	return locate(/obj/item/organ/internal/eyes) in contents

/obj/item/organ/external/head/get_icon_cache_key_components()
	. = ..()
	if(bodytype.has_eyes)
		. += "_eyes[get_eyes_organ()?.eye_colour][bodytype.eye_icon]"
	if(bodytype.appearance_flags & HAS_LIPS)
		var/lip_icon = bodytype.get_lip_icon(owner)
		if(lip_icon)
			. += "_lips[lip_icon][owner?.lip_color || "skip"]"

/obj/item/organ/external/head/generate_mob_icon()
	var/icon/ret = ..()
	// Eye icon.
	if(bodytype.has_eyes)
		var/icon/eyes_icon = get_eyes_organ()?.get_onhead_icon()
		if(eyes_icon)
			ret.Blend(eyes_icon, ICON_OVERLAY)
	// Lip icon.
	if(owner && (bodytype.appearance_flags & HAS_LIPS))
		var/lip_icon = bodytype.get_lip_icon(owner)
		if(lip_icon)
			var/lip_color = owner?.lip_color
			if(lip_color)
				var/icon/lip_appearance = new/icon(lip_icon, "lipstick_s")
				lip_appearance.Blend(lip_color || COLOR_BLACK, ICON_MULTIPLY)
				ret.Blend(lip_appearance, ICON_OVERLAY)
	return ret

/obj/item/organ/external/head/get_mob_overlays()
	. = ..()
	var/image/eye_glow = get_organ_eyes_overlay()
	if(eye_glow)
		LAZYADD(., eye_glow)
	if(!owner)
		return
	var/facial_hairstyle = owner.get_facial_hairstyle()
	if(facial_hairstyle)
		var/decl/sprite_accessory/facial_hair_style = resolve_accessory_to_decl(facial_hairstyle)
		if(facial_hair_style?.accessory_is_available(owner, species, bodytype))
			LAZYADD(., image(facial_hair_style.get_cached_accessory_icon(src, owner.get_facial_hair_colour())))
	var/hairstyle = owner.get_hairstyle()
	if(hairstyle)
		var/decl/sprite_accessory/hair/hair_style = resolve_accessory_to_decl(hairstyle)
		if(hair_style?.accessory_is_available(owner, species, bodytype))
			LAZYADD(., image(hair_style.get_cached_accessory_icon(src, owner.get_hair_colour())))
