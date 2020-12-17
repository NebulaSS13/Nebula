/decl/species/corvid
	name = SPECIES_CORVID
	bodytype = BODYTYPE_CORVID
	name_plural = "Corvidae"
	description = "Corvid uplifts were among the first sophonts produced by human science to aid in colonizing Mars. These days they \
	are more commonly found pursuing their own careers and goals on the fringes of human space or around their adopted homeworld \
	of Hyperion. Corvid naming conventions are a chosen name followed by the species of the person, followed by the location they were hatched."

	meat_type = /obj/item/chems/food/snacks/meat/chicken
	min_age = 12
	max_age = 45
	health_hud_intensity = 3

	base_color = "#000616"
	reagent_tag = IS_CORVID

	icobase =         'mods/species/neocorvids/icons/body.dmi'
	deform =          'mods/species/neocorvids/icons/body.dmi'
	damage_overlays = 'mods/species/neocorvids/icons/dam_corvid.dmi'
	blood_mask =      'mods/species/neocorvids/icons/blood_corvid.dmi'
	limb_blend =      ICON_MULTIPLY

	total_health = 80
	brute_mod = 1.35
	burn_mod =  1.35
	mob_size = MOB_SIZE_SMALL
	holder_type = /obj/item/holder/human
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
		BP_EYES =     /obj/item/organ/internal/eyes/corvid
	)

	unarmed_attacks = list(
		/decl/natural_attack/bite/sharp,
		/decl/natural_attack/claws,
		/decl/natural_attack/stomp/weak
	)

/decl/species/corvid/New()
	..()
	equip_adjust = list(
		BP_L_HAND =          list("[NORTH]" = list("x" =  3, "y" = -3), "[EAST]" = list("x" =  1, "y" = -3), "[SOUTH]" = list("x" = -3, "y" = -3),  "[WEST]" = list("x" = -5, "y" = -3)),
		BP_R_HAND =          list("[NORTH]" = list("x" = -3, "y" = -3), "[EAST]" = list("x" =  5, "y" = -3), "[SOUTH]" = list("x" =  3, "y" = -3),  "[WEST]" = list("x" = -1, "y" = -3)),
		slot_head_str =      list("[NORTH]" = list("x" =  0, "y" = -5), "[EAST]" = list("x" =  1, "y" = -5), "[SOUTH]" = list("x" =  0, "y" = -5),  "[WEST]" = list("x" = -1, "y" = -5)),
		slot_wear_mask_str = list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" =  2, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" = -2, "y" = -6)),
		slot_glasses_str =   list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" =  1, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" = -1, "y" = -6)),
		slot_back_str =      list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" =  3, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" = -3, "y" = -6)),
		slot_w_uniform_str = list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" = -1, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" =  1, "y" = -6)),
		slot_wear_id_str =   list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" = -1, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" =  1, "y" = -6)),
		slot_wear_suit_str = list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" = -1, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" =  1, "y" = -6)),
		slot_belt_str =      list("[NORTH]" = list("x" =  0, "y" = -6), "[EAST]" = list("x" = -1, "y" = -6), "[SOUTH]" = list("x" =  0, "y" = -6),  "[WEST]" = list("x" =  1, "y" = -6))
	)

/decl/species/corvid/equip_default_fallback_uniform(var/mob/living/carbon/human/H)
	if(istype(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/under/corvid_smock/worker, slot_w_uniform_str)

/obj/item/organ/internal/eyes/corvid
	eye_icon = 'mods/species/neocorvids/icons/eyes.dmi'

/datum/sprite_accessory/hair/corvid
	name = "Corvid Plumage"
	icon_state = "corvid_default"
	icon = 'mods/species/neocorvids/icons/hair.dmi'
	species_allowed = list(SPECIES_CORVID)
	blend = ICON_MULTIPLY

/datum/sprite_accessory/hair/corvid/ears
	name = "Corvid Curly"
	icon_state = "corvid_ears"

/datum/sprite_accessory/hair/corvid/spiky
	name = "Corvid Spiky"
	icon_state = "corvid_spiky"

/datum/sprite_accessory/hair/corvid/crest
	name = "Corvid Crest"
	icon_state = "corvid_crest"

/datum/sprite_accessory/marking/corvid
	name = "Beak (Head)"
	icon_state = "beak"
	body_parts = list(BP_HEAD)
	icon = 'mods/species/neocorvids/icons/markings.dmi'
	species_allowed = list(SPECIES_CORVID)
	blend = ICON_MULTIPLY

/datum/sprite_accessory/marking/corvid/wing_feathers
	name = "Wing Feathers (Left)"
	body_parts = list(BP_L_HAND)
	icon_state = "wing_feathers"

/datum/sprite_accessory/marking/corvid/wing_feathers/right
	name = "Wing Feathers (Right)"
	body_parts = list(BP_R_HAND)

/datum/sprite_accessory/hair/bald/New()
	..()
	LAZYADD(species_allowed, SPECIES_CORVID)
