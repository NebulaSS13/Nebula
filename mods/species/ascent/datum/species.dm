/datum/appearance_descriptor/age/kharmaani
	chargen_min_index = 3
	chargen_max_index = 6
	standalone_value_descriptors = list(
		"a larva" =         1,
		"a nymph" =         2,
		"a juvenile" =      3,
		"an adolescent" =   5,
		"a young adult" =  12,
		"a full adult" =   30,
		"a matriarch" =    45,
		"a queen" =        60,
		"an imperatrix" = 150,
		"a crone" =       500
	)

/datum/appearance_descriptor/age/kharmaani/gyne
	chargen_min_index = 5
	chargen_max_index = 9

/decl/blood_type/hemolymph/mantid
	name = "crystalline ichor"
	antigens = list("Hc") // hemocyanin, more of an octopus thing than a bug thing but whatever, it sounds neat
	splatter_colour = "#660066"

/decl/species/mantid

	name =                   SPECIES_MANTID_ALATE
	name_plural =            "Kharmaan Alates"
	show_ssd =               "quiescent"

	base_prosthetics_model = null
	available_bodytypes = list(/decl/bodytype/alate)

	description = "When human surveyors finally arrived at the outer reaches of explored space, they hoped to find \
	new frontiers and new planets to exploit. They were largely not expecting to have entire expeditions lost \
	amid reports of highly advanced, astonishingly violent mantid-cephlapodean sentients with particle cannons."
	organs_icon =       'mods/species/ascent/icons/species/body/organs.dmi'

	flesh_color =             "#009999"
	move_trail =              /obj/effect/decal/cleanable/blood/tracks/snake

	blood_types = list(/decl/blood_type/hemolymph/mantid)

	speech_chance = 100
	speech_sounds = list(
		'mods/species/ascent/sounds/ascent1.ogg',
		'mods/species/ascent/sounds/ascent2.ogg',
		'mods/species/ascent/sounds/ascent3.ogg',
		'mods/species/ascent/sounds/ascent4.ogg',
		'mods/species/ascent/sounds/ascent5.ogg',
		'mods/species/ascent/sounds/ascent6.ogg'
	)

	siemens_coefficient =   0.2 // Crystalline body.
	oxy_mod =               0.8 // Don't need as much breathable gas as humans.
	toxins_mod =            0.8 // Not as biologically fragile as meatboys.
	radiation_mod =         0.5 // Not as biologically fragile as meatboys.
	flash_mod =               2 // Highly photosensitive.

	age_descriptor = /datum/appearance_descriptor/age/kharmaani
	slowdown =               -1
	rarity_value =            3
	gluttonous =              2
	siemens_coefficient =     0
	body_temperature =        null

	breath_type =             /decl/material/gas/methyl_bromide
	exhale_type =             /decl/material/gas/methane
	poison_types =            list(/decl/material/gas/chlorine)

	available_pronouns = list(/decl/pronouns/male)

	appearance_flags =        0
	species_flags =           SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_MINOR_CUT | SPECIES_FLAG_CRYSTALLINE
	spawn_flags =             SPECIES_IS_RESTRICTED

	heat_discomfort_strings = list(
		"You feel brittle and overheated.",
		"Your overheated carapace flexes uneasily.",
		"Overheated ichor trickles from your eyes."
		)
	cold_discomfort_strings = list(
		"Frost forms along your carapace.",
		"You hear a faint crackle of ice as you shift your freezing body.",
		"Your movements become sluggish under the weight of the chilly conditions."
		)
	unarmed_attacks = list(
		/decl/natural_attack/claws/strong/gloves,
		/decl/natural_attack/bite/sharp
	)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/insectoid),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/insectoid/mantid),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/insectoid),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/insectoid),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/insectoid),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/insectoid),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/insectoid),
		BP_M_HAND = list("path" = /obj/item/organ/external/hand/insectoid/midlimb),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/insectoid),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/insectoid),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/insectoid),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/insectoid)
	)

	has_organ = list(
		BP_HEART =             /obj/item/organ/internal/heart/insectoid,
		BP_STOMACH =           /obj/item/organ/internal/stomach/insectoid,
		BP_LUNGS =             /obj/item/organ/internal/lungs/insectoid,
		BP_LIVER =             /obj/item/organ/internal/liver/insectoid,
		BP_KIDNEYS =           /obj/item/organ/internal/kidneys/insectoid,
		BP_BRAIN =             /obj/item/organ/internal/brain/insectoid,
		BP_EYES =              /obj/item/organ/internal/eyes/insectoid,
		BP_SYSTEM_CONTROLLER = /obj/item/organ/internal/controller
	)

	limb_mapping = list(BP_CHEST = list(BP_CHEST, BP_M_HAND))

	force_cultural_info = list(
		TAG_CULTURE =   /decl/cultural_info/culture/ascent,
		TAG_HOMEWORLD = /decl/cultural_info/location/kharmaani,
		TAG_FACTION =   /decl/cultural_info/faction/ascent_alate,
		TAG_RELIGION =  /decl/cultural_info/religion/kharmaani
	)

	appearance_descriptors = list(
		/datum/appearance_descriptor/height =      0.75,
		/datum/appearance_descriptor/body_length = 0.5
	)

	pain_emotes_with_pain_level = list(
			list(/decl/emote/visible/ascent_shine, /decl/emote/visible/ascent_dazzle) = 80,
			list(/decl/emote/visible/ascent_glimmer, /decl/emote/visible/ascent_pulse) = 50,
			list(/decl/emote/visible/ascent_flicker, /decl/emote/visible/ascent_glint) = 20,
		)

/decl/species/mantid/handle_sleeping(var/mob/living/carbon/human/H)
	return

/decl/species/mantid/apply_species_organ_modifications(var/obj/item/organ/org)
	..()
	org.status &= ~ORGAN_BRITTLE

/decl/species/mantid/equip_survival_gear(var/mob/living/carbon/human/H, var/extendedtank = 1)
	return

/decl/species/mantid/gyne

	name =        SPECIES_MANTID_GYNE
	name_plural = "Kharmaan Gynes"

	available_bodytypes = list(/decl/bodytype/gyne)
	available_pronouns = list(/decl/pronouns/female)

	gluttonous =              3
	slowdown =                2
	rarity_value =           10

	age_descriptor = /datum/appearance_descriptor/age/kharmaani/gyne
	blood_volume =         1200

	bump_flag =               HEAVY
	push_flags =              ALLMOBS
	swap_flags =              ALLMOBS

	override_limb_types = list(
		BP_HEAD = /obj/item/organ/external/head/insectoid/mantid,
		BP_GROIN = /obj/item/organ/external/groin/insectoid/mantid/gyne,
	)

	override_organ_types = list(
		BP_EGG = /obj/item/organ/internal/egg_sac/insectoid,
	)

	appearance_descriptors = list(
		/datum/appearance_descriptor/height =      2,
		/datum/appearance_descriptor/body_length = 1.25
	)

	force_cultural_info = list(
		TAG_CULTURE =   /decl/cultural_info/culture/ascent,
		TAG_HOMEWORLD = /decl/cultural_info/location/kharmaani,
		TAG_FACTION =   /decl/cultural_info/faction/ascent_gyne,
		TAG_RELIGION =  /decl/cultural_info/religion/kharmaani
	)
