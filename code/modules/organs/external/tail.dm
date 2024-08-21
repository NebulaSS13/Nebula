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
	/// Are we actively hiding our tail currently?
	var/tail_hidden = FALSE

/mob/living/proc/hide_tail()
	set name     = "Hide Tail"
	set category = "IC"
	set src      = usr

	if(incapacitated())
		to_chat(usr, SPAN_WARNING("You are in no state to do that."))
		return

	var/obj/item/organ/external/tail/tail = get_organ(BP_TAIL)
	if(!istype(tail))
		to_chat(usr, SPAN_WARNING("You don't have a tail!"))
		verbs -= /mob/living/proc/hide_tail
		return

	if(!tail.tail_hidden && !tail.can_be_hidden())
		to_chat(usr, SPAN_WARNING("You are not wearing clothing in which your tail can be hidden."))
		return

	tail.tail_hidden = !tail.tail_hidden
	if(usr == src)
		var/decl/pronouns/pronouns = get_pronouns()
		visible_message(SPAN_NOTICE("\The [src] [tail.tail_hidden ? "conceals" : "reveals"] [pronouns.his] [tail.name]."))
	else
		visible_message(SPAN_NOTICE("\The [usr] [tail.tail_hidden ? "conceals" : "reveals"] \the [src]'s [tail.name]."))
	update_tail_showing()

/obj/item/organ/external/tail/proc/can_be_hidden()
	if(owner)
		var/covered_parts = owner.get_covered_body_parts()
		return (covered_parts & (SLOT_LEGS|SLOT_LOWER_BODY)) == (SLOT_LEGS|SLOT_LOWER_BODY)
	return FALSE

/obj/item/organ/external/tail/skeletonize()
	. = ..()
	tail_animation_state = null
	owner?.update_tail_showing()

/obj/item/organ/external/tail/proc/get_accessory_data()
	if(tail_hidden && can_be_hidden())
		return GET_DECL(/decl/sprite_accessory/tail/none/hide_tail)
	return get_sprite_accessory_by_category(SAC_TAIL)

/obj/item/organ/external/tail/do_uninstall(in_place, detach, ignore_children, update_icon)
	var/mob/living/prior_owner = owner
	if(!(. = ..()))
		return

	// Set our onmob appearance.
	var/decl/sprite_accessory/tail/tail_data = get_accessory_data()
	if(tail_data?.draw_accessory)
		icon = tail_data.icon
		icon_state = tail_data.icon_state

	if(update_icon && istype(prior_owner) && !QDELETED(prior_owner) && prior_owner != owner)
		prior_owner.update_tail_showing(FALSE)

	if(istype(prior_owner) && !prior_owner.get_organ(BP_TAIL))
		prior_owner.verbs -= /mob/living/proc/hide_tail

/obj/item/organ/external/tail/do_install(mob/living/human/target, affected, in_place, update_icon, detached)
	. = ..()
	if(istype(owner) && !QDELETED(owner))
		owner.verbs |= /mob/living/proc/hide_tail
		if(update_icon)
			owner.update_tail_showing(FALSE)

/obj/item/organ/external/tail/proc/get_tail()
	var/modifier = owner?.get_overlay_state_modifier()
	. = modifier ? "[get_tail_state()][modifier]" : get_tail_state()
	if(tail_animation_state && tail_animation_states)
		. = "[.][tail_animation_state]"

/obj/item/organ/external/tail/proc/get_tail_icon()
	var/decl/sprite_accessory/tail/tail_data = get_accessory_data()
	return tail_data?.draw_accessory ? tail_data.icon : tail_icon

/obj/item/organ/external/tail/proc/get_tail_state()
	var/decl/sprite_accessory/tail/tail_data = get_accessory_data()
	return tail_data?.draw_accessory ? tail_data.icon_state : tail_state

/obj/item/organ/external/tail/proc/get_tail_animation_states()
	var/decl/sprite_accessory/tail/tail_data = get_accessory_data()
	return tail_data?.draw_accessory ? tail_data.icon_animation_states : tail_animation_states

/obj/item/organ/external/tail/proc/get_tail_blend()
	var/decl/sprite_accessory/tail/tail_data = get_accessory_data()
	return tail_data?.draw_accessory ? tail_data.color_blend : tail_blend

/obj/item/organ/external/tail/proc/get_tail_hair()
	var/decl/sprite_accessory/tail/tail_data = get_accessory_data()
	return tail_data?.draw_accessory ? tail_data.hair_state : tail_hair

/obj/item/organ/external/tail/proc/get_tail_hair_blend()
	var/decl/sprite_accessory/tail/tail_data = get_accessory_data()
	return tail_data?.draw_accessory ? tail_data.hair_blend : tail_hair_blend

/obj/item/organ/external/tail/proc/get_tail_metadata()
	var/decl/sprite_accessory/tail/tail_data = get_accessory_data()
	if(tail_data?.draw_accessory)
		return get_sprite_accessory_metadata(tail_data.type)
	if(owner && (bodytype?.appearance_flags & HAS_SKIN_COLOR))
		return list(SAM_COLOR = owner.get_skin_colour())
	return list(SAM_COLOR = COLOR_WHITE)
