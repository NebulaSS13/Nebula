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

	age_descriptor = /datum/appearance_descriptor/age/neoavian

	meat_type = /obj/item/chems/food/meat/chicken

	base_color = "#000616"
	reagent_tag = IS_AVIAN

	available_bodytypes = list(/decl/bodytype/avian)

	total_health = 80
	brute_mod = 1.35
	burn_mod =  1.35
	mob_size = MOB_SIZE_SMALL
	holder_type = /obj/item/holder
	gluttonous = GLUT_TINY
	blood_volume = 320
	hunger_factor = 0.1

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
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes/avian
	)

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

/decl/species/neoavian/handle_post_species_pref_set(var/datum/preferences/pref)
	pref.body_markings = pref.body_markings || list()
	if(!pref.body_markings["Beak (Head)"])
		pref.body_markings["Beak (Head)"] = "#454545"
	if(!pref.body_markings["Tailfeathers (Groin)"])
		pref.body_markings["Tailfeathers (Groin)"] = "#252525"
	pref.skin_colour = "#252525"

/obj/item/organ/internal/eyes/avian
	eye_icon = 'mods/species/neoavians/icons/eyes.dmi'

/datum/sprite_accessory/hair/avian
	name = "Avian Plumage"
	icon_state = "avian_default"
	icon = 'mods/species/neoavians/icons/hair.dmi'
	species_allowed = list(SPECIES_AVIAN)
	blend = ICON_MULTIPLY

/datum/sprite_accessory/hair/avian/mohawk
	name = "Avian Mohawk"
	icon_state = "avian_mohawk"

/datum/sprite_accessory/hair/avian/spiky
	name = "Avian Spiky"
	icon_state = "avian_spiky"

/datum/sprite_accessory/hair/avian/crest
	name = "Avian Crest"
	icon_state = "avian_crest"

/datum/sprite_accessory/hair/avian/mane
	name = "Avian Mane"
	icon_state = "avian_mane"

/datum/sprite_accessory/hair/avian/upright
	name = "Avian Upright"
	icon_state = "avian_upright"

/datum/sprite_accessory/hair/avian/fluffymohawk
	name = "Avian Fluffy Mohawk"
	icon_state = "avian_fluffymohawk"

/datum/sprite_accessory/hair/avian/twies
	name = "Avian Twies"
	icon_state = "avian_twies"

/datum/sprite_accessory/marking/avian
	name = "Beak (Head)"
	icon_state = "beak"
	body_parts = list(BP_HEAD)
	icon = 'mods/species/neoavians/icons/markings.dmi'
	species_allowed = list(SPECIES_AVIAN)
	blend = ICON_MULTIPLY

/datum/sprite_accessory/marking/avian/resomi
	name = "Raptor Ears (Head)"
	icon_state = "ears"

/datum/sprite_accessory/marking/avian/tail
	name = "Tailfeathers (Groin)"
	icon_state = "feathered_tail"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/avian/tail/resomi
	name = "Raptor Tail (Groin)"
	icon_state = "raptor_tail"

/datum/sprite_accessory/marking/avian/tail/resomi_feathers
	name = "Raptor Tailfeathers (Groin)"
	icon_state = "raptor_tail_feathers"

/datum/sprite_accessory/marking/avian/wing_feathers
	name = "Wing Feathers (Left)"
	body_parts = list(BP_L_HAND)
	icon_state = "wing_feathers"

/datum/sprite_accessory/marking/avian/wing_feathers/right
	name = "Wing Feathers (Right)"
	body_parts = list(BP_R_HAND)

/datum/sprite_accessory/hair/bald/New()
	..()
	LAZYADD(species_allowed, SPECIES_AVIAN)
