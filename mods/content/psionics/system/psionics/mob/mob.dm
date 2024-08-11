/datum/ability_handler/psionics/refresh_login()
	update(TRUE)
	if(!suppressed)
		show_auras()

/mob/proc/set_psi_rank(var/faculty, var/rank, var/take_larger, var/defer_update, var/temporary)
	return

/mob/living/set_psi_rank(var/faculty, var/rank, var/take_larger, var/defer_update, var/temporary)
	if(!get_target_zone()) // Can't target a zone, so you can't really invoke psionics.
		to_chat(src, SPAN_NOTICE("You feel something strange brush against your mind... but your brain is not able to grasp it."))
		return
	var/datum/ability_handler/psionics/psi = get_ability_handler(/datum/ability_handler/psionics)
	var/current_rank = psi?.get_rank(faculty)
	if(!current_rank && !rank)
		return
	if(current_rank != rank && (!take_larger || current_rank < rank))
		if(!psi && rank)
			psi = get_ability_handler(/datum/ability_handler/psionics, TRUE)
		if(psi)
			psi.set_rank(faculty, rank, defer_update, temporary)

/mob/living/proc/deflect_psionic_attack(var/attacker)
	var/blocked = 100 * get_blocked_ratio(null, PSIONIC)
	if(prob(blocked))
		if(attacker)
			to_chat(attacker, SPAN_WARNING("Your mental attack is deflected by \the [src]'s defenses!"))
			to_chat(src, SPAN_DANGER("\The [attacker] strikes out with a mental attack, but you deflect it!"))
		return TRUE
	return FALSE

/mob/living/human/check_shields(var/damage = 0, var/atom/damage_source = null, var/mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	var/obj/item/projectile/P = damage_source
	var/datum/ability_handler/psionics/psi = get_ability_handler(/datum/ability_handler/psionics)
	if(istype(P) && !P.disrupts_psionics() && psi && P.starting && prob(psi.get_armour(SSmaterials.get_armor_key(P.atom_damage_type, P.damage_flags())) * 0.5) && psi.spend_power(round(damage/10)))
		visible_message(SPAN_DANGER("\The [src] deflects [isatom(attack_text) ? "\the [attack_text]" : attack_text]!"))
		P.redirect(P.starting.x + rand(-2,2), P.starting.y + rand(-2,2), get_turf(src), src)
		return PROJECTILE_FORCE_MISS
	. = ..()

/mob/living/get_cuff_breakout_mod()
	. = ..()
	var/datum/ability_handler/psionics/psi = get_ability_handler(/datum/ability_handler/psionics)
	if(psi)
		. = clamp(. - (psi.get_rank(PSI_PSYCHOKINESIS)*0.2), 0, 1)

/mob/living/can_break_cuffs()
	var/datum/ability_handler/psionics/psi = get_ability_handler(/datum/ability_handler/psionics)
	. = (psi && psi.can_use() && psi.get_rank(PSI_PSYCHOKINESIS) >= PSI_RANK_PARAMOUNT)

/mob/living/get_special_resist_time()
	. = ..()
	var/datum/ability_handler/psionics/psi = get_ability_handler(/datum/ability_handler/psionics)
	if(psi && psi.can_use())
		. += ((25 SECONDS) * psi.get_rank(PSI_PSYCHOKINESIS))

/mob/living/is_telekinetic()
	var/datum/ability_handler/psionics/psi = get_ability_handler(/datum/ability_handler/psionics)
	. = psi && !psi.suppressed && psi.get_rank(PSI_PSYCHOKINESIS) >= PSI_RANK_OPERANT

/mob/living/get_armors_by_zone(def_zone, damage_type, damage_flags)
	. = ..()
	var/datum/ability_handler/psionics/psi = get_ability_handler(/datum/ability_handler/psionics)
	if(psi)
		. += get_extension(psi, /datum/extension/armor)
