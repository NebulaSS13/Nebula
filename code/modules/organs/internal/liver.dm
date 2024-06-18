
/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	prosthetic_icon = "liver-prosthetic"
	w_class = ITEM_SIZE_SMALL
	organ_tag = BP_LIVER
	parent_organ = BP_GROIN
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 60
	// Liver recovers a lot better than most meat.
	min_regeneration_cutoff_threshold = 2
	max_regeneration_cutoff_threshold = 5

/obj/item/organ/internal/liver/organ_can_heal()
	return !GET_CHEMICAL_EFFECT(owner, CE_ALCOHOL) && ..()

/obj/item/organ/internal/liver/Process()

	..()
	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE && prob(1))
		to_chat(owner, SPAN_DANGER("Your skin itches."))
	if (germ_level > INFECTION_LEVEL_TWO && prob(1))
		owner.vomit()

	//Detox can heal small amounts of damage
	if (damage < max_damage && !GET_CHEMICAL_EFFECT(owner, CE_TOXIN))
		heal_damage(0.2 * GET_CHEMICAL_EFFECT(owner, CE_ANTITOX))

	var/alco = GET_CHEMICAL_EFFECT(owner, CE_ALCOHOL)
	var/alcotox = GET_CHEMICAL_EFFECT(owner, CE_ALCOHOL_TOXIC)
	// Get the effectiveness of the liver.
	var/filter_effect = 3
	if(is_bruised())
		filter_effect -= 1
	if(is_broken())
		filter_effect -= 2
	// Robotic organs filter better but don't get benefits from antitoxins for filtering.
	if(BP_IS_PROSTHETIC(src))
		filter_effect += 1
	else if(owner.has_chemical_effect(CE_ANTITOX, 1))
		filter_effect += 1
	// If you're not filtering well, you're in trouble. Ammonia buildup to toxic levels and damage from alcohol
	if(filter_effect < 2)
		if(alco)
			owner.take_damage(0.5 * max(2 - filter_effect, TOX, 0) * (alcotox + 0.5 * alco))

	if(alcotox)
		take_internal_damage(alcotox, prob(90)) // Chance to warn them

	//Blood regeneration if there is some space
	owner.regenerate_blood(0.1 + GET_CHEMICAL_EFFECT(owner, CE_BLOODRESTORE))

	// Blood loss or liver damage make you lose nutriments
	var/blood_volume = owner.get_blood_volume()
	if(blood_volume < BLOOD_VOLUME_SAFE || is_bruised())
		if(owner.nutrition >= 300)
			owner.adjust_nutrition(-10)
		else if(owner.nutrition >= 200)
			owner.adjust_nutrition(-3)
