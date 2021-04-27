/datum/appearance_descriptor/age/lizard
	standalone_value_descriptors = list(
		"an infant" =       1,
		"a toddler" =       3,
		"a child" =         7,
		"an adolescent" =  13,
		"a young adult" =  18,
		"an adult" =       25,
		"middle-aged" =    50,
		"aging" =         150,
		"elderly" =       260
	)

/decl/species/lizard
	name = SPECIES_LIZARD
	name_plural = SPECIES_LIZARD
	preview_icon = 'mods/species/lizard/icons/preview.dmi'
	skin_material = /decl/material/solid/skin/lizard

	available_bodytypes = list(
		/decl/bodytype/lizard,
		/decl/bodytype/lizard/masculine
	)
	unarmed_attacks = list(
		/decl/natural_attack/stomp,
		/decl/natural_attack/tail,
		/decl/natural_attack/claws,
		/decl/natural_attack/punch,
		/decl/natural_attack/bite/sharp
	)

	primitive_form = "Stok"
	darksight_range = 3
	gluttonous = GLUT_TINY
	strength = STR_HIGH
	breath_pressure = 18
	slowdown = 0.5
	brute_mod = 0.8
	flash_mod = 1.2
	blood_volume = 800

	hunger_factor = DEFAULT_HUNGER_FACTOR * 2

	age_descriptor = /datum/appearance_descriptor/age/lizard

	body_temperature = null // cold-blooded, implemented the same way nabbers do it

	description = "A heavily reptillian species. They prefer warmer temperatures than most species and \
	their native tongue is a heavy hissing laungage."

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_NO_ROBOTIC_INTERNAL_ORGANS
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#34af10"

	reagent_tag = IS_LIZARD
	base_color = "#066000"
	blood_color = "#f24b2e"
	organs_icon = 'mods/species/lizard/icons/organs.dmi'

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	heat_discomfort_level = 320
	heat_discomfort_strings = list(
		"You feel soothingly warm.",
		"You feel the heat sink into your bones.",
		"You feel warm enough to take a nap."
		)

	cold_discomfort_level = 292
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel sluggish and cold.",
		"Your scales bristle against the cold."
		)

	breathing_sound = 'mods/species/lizard/sound/lizard_breathing.ogg'

	override_organ_types = list(
		BP_EYES = /obj/item/organ/internal/eyes/lizard,
		BP_BRAIN = /obj/item/organ/internal/brain/lizard
	)

	appearance_descriptors = list(
		/datum/appearance_descriptor/height = 1.25,
		/datum/appearance_descriptor/build =  1.25
		)

	default_emotes = list(
		/decl/emote/human/swish,
		/decl/emote/human/wag,
		/decl/emote/human/sway,
		/decl/emote/human/qwag,
		/decl/emote/human/fastsway,
		/decl/emote/human/swag,
		/decl/emote/human/stopsway
	)

	pain_emotes_with_pain_level = list(
		list(/decl/emote/audible/wheeze, /decl/emote/audible/roar, /decl/emote/audible/bellow, /decl/emote/audible/howl) = 80,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan, /decl/emote/audible/wheeze, /decl/emote/audible/hiss) = 50,
		list(/decl/emote/audible/grunt, /decl/emote/audible/groan, /decl/emote/audible/hiss) = 20,
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

/decl/species/lizard/New()
	..()
	LAZYINITLIST(available_cultural_info)
	LAZYDISTINCTADD(available_cultural_info[TAG_CULTURE], /decl/cultural_info/culture/lizard)
	LAZYSET(default_cultural_info, TAG_CULTURE, /decl/cultural_info/culture/lizard)

/decl/species/lizard/equip_survival_gear(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H), slot_shoes_str)
