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

/decl/butchery_data/humanoid/avian
	meat_name = "chicken"
	meat_type = /obj/item/food/butchery/meat/chicken

/decl/species/neoavian
	name = SPECIES_AVIAN
	name_plural = "Neo-Avians"
	description = "Avian species, largely crows, magpies and other corvids, were among the first sophonts uplifted to aid in colonizing Mars. \
	These days they are more commonly found pursuing their own careers and goals on the fringes of human space or around their adopted homeworld \
	of Hyperion. Neo-avian naming conventions tend to be a chosen name followed by the species of the person, followed by the location they were hatched."
	base_external_prosthetics_model = null

	snow_slowdown_mod = -1

	holder_icon = 'mods/species/neoavians/icons/holder.dmi'

	butchery_data = /decl/butchery_data/humanoid/avian

	preview_outfit = /decl/outfit/job/generic/assistant/avian

	available_bodytypes = list(
		/decl/bodytype/avian,
		/decl/bodytype/avian/additive,
		/decl/bodytype/avian/raptor,
		/decl/bodytype/avian/additive/raptor
	)

	total_health = 120
	holder_type = /obj/item/holder
	gluttonous = GLUT_TINY
	blood_volume = 320
	hunger_factor = DEFAULT_HUNGER_FACTOR * 1.6
	thirst_factor = DEFAULT_THIRST_FACTOR * 1.6

	spawn_flags = SPECIES_CAN_JOIN
	bump_flag = MONKEY
	swap_flags = MONKEY|SIMPLE_ANIMAL
	push_flags = MONKEY|SIMPLE_ANIMAL

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

/decl/species/neoavian/equip_default_fallback_uniform(var/mob/living/human/H)
	if(istype(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/dress/avian_smock/worker, slot_w_uniform_str)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/avian, slot_shoes_str)

/decl/species/neoavian/get_holder_color(var/mob/living/human/H)
	return H.get_skin_colour()

/decl/outfit/job/generic/assistant/avian
	name = "Job - Avian Assistant"
	uniform = /obj/item/clothing/dress/avian_smock/worker
	shoes = /obj/item/clothing/shoes/avian/footwraps
