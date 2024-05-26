/mob/living/exosuit/explosion_act(severity)
	. = ..(4) //We want to avoid the automatic handling of damage to contents
	var/b_loss = 0
	var/f_loss = 0
	switch (severity)
		if (1)
			b_loss = 200
			f_loss = 200
		if (2)
			b_loss = 90
			f_loss = 90
		if(3)
			b_loss = 45

	// spread damage overall
	take_damage(b_loss, damage_flags = DAM_EXPLODE | DAM_DISPERSED, used_weapon = "Explosive blast")
	take_damage(f_loss, damage_flags = DAM_EXPLODE | DAM_DISPERSED, used_weapon = "Explosive blast")

/mob/living/exosuit/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if(!effect || (blocked >= 100))
		return 0
	if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
		if(effect > 0 && effecttype == IRRADIATE)
			effect = max((1-(get_armors_by_zone(null, IRRADIATE)/100))*effect/(blocked+1),0)
		var/mob/living/pilot = pick(pilots)
		return pilot.apply_effect(effect, effecttype, blocked)
	if(!(effecttype in list(PAIN, STUTTER, EYE_BLUR, DROWSY, STUN, WEAKEN)))
		. = ..()

/mob/living/exosuit/resolve_item_attack(var/obj/item/I, var/mob/living/user, var/def_zone)
	if(!I.force)
		user.visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly with \the [I]."))
		return

	switch(def_zone)
		if(BP_HEAD , BP_CHEST, BP_MOUTH, BP_EYES)
			if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
				var/mob/living/pilot = pick(pilots)
				var/zone = pilot.resolve_item_attack(I, user, def_zone)
				if(zone)
					var/datum/attack_result/AR = new()
					AR.hit_zone = zone
					AR.attackee = pilot
					return AR

	return def_zone //Careful with effects, mechs shouldn't be stunned

/mob/living/exosuit/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	if (!hatch_closed && (LAZYLEN(pilots) < body.pilot_positions.len))
		var/mob/living/M = AM
		if (istype(M))
			var/chance = 50 //Throwing someone at an empty exosuit MAY put them in the seat
			var/message = "\The [AM] lands in \the [src]'s cockpit with a crash. Get in the damn exosuit!"
			if (TT.thrower == TT.thrownthing)
				//This is someone jumping
				chance = M.skill_check_multiple(list(SKILL_MECH = HAS_PERK, SKILL_HAULING = SKILL_ADEPT)) ? 100 : chance
				message = "\The [AM] gets in \the [src]'s cockpit in one fluid motion."
			if (prob(chance))
				if (enter(AM, silent = TRUE, check_incap = FALSE, instant = TRUE))
					visible_message(SPAN_NOTICE("[message]"))
					return TRUE

	if (LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
		var/mob/living/pilot = pick(pilots)
		return pilot.hitby(AM, TT)

	. = ..()

/mob/living/exosuit/bullet_act(obj/item/projectile/P, def_zone, used_weapon)
	switch(def_zone)
		if(BP_HEAD , BP_CHEST, BP_MOUTH, BP_EYES)
			if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
				var/mob/living/pilot = pick(pilots)
				return pilot.bullet_act(P, def_zone, used_weapon)
	..()

/mob/living/exosuit/get_armors_by_zone(def_zone, damage_type, damage_flags)
	. = ..()
	if(body && body.m_armour)
		var/body_armor = get_extension(body.m_armour, /datum/extension/armor)
		if(body_armor)
			. += body_armor

/mob/living/exosuit/get_max_health()
	return (body ? body.mech_health : 0)

/mob/living/exosuit/get_total_life_damage()
	return (get_damage(BURN)+get_damage(BRUTE))

/mob/living/exosuit/adjustFireLoss(var/amount, var/obj/item/mech_component/MC = pick(list(arms, legs, body, head)), var/do_update_health = TRUE)
	if(MC)
		MC.take_burn_damage(amount)
		if(do_update_health)
			update_health() // TODO: unify these procs somehow instead of having weird brute-wrapping behavior as the default.

/mob/living/exosuit/adjustBruteLoss(var/amount, var/obj/item/mech_component/MC = pick(list(arms, legs, body, head)), var/do_update_health = TRUE)
	if(MC)
		MC.take_brute_damage(amount)
	..()

/mob/living/exosuit/proc/zoneToComponent(var/zone)
	switch(zone)
		if(BP_EYES , BP_HEAD)
			return head
		if(BP_L_ARM , BP_R_ARM)
			return arms
		if(BP_L_LEG , BP_R_LEG)
			return legs
		else
			return body

/mob/living/exosuit/rad_act(var/severity)
	return FALSE // Pilots already query rads, modify this for radiation alerts and such

/mob/living/exosuit/get_rads()
	. = ..()
	if(!hatch_closed || (body.pilot_coverage < 100)) //Open, environment is the source
		return .
	var/list/after_armor = modify_damage_by_armor(null, ., IRRADIATE, DAM_DISPERSED, src, 0, TRUE)
	return after_armor[1]

/mob/living/exosuit/getFireLoss()
	var/total = 0
	for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
		if(MC)
			total += MC.burn_damage
	return total

/mob/living/exosuit/getBruteLoss()
	var/total = 0
	for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
		if(MC)
			total += MC.brute_damage
	return total

/mob/living/exosuit/emp_act(var/severity)

	var/ratio = get_blocked_ratio(null, BURN, null, (4-severity) * 20)

	if(ratio >= 0.5)
		for(var/mob/living/m in pilots)
			to_chat(m, SPAN_NOTICE("Your Faraday shielding absorbed the pulse!"))
		return
	else if(ratio > 0)
		for(var/mob/living/m in pilots)
			to_chat(m, SPAN_NOTICE("Your Faraday shielding mitigated the pulse!"))

	emp_damage += round((12 - (severity*3))*( 1 - ratio))
	if(severity <= 3)
		for(var/obj/item/thing in list(arms,legs,head,body))
			thing.emp_act(severity)
		if(!hatch_closed || !prob(body.pilot_coverage))
			for(var/thing in pilots)
				var/mob/pilot = thing
				pilot.emp_act(severity)

/mob/living/exosuit/get_bullet_impact_effect_type(def_zone)
	return BULLET_IMPACT_METAL
