/obj/aura/regenerating
	name = "regenerating aura"
	var/brute_mult = 1
	var/fire_mult = 1
	var/tox_mult = 1

/obj/aura/regenerating/life_tick()
	user.adjustBruteLoss(-brute_mult)
	user.adjustFireLoss(-fire_mult)
	user.adjustToxLoss(-tox_mult)

/obj/aura/regenerating/human
	var/nutrition_damage_mult = 1 //How much nutrition it takes to heal regular damage
	var/external_nutrition_mult = 50 // How much nutrition it takes to regrow a limb
	var/organ_mult = 2
	var/regen_message = "<span class='warning'>Your body throbs as you feel your ORGAN regenerate.</span>"
	var/grow_chance = 0
	var/grow_threshold = 0
	var/ignore_tag = BP_BRAIN //organ tag to ignore
	var/last_nutrition_warning = 0
	var/innate_heal = TRUE // Whether the aura is on, basically.


/obj/aura/regenerating/human/proc/external_regeneration_effect(var/obj/item/organ/external/O, var/mob/living/carbon/human/H)
	return

/obj/aura/regenerating/human/life_tick()
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		. = 0
		CRASH("Someone gave [user.type] a [src.type] aura. This is invalid.")
	if(!innate_heal || H.is_in_stasis() || H.stat == DEAD)
		return 0
	if(H.nutrition < nutrition_damage_mult)
		low_nut_warning()
		return 0

	if(brute_mult && H.getBruteLoss())
		H.adjustBruteLoss(-brute_mult * config.organ_regeneration_multiplier)
		H.adjust_nutrition(-nutrition_damage_mult)
	if(fire_mult && H.getFireLoss())
		H.adjustFireLoss(-fire_mult * config.organ_regeneration_multiplier)
		H.adjust_nutrition(-nutrition_damage_mult)
	if(tox_mult && H.getToxLoss())
		H.adjustToxLoss(-tox_mult * config.organ_regeneration_multiplier)
		H.adjust_nutrition(-nutrition_damage_mult)

	if(!can_regenerate_organs())
		return 1
	if(organ_mult)
		if(prob(10) && H.nutrition >= 150 && !H.getBruteLoss() && !H.getFireLoss())
			var/obj/item/organ/external/D = GET_EXTERNAL_ORGAN(H, BP_HEAD)
			if (D.status & ORGAN_DISFIGURED)
				if (H.nutrition >= 20)
					D.status &= ~ORGAN_DISFIGURED
					H.adjust_nutrition(-20)
				else
					low_nut_warning(BP_HEAD)

		var/list/organs = H.get_internal_organs()
		for(var/obj/item/organ/internal/regen_organ in shuffle(organs.Copy()))
			if(BP_IS_PROSTHETIC(regen_organ) || regen_organ.organ_tag == ignore_tag)
				continue
			if(istype(regen_organ))
				if(regen_organ.damage > 0 && !(regen_organ.status & ORGAN_DEAD))
					if (H.nutrition >= organ_mult)
						regen_organ.damage = max(regen_organ.damage - organ_mult, 0)
						H.adjust_nutrition(-organ_mult)
						if(prob(5))
							to_chat(H, replacetext(regen_message,"ORGAN", regen_organ.name))
					else
						low_nut_warning(regen_organ.name)

	if(prob(grow_chance))
		for(var/limb_type in H.species.has_limbs)
			var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(H, limb_type)
			if(E && E.organ_tag != BP_HEAD && !E.is_vital_to_owner() && !E.is_usable())	//Skips heads and vital bits...
				if (H.nutrition > grow_threshold)
					H.remove_organ(E) 		//...because no one wants their head to explode to make way for a new one.
					qdel(E)
					E= null
				else
					low_nut_warning(E.name)
			if(!E)
				var/list/organ_data = H.species.has_limbs[limb_type]
				var/limb_path = organ_data["path"]
				var/obj/item/organ/external/O = new limb_path(H)
				external_regeneration_effect(O,H)
				H.adjust_nutrition(-external_nutrition_mult)
				organ_data["descriptor"] = O.name
				H.update_body()
				return
			else if (H.nutrition > grow_threshold) //We don't subtract any nut here, but let's still only heal wounds when we have nut.
				for(var/datum/wound/W in E.wounds)
					if(W.wound_damage() == 0 && prob(50))
						qdel(W)
	return 1

/obj/aura/regenerating/human/proc/low_nut_warning(var/wound_type)
	if (last_nutrition_warning + 1 MINUTE < world.time)
		to_chat(user, "<span class='warning'>You need more energy to regenerate your [wound_type || "wounds"].</span>")
		last_nutrition_warning = world.time
		return 1
	return 0

/obj/aura/regenerating/human/proc/toggle()
	innate_heal = !innate_heal

/obj/aura/regenerating/human/proc/can_toggle()
	return TRUE

/obj/aura/regenerating/human/proc/can_regenerate_organs()
	return TRUE
