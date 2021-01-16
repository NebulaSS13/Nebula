/mob/living
	var/datum/psi_complexus/psi

/mob/living/Login()
	. = ..()
	if(psi)
		psi.update(TRUE)
		if(!psi.suppressed)
			psi.show_auras()

/mob/living/Destroy()
	QDEL_NULL(psi)
	. = ..()

/mob/living/proc/set_psi_rank(var/faculty, var/rank, var/take_larger, var/defer_update, var/temporary)
	if(!src.zone_sel)
		to_chat(src, SPAN_NOTICE("You feel something strange brush against your mind... but your brain is not able to grasp it."))
		return
	if(!psi)
		psi = new(src)
	var/current_rank = psi.get_rank(faculty)
	if(current_rank != rank && (!take_larger || current_rank < rank))
		psi.set_rank(faculty, rank, defer_update, temporary)

/mob/living/proc/deflect_psionic_attack(var/attacker)
	var/blocked = 100 * get_blocked_ratio(null, PSIONIC)
	if(prob(blocked))
		if(attacker)
			to_chat(attacker, SPAN_WARNING("Your mental attack is deflected by \the [src]'s defenses!"))
			to_chat(src, SPAN_DANGER("\The [attacker] strikes out with a mental attack, but you deflect it!"))
		return TRUE
	return FALSE

/mob/living/carbon/human/check_shields(var/damage = 0, var/atom/damage_source = null, var/mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	var/obj/item/projectile/P = damage_source
	if(istype(P) && !P.disrupts_psionics() && psi && P.starting && prob(psi.get_armour(get_armor_key(P.damage_type, P.damage_flags())) * 0.5) && psi.spend_power(round(damage/10)))
		visible_message("<span class='danger'>\The [src] deflects [attack_text]!</span>")
		P.redirect(P.starting.x + rand(-2,2), P.starting.y + rand(-2,2), get_turf(src), src)
		return PROJECTILE_FORCE_MISS
	. = ..()

/mob/living/carbon/get_cuff_breakout_mod()
	. = ..()
	if(psi)
		. = Clamp(. - (psi.get_rank(PSI_PSYCHOKINESIS)*0.2), 0, 1)

/mob/living/can_break_cuffs()
	. = (psi && psi.can_use() && psi.get_rank(PSI_PSYCHOKINESIS) >= PSI_RANK_PARAMOUNT)

/mob/living/carbon/get_special_resist_time()
	. = ..()
	if(psi && psi.can_use())
		. += ((25 SECONDS) * psi.get_rank(PSI_PSYCHOKINESIS))

/mob/living/is_telekinetic()
	. = psi && !psi.suppressed && psi.get_rank(PSI_PSYCHOKINESIS) >= PSI_RANK_OPERANT

/mob/living/get_armors_by_zone(def_zone, damage_type, damage_flags)
	. = ..()
	if(psi)
		. += get_extension(psi, /datum/extension/armor)
