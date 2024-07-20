/**Basic damage handling for items. Returns the amount of damage taken after armor if the item was damaged.*/
/obj/item/take_damage(damage, damage_type = BRUTE, damage_flags, inflicter, armor_pen = 0, silent, do_update_health)
	if(!can_take_damage()) // This object does not take damage.
		return 0 //Must return a number
	if(damage < 0)
		CRASH("Item '[type]' take_damage proc was called with negative damage.") //Negative damage are an implementation issue.

	//Apply armor
	var/datum/extension/armor/A = get_extension(src, /datum/extension/armor)
	if(A)
		var/list/dam_after_armor = A.apply_damage_modifications(damage, damage_type, damage_flags, null, armor_pen, TRUE)
		damage       = dam_after_armor[1]
		damage_type  = dam_after_armor[2]
		damage_flags = dam_after_armor[3]
		armor_pen    = dam_after_armor[5]

	if(damage <= 0)
		return 0 //must return a number

	//Apply damage
	damage = min(current_health, damage)
	current_health = clamp(current_health - damage, 0, get_max_health())
	check_health(damage, damage_type, damage_flags)
	return damage

/obj/item/lava_act()
	if(QDELETED(src))
		return TRUE
	. = (!throwing) ? ..() : FALSE

// We only do this for the extension as other stuff that overrides get_cell() handles EMP in an override.
/obj/item/emp_act(var/severity)
	// we do not use get_cell() here as some devices may return a non-extension cell
	var/datum/extension/loaded_cell/cell_loaded = get_extension(src, /datum/extension/loaded_cell)
	var/obj/item/cell/cell = cell_loaded?.get_cell()
	for(var/obj/O in contents)
		if(O == cell)
			continue
		O.emp_act(severity)
	if(cell)
		cell.emp_act(severity)
		update_icon()
	return ..()

/obj/item/explosion_act(severity)
	if(QDELETED(src))
		return
	. = ..()
	take_damage(explosion_severity_damage(severity), BURN, DAM_EXPLODE | DAM_DISPERSED, "explosion")

/obj/item/proc/explosion_severity_damage(var/severity)
	var/mult = explosion_severity_damage_multiplier()
	return (mult * (4 - severity)) + (severity != 1? rand(-(mult / severity), (mult / severity)) : 0 )

/obj/item/proc/explosion_severity_damage_multiplier()
	return ceil(get_max_health() / 3)

/obj/item/is_burnable()
	return simulated

/obj/item/proc/get_volume_by_throwforce_and_or_w_class()
	var/thrown_force = get_thrown_attack_force()
	if(thrown_force && w_class)
		return clamp((thrown_force + w_class) * 5, 30, 100)// Add the item's thrown force to its weight class and multiply by 5, then clamp the value between 30 and 100
	else if(w_class)
		return clamp(w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
	else
		return 0

/obj/item/throw_impact(atom/hit_atom, datum/thrownthing/TT)
	. = ..()
	if(isliving(hit_atom)) //Living mobs handle hit sounds differently.
		var/volume = get_volume_by_throwforce_and_or_w_class()
		if (get_thrown_attack_force() > 0)
			if(hitsound)
				playsound(hit_atom, hitsound, volume, TRUE, -1)
			else
				playsound(hit_atom, 'sound/weapons/genhit.ogg', volume, TRUE, -1)
		else
			playsound(hit_atom, 'sound/weapons/throwtap.ogg', volume, TRUE, -1)

/obj/item/proc/eyestab(mob/living/M, mob/living/user)
	var/mob/living/human/H = M
	if(istype(H))
		for(var/slot in global.standard_headgear_slots)
			var/obj/item/protection = H.get_equipped_item(slot)
			if(istype(protection) && (protection.body_parts_covered & SLOT_EYES))
				// you can't stab someone in the eyes wearing a mask!
				to_chat(user, SPAN_WARNING("You're going to need to remove the eye covering first."))
				return TRUE

	if(!M.check_has_eyes())
		to_chat(user, SPAN_WARNING("You cannot locate any eyes on [M]!"))
		return TRUE

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
			if(M.stat != DEAD)
				if(!BP_IS_PROSTHETIC(eyes)) //robot eyes bleeding might be a bit silly
					to_chat(M, SPAN_DANGER("Your eyes start to bleed profusely!"))
			if(prob(50))
				if(M.stat != DEAD)
					to_chat(M, SPAN_WARNING("You drop what you're holding and clutch at your eyes!"))
					M.drop_held_items()
				SET_STATUS_MAX(M, STAT_BLURRY, 10)
				SET_STATUS_MAX(M, STAT_PARA, 1)
				SET_STATUS_MAX(M, STAT_WEAK, 4)
			if (eyes.damage >= eyes.min_broken_damage)
				if(M.stat != DEAD)
					to_chat(M, SPAN_WARNING("You go blind!"))

		var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, eyes.parent_organ)
		affecting.take_external_damage(7)
	else
		M.take_organ_damage(7)
	SET_STATUS_MAX(M, STAT_BLURRY, rand(3,4))
	return TRUE
