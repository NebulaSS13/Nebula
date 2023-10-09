/mob/living/carbon/human/get_lethal_damage_types()
	var/static/list/lethal_damage_types = list(
		BRUTE,
		BURN,
		TOX,
		OXY
	)
	return lethal_damage_types

/mob/living/carbon/human/get_handled_damage_types()
	var/static/list/mob_damage_types = list(
		BRUTE = /decl/damage_handler/brute/limbs,
		BURN  = /decl/damage_handler/burn/limbs,
		TOX   = /decl/damage_handler/organ/internal,
		IRRADIATE,
		ELECTROCUTE,
		PAIN,
		OXY,
		CLONE
	)
	return mob_damage_types

/decl/damage_handler/brute/limbs
	expected_type = /mob/living/carbon/human

/decl/damage_handler/brute/limbs/apply_damage_to_mob(mob/living/target, damage, def_zone, damage_flags, used_weapon, silent)
	if(!causes_limb_damage)
		return FALSE
	var/obj/item/organ/external/organ = GET_EXTERNAL_ORGAN(target, def_zone || ran_zone())
	if(!organ)
		return FALSE
	var/mob/living/carbon/human/target_human = target
	target_human.handle_suit_punctures(category_type, damage, def_zone)
	if(damage > 15 && prob(damage*4) && organ.can_feel_pain())
		target_human.make_reagent(round(damage/10), /decl/material/liquid/adrenaline)
	target_human.damageoverlaytemp = 20
	BITSET(target_human.hud_updateflag, HEALTH_HUD)
	return damage_limb(organ, damage, damage_flags, used_weapon)

/decl/damage_handler/burn/limbs
	expected_type = /mob/living/carbon/human

/decl/damage_handler/burn/limbs/apply_damage_to_mob(mob/living/target, damage, def_zone, damage_flags, used_weapon, silent)
	if(!causes_limb_damage)
		return FALSE
	var/obj/item/organ/external/organ = GET_EXTERNAL_ORGAN(target, def_zone || ran_zone())
	if(!organ)
		return FALSE
	var/mob/living/carbon/human/target_human = target
	target_human.handle_suit_punctures(category_type, damage, def_zone)
	if(damage > 15 && prob(damage*4) && organ.can_feel_pain())
		target_human.make_reagent(round(damage/10), /decl/material/liquid/adrenaline)
	target_human.damageoverlaytemp = 20
	BITSET(target_human.hud_updateflag, HEALTH_HUD)
	return damage_limb(organ, damage, damage_flags, used_weapon)

/decl/damage_handler/organ/internal/get_damage_for_mob(var/mob/living/target)
	var/decl/species/my_species = target.get_species()
	if(my_species && (my_species.species_flags & SPECIES_FLAG_NO_POISON))
		return 0
	if(target.isSynthetic())
		return 0
	. = 0
	for(var/obj/item/organ/internal/I in target.get_internal_organs())
		. += I.get_toxins_damage()

/decl/damage_handler/organ/internal/set_mob_damage(var/mob/living/target, var/damage, var/skip_update_health = FALSE)
	var/decl/species/my_species = target.get_species()
	if(my_species && (my_species.species_flags & SPECIES_FLAG_NO_POISON))
		return FALSE
	if(target.isSynthetic())
		return FALSE

	var/amount = damage - get_damage_for_mob(target, category_type)
	var/heal = amount < 0
	amount = abs(amount)
	if(!heal)
		amount *= target.get_damage_modifier(TOX)
		var/antitox = GET_CHEMICAL_EFFECT(target, CE_ANTITOX)
		if(antitox)
			amount *= 1 - antitox * 0.25

	var/list/pick_organs = target.get_internal_organs()
	if(!LAZYLEN(pick_organs))
		return
	pick_organs = shuffle(pick_organs.Copy())

	// Prioritize damaging our filtration organs first.
	for(var/organ in list(BP_KIDNEYS, BP_LIVER))
		var/obj/item/organ/internal/lump = GET_INTERNAL_ORGAN(target, organ)
		if(lump)
			pick_organs -= lump
			pick_organs.Insert(1, lump)

	// Move the brain to the very end since damage to it is vastly more dangerous
	// (and isn't technically counted as toxloss) than general organ damage.
	var/obj/item/organ/internal/brain = GET_INTERNAL_ORGAN(target, BP_BRAIN)
	if(brain)
		pick_organs -= brain
		pick_organs += brain

	for(var/internal in pick_organs)
		var/obj/item/organ/internal/I = internal
		if(amount <= 0)
			break
		if(heal)
			if(I.organ_damage < amount)
				amount -= I.organ_damage
				I.organ_damage = 0
			else
				I.organ_damage -= amount
				amount = 0
		else
			var/cap_dam = I.max_damage - I.organ_damage
			if(amount >= cap_dam)
				I.take_damage(cap_dam, TOX, silent=TRUE)
				amount -= cap_dam
			else
				I.take_damage(amount, TOX, silent=TRUE)
				amount = 0
