/decl/sprite_accessory_category/tail
	name                 = "Tail"
	base_accessory_type  = /decl/sprite_accessory/tail
	default_accessory    = /decl/sprite_accessory/tail/none
	uid                  = "acc_cat_tail"

/decl/sprite_accessory_category/tail/prepare_character(mob/living/character, list/accessories)
	if(!istype(character) || !length(accessories))
		return
	// Give us a tail if we need one.
	var/decl/sprite_accessory/tail_data = GET_DECL(accessories[1])
	if(tail_data?.draw_accessory && !character.get_organ(BP_TAIL))
		character.add_organ(new /obj/item/organ/external/tail(null, character.get_mob_snapshot()), null, TRUE, FALSE, FALSE, TRUE)

/decl/sprite_accessory/tail
	abstract_type = /decl/sprite_accessory/tail
	hidden_by_gear_slot  = list(slot_w_uniform_str, slot_wear_suit_str)
	hidden_by_gear_flag  = HIDETAIL
	body_parts           = list(BP_TAIL)
	sprite_overlay_layer = FLOAT_LAYER-1
	is_heritable         = TRUE
	icon_state           = "tail"
	icon                 = 'icons/mob/human_races/species/default_tail.dmi'
	accessory_category   = SAC_TAIL
	abstract_type        = /decl/sprite_accessory/tail
	color_blend          = ICON_MULTIPLY

	var/icon_animation_states
	var/hair_state
	var/hair_blend = ICON_ADD

/decl/sprite_accessory/tail/none
	name                        = "Default Tail"
	icon_state                  = "none"
	uid                         = "acc_tail_none"
	bodytypes_allowed           = null
	bodytypes_denied            = null
	species_allowed             = null
	subspecies_allowed          = null
	bodytype_categories_allowed = null
	bodytype_categories_denied  = null
	body_flags_allowed          = null
	body_flags_denied           = null
	grooming_flags              = null
	draw_accessory              = FALSE

/decl/sprite_accessory/tail/none/hide_tail
	name           = "Hide Species Tail"
	uid            = "acc_tail_hidden"
	draw_accessory = TRUE

/decl/sprite_accessory/tail/none/hide_tail/accessory_is_available(mob/owner, decl/species/species, decl/bodytype/bodytype)
	. = ..() && (BP_TAIL in bodytype.has_limbs)

/*
// Leaving these in for future reference.
/decl/sprite_accessory/tail/debug
	name                     = "Debug Tail"
	uid                      = "acc_tail_debug"
	is_whitelisted           = "DEBUG"

/decl/sprite_accessory/tail/debug_inner
	name                     = "Debug Two-Tone Tail"
	uid                      = "acc_tail_debug2"
	is_whitelisted           = "DEBUG"
	accessory_metadata_types = list(SAM_COLOR, SAM_COLOR_INNER)
*/
