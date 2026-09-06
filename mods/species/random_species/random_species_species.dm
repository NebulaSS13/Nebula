/decl/species/alium
	uid = "species_random_alien"
	name = "Humanoid"
	name_plural = "Humanoids"
	description = "Some alien humanoid species, unknown to humanity. How exciting."
	rarity_value = 5
	hidden_from_codex = TRUE

	spawn_flags = SPECIES_IS_RESTRICTED

	available_bodytypes = list(/decl/bodytype/alium)

	force_background_info = list(
		/decl/background_category/heritage = /decl/background_detail/heritage/hidden/alium
	)

	exertion_effect_chance = 10
	exertion_hydration_scale = 1
	exertion_reagent_scale = 1
	exertion_reagent_path = /decl/material/liquid/lactate
	exertion_emotes_biological = list(
		/decl/emote/exertion/biological,
		/decl/emote/exertion/biological/breath,
		/decl/emote/exertion/biological/pant
	)
	var/blood_color

/decl/species/alium/Initialize()

	//Coloring
	blood_color = RANDOM_RGB
	flesh_color = RANDOM_RGB

	//Combat stats
	MULT_BY_RANDOM_COEF(total_health, 0.8, 1.2)
	MULT_BY_RANDOM_COEF(brute_mod, 0.5, 1.5)
	MULT_BY_RANDOM_COEF(burn_mod, 0.8, 1.2)
	MULT_BY_RANDOM_COEF(oxy_mod, 0.5, 1.5)
	MULT_BY_RANDOM_COEF(toxins_mod, 0, 2)
	MULT_BY_RANDOM_COEF(radiation_mod, 0, 2)

	if(brute_mod < 1 && prob(40))
		species_flags |= SPECIES_FLAG_NO_MINOR_CUT
	if(brute_mod < 0.9 && prob(40))
		species_flags |= SPECIES_FLAG_NO_EMBED
	if(toxins_mod < 0.1)
		species_flags |= SPECIES_FLAG_NO_POISON

	//Gastronomic traits
	taste_sensitivity = pick(TASTE_HYPERSENSITIVE, TASTE_SENSITIVE, TASTE_DULL, TASTE_NUMB)
	gluttonous = pick(0, GLUT_TINY, GLUT_SMALLER, GLUT_ANYTHING)
	stomach_capacity = 5 * stomach_capacity
	if(prob(20))
		gluttonous |= pick(GLUT_ITEM_TINY, GLUT_ITEM_NORMAL, GLUT_ITEM_ANYTHING, GLUT_PROJECTILE_VOMIT)
		if(gluttonous & GLUT_ITEM_ANYTHING)
			stomach_capacity += ITEM_SIZE_HUGE

	//Environment
	var/temp_comfort_shift = rand(-50,50)
	body_temperature += temp_comfort_shift

	var/pressure_comfort_shift = rand(-50,50)
	hazard_high_pressure += pressure_comfort_shift
	warning_high_pressure += pressure_comfort_shift
	warning_low_pressure += pressure_comfort_shift
	hazard_low_pressure += pressure_comfort_shift

	//Misc traits
	if(prob(40))
		// 50% chance of pseudoplural or actually plural
		available_pronouns = list(pick(/decl/pronouns/pseudoplural, /decl/pronouns))
	if(prob(10))
		species_flags |= SPECIES_FLAG_NO_SLIP
	if(prob(10))
		species_flags |= SPECIES_FLAG_NO_TANGLE

	. = ..()

/decl/species/alium/get_species_blood_color(mob/living/human/H)
	if(istype(H) && H.isSynthetic())
		return ..()
	return blood_color