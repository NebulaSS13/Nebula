/decl/bodytype/alium
	name              = "humanoid"
	bodytype_category = BODYTYPE_HUMANOID
	icon_base         = 'icons/mob/human_races/species/humanoid/body.dmi'
	bandages_icon     = 'icons/mob/bandage.dmi'
	limb_blend        = ICON_MULTIPLY
	appearance_flags  = HAS_SKIN_COLOR
	body_flags        = BODY_FLAG_NO_DNA | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS
	uid               = "bodytype_alium"

/decl/bodytype/alium/Initialize()
	if(prob(10))
		movement_slowdown += pick(-1,1)
	if(prob(5))
		body_flags |= BODY_FLAG_NO_PAIN
	base_color  = RANDOM_RGB
	MULT_BY_RANDOM_COEF(eye_flash_mod, 0.5, 1.5)
	eye_darksight_range = rand(1,8)
	var/temp_comfort_shift = rand(-50,50)
	cold_level_1 += temp_comfort_shift
	cold_level_2 += temp_comfort_shift
	cold_level_3 += temp_comfort_shift
	heat_level_1 += temp_comfort_shift
	heat_level_2 += temp_comfort_shift
	heat_level_3 += temp_comfort_shift
	heat_discomfort_level += temp_comfort_shift
	cold_discomfort_level += temp_comfort_shift
	. = ..()

/decl/species/alium
	name = SPECIES_ALIEN
	name_plural = "Humanoids"
	description = "Some alien humanoid species, unknown to humanity. How exciting."
	rarity_value = 5

	spawn_flags = SPECIES_IS_RESTRICTED

	available_bodytypes = list(/decl/bodytype/alium)

	force_cultural_info = list(
		TAG_CULTURE = /decl/cultural_info/culture/hidden/alium
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
		available_pronouns = list(/decl/pronouns)
	if(prob(10))
		species_flags |= SPECIES_FLAG_NO_SLIP
	if(prob(10))
		species_flags |= SPECIES_FLAG_NO_TANGLE

	. = ..()

/decl/species/alium/get_species_blood_color(mob/living/human/H)
	if(istype(H) && H.isSynthetic())
		return ..()
	return blood_color

/obj/structure/aliumizer
	name = "alien monolith"
	desc = "Your true form is calling. Use this to become an alien humanoid."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano51"
	anchored = TRUE

/obj/structure/aliumizer/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	if(!ishuman(user))
		to_chat(user, SPAN_WARNING("You've got no business touching this."))
		return TRUE
	var/decl/species/species = user.get_species()
	if(!species)
		return TRUE
	if(species.name == SPECIES_ALIEN)
		to_chat(user, SPAN_WARNING("You're already a [SPECIES_ALIEN]."))
		return TRUE
	if(alert("Are you sure you want to be an alien?", "Mom Look I'm An Alien!", "Yes", "No") == "No")
		to_chat(user, SPAN_NOTICE("<b>You are now a [SPECIES_ALIEN]!</b>"))
		return TRUE
	if(species.name == SPECIES_ALIEN) //no spamming it to get free implants
		return TRUE
	to_chat(user, "You're now an alien humanoid of some undiscovered species. Make up what lore you want, no one knows a thing about your species! You can check info about your traits with Check Species Info verb in IC tab.")
	to_chat(user, "You can't speak any other languages by default. You can use translator implant that spawns on top of this monolith - it will give you knowledge of any language if you hear it enough times.")
	var/mob/living/human/H = user
	new /obj/item/implanter/translator(get_turf(src))
	H.change_species(SPECIES_ALIEN)
	var/decl/cultural_info/culture = H.get_cultural_value(TAG_CULTURE)
	H.fully_replace_character_name(culture.get_random_name(H, H.gender))
	H.rename_self("Humanoid Alien", 1)
	return TRUE
