/obj/item/organ/external/tail

	organ_tag = BP_TAIL
	name = "tail"
	max_damage = 20
	min_broken_damage = 10
	w_class = ITEM_SIZE_NORMAL
	body_part = SLOT_TAIL
	parent_organ = BP_GROIN
	joint = "tail"
	amputation_point = "tail"
	artery_name = "vein"
	arterial_bleed_severity = 0.3
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_DISLOCATE
	skip_body_icon_draw = TRUE
	force_limb_dir = WEST

	/// Name of tail state in species effects icon file. Used as a prefix for animated states.
	var/tail_state = BP_TAIL
	/// Icon file to use for tail states (including animations)
	var/tail_icon  = 'icons/mob/human_races/species/default_tail.dmi'
	/// Blend mode for overlaying colour on the tail.
	var/tail_blend = ICON_ADD
	/// State modifier for hair overlays.
	var/tail_hair
	/// Blend mode for hair overlays.
	var/tail_hair_blend = ICON_ADD
	/// How many random tail states are available for animations.
	var/tail_animation_states = 0
	/// If we have an animation playing, it will be this state.
	var/tail_animation_state

/obj/item/organ/external/tail/skeletonize()
	. = ..()
	tail_animation_state = null
	owner?.update_tail_showing()

/obj/item/organ/external/tail/do_uninstall(in_place, detach, ignore_children, update_icon)
	var/mob/living/human/H = owner
	if(!(. = ..()))
		return

	// Set our onmob appearance.
	var/decl/sprite_accessory/tail/tail_data = get_sprite_accessory_by_category(SAC_TAIL)
	if(tail_data?.draw_accessory)
		icon = tail_data.icon
		icon_state = tail_data.icon_state

	if(update_icon && istype(H) && !QDELETED(H) && H != owner)
		H.update_tail_showing(FALSE)

/obj/item/organ/external/tail/do_install(mob/living/human/target, affected, in_place, update_icon, detached)
	. = ..()
	if(update_icon && istype(owner) && !QDELETED(owner))
		owner.update_tail_showing(FALSE)

/obj/item/organ/external/tail/proc/get_tail()
	var/modifier = owner?.get_overlay_state_modifier()
	. = modifier ? "[get_tail_state()][modifier]" : get_tail_state()
	if(tail_animation_state && tail_animation_states)
		. = "[.][tail_animation_state]"

/obj/item/organ/external/tail/proc/get_tail_icon()
	var/decl/sprite_accessory/tail/tail_data = get_sprite_accessory_by_category(SAC_TAIL)
	return tail_data?.draw_accessory ? tail_data.icon : tail_icon

/obj/item/organ/external/tail/proc/get_tail_state()
	var/decl/sprite_accessory/tail/tail_data = get_sprite_accessory_by_category(SAC_TAIL)
	return tail_data?.draw_accessory ? tail_data.icon_state : tail_state

/obj/item/organ/external/tail/proc/get_tail_animation_states()
	var/decl/sprite_accessory/tail/tail_data = get_sprite_accessory_by_category(SAC_TAIL)
	return tail_data?.draw_accessory ? tail_data.icon_animation_states : tail_animation_states

/obj/item/organ/external/tail/proc/get_tail_blend()
	var/decl/sprite_accessory/tail/tail_data = get_sprite_accessory_by_category(SAC_TAIL)
	return tail_data?.draw_accessory ? tail_data.color_blend : tail_blend

/obj/item/organ/external/tail/proc/get_tail_hair()
	var/decl/sprite_accessory/tail/tail_data = get_sprite_accessory_by_category(SAC_TAIL)
	return tail_data?.draw_accessory ? tail_data.hair_state : tail_hair

/obj/item/organ/external/tail/proc/get_tail_hair_blend()
	var/decl/sprite_accessory/tail/tail_data = get_sprite_accessory_by_category(SAC_TAIL)
	return tail_data?.draw_accessory ? tail_data.hair_blend : tail_hair_blend

/obj/item/organ/external/tail/proc/get_tail_metadata()
	var/decl/sprite_accessory/tail/tail_data = get_sprite_accessory_by_category(SAC_TAIL)
	if(tail_data?.draw_accessory)
		return get_sprite_accessory_metadata(tail_data.type)
	if(owner && (bodytype?.appearance_flags & HAS_SKIN_COLOR))
		return list(SAM_COLOR = owner.get_skin_colour())
	return list(SAM_COLOR = COLOR_WHITE)
