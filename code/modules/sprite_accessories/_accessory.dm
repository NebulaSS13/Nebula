/*

	Hello and welcome to sprite accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl

	Notice: This all gets automatically compiled in a list via the decl rfepository,
	so you do not have to add sprite accessories manually to any lists etc. Just add
	in new hair types and the game will naturally adapt.

	Changing icon states, icon files and names should not represent any risks to
	existing savefiles, but please do not change decl uids unless you are very sure
	you know what you're doing and don't mind potentially causing people's savefiles
	to load the default values for the marking category in question.
*/

/decl/sprite_accessory
	abstract_type = /decl/sprite_accessory
	decl_flags = DECL_FLAG_MANDATORY_UID
	/// The preview name of the accessory
	var/name
	/// the icon file the accessory is located in
	var/icon
	/// the icon_state of the accessory
	var/icon_state
	/// Restricted to specific bodytypes. null matches any
	var/list/decl/bodytype/bodytypes_allowed
	/// Restricted from specific bodytypes. null matches none
	var/list/decl/bodytype/bodytypes_denied
	/// Restrict some styles to specific root species names
	var/list/species_allowed = list(SPECIES_HUMAN)
	/// Restrict some styles to specific species names, irrespective of root species name
	var/list/subspecies_allowed
	/// Restrict some styles to specific bodytype flags.
	var/body_flags_allowed
	/// Restrict some styles to specific bodytype flags.
	var/body_flags_denied
	/// Restricts some styles to specific bodytype categories
	var/list/bodytype_categories_allowed
	/// Restricts some styles to specific bodytype categories
	var/list/bodytype_categories_denied
	/// Slot to check equipment for when hiding this accessory.
	var/hidden_by_gear_slot
	/// Flag to check equipment for when hiding this accessory.
	var/hidden_by_gear_flag
	/// Various flags controlling some checks and behavior.
	var/accessory_flags = 0
	/// Flags to check when applying this accessory to the mob.
	var/requires_appearance_flags = 0
	/// Icon cache for various icon generation steps.
	var/list/cached_icons = list()
	/// Whether or not this overlay should be trimmed to fit the base bodypart icon.
	var/mask_to_bodypart = FALSE
	/// What blend mode to use when colourizing this accessory.
	var/color_blend = ICON_ADD
	/// What blend mode to use when applying this accessory to the compiled organ.
	var/layer_blend = ICON_OVERLAY
	/// What bodypart tags does this marking apply to?
	var/list/body_parts
	/// Set to a layer integer to apply this as an overlay over the top of hair and such.
	var/sprite_overlay_layer
	/// A list of sprite accessory types that are disallowed by this one being included.
	var/list/disallows_accessories
	/// Whether or not this accessory is transferred via DNA (ie. not a scar or tattoo)
	var/is_heritable = FALSE
	/// What category does this accessory fall under?
	var/accessory_category
	/// Whether or not this accessory should be drawn on the mob at all.
	var/draw_accessory = TRUE
	/// Bitflags indicating what grooming tools work on this accessory.
	var/grooming_flags = GROOMABLE_NONE
	/// A list of metadata types for customisation of this accessory.
	var/list/accessory_metadata_types
	/// A value to check whitelists for.
	var/is_whitelisted

/decl/sprite_accessory/Initialize()
	. = ..()
	if(!isnull(color_blend))
		LAZYDISTINCTADD(accessory_metadata_types, /decl/sprite_accessory_metadata/color)

/decl/sprite_accessory/proc/refresh_mob(var/mob/living/subject)
	return

/decl/sprite_accessory/proc/accessory_is_available(var/mob/owner, var/decl/species/species, var/decl/bodytype/bodytype)
	if(species)
		var/species_is_permitted = TRUE
		if(species_allowed)
			species_is_permitted = (species.get_root_species_name(owner) in species_allowed)
		if(subspecies_allowed)
			species_is_permitted = (species.name in subspecies_allowed)
		if(!species_is_permitted)
			return FALSE
	if(bodytype)
		if(LAZYLEN(bodytypes_allowed) && !(bodytype.type in bodytypes_allowed))
			return FALSE
		if(LAZYISIN(bodytypes_denied, bodytype.type))
			return FALSE
		if(!isnull(bodytype_categories_allowed) && !(bodytype.bodytype_category in bodytype_categories_allowed))
			return FALSE
		if(!isnull(bodytype_categories_denied) && (bodytype.bodytype_category in bodytype_categories_denied))
			return FALSE
		if(!isnull(body_flags_allowed) && !(body_flags_allowed & bodytype.bodytype_flag))
			return FALSE
		if(!isnull(body_flags_denied) && (body_flags_denied & bodytype.bodytype_flag))
			return FALSE
	if(requires_appearance_flags && !(bodytype.appearance_flags & requires_appearance_flags))
		return FALSE
	if(is_whitelisted && usr?.ckey && !is_admin(usr))
		return is_alien_whitelisted(usr, is_whitelisted)
	return TRUE

/decl/sprite_accessory/validate()
	. = ..()
	if(!ispath(accessory_category, /decl/sprite_accessory_category))
		. += "invalid sprite accessory category: [accessory_category || "null"]"
	if(!icon)
		. += "missing icon"
	else
		if(!icon_state)
			. += "missing icon_state"
		else if(!check_state_in_icon(icon_state, icon))
			. += "missing icon state \"[icon_state]\" in [icon]"

/decl/sprite_accessory/proc/get_hidden_substitute()
	return

/decl/sprite_accessory/proc/is_hidden(var/obj/item/organ/external/organ)
	if(!organ?.owner)
		return FALSE
	if(hidden_by_gear_slot)
		if(islist(hidden_by_gear_slot))
			for(var/hiding_slot in hidden_by_gear_slot)
				var/obj/item/hiding = organ.owner.get_equipped_item(hiding_slot)
				if(hiding && (hiding.flags_inv & hidden_by_gear_flag))
					return TRUE
		else
			var/obj/item/hiding = organ.owner.get_equipped_item(hidden_by_gear_slot)
			return hiding && (hiding.flags_inv & hidden_by_gear_flag)
	return FALSE

/decl/sprite_accessory/proc/get_accessory_icon(var/obj/item/organ/external/organ)
	return icon

/decl/sprite_accessory/proc/can_be_groomed_with(obj/item/organ/external/organ, obj/item/grooming/tool)
	if(istype(tool) && (grooming_flags & tool.grooming_flags))
		return GROOMING_RESULT_SUCCESS
	return GROOMING_RESULT_FAILED

/decl/sprite_accessory/proc/get_grooming_descriptor(grooming_result, obj/item/organ/external/organ, obj/item/grooming/tool)
	return "mystery grooming target"

/decl/sprite_accessory/proc/get_default_accessory_metadata()
	. = list()
	for(var/metadata_type in accessory_metadata_types)
		var/decl/sprite_accessory_metadata/metadata_decl = GET_DECL(metadata_type)
		.[metadata_type] = metadata_decl.default_value

/decl/sprite_accessory/proc/validate_cached_icon_metadata(list/metadata)
	LAZYINITLIST(metadata)
	for(var/metadata_type in accessory_metadata_types)
		var/decl/sprite_accessory_metadata/metadata_decl = GET_DECL(metadata_type)
		if(!(metadata_type in metadata) || !metadata_decl.validate_data(metadata[metadata_type]))
			metadata[metadata_type] = metadata_decl.default_value
	return metadata

/decl/sprite_accessory/proc/get_cached_accessory_icon_key(var/obj/item/organ/external/organ, var/list/metadata)
	. = list(organ.bodytype, organ.icon_state)
	for(var/metadata_type in accessory_metadata_types)
		. += LAZYACCESS(metadata, metadata_type) || "null"
	return JOINTEXT(.)

/decl/sprite_accessory/proc/get_cached_accessory_icon(var/obj/item/organ/external/organ, var/list/metadata)

	if(!icon_state || !istype(organ))
		return null

	metadata = validate_cached_icon_metadata(metadata)
	if(!islist(metadata))
		return null

	var/cache_key = get_cached_accessory_icon_key(organ, metadata)
	var/icon/accessory_icon = cached_icons[cache_key]
	if(!accessory_icon)

		// make a new one to avoid mutating the base
		var/use_icon = get_accessory_icon(organ)
		if(!use_icon)
			return

		var/use_state = icon_state
		var/marking_modifier = organ.owner?.get_overlay_state_modifier()
		if(marking_modifier)
			use_state = "[use_state][marking_modifier]"

		if(!check_state_in_icon(use_state, use_icon))
			return

		accessory_icon = icon(use_icon, use_state)

		// Inner overlay and color.
		var/inner_color = LAZYACCESS(metadata, SAM_COLOR_INNER)

		// Base icon and color.
		if(!isnull(color_blend))
			var/decl/sprite_accessory_metadata/gradient/gradient_metadata = GET_DECL(SAM_GRADIENT)
			var/icon/gradient_icon = LAZYACCESS(metadata, SAM_GRADIENT)
			if(istext(gradient_icon) && (gradient_metadata.validate_data(gradient_icon)))
				gradient_icon = icon(gradient_metadata.icon, gradient_icon)
			else
				gradient_icon = null
			if(gradient_icon)
				gradient_icon.Blend(accessory_icon, ICON_AND)
				if(!isnull(inner_color))
					gradient_icon.Blend(inner_color, color_blend)
			var/color = LAZYACCESS(metadata, SAM_COLOR)
			if(!isnull(color))
				accessory_icon.Blend(color, color_blend)
			if(gradient_icon)
				accessory_icon.Blend(gradient_icon, ICON_OVERLAY)

		if(!isnull(inner_color))
			var/inner_state = "[use_state]_inner"
			if(check_state_in_icon(inner_state, use_icon))
				var/icon/inner_icon = icon(use_icon, inner_state)
				if(!isnull(color_blend))
					inner_icon.Blend(inner_color, color_blend)
				accessory_icon.Blend(inner_icon, ICON_OVERLAY)

		// Clip the icon if needed.
		if(mask_to_bodypart)
			accessory_icon.Blend(get_limb_mask_for(organ), ICON_MULTIPLY)

		// Cache it for next time!
		cached_icons[cache_key] = accessory_icon

	return accessory_icon

/decl/sprite_accessory/proc/update_metadata(list/new_metadata, list/old_metadata)
	if(!islist(new_metadata) && !islist(old_metadata))
		return get_default_accessory_metadata()
	if(!islist(new_metadata))
		new_metadata = get_default_accessory_metadata()
	if(!islist(old_metadata))
		old_metadata = get_default_accessory_metadata()
	for(var/metadata_type in old_metadata)
		if(!(metadata_type in new_metadata))
			new_metadata[metadata_type] = old_metadata[metadata_type]
	for(var/metadata_type in new_metadata)
		if(!(metadata_type in old_metadata))
			new_metadata -= metadata_type
	return new_metadata

/decl/sprite_accessory/proc/get_random_metadata()
	return list(SAM_COLOR = get_random_colour())

/decl/sprite_accessory_category/proc/prepare_character(mob/living/character, list/accessories)
	return

