/mob/living/proc/get_allergy_choke_emote()
	var/decl/species/my_species = get_species()
	if(length(my_species?.allergy_choke_emotes))
		return pick(my_species.allergy_choke_emotes)

/mob/living/proc/get_allergy_faint_emote()
	var/decl/species/my_species = get_species()
	if(length(my_species?.allergy_choke_emotes))
		return pick(my_species.allergy_faint_emotes)

/mob/living/proc/get_allergen_damage_severity()
	var/decl/species/my_species = get_species()
	return my_species?.allergen_damage_severity || 0

/mob/living/proc/get_allergen_disable_severity()
	var/decl/species/my_species = get_species()
	return my_species?.allergen_disable_severity || 0

/mob/living/proc/get_allergen_reaction_flags()
	var/decl/species/my_species = get_species()
	return my_species?.allergen_reaction || ALLERGEN_REACTION_NONE

/mob/living/proc/handle_allergens()

	var/allergen_power = LAZYACCESS(chem_effects, CE_ALLERGEN)
	if(allergen_power <= 0)
		return FALSE

	var/allergen_reaction = get_allergen_reaction_flags()
	if(!allergen_reaction)
		return FALSE

	var/damage_severity   = get_allergen_damage_severity()  * allergen_power
	var/disable_severity  = get_allergen_disable_severity() * allergen_power

	if(allergen_reaction & ALLERGEN_REACTION_PHYS_DMG)
		take_damage(damage_severity, BRUTE, armor_pen = 100)
	if(allergen_reaction & ALLERGEN_REACTION_BURN_DMG)
		take_damage(damage_severity, BURN, armor_pen = 100)
	if(allergen_reaction & ALLERGEN_REACTION_TOX_DMG)
		take_damage(damage_severity, TOX, armor_pen = 100)
	if(allergen_reaction & ALLERGEN_REACTION_PAIN)
		take_damage(disable_severity, PAIN, armor_pen = 100)
	if(allergen_reaction & ALLERGEN_REACTION_OXY_DMG)
		take_damage(damage_severity, OXY, armor_pen = 100)
		if(prob(disable_severity/2))
			var/allergy_emote = get_allergy_choke_emote()
			if(allergy_emote)
				emote(allergy_emote)

	if(allergen_reaction & ALLERGEN_REACTION_EMOTE)
		if(prob(disable_severity/2))
			var/allergy_emote = get_allergy_faint_emote()
			if(allergy_emote)
				emote(allergy_emote)

	if(allergen_reaction & ALLERGEN_REACTION_WEAKEN)
		SET_STATUS_MAX(src, STAT_WEAK, disable_severity)
	if(allergen_reaction & ALLERGEN_REACTION_BLURRY)
		SET_STATUS_MAX(src, STAT_BLURRY, disable_severity)
	if(allergen_reaction & ALLERGEN_REACTION_SLEEPY)
		SET_STATUS_MAX(src, STAT_DROWSY, disable_severity)
	if(allergen_reaction & ALLERGEN_REACTION_CONFUSE)
		SET_STATUS_MAX(src, STAT_CONFUSE, ceil(disable_severity/4))
