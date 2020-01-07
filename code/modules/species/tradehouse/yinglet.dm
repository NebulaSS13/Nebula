// Semi-adapted from Polaris Teshari.
/datum/species/yinglet
	name = SPECIES_YINGLET
	name_plural = "Yinglets"
	description = "A species of short, slender rat-birds with a fondness for clams. Commonly found wherever humans are, \
	either scavenging amongst their leavings, or benefiting from adjacency to an older and more developed culture."
	autohiss_basic_map = list("th" = list("z"))

	icobase =         'icons/mob/human_races/species/yinglet/body.dmi'
	deform =          'icons/mob/human_races/species/yinglet/deformed_body.dmi'
	preview_icon =    'icons/mob/human_races/species/yinglet/preview.dmi'
	husk_icon =       'icons/mob/human_races/species/yinglet/husk.dmi'
	damage_overlays = 'icons/mob/human_races/species/yinglet/damage_overlay.dmi'
	damage_mask =     'icons/mob/human_races/species/yinglet/damage_mask.dmi'
	blood_mask =      'icons/mob/human_races/species/yinglet/blood_mask.dmi'

	limb_blend = ICON_MULTIPLY
	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/yinglet),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/yinglet),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/yinglet),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/yinglet),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/yinglet),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/yinglet),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/yinglet),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/yinglet),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/yinglet),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/yinglet),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/yinglet)
		)

	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes/yinglet
		)
	descriptors = list(
		/datum/mob_descriptor/height = -3,
		/datum/mob_descriptor/build =  -3
	)
	min_age = 5
	max_age = 20
	slowdown = -0.5
	total_health = 75
	brute_mod = 1.25
	burn_mod =  1.25
	//mob_size = MOB_SMALL
	holder_type = /obj/item/weapon/holder/human
	blood_volume = 350
	hunger_factor = 0.1
	inherent_verbs = list(/mob/living/proc/hide)

	available_cultural_info = list(
		TAG_CULTURE =   list(CULTURE_SCAV_ENCLAVE, CULTURE_OTHER),
		TAG_HOMEWORLD = list(HOME_SYSTEM_STATELESS),
		TAG_FACTION =   list(FACTION_SCAV, FACTION_OTHER),
		TAG_RELIGION =  list(RELIGION_OTHER, RELIGION_ATHEISM, RELIGION_AGNOSTICISM)
	)

/datum/species/yinglet/get_bodytype(var/mob/living/carbon/human/H)
	. = SPECIES_YINGLET

/datum/species/yinglet/New()
	equip_adjust = list(
		slot_head_str = list(
			"[NORTH]" = list("x" = 0,  "y" = -3),  
			"[EAST]" =  list("x" = 3,  "y" = -3),  
			"[WEST]" =  list("x" = -3, "y" = -3),  
			"[SOUTH]" = list("x" = 0,  "y" = -3)
		),
		slot_back_str = list(
			"[NORTH]" = list("x" = 0,  "y" = -5),  
			"[EAST]" =  list("x" = 3,  "y" = -5),  
			"[WEST]" =  list("x" = -3, "y" = -5),  
			"[SOUTH]" = list("x" = 0,  "y" = -5)
		),
		slot_belt_str = list(
			"[NORTH]" = list("x" = 0,  "y" = -1),  
			"[EAST]" =  list("x" = 2,  "y" = -1),  
			"[WEST]" =  list("x" = -2, "y" = -1),  
			"[SOUTH]" = list("x" = 0,  "y" = -1)
		),
		slot_glasses_str = list(
			"[NORTH]" = list("x" = 0,  "y" = -3),  
			"[EAST]" =  list("x" = 2,  "y" = -3),  
			"[WEST]" =  list("x" = -2, "y" = -3),  
			"[SOUTH]" = list("x" = 0,  "y" = -3)
		),
		slot_l_hand_str = list(
			"[NORTH]" = list("x" = 2,  "y" = -3),  
			"[EAST]" =  list("x" = 2,  "y" = -3),  
			"[WEST]" =  list("x" = -2, "y" = -3),  
			"[SOUTH]" = list("x" = -2, "y" = -3)
		),
		slot_r_hand_str = list(
			"[NORTH]" = list("x" = -2, "y" = -3),  
			"[EAST]" =  list("x" = 2,  "y" = -3),  
			"[WEST]" =  list("x" = -2, "y" = -3),  
			"[SOUTH]" = list("x" = 2,  "y" = -3)
		),
		slot_wear_mask_str = list(
			"[NORTH]" = list("x" = 0,  "y" = -3),  
			"[EAST]" =  list("x" = 2,  "y" = -3),  
			"[WEST]" =  list("x" = -2, "y" = -3),  
			"[SOUTH]" = list("x" = 0,  "y" = -3)
		)
	)
	..()

// This is honestly just so the other name generator becomes available.
/datum/species/yinglet/southern
	name = SPECIES_YINGLET_SOUTHERN
	name_plural = "Southern Yinglets"
	description = "Although similar to the other clam-loving rat-birds of the yinglet species, the southern \
	yinglets are more parochial, tribal and generally less developed. Nobody is quite clear on which south \
	they are from."
	available_cultural_info = list(
		TAG_CULTURE =   list(CULTURE_SCAV_TRIBE, CULTURE_OTHER),
		TAG_HOMEWORLD = list(HOME_SYSTEM_STATELESS),
		TAG_FACTION =   list(FACTION_SCAV, FACTION_OTHER),
		TAG_RELIGION =  list(RELIGION_OTHER, RELIGION_ATHEISM, RELIGION_AGNOSTICISM)
	)
