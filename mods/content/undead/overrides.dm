/mob/living/can_feel_pain(var/check_organ)
	return !has_trait(/decl/trait/undead) && ..()

/mob/living/human/get_gibber_type() // To avoid skeletons causing gibs.
	return has_trait(/decl/trait/undead, TRAIT_LEVEL_MODERATE) ? null : ..()

/mob/living/human/ssd_check()
	if(has_trait(/decl/trait/undead))
		return FALSE
	return ..()

/mob/living/human/get_movement_delay(travel_dir)
	. = ..()
	if(has_trait(/decl/trait/undead))
		var/static/default_walk_delay = get_config_value(/decl/config/num/movement_walk)
		. = max(., default_walk_delay)

/mob/living/human/get_attack_telegraph_delay()
	if(has_trait(/decl/trait/undead))
		return (0.6 SECONDS)
	return ..()

/mob/living/human/get_self_death_message(gibbed)
	return has_trait(/decl/trait/undead, TRAIT_LEVEL_MODERATE) ? "You have crumbled." : ..()

/mob/living/human/get_death_message(gibbed)
	if(has_trait(/decl/trait/undead, TRAIT_LEVEL_MODERATE))
		return "crumbles and falls apart!"
	return ..()

/mob/living/human/death(gibbed)
	. = ..()
	if(stat == DEAD && !QDELETED(src) && !gibbed && has_trait(/decl/trait/undead, TRAIT_LEVEL_MODERATE))
		gib()

/mob/living/human/get_eye_colour()
	// Force an evil red glow for undead mobs.
	if(stat == CONSCIOUS && has_trait(/decl/trait/undead))
		return COLOR_RED
	return ..()

/mob/living/human/death(gibbed)
	. = ..()
	if(!QDELETED(src) && has_trait(/decl/trait/undead))
		var/obj/item/organ/external/head/head = get_organ(BP_HEAD)
		head.glowing_eyes = initial(head.glowing_eyes)
		update_eyes()

/mob/living/human/get_life_damage_types()
	if(has_trait(/decl/trait/undead))
		// Undead human mobs use brute and burn damage instead of brain damage, a la simplemobs.
		var/static/list/life_damage_types = list(
			BURN,
			BRUTE
		)
		return life_damage_types
	return ..()

/mob/living/human/getOxyLoss(var/amount)
	return has_trait(/decl/trait/undead) ? 0 : ..()

/mob/living/human/setOxyLoss(var/amount)
	return has_trait(/decl/trait/undead) ? 0 : ..()

/mob/living/human/adjustOxyLoss(var/damage, var/do_update_health = TRUE)
	return has_trait(/decl/trait/undead) ? 0 : ..()

/mob/living/human/getToxLoss()
	return has_trait(/decl/trait/undead) ? 0 : ..()

/mob/living/human/setToxLoss(var/amount)
	return has_trait(/decl/trait/undead) ? 0 : ..()

/mob/living/human/adjustToxLoss(var/amount, var/do_update_health = TRUE)
	return has_trait(/decl/trait/undead) ? 0 : ..()

/mob/living/human/check_vital_organ_missing()
	return !has_trait(/decl/trait/undead) && ..()

/mob/living/human/process_internal_organs()
	return has_trait(/decl/trait/undead) ? null : ..()

/mob/living/human/should_have_organ(organ_to_check)
	// It might be nice to have eyes etc. matter for zombies, but as all organs are dead it won't work currently.
	return has_trait(/decl/trait/undead) ? FALSE : ..()

/mob/living/human/get_vision_organ_tag()
	 // Where we're going, we don't need eyes.
	return has_trait(/decl/trait/undead) ? null : ..()

/mob/living/human/need_breathe()
	return has_trait(/decl/trait/undead) ? FALSE : ..()

// Undead don't get hungry/thirsty (except for brains)
/mob/living/human/get_nutrition()
	return has_trait(/decl/trait/undead) ? get_max_nutrition() : ..()

/mob/living/human/get_hydration()
	return has_trait(/decl/trait/undead) ? get_max_hydration() : ..()

// Overrides to handle dead flag separately.
/obj/item/organ/is_usable()
	. = !(status & (ORGAN_CUT_AWAY|ORGAN_MUTATED))
	if(. && (status & ORGAN_DEAD))
		return owner?.has_trait(/decl/trait/undead)

/obj/item/organ/external/check_status_flags_for_process()
	if(status & (ORGAN_CUT_AWAY|ORGAN_BLEEDING|ORGAN_BROKEN|ORGAN_MUTATED|ORGAN_DISLOCATED))
		return TRUE
	if((status & ORGAN_DEAD) && !owner?.has_trait(/decl/trait/undead))
		return TRUE
	return FALSE

/mob/living/human/set_status_condition(condition, amount)
	if(has_trait(/decl/trait/undead))
		var/static/list/ignore_status_conditions = list(
			STAT_BLIND,
			STAT_DEAF,
			STAT_CONFUSE,
			STAT_DIZZY,
			STAT_JITTER,
			STAT_STUTTER,
			STAT_SLUR,
			STAT_ASLEEP,
			STAT_DRUGGY,
			STAT_DROWSY,
			STAT_BLURRY,
			STAT_BLIND,
			STAT_TINNITUS,
			STAT_DEAF
		)
		if(condition in ignore_status_conditions)
			return
	. = ..()
