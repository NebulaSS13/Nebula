/decl/grab/normal
	name = "grab"
	icon = 'icons/mob/screen1.dmi'
	help_action = "inspect"
	disarm_action = "pin"
	grab_action = "jointlock"
	harm_action = "dislocate"
	var/drop_headbutt = 1

/decl/grab/normal/on_hit_help(var/obj/item/grab/G, var/atom/A, var/proximity)

	var/obj/item/organ/external/O = G.get_targeted_organ()
	if(!O || !proximity || (A && A != G.get_affecting_mob()))
		return FALSE
	return O.inspect(G.assailant)

/decl/grab/normal/on_hit_disarm(var/obj/item/grab/G, var/atom/A, var/proximity)

	if(!proximity)
		return FALSE

	var/mob/living/affecting = G.get_affecting_mob()
	var/mob/living/assailant = G.assailant
	if(affecting && A && A == affecting && !affecting.lying)

		affecting.visible_message(SPAN_DANGER("\The [assailant] is trying to pin \the [affecting] to the ground!"))
		if(do_mob(assailant, affecting, action_cooldown - 1))
			G.action_used()
			SET_STATUS_MAX(affecting, STAT_WEAK, 2)
			affecting.visible_message(SPAN_DANGER("\The [assailant] pins \the [affecting] to the ground!"))
			return TRUE
		affecting.visible_message(SPAN_WARNING("\The [assailant] fails to pin \the [affecting] to the ground."))

	return FALSE

/decl/grab/normal/on_hit_grab(var/obj/item/grab/G, var/atom/A, var/proximity)

	if(!proximity)
		return FALSE

	var/mob/living/affecting = G.get_affecting_mob()
	if(!affecting || (A && A != affecting))
		return FALSE

	var/mob/living/assailant = G.assailant
	if(!assailant)
		return FALSE

	var/obj/item/organ/external/O = G.get_targeted_organ()
	if(!O)
		to_chat(assailant, SPAN_WARNING("\The [affecting] is missing that body part!"))
		return FALSE

	if(!assailant.skill_check(SKILL_COMBAT, SKILL_ADEPT))
		to_chat(assailant, SPAN_WARNING("You clumsily attempt to jointlock \the [affecting]'s [O.name], but fail!"))
		return FALSE

	assailant.visible_message(SPAN_DANGER("\The [assailant] begins to [pick("bend", "twist")] \the [affecting]'s [O.name] into a jointlock!"))
	if(do_mob(assailant, affecting, action_cooldown - 1))
		G.action_used()
		O.jointlock(assailant)
		assailant.visible_message(SPAN_DANGER("\The [affecting]'s [O.name] is twisted!"))
		playsound(assailant.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		return TRUE

	affecting.visible_message(SPAN_WARNING("\The [assailant] fails to jointlock \the [affecting]'s [O.name]."))
	return FALSE

/decl/grab/normal/on_hit_harm(var/obj/item/grab/G, var/atom/A, var/proximity)

	if(!proximity)
		return FALSE

	var/mob/living/affecting = G.get_affecting_mob()
	if(!affecting || (A && A != affecting))
		return FALSE

	var/mob/living/assailant = G.assailant
	if(!assailant)
		return FALSE

	var/obj/item/organ/external/O = G.get_targeted_organ()
	if(!O)
		to_chat(assailant, SPAN_WARNING("\The [affecting] is missing that body part!"))
		return  FALSE

	if(!assailant.skill_check(SKILL_COMBAT, SKILL_ADEPT))
		to_chat(assailant, SPAN_WARNING("You clumsily attempt to dislocate \the [affecting]'s [O.name], but fail!"))
		return FALSE

	if(!O.is_dislocated() && (O.limb_flags & ORGAN_FLAG_CAN_DISLOCATE))
		assailant.visible_message(SPAN_DANGER("\The [assailant] begins to dislocate \the [affecting]'s [O.joint]!"))
		if(do_mob(assailant, affecting, action_cooldown - 1))
			G.action_used()
			O.dislocate()
			assailant.visible_message(SPAN_DANGER("\The [affecting]'s [O.joint] [pick("gives way","caves in","crumbles","collapses")]!"))
			playsound(assailant.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			return TRUE
		affecting.visible_message(SPAN_WARNING("\The [assailant] fails to dislocate \the [affecting]'s [O.joint]."))
		return FALSE

	if(O.limb_flags & ORGAN_FLAG_CAN_DISLOCATE)
		to_chat(assailant, SPAN_WARNING("\The [affecting]'s [O.joint] is already dislocated!"))
	else
		to_chat(assailant, SPAN_WARNING("You can't dislocate \the [affecting]'s [O.joint]!"))
	return FALSE

/decl/grab/normal/resolve_openhand_attack(var/obj/item/grab/G)
	if(G.assailant.a_intent != I_HELP)
		if(G.target_zone == BP_HEAD)
			if(G.assailant.get_target_zone() == BP_EYES)
				if(attack_eye(G))
					return TRUE
			else
				if(headbutt(G))
					if(drop_headbutt)
						let_go()
					return TRUE
	return FALSE

/decl/grab/normal/proc/attack_eye(var/obj/item/grab/G)
	var/mob/living/carbon/human/target = G.get_affecting_mob()
	var/mob/living/carbon/human/attacker = G.assailant
	if(!istype(target) || !istype(attacker))
		return
	var/decl/natural_attack/attack = attacker.get_unarmed_attack(target, BP_EYES)
	if(!istype(attack))
		return
	for(var/slot in global.standard_headgear_slots)
		var/obj/item/protection = target.get_equipped_item(slot)
		if(istype(protection) && (protection.body_parts_covered & SLOT_EYES))
			to_chat(attacker, "<span class='danger'>You're going to need to remove the eye covering first.</span>")
			return
	if(!target.check_has_eyes())
		to_chat(attacker, "<span class='danger'>You cannot locate any eyes on [target]!</span>")
		return

	admin_attack_log(attacker, target, "Grab attacked the victim's eyes.", "Had their eyes grab attacked.", "attacked the eyes, using a grab action, of")

	attack.handle_eye_attack(attacker, target)
	return 1

/decl/grab/normal/proc/headbutt(var/obj/item/grab/G)
	var/mob/living/carbon/human/target = G.get_affecting_mob()
	var/mob/living/carbon/human/attacker = G.assailant
	if(!istype(target)	 || !istype(attacker))
		return
	if(!attacker.skill_check(SKILL_COMBAT, SKILL_BASIC))
		return

	if(target.lying)
		return

	var/damage = 20
	var/obj/item/clothing/hat = attacker.get_equipped_item(slot_head_str)
	var/damage_flags = 0
	if(istype(hat))
		damage += hat.force * 3
		damage_flags = hat.damage_flags()

	if(damage_flags & DAM_SHARP)
		if(istype(hat))
			attacker.visible_message(SPAN_DANGER("\The [attacker] gores \the [target] with \the [hat]!"))
		else
			attacker.visible_message(SPAN_DANGER("\The [attacker] gores \the [target]!"))
	else
		var/decl/pronouns/attacker_gender = attacker.get_pronouns()
		attacker.visible_message(SPAN_DANGER("\The [attacker] thrusts [attacker_gender.his] head into \the [target]'s skull!"))

	var/armor = target.get_blocked_ratio(BP_HEAD, BRUTE, damage = 10)
	target.apply_damage(damage, BRUTE, BP_HEAD, damage_flags)
	attacker.apply_damage(10, BRUTE, BP_HEAD)

	if(armor < 0.5 && target.headcheck(BP_HEAD) && prob(damage))
		target.apply_effect(20, PARALYZE)
		target.visible_message(SPAN_DANGER("\The [target] [target.species.get_knockout_message(target)]"))

	playsound(attacker.loc, "swing_hit", 25, 1, -1)

	admin_attack_log(attacker, target, "Headbutted their victim.", "Was headbutted.", "headbutted")
	return 1

// Handles special targeting like eyes and mouth being covered.
/decl/grab/normal/special_target_effect(var/obj/item/grab/G)
	var/mob/living/affecting_mob = G.get_affecting_mob()
	if(istype(affecting_mob) && G.special_target_functional)
		switch(G.target_zone)
			if(BP_MOUTH)
				if(GET_STATUS(affecting_mob, STAT_SILENCE) < 2)
					affecting_mob.set_status(STAT_SILENCE, 2)
			if(BP_EYES)
				if(GET_STATUS(affecting_mob, STAT_BLIND) < 2)
					affecting_mob.set_status(STAT_BLIND, 2)

// Handles when they change targeted areas and something is supposed to happen.
/decl/grab/normal/special_target_change(var/obj/item/grab/G, old_zone, new_zone)
	if((old_zone != BP_HEAD && old_zone != BP_CHEST) || !G.get_affecting_mob())
		return
	switch(new_zone)
		if(BP_MOUTH)
			G.assailant.visible_message("<span class='warning'>\The [G.assailant] covers [G.affecting]'s mouth!</span>")
		if(BP_EYES)
			G.assailant.visible_message("<span class='warning'>\The [G.assailant] covers [G.affecting]'s eyes!</span>")

/decl/grab/normal/check_special_target(var/obj/item/grab/G)
	var/mob/living/affecting_mob = G.get_affecting_mob()
	if(!istype(affecting_mob))
		return FALSE
	switch(G.target_zone)
		if(BP_MOUTH)
			if(!affecting_mob.check_has_mouth())
				to_chat(G.assailant, "<span class='danger'>You cannot locate a mouth on [G.affecting]!</span>")
				return FALSE
		if(BP_EYES)
			if(!affecting_mob.check_has_eyes())
				to_chat(G.assailant, "<span class='danger'>You cannot locate any eyes on [G.affecting]!</span>")
				return FALSE
	return TRUE

/decl/grab/normal/resolve_item_attack(var/obj/item/grab/G, var/mob/living/carbon/human/user, var/obj/item/I)
	switch(G.target_zone)
		if(BP_HEAD)
			return attack_throat(G, I, user)
		else
			return attack_tendons(G, I, user, G.target_zone)

/decl/grab/normal/proc/attack_throat(var/obj/item/grab/G, var/obj/item/W, mob/user)
	var/mob/living/affecting = G.get_affecting_mob()
	if(!affecting)
		return
	if(user.a_intent != I_HURT)
		return 0 // Not trying to hurt them.

	if(!W.edge || !W.force || W.damtype != BRUTE)
		return 0 //unsuitable weapon
	user.visible_message("<span class='danger'>\The [user] begins to slit [affecting]'s throat with \the [W]!</span>")

	user.next_move = world.time + 20 //also should prevent user from triggering this repeatedly
	if(!do_after(user, 20*user.skill_delay_mult(SKILL_COMBAT) , progress = 0))
		return 0
	if(!(G && G.affecting == affecting)) //check that we still have a grab
		return 0

	var/damage_mod = 1
	var/damage_flags = W.damage_flags()
	//presumably, if they are wearing a helmet that stops pressure effects, then it probably covers the throat as well
	var/obj/item/clothing/head/helmet = affecting.get_equipped_item(slot_head_str)
	if(istype(helmet) && (helmet.body_parts_covered & SLOT_HEAD) && (helmet.item_flags & ITEM_FLAG_AIRTIGHT) && !isnull(helmet.max_pressure_protection))
		var/datum/extension/armor/armor_datum = get_extension(helmet, /datum/extension/armor)
		if(armor_datum)
			damage_mod -= armor_datum.get_blocked(BRUTE, damage_flags, W.armor_penetration, W.force*1.5)

	var/total_damage = 0
	for(var/i in 1 to 3)
		var/damage = min(W.force*1.5, 20)*damage_mod
		affecting.apply_damage(damage, W.damtype, BP_HEAD, damage_flags, armor_pen = 100, used_weapon=W)
		total_damage += damage

	if(total_damage)
		user.visible_message("<span class='danger'>\The [user] slit [affecting]'s throat open with \the [W]!</span>")

		if(W.hitsound)
			playsound(affecting.loc, W.hitsound, 50, 1, -1)

	G.last_action = world.time

	admin_attack_log(user, affecting, "Knifed their victim", "Was knifed", "knifed")
	return 1

/decl/grab/normal/proc/attack_tendons(var/obj/item/grab/G, var/obj/item/W, mob/user, var/target_zone)
	var/mob/living/affecting = G.get_affecting_mob()
	if(!affecting)
		return
	if(!user.skill_check(SKILL_COMBAT, SKILL_ADEPT))
		return
	if(user.a_intent != I_HURT)
		return 0 // Not trying to hurt them.
	if(!W.edge || !W.force || W.damtype != BRUTE)
		return 0 //unsuitable weapon
	var/obj/item/organ/external/O = G.get_targeted_organ()
	if(!O || !(O.limb_flags & ORGAN_FLAG_HAS_TENDON) || (O.status & ORGAN_TENDON_CUT))
		return FALSE
	user.visible_message(SPAN_DANGER("\The [user] begins to cut \the [affecting]'s [O.tendon_name] with \the [W]!"))
	user.next_move = world.time + 20
	if(!do_after(user, 20, progress=0))
		return 0
	if(!(G && G.affecting == affecting)) //check that we still have a grab
		return 0
	if(!O || !O.sever_tendon())
		return 0
	user.visible_message(SPAN_DANGER("\The [user] cut \the [affecting]'s [O.tendon_name] with \the [W]!"))
	if(W.hitsound) playsound(affecting.loc, W.hitsound, 50, 1, -1)
	G.last_action = world.time
	admin_attack_log(user, affecting, "hamstrung their victim", "was hamstrung", "hamstrung")
	return 1
