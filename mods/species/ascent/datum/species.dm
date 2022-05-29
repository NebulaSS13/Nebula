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

	available_bodytypes = list(/decl/bodytype/alate)

	description = "When human surveyors finally arrived at the outer reaches of explored space, they hoped to find \
	new frontiers and new planets to exploit. They were largely not expecting to have entire expeditions lost \
	amid reports of highly advanced, astonishingly violent mantid-cephlapodean sentients with particle cannons."
	organs_icon =       'mods/species/ascent/icons/species/body/organs.dmi'

	flesh_color =             "#009999"
	hud_type =                /datum/hud_data/mantid
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

	reagent_tag =             IS_MANTID
	available_pronouns = list(/decl/pronouns/male)

	appearance_flags =        0
	species_flags =           SPECIES_FLAG_NO_SCAN  | SPECIES_FLAG_NO_SLIP        | SPECIES_FLAG_NO_MINOR_CUT
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

/decl/species/mantid/post_organ_rejuvenate(var/obj/item/organ/org, var/mob/living/carbon/human/H)
	org.status |= ORGAN_CRYSTAL

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
	spawns_with_stack =       0

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


/datum/hud_data/mantid
	gear = list(
		"i_clothing" =   list("loc" = ui_iclothing, "name" = "Uniform",      "slot" = slot_w_uniform_str, "state" = "center", "toggle" = 1),
		"o_clothing" =   list("loc" = ui_oclothing, "name" = "Suit",         "slot" = slot_wear_suit_str, "state" = "suit",   "toggle" = 1),
		"mask" =         list("loc" = ui_mask,      "name" = "Mask",         "slot" = slot_wear_mask_str, "state" = "mask",   "toggle" = 1),
		"gloves" =       list("loc" = ui_gloves,    "name" = "Gloves",       "slot" = slot_gloves_str,    "state" = "gloves", "toggle" = 1),
		"eyes" =         list("loc" = ui_glasses,   "name" = "Glasses",      "slot" = slot_glasses_str,   "state" = "glasses","toggle" = 1),
		"l_ear" =        list("loc" = ui_l_ear,     "name" = "Left Ear",     "slot" = slot_l_ear_str,     "state" = "ears",   "toggle" = 1),
		"r_ear" =        list("loc" = ui_r_ear,     "name" = "Right Ear",    "slot" = slot_r_ear_str,     "state" = "ears",   "toggle" = 1),
		"head" =         list("loc" = ui_head,      "name" = "Hat",          "slot" = slot_head_str,      "state" = "hair",   "toggle" = 1),
		"shoes" =        list("loc" = ui_shoes,     "name" = "Shoes",        "slot" = slot_shoes_str,     "state" = "shoes",  "toggle" = 1),
		"suit storage" = list("loc" = ui_sstore1,   "name" = "Suit Storage", "slot" = slot_s_store_str,   "state" = "suitstore"),
		"back" =         list("loc" = ui_back,      "name" = "Back",         "slot" = slot_back_str,      "state" = "back"),
		"id" =           list("loc" = ui_id,        "name" = "ID",           "slot" = slot_wear_id_str,   "state" = "id"),
		"storage1" =     list("loc" = ui_storage1,  "name" = "Left Pocket",  "slot" = slot_l_store_str,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "name" = "Right Pocket", "slot" = slot_r_store_str,   "state" = "pocket"),
		"belt" =         list("loc" = ui_belt,      "name" = "Belt",         "slot" = slot_belt_str,      "state" = "belt")
		)
