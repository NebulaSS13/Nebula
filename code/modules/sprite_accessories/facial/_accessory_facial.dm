/decl/sprite_accessory_category/facial_hair
	name                  = "Facial Hair"
	base_accessory_type   = /decl/sprite_accessory/facial_hair
	default_accessory     = /decl/sprite_accessory/facial_hair/shaved
	always_apply_defaults = TRUE
	uid                   = "acc_cat_facial_hair"

/decl/sprite_accessory/facial_hair
	abstract_type         = /decl/sprite_accessory/facial_hair
	icon                  = 'icons/mob/human_races/species/human/facial.dmi'
	hidden_by_gear_slot   = slot_head_str
	hidden_by_gear_flag   = BLOCK_HEAD_HAIR
	body_parts            = list(BP_HEAD)
	sprite_overlay_layer  = FLOAT_LAYER
	is_heritable          = TRUE
	accessory_category    = SAC_FACIAL_HAIR
	accessory_flags       = HAIR_LOSS_VULNERABLE
	grooming_flags        = GROOMABLE_BRUSH | GROOMABLE_COMB

/decl/sprite_accessory/facial_hair/get_grooming_descriptor(grooming_result, obj/item/organ/external/organ, obj/item/grooming/tool)
	return grooming_result == GROOMING_RESULT_PARTIAL ? "chin and cheeks" : "facial hair"

/decl/sprite_accessory/facial_hair/can_be_groomed_with(obj/item/organ/external/organ, obj/item/grooming/tool)
	. = ..()
	if(. == GROOMING_RESULT_SUCCESS && (accessory_flags & HAIR_VERY_SHORT))
		return GROOMING_RESULT_PARTIAL

/decl/sprite_accessory/facial_hair/get_hidden_substitute()
	return GET_DECL(/decl/sprite_accessory/facial_hair/shaved)

/decl/sprite_accessory/facial_hair/refresh_mob(var/mob/living/subject)
	if(istype(subject))
		subject.update_hair()

/decl/sprite_accessory/facial_hair/shaved
	name                        = "Shaved"
	icon_state                  = "bald"
	uid                         = "acc_fhair_shaved"
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
