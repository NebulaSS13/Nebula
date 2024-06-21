/decl/bodytype/avian
	name                 = "avian"
	bodytype_category    = BODYTYPE_AVIAN
	icon_base            = 'mods/species/neoavians/icons/body.dmi'
	blood_overlays       = 'mods/species/neoavians/icons/blood_avian.dmi'
	skeletal_icon        = 'mods/species/neoavians/icons/skeleton.dmi'
	limb_blend           = ICON_MULTIPLY
	bodytype_flag        = BODY_FLAG_AVIAN
	eye_icon             = 'mods/species/neoavians/icons/eyes.dmi'
	appearance_flags     = HAS_SKIN_COLOR | HAS_EYE_COLOR
	base_color           = "#252525"
	base_eye_color       = "#f5c842"
	mob_size             = MOB_SIZE_SMALL
	nail_noun            = "talons"
	has_organ            = list(
		BP_STOMACH = /obj/item/organ/internal/stomach,
		BP_HEART   = /obj/item/organ/internal/heart,
		BP_LUNGS   = /obj/item/organ/internal/lungs,
		BP_LIVER   = /obj/item/organ/internal/liver,
		BP_KIDNEYS = /obj/item/organ/internal/kidneys,
		BP_BRAIN   = /obj/item/organ/internal/brain,
		BP_EYES    = /obj/item/organ/internal/eyes
	)
	override_limb_types  = list(BP_TAIL = /obj/item/organ/external/tail/avian)
	default_sprite_accessories = list(
		SAC_HAIR     = list(/decl/sprite_accessory/hair/avian    = "#252525"),
		SAC_MARKINGS = list(/decl/sprite_accessory/marking/avian = "#454545")
	)
	age_descriptor = /datum/appearance_descriptor/age/neoavian
	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
	)

	var/tail =              "tail_avian"
	var/tail_icon =         'mods/species/neoavians/icons/tail.dmi'
	var/tail_blend =        ICON_MULTIPLY
	var/tail_hair
	var/tail_hair_blend
	var/tail_states

/decl/bodytype/avian/raptor
	name                 = "raptor"
	icon_base            = 'mods/species/neoavians/icons/body_raptor.dmi'
	tail_icon            = 'mods/species/neoavians/icons/tail.dmi'
	tail                 = "tail_raptor"
	tail_hair            = "over"
	tail_hair_blend      = ICON_MULTIPLY

/decl/bodytype/avian/additive
	name                 = "avian, additive"
	icon_base            = 'mods/species/neoavians/icons/body_add.dmi'
	health_hud_intensity = 3
	limb_blend           = ICON_ADD
	tail_blend           = ICON_ADD
	tail                 = "tail_avian_add"

/decl/bodytype/avian/additive/raptor
	name                 = "raptor, additive"
	icon_base            = 'mods/species/neoavians/icons/body_raptor_add.dmi'
	tail                 = "tail_raptor_add"
	tail_hair            = "over"
	tail_hair_blend      = ICON_ADD

/decl/bodytype/avian/Initialize()
	equip_adjust = list(
		slot_l_ear_str     = list("[NORTH]" = list( 1, -5), "[EAST]" = list(-2, -5), "[SOUTH]" = list(-1, -5),  "[WEST]" = list( 0, -5)),
		slot_r_ear_str     = list("[NORTH]" = list( 1, -5), "[EAST]" = list( 0, -5), "[SOUTH]" = list(-1, -5),  "[WEST]" = list( 2, -5)),
		BP_L_HAND          = list("[NORTH]" = list( 3, -3), "[EAST]" = list( 1, -3), "[SOUTH]" = list(-3, -3),  "[WEST]" = list(-5, -3)),
		BP_R_HAND          = list("[NORTH]" = list(-3, -3), "[EAST]" = list( 5, -3), "[SOUTH]" = list( 3, -3),  "[WEST]" = list(-1, -3)),
		slot_head_str      = list("[NORTH]" = list( 0, -5), "[EAST]" = list( 1, -5), "[SOUTH]" = list( 0, -5),  "[WEST]" = list(-1, -5)),
		slot_wear_mask_str = list("[NORTH]" = list( 0, -6), "[EAST]" = list( 2, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list(-2, -6)),
		slot_glasses_str   = list("[NORTH]" = list( 0, -6), "[EAST]" = list( 1, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list(-1, -6)),
		slot_back_str      = list("[NORTH]" = list( 0, -6), "[EAST]" = list( 3, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list(-3, -6)),
		slot_w_uniform_str = list("[NORTH]" = list( 0, -6), "[EAST]" = list(-1, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list( 1, -6)),
		slot_wear_id_str   = list("[NORTH]" = list( 0, -6), "[EAST]" = list(-1, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list( 1, -6)),
		slot_wear_suit_str = list("[NORTH]" = list( 0, -6), "[EAST]" = list(-1, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list( 1, -6)),
		slot_belt_str      = list("[NORTH]" = list( 0, -6), "[EAST]" = list(-1, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list( 1, -6))
	)
	. = ..()

/obj/item/organ/external/tail/avian/get_tail()
	if(istype(bodytype, /decl/bodytype/avian))
		var/decl/bodytype/avian/bird_bod = bodytype
		return bird_bod.tail

/obj/item/organ/external/tail/avian/get_tail_icon()
	if(istype(bodytype, /decl/bodytype/avian))
		var/decl/bodytype/avian/bird_bod = bodytype
		return bird_bod.tail_icon

/obj/item/organ/external/tail/avian/get_tail_states()
	if(istype(bodytype, /decl/bodytype/avian))
		var/decl/bodytype/avian/bird_bod = bodytype
		return bird_bod.tail_states

/obj/item/organ/external/tail/avian/get_tail_blend()
	if(istype(bodytype, /decl/bodytype/avian))
		var/decl/bodytype/avian/bird_bod = bodytype
		return bird_bod.tail_blend

/obj/item/organ/external/tail/avian/get_tail_hair()
	if(istype(bodytype, /decl/bodytype/avian))
		var/decl/bodytype/avian/bird_bod = bodytype
		return bird_bod.tail_hair

/obj/item/organ/external/tail/avian/get_tail_hair_blend()
	if(istype(bodytype, /decl/bodytype/avian))
		var/decl/bodytype/avian/bird_bod = bodytype
		return bird_bod.tail_hair_blend
