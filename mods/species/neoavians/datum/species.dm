/datum/appearance_descriptor/age/neoavian
	chargen_min_index = 3
	chargen_max_index = 6
	standalone_value_descriptors = list(
		"a hatchling" =     1,
		"an fledgeling" =   6,
		"a young adult" =  12,
		"an adult" =       25,
		"middle-aged" =    35,
		"aging" =          45,
		"elderly" =        50
	)

/decl/species/neoavian
	name = SPECIES_AVIAN
	name_plural = "Neo-Avians"
	description = "Avian species, largely crows, magpies and other corvids, were among the first sophonts uplifted to aid in colonizing Mars. \
	These days they are more commonly found pursuing their own careers and goals on the fringes of human space or around their adopted homeworld \
	of Hyperion. Neo-avian naming conventions tend to be a chosen name followed by the species of the person, followed by the location they were hatched."
	base_prosthetics_model = null

	snow_slowdown_mod = -1

	age_descriptor = /datum/appearance_descriptor/age/neoavian
	holder_icon = 'mods/species/neoavians/icons/holder.dmi'

	meat_type = /obj/item/chems/food/meat/chicken

	base_color = "#252525"
	base_eye_color = "#f5c842"
	base_markings = list(/decl/sprite_accessory/marking/avian = "#454545")
	default_h_style = /decl/sprite_accessory/hair/avian

	preview_outfit = /decl/hierarchy/outfit/job/generic/assistant/avian

	available_bodytypes = list(
		/decl/bodytype/avian,
		/decl/bodytype/avian/additive,
		/decl/bodytype/avian/raptor,
		/decl/bodytype/avian/additive/raptor
	)

	total_health = 120
	mob_size = MOB_SIZE_SMALL
	holder_type = /obj/item/holder
	gluttonous = GLUT_TINY
	blood_volume = 320
	hunger_factor = DEFAULT_HUNGER_FACTOR * 1.6

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	bump_flag = MONKEY
	swap_flags = MONKEY|SIMPLE_ANIMAL
	push_flags = MONKEY|SIMPLE_ANIMAL

	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
		)

	has_organ = list(
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes/avian
	)

	override_limb_types = list(BP_TAIL = /obj/item/organ/external/tail/avian)

	unarmed_attacks = list(
		/decl/natural_attack/bite/sharp,
		/decl/natural_attack/claws,
		/decl/natural_attack/stomp/weak
	)

	available_cultural_info = list(
		TAG_CULTURE = list(
			/decl/cultural_info/culture/neoavian,
			/decl/cultural_info/culture/neoavian/saurian,
			/decl/cultural_info/culture/other
		)
	)

/decl/species/neoavian/equip_default_fallback_uniform(var/mob/living/carbon/human/H)
	if(istype(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/avian_smock/worker, slot_w_uniform_str)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/avian, slot_shoes_str)

/decl/species/neoavian/get_holder_color(var/mob/living/carbon/human/H)
	return H.skin_colour

/obj/item/organ/internal/eyes/avian
	eye_icon = 'mods/species/neoavians/icons/eyes.dmi'

/decl/hierarchy/outfit/job/generic/assistant/avian
	name = "Job - Avian Assistant"
	uniform = /obj/item/clothing/under/avian_smock/worker
	shoes = /obj/item/clothing/shoes/avian/footwraps
