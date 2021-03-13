
/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	w_class = ITEM_SIZE_SMALL
	organ_tag = BP_LIVER
	parent_organ = BP_GROIN
	min_bruised_damage = 25
	min_broken_damage = 45
	max_damage = 70
	relative_size = 60

/obj/item/organ/internal/liver/robotize(var/company = /decl/prosthetics_manufacturer, var/skip_prosthetics, var/keep_organs, var/apply_material = /decl/material/solid/metal/steel)
	. = ..()
	icon_state = "liver-prosthetic"

/obj/item/organ/internal/liver/Process()

	..()
	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(1))
			to_chat(owner, "<span class='danger'>Your skin itches.</span>")
	if (germ_level > INFECTION_LEVEL_TWO)
		if(prob(1))
			spawn owner.vomit()

	//Detox can heal small amounts of damage
	if (damage < max_damage && !LAZYACCESS(owner.chem_effects, CE_TOXIN))
		heal_damage(0.2 * LAZYACCESS(owner.chem_effects, CE_ANTITOX))

	var/alco = LAZYACCESS(owner.chem_effects, CE_ALCOHOL)
	var/alcotox = LAZYACCESS(owner.chem_effects, CE_ALCOHOL_TOXIC)
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
			owner.adjustToxLoss(0.5 * max(2 - filter_effect, 0) * (alcotox + 0.5 * alco))

	if(alcotox)
		take_internal_damage(alcotox, prob(90)) // Chance to warn them

	// Heal a bit if needed and we're not busy. This allows recovery from low amounts of toxloss.
	if(!alco && !LAZYACCESS(owner.chem_effects, CE_TOXIN) && !owner.radiation && damage > 0)
		if(damage < min_broken_damage)
			heal_damage(0.2)
		if(damage < min_bruised_damage)
			heal_damage(0.3)

	//Blood regeneration if there is some space
	owner.regenerate_blood(0.1 + LAZYACCESS(owner.chem_effects, CE_BLOODRESTORE))

	// Blood loss or liver damage make you lose nutriments
	var/blood_volume = owner.get_blood_volume()
	if(blood_volume < BLOOD_VOLUME_SAFE || is_bruised())
		if(owner.nutrition >= 300)
			owner.adjust_nutrition(-10)
		else if(owner.nutrition >= 200)
			owner.adjust_nutrition(-3)

//We got it covered in Process with more detailed thing
/obj/item/organ/internal/liver/handle_regeneration()
	return