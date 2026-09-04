/decl/bodytype/prosthetic/avian
	name = "synthetic avian"
	icon_base            = 'mods/species/neoavians/icons/body_synthetic.dmi'
	blood_overlays       = /decl/bodytype/avian::blood_overlays
	skeletal_icon        = /decl/bodytype/avian::skeletal_icon
	bodytype_category    = /decl/bodytype/avian::bodytype_category
	bodytype_flag        = /decl/bodytype/avian::bodytype_flag
	mob_size             = /decl/bodytype/avian::mob_size
	eye_icon             = /decl/bodytype/avian::eye_icon
	nail_noun            = /decl/bodytype/avian::nail_noun
	uid                  = "bodytype_prosthetic_avian"

/decl/bodytype/prosthetic/avian/raptor
	name                 = "synthetic raptor"
	icon_base            = 'mods/species/neoavians/icons/body_synthetic_raptor.dmi'
	uid                  = "bodytype_prosthetic_raptor"
	default_sprite_accessories = list(
		SAC_HAIR     = list(/decl/sprite_accessory/hair/avian/spiky  = list(SAM_COLOR = "#252525")),
		SAC_EARS     = list(/decl/sprite_accessory/ears/avian        = list(SAM_COLOR = "#252525")),
		SAC_TAIL     = list(/decl/sprite_accessory/tail/avian        = list(SAM_COLOR = "#252525"))
	)

/decl/bodytype/avian
	name                 = "avian"
	bodytype_category    = BODYTYPE_AVIAN
	icon_base            = 'mods/species/neoavians/icons/body.dmi'
	blood_overlays       = 'mods/species/neoavians/icons/blood_avian.dmi'
	skeletal_icon        = 'mods/species/neoavians/icons/skeleton.dmi'
	limb_blend           = ICON_MULTIPLY
	bodytype_flag        = BODY_EQUIP_FLAG_AVIAN
	eye_icon             = 'mods/species/neoavians/icons/eyes.dmi'
	appearance_flags     = HAS_SKIN_COLOR | HAS_EYE_COLOR
	base_color           = "#252525"
	base_eye_color       = "#f5c842"
	mob_size             = MOB_SIZE_SMALL
	nail_noun            = "talons"
	override_limb_types  = list(
		BP_L_FOOT = /obj/item/organ/external/foot/avian,
		BP_R_FOOT = /obj/item/organ/external/foot/right/avian,
		BP_L_HAND = /obj/item/organ/external/hand/clawed,
		BP_R_HAND = /obj/item/organ/external/hand/right/clawed,
		BP_HEAD   = /obj/item/organ/external/head/sharp_bite,
		BP_TAIL   = /obj/item/organ/external/tail/avian
	)
	has_organ            = list(
		BP_STOMACH = /obj/item/organ/internal/stomach,
		BP_HEART   = /obj/item/organ/internal/heart,
		BP_LUNGS   = /obj/item/organ/internal/lungs,
		BP_LIVER   = /obj/item/organ/internal/liver,
		BP_KIDNEYS = /obj/item/organ/internal/kidneys,
		BP_BRAIN   = /obj/item/organ/internal/brain,
		BP_EYES    = /obj/item/organ/internal/eyes
	)
	default_sprite_accessories = list(
		SAC_HAIR     = list(/decl/sprite_accessory/hair/avian    = list(SAM_COLOR = "#252525")),
		SAC_MARKINGS = list(/decl/sprite_accessory/marking/avian = list(SAM_COLOR = "#454545"))
	)
	age_descriptor          = /datum/appearance_descriptor/age/neoavian
	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
	)
	uid            = "bodytype_avian"

/decl/bodytype/avian/raptor
	name                 = "raptor"
	icon_base            = 'mods/species/neoavians/icons/body_raptor.dmi'
	uid                  = "bodytype_avian_raptor"
	default_sprite_accessories = list(
		SAC_HAIR     = list(/decl/sprite_accessory/hair/avian    = list(SAM_COLOR = "#252525")),
		SAC_EARS     = list(/decl/sprite_accessory/ears/avian    = list(SAM_COLOR = "#252525")),
		SAC_TAIL     = list(/decl/sprite_accessory/tail/avian    = list(SAM_COLOR = "#252525"))
	)

/decl/bodytype/avian/additive
	name                 = "avian, additive"
	icon_base            = 'mods/species/neoavians/icons/body_add.dmi'
	health_hud_intensity = 3
	limb_blend           = ICON_ADD
	uid                  = "bodytype_avian_additive"

/decl/bodytype/avian/additive/raptor
	name                 = "raptor, additive"
	icon_base            = 'mods/species/neoavians/icons/body_raptor_add.dmi'
	uid                  = "bodytype_avian_additive_raptor"

/decl/bodytype/avian/Initialize()
	_equip_adjust = list(
		(slot_l_ear_str) = list(
			"[NORTH]" = list( 1, -5),
			"[EAST]"  = list(-2, -5),
			"[SOUTH]" = list(-1, -5),
			"[WEST]"  = list( 0, -5)
		),
		(slot_r_ear_str) = list(
			"[NORTH]" = list( 1, -5),
			"[EAST]"  = list( 0, -5),
			"[SOUTH]" = list(-1, -5),
			"[WEST]"  = list( 2, -5)
		),
		(BP_L_HAND) = list(
			"[NORTH]" = list( 3, -3),
			"[EAST]"  = list( 1, -3),
			"[SOUTH]" = list(-3, -3),
			"[WEST]"  = list(-5, -3)
		),
		(BP_R_HAND) = list(
			"[NORTH]" = list(-3, -3),
			"[EAST]"  = list( 5, -3),
			"[SOUTH]" = list( 3, -3),
			"[WEST]"  = list(-1, -3)
		),
		(slot_head_str) = list(
			"[NORTH]" = list( 0, -5),
			"[EAST]"  = list( 1, -5),
			"[SOUTH]" = list( 0, -5),
			"[WEST]"  = list(-1, -5)
		),
		(slot_wear_mask_str) = list(
			"[NORTH]" = list( 0, -6),
			"[EAST]"  = list( 2, -6),
			"[SOUTH]" = list( 0, -6),
			"[WEST]"  = list(-2, -6)
		),
		(slot_glasses_str) = list(
			"[NORTH]" = list( 0, -6),
			"[EAST]"  = list( 1, -6),
			"[SOUTH]" = list( 0, -6),
			"[WEST]"  = list(-1, -6)
		),
		(slot_back_str) = list(
			"[NORTH]" = list( 0, -6),
			"[EAST]"  = list( 3, -6),
			"[SOUTH]" = list( 0, -6),
			"[WEST]"  = list(-3, -6)
		),
		(slot_w_uniform_str) = list(
			"[NORTH]" = list( 0, -6),
			"[EAST]"  = list(-1, -6),
			"[SOUTH]" = list( 0, -6),
			"[WEST]"  = list( 1, -6)
		),
		(slot_wear_id_str) = list(
			"[NORTH]" = list( 0, -6),
			"[EAST]"  = list(-1, -6),
			"[SOUTH]" = list( 0, -6),
			"[WEST]"  = list( 1, -6)
		),
		(slot_wear_suit_str) = list(
			"[NORTH]" = list( 0, -6),
			"[EAST]"  = list(-1, -6),
			"[SOUTH]" = list( 0, -6),
			"[WEST]"  = list( 1, -6)
		),
		(slot_belt_str) = list(
			"[NORTH]" = list( 0, -6),
			"[EAST]"  = list(-1, -6),
			"[SOUTH]" = list( 0, -6),
			"[WEST]"  = list( 1, -6)
		)
	)
	. = ..()

/obj/item/organ/external/foot/avian/get_natural_attacks()
	var/static/unarmed_attack = GET_DECL(/decl/natural_attack/stomp/weak)
	return unarmed_attack

/obj/item/organ/external/foot/right/avian/get_natural_attacks()
	var/static/unarmed_attack = GET_DECL(/decl/natural_attack/stomp/weak)
	return unarmed_attack

/obj/item/organ/external/tail/avian
	tail_icon = 'mods/species/neoavians/icons/tail.dmi'
	tail_blend = ICON_MULTIPLY
