//These are meant for spawning on maps, namely Away Missions.

//If someone can do this in a neater way, be my guest-Kor

//To do: Allow corpses to appear mangled, bloody, etc. Allow customizing the bodies appearance (they're all bald and white right now).

#define CORPSE_SPAWNER_RANDOM_NAME         BITFLAG(0)
#define CORPSE_SPAWNER_CUT_SURVIVAL        BITFLAG(1)
#define CORPSE_SPAWNER_CUT_ID_PDA          BITFLAG(2)
#define CORPSE_SPAWNER_PLAIN_HEADSET       BITFLAG(3)
#define CORPSE_SPAWNER_RANDOM_SKIN_TONE    BITFLAG(4)
#define CORPSE_SPAWNER_RANDOM_SKIN_COLOR   BITFLAG(5)
#define CORPSE_SPAWNER_RANDOM_HAIR_COLOR   BITFLAG(6)
#define CORPSE_SPAWNER_RANDOM_HAIR_STYLE   BITFLAG(7)
#define CORPSE_SPAWNER_RANDOM_FACIAL_STYLE BITFLAG(8)
#define CORPSE_SPAWNER_RANDOM_EYE_COLOR    BITFLAG(9)
#define CORPSE_SPAWNER_RANDOM_GENDER       BITFLAG(10)

#define CORPSE_SPAWNER_NO_RANDOMIZATION ~(CORPSE_SPAWNER_RANDOM_NAME|CORPSE_SPAWNER_RANDOM_SKIN_TONE|CORPSE_SPAWNER_RANDOM_SKIN_COLOR|CORPSE_SPAWNER_RANDOM_HAIR_COLOR|CORPSE_SPAWNER_RANDOM_HAIR_STYLE|CORPSE_SPAWNER_RANDOM_FACIAL_STYLE|CORPSE_SPAWNER_RANDOM_EYE_COLOR)


/obj/abstract/landmark/corpse
	name = "Unknown"
	abstract_type = /obj/abstract/landmark/corpse
	var/species                                       // List of species to pick from.
	var/corpse_outfits = list(/decl/hierarchy/outfit) // List of outfits to pick from. Uses pickweight()
	var/spawn_flags = (~0)
	var/weakref/my_corpse

	var/skin_colors_per_species   = list() // Custom skin colors, per species -type-, if any. For example if you want dead aliens to always have blue hair, or similar
	var/skin_tones_per_species    = list() // Custom skin tones, per species -type-, if any. See above as to why.
	var/eye_colors_per_species    = list() // Custom eye colors, per species -type-, if any. See above as to why.
	var/hair_colors_per_species   = list() // Custom hair colors, per species -type-, if any. See above as to why.
	var/hair_styles_per_species   = list() // Custom hair styles, per species -type-, if any. For example if you want a punk gang with handlebars.
	var/facial_styles_per_species = list() // Custom facial hair styles, per species -type-, if any. See above as to why
	var/genders_per_species       = list() // For gender biases per species -type-

/obj/abstract/landmark/corpse/Initialize()
	..()
	if(!species)
		species = global.using_map.default_species
	var/species_choice = islist(species) ? pickweight(species) : species
	my_corpse = weakref(new /mob/living/human/corpse(loc, species_choice, null, src))
	return INITIALIZE_HINT_QDEL

/obj/abstract/landmark/corpse/proc/randomize_appearance(var/mob/living/human/M, species_choice)

	if((spawn_flags & CORPSE_SPAWNER_RANDOM_GENDER))
		if(species_choice in genders_per_species)
			M.set_gender(pick(genders_per_species[species_choice]), TRUE)
		else
			M.randomize_gender()

	if((spawn_flags & CORPSE_SPAWNER_RANDOM_SKIN_TONE))
		if(species_choice in skin_tones_per_species)
			M.change_skin_tone(pick(skin_tones_per_species[species_choice]))
		else
			M.randomize_skin_tone()

	if((spawn_flags & CORPSE_SPAWNER_RANDOM_SKIN_COLOR))
		if(species_choice in skin_colors_per_species)
			M.set_skin_colour(pick(skin_colors_per_species[species_choice]))
		else
			M.randomize_skin_color()

	var/decl/species/species_decl = get_species_by_key(species_choice)
	var/decl/bodytype/root_bodytype = M.get_bodytype()
	var/update_hair = FALSE
	if((spawn_flags & CORPSE_SPAWNER_RANDOM_HAIR_COLOR))
		if(species_choice in hair_colors_per_species)
			SET_HAIR_COLOR(M, pick(hair_colors_per_species[species_choice]), TRUE)
		else
			SET_HAIR_COLOR(M, get_random_colour(), TRUE)
		SET_FACIAL_HAIR_COLOR(M, GET_HAIR_COLOR(M), TRUE)
		update_hair = TRUE
	if((spawn_flags & CORPSE_SPAWNER_RANDOM_HAIR_STYLE))
		if(species_choice in hair_styles_per_species)
			SET_HAIR_STYLE(M, pick(hair_styles_per_species[species_choice]), TRUE)
		else
			SET_HAIR_STYLE(M, pick(species_decl.get_available_accessory_types(root_bodytype, SAC_HAIR)), TRUE)
		update_hair = TRUE
	if((spawn_flags & CORPSE_SPAWNER_RANDOM_FACIAL_STYLE))
		if(species_choice in facial_styles_per_species)
			SET_FACIAL_HAIR_STYLE(M, pick(facial_styles_per_species[species_choice]), TRUE)
		else
			SET_FACIAL_HAIR_STYLE(M, pick(species_decl.get_available_accessory_types(root_bodytype, SAC_FACIAL_HAIR)), TRUE)
		update_hair = TRUE
	if(update_hair)
		M.update_hair()

	if((spawn_flags & CORPSE_SPAWNER_RANDOM_EYE_COLOR))
		if(species_choice in eye_colors_per_species)
			M.set_eye_colour(pick(eye_colors_per_species[species_choice]))
		else
			M.randomize_eye_color()

	var/decl/cultural_info/culture = M.get_cultural_value(TAG_CULTURE)
	if(culture && CORPSE_SPAWNER_RANDOM_NAME & spawn_flags)
		M.SetName(culture.get_random_name(M.gender))
	else
		M.SetName(name)
	M.real_name = M.name

/obj/abstract/landmark/corpse/proc/equip_corpse_outfit(var/mob/living/human/M)
	var/adjustments = 0
	adjustments = (spawn_flags & CORPSE_SPAWNER_CUT_SURVIVAL)  ? (adjustments|OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR) : adjustments
	adjustments = (spawn_flags & CORPSE_SPAWNER_CUT_ID_PDA)    ? (adjustments|OUTFIT_ADJUSTMENT_SKIP_ID_PDA)        : adjustments
	adjustments = (spawn_flags & CORPSE_SPAWNER_PLAIN_HEADSET) ? (adjustments|OUTFIT_ADJUSTMENT_PLAIN_HEADSET)      : adjustments

	var/decl/hierarchy/outfit/corpse_outfit = outfit_by_type(pickweight(corpse_outfits))
	corpse_outfit.equip_outfit(M, equip_adjustments = adjustments)

/obj/abstract/landmark/corpse/pirate
	name = "Pirate"
	corpse_outfits = list(/decl/hierarchy/outfit/pirate/norm)
	spawn_flags = CORPSE_SPAWNER_NO_RANDOMIZATION

/obj/abstract/landmark/corpse/pirate/ranged
	name = "Pirate Gunner"
	corpse_outfits = list(/decl/hierarchy/outfit/pirate/space)

/obj/abstract/landmark/corpse/russian
	name = "Russian"
	corpse_outfits = list(/decl/hierarchy/outfit/soviet_soldier)
	spawn_flags = CORPSE_SPAWNER_NO_RANDOMIZATION

/obj/abstract/landmark/corpse/russian/ranged
	corpse_outfits = list(/decl/hierarchy/outfit/soviet_soldier)

/obj/abstract/landmark/corpse/syndicate
	name = "Syndicate Operative"
	corpse_outfits = list(/decl/hierarchy/outfit/mercenary/syndicate)
	spawn_flags = CORPSE_SPAWNER_NO_RANDOMIZATION

/obj/abstract/landmark/corpse/syndicate/commando
	name = "Syndicate Commando"
	corpse_outfits = list(/decl/hierarchy/outfit/mercenary/syndicate/commando)

/obj/abstract/landmark/corpse/chef
	name = "Chef"
	corpse_outfits = list(/decl/hierarchy/outfit/job/generic/chef)

/obj/abstract/landmark/corpse/doctor
	name = "Doctor"
	corpse_outfits = list(/decl/hierarchy/outfit/job/generic/doctor)

/obj/abstract/landmark/corpse/engineer
	name = "Engineer"
	corpse_outfits = list(/decl/hierarchy/outfit/job/generic/engineer)

/obj/abstract/landmark/corpse/scientist
	name = "Scientist"
	corpse_outfits = list(/decl/hierarchy/outfit/job/generic/scientist)
