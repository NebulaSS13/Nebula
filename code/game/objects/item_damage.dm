/obj/item/throw_impact(atom/hit_atom, datum/thrownthing/TT)
	. = ..()
	if(isliving(hit_atom)) //Living mobs handle hit sounds differently.
		var/volume = get_impact_sound_volume()
		if (throwforce > 0)
			if(hitsound)
				playsound(hit_atom, hitsound, volume, TRUE, -1)
			else
				playsound(hit_atom, 'sound/weapons/genhit.ogg', volume, TRUE, -1)
		else
			playsound(hit_atom, 'sound/weapons/throwtap.ogg', volume, TRUE, -1)

/obj/item/proc/eyestab(mob/living/carbon/M, mob/living/carbon/user)
	var/mob/living/carbon/human/H = M
	if(istype(H))
		for(var/slot in global.standard_headgear_slots)
			var/obj/item/protection = H.get_equipped_item(slot)
			if(istype(protection) && (protection.body_parts_covered & SLOT_EYES))
				// you can't stab someone in the eyes wearing a mask!
				to_chat(user, SPAN_WARNING("You're going to need to remove the eye covering first."))
				return

	if(!M.check_has_eyes())
		to_chat(user, SPAN_WARNING("You cannot locate any eyes on [M]!"))
		return

	admin_attack_log(user, M, "Attacked using \a [src]", "Was attacked with \a [src]", "used \a [src] to attack")
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)
	src.add_fingerprint(user)

	if(istype(H))
		if(H != user)
			M.visible_message(
				SPAN_DANGER("\The [M] has been stabbed in the eye with \the [src] by \the [user]!"),
				self_message = SPAN_DANGER("You stab \the [M] in the eye with \the [src]!"))
		else
			user.visible_message(
				SPAN_DANGER("\The [user] has stabbed themself with \the [src]!"),
				self_message = SPAN_DANGER("You stab yourself in the eyes with \the [src]!"))

		var/obj/item/organ/internal/eyes = GET_INTERNAL_ORGAN(H, BP_EYES)
		eyes.damage += rand(3,4)
		if(eyes.damage >= eyes.min_bruised_damage)
			if(M.stat != 2)
				if(!BP_IS_PROSTHETIC(eyes)) //robot eyes bleeding might be a bit silly
					to_chat(M, SPAN_DANGER("Your eyes start to bleed profusely!"))
			if(prob(50))
				if(M.stat != 2)
					to_chat(M, SPAN_WARNING("You drop what you're holding and clutch at your eyes!"))
					M.drop_held_items()
				SET_STATUS_MAX(M, STAT_BLURRY, 10)
				SET_STATUS_MAX(M, STAT_PARA, 1)
				SET_STATUS_MAX(M, STAT_WEAK, 4)
			if (eyes.damage >= eyes.min_broken_damage)
				if(M.stat != 2)
					to_chat(M, SPAN_WARNING("You go blind!"))

		var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, eyes.parent_organ)
		affecting.take_external_damage(7)
	else
		M.take_organ_damage(7)
	SET_STATUS_MAX(M, STAT_BLURRY, rand(3,4))
	return

///Returns whether the object is currently damaged.
/obj/item/proc/is_damaged()
	return can_take_damage() && (health < max_health)

///Returns the percentage of health remaining for this object.
/obj/item/proc/get_percent_health()
	return can_take_damage()? round((health * 100)/max_health, 0.01) : 100

///Returns the percentage of damage done to this object.
/obj/item/proc/get_percent_damage()
	//Clamp from 0 to 100 so health values larger than max_health don't return unhelpful numbers
	return clamp(100 - get_percent_health(), 0, 100)