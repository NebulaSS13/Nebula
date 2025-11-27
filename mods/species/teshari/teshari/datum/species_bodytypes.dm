/decl/bodytype/teshari
	name                 = "raptor"
	bodytype_category    = BODYTYPE_AVIAN
	icon_base            = 'mods/species/teshari/icons/body_raptor.dmi'
	blood_overlays       = 'mods/species/teshari/icons/blood_avian.dmi'
	skeletal_icon        = 'mods/species/teshari/icons/skeleton.dmi'
	limb_blend           = ICON_MULTIPLY
	bodytype_flag        = BODY_EQUIP_FLAG_AVIAN
	eye_icon             = 'mods/species/teshari/icons/eyes.dmi'
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
		BP_TAIL   = /obj/item/organ/external/tail/teshari
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
	age_descriptor          = /datum/appearance_descriptor/age/teshari
	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
	)
	uid = "bodytype_teshari"

	var/tail            = "tail_raptor"
	var/tail_icon       = 'mods/species/teshari/icons/tail.dmi'
	var/tail_blend      = ICON_MULTIPLY
	var/tail_hair       = "over"
	var/tail_hair_blend = ICON_MULTIPLY
	var/tail_states

/decl/bodytype/teshari/additive
	name                 = "raptor, additive"
	icon_base            = 'mods/species/teshari/icons/body_raptor_add.dmi'
	tail                 = "tail_raptor_add"
	tail_hair_blend      = ICON_ADD
	uid                  = "bodytype_teshari_additive"

/decl/bodytype/teshari/Initialize()
	// Avoiding cross-reference loop on compile.
	default_sprite_accessories = list(
		SAC_HAIR     = list(/decl/sprite_accessory/hair/teshari = list(SAM_COLOR = base_color))
	)
	_equip_adjust = list(
		(slot_l_ear_str)     = list("[NORTH]" = list( 1, -5), "[EAST]" = list(-2, -5), "[SOUTH]" = list(-1, -5),  "[WEST]" = list( 0, -5)),
		(slot_r_ear_str)     = list("[NORTH]" = list( 1, -5), "[EAST]" = list( 0, -5), "[SOUTH]" = list(-1, -5),  "[WEST]" = list( 2, -5)),
		(BP_L_HAND)          = list("[NORTH]" = list( 3, -3), "[EAST]" = list( 1, -3), "[SOUTH]" = list(-3, -3),  "[WEST]" = list(-5, -3)),
		(BP_R_HAND)          = list("[NORTH]" = list(-3, -3), "[EAST]" = list( 5, -3), "[SOUTH]" = list( 3, -3),  "[WEST]" = list(-1, -3)),
		(slot_head_str)      = list("[NORTH]" = list( 0, -5), "[EAST]" = list( 1, -5), "[SOUTH]" = list( 0, -5),  "[WEST]" = list(-1, -5)),
		(slot_wear_mask_str) = list("[NORTH]" = list( 0, -6), "[EAST]" = list( 2, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list(-2, -6)),
		(slot_glasses_str)   = list("[NORTH]" = list( 0, -6), "[EAST]" = list( 1, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list(-1, -6)),
		(slot_back_str)      = list("[NORTH]" = list( 0, -6), "[EAST]" = list( 3, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list(-3, -6)),
		(slot_w_uniform_str) = list("[NORTH]" = list( 0, -6), "[EAST]" = list(-1, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list( 1, -6)),
		(slot_wear_id_str)   = list("[NORTH]" = list( 0, -6), "[EAST]" = list(-1, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list( 1, -6)),
		(slot_wear_suit_str) = list("[NORTH]" = list( 0, -6), "[EAST]" = list(-1, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list( 1, -6)),
		(slot_belt_str)      = list("[NORTH]" = list( 0, -6), "[EAST]" = list(-1, -6), "[SOUTH]" = list( 0, -6),  "[WEST]" = list( 1, -6))
	)
	. = ..()

/obj/item/organ/external/tail/teshari/get_tail()
	if(istype(bodytype, /decl/bodytype/teshari))
		var/decl/bodytype/teshari/bird_bod = bodytype
		return bird_bod.tail

/obj/item/organ/external/tail/teshari/get_tail_icon()
	if(istype(bodytype, /decl/bodytype/teshari))
		var/decl/bodytype/teshari/bird_bod = bodytype
		return bird_bod.tail_icon

/obj/item/organ/external/tail/teshari/get_tail_animation_states()
	if(istype(bodytype, /decl/bodytype/teshari))
		var/decl/bodytype/teshari/bird_bod = bodytype
		return bird_bod.tail_states

/obj/item/organ/external/tail/teshari/get_tail_blend()
	if(istype(bodytype, /decl/bodytype/teshari))
		var/decl/bodytype/teshari/bird_bod = bodytype
		return bird_bod.tail_blend

/obj/item/organ/external/tail/teshari/get_tail_hair()
	if(istype(bodytype, /decl/bodytype/teshari))
		var/decl/bodytype/teshari/bird_bod = bodytype
		return bird_bod.tail_hair

/obj/item/organ/external/tail/teshari/get_tail_hair_blend()
	if(istype(bodytype, /decl/bodytype/teshari))
		var/decl/bodytype/teshari/bird_bod = bodytype
		return bird_bod.tail_hair_blend
