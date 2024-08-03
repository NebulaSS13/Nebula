/decl/sprite_accessory_category/hair
	name                     = "Hair"
	base_accessory_type      = /decl/sprite_accessory/hair
	default_accessory        = /decl/sprite_accessory/hair/bald
	always_apply_defaults    = TRUE
	uid                      = "acc_cat_hair"

/decl/sprite_accessory/hair
	abstract_type            = /decl/sprite_accessory/hair
	icon                     = 'icons/mob/human_races/species/human/hair.dmi'
	hidden_by_gear_slot      = slot_head_str
	hidden_by_gear_flag      = BLOCK_HEAD_HAIR
	body_parts               = list(BP_HEAD)
	sprite_overlay_layer     = FLOAT_LAYER
	is_heritable             = TRUE
	accessory_category       = SAC_HAIR
	accessory_flags          = HAIR_LOSS_VULNERABLE
	grooming_flags           = GROOMABLE_BRUSH | GROOMABLE_COMB
	accessory_metadata_types = list(SAM_COLOR, SAM_COLOR_INNER, SAM_GRADIENT)

/decl/sprite_accessory/hair/get_grooming_descriptor(grooming_result, obj/item/organ/external/organ, obj/item/grooming/tool)
	return grooming_result == GROOMING_RESULT_PARTIAL ? "scalp" : "hair"

/decl/sprite_accessory/hair/can_be_groomed_with(obj/item/organ/external/organ, obj/item/grooming/tool)
	. = ..()
	if(. == GROOMING_RESULT_SUCCESS && (accessory_flags & HAIR_VERY_SHORT))
		return GROOMING_RESULT_PARTIAL

/decl/sprite_accessory/hair/get_hidden_substitute()
	if(accessory_flags & HAIR_VERY_SHORT)
		return src
	return GET_DECL(/decl/sprite_accessory/hair/short)

/decl/sprite_accessory/hair/refresh_mob(var/mob/living/subject)
	if(istype(subject))
		subject.update_hair()

/decl/sprite_accessory/hair/bald
	name                        = "Bald"
	icon_state                  = "bald"
	uid                         = "acc_hair_bald"
	accessory_flags             = HAIR_VERY_SHORT | HAIR_BALD
	bodytypes_allowed           = null
	bodytypes_denied            = null
	species_allowed             = null
	subspecies_allowed          = null
	bodytype_categories_allowed = null
	bodytype_categories_denied  = null
	body_flags_allowed          = null
	body_flags_denied           = null
	draw_accessory              = FALSE
	grooming_flags              = null
