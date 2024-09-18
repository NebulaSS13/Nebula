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
	name_plural = "Teshari"
	description = "A race of feathered raptors who developed alongside the Skrell, \
	inhabiting the polar tundral regions outside of Skrell territory. \
	Extremely fragile, they developed hunting skills that emphasized \
	taking out their prey without themselves getting hit. \
	They are only recently becoming known on human stations \
	after reaching space with Skrell assistance."
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

	blood_types = list(
		/decl/blood_type/avian/taplus,
		/decl/blood_type/avian/taminus,
		/decl/blood_type/avian/tbplus,
		/decl/blood_type/avian/tbminus,
		/decl/blood_type/avian/tatbplus,
		/decl/blood_type/avian/tatbminus,
		/decl/blood_type/avian/oplus,
		/decl/blood_type/avian/ominus,
	)

/decl/species/neoavian/Initialize()
	. = ..()
	LAZYINITLIST(available_background_info)
	LAZYDISTINCTADD(available_background_info[/decl/background_category/heritage], /decl/background_detail/heritage/teshari)
	LAZYDISTINCTADD(available_background_info[/decl/background_category/heritage], /decl/background_detail/heritage/teshari/kamerr)
	LAZYDISTINCTADD(available_background_info[/decl/background_category/heritage], /decl/background_detail/heritage/teshari/autonomist)
	LAZYDISTINCTADD(available_background_info[/decl/background_category/heritage], /decl/background_detail/heritage/teshari/sif)
	LAZYDISTINCTADD(available_background_info[/decl/background_category/heritage], /decl/background_detail/heritage/teshari/spacer)
	LAZYSET(default_background_info, /decl/background_category/heritage, /decl/background_detail/heritage/teshari)

/decl/species/neoavian/equip_default_fallback_uniform(var/mob/living/human/H)
	if(istype(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/dress/avian_smock/worker, slot_w_uniform_str)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/avian, slot_shoes_str)

/decl/species/neoavian/get_holder_color(var/mob/living/human/H)
	return H.get_skin_colour()

/decl/outfit/job/generic/assistant/avian
	name = "Job - Teshari Assistant"
	uniform = /obj/item/clothing/dress/avian_smock/worker
	shoes = /obj/item/clothing/shoes/avian/footwraps
