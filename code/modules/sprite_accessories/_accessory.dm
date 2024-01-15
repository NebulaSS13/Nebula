/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl

	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

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
	/// Restricted to specific genders. null matches any
	var/required_gender
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
	/// Category type used for this accessory.
	var/accessory_category
	/// Slot to check equipment for when hiding this accessory.
	var/hidden_by_gear_slot
	/// Flag to check equipment for when hiding this accessory.
	var/hidden_by_gear_flag
	/// Whether or not the accessory can be affected by colouration
	var/do_colouration = TRUE
	/// Various flags controlling some checks and behavior.
	var/flags = 0
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
	/// Whether or not this marking draws over or under hair.
	var/draw_target = MARKING_TARGET_SKIN
	/// A list of sprite accessory types that are disallowed by this one being included.
	var/list/disallows_accessories

/decl/sprite_accessory/proc/accessory_is_available(var/mob/owner, var/decl/species/species, var/decl/bodytype/bodytype)
	if(!isnull(required_gender) && bodytype.associated_gender != required_gender)
		return FALSE
	if(species)
		var/species_is_permitted = TRUE
		if(species_allowed)
			species_is_permitted = (species.get_root_species_name(owner) in species_allowed)
		if(subspecies_allowed)
			species_is_permitted = (species.name in subspecies_allowed)
		if(!species_is_permitted)
			return FALSE
	if(bodytype)
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
	return TRUE

/decl/sprite_accessory/validate()
	. = ..()
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
		var/obj/item/hiding = organ.owner.get_equipped_item(hidden_by_gear_slot)
		if(!hiding)
			return FALSE
		return (hiding.flags_inv & hidden_by_gear_flag)
	return FALSE

/decl/sprite_accessory/proc/get_accessory_icon(var/obj/item/organ/external/organ)
	return icon

/decl/sprite_accessory/proc/get_cached_accessory_icon(var/obj/item/organ/external/organ, var/color = COLOR_WHITE)
	ASSERT(istext(color) && (length(color) == 7 || length(color) == 9))
	if(!icon_state)
		return null
	LAZYINITLIST(cached_icons[organ.bodytype])
	LAZYINITLIST(cached_icons[organ.bodytype][organ.organ_tag])
	var/icon/accessory_icon = cached_icons[organ.bodytype][organ.organ_tag][color]
	if(!accessory_icon)
		accessory_icon = icon(get_accessory_icon(organ), icon_state) // make a new one to avoid mutating the base
		if(!accessory_icon)
			cached_icons[organ.bodytype][organ.organ_tag][color] = null
			return null
		if(mask_to_bodypart)
			accessory_icon.Blend(get_limb_mask_for(organ.bodytype, organ.organ_tag), ICON_MULTIPLY)
		if(do_colouration && color)
			accessory_icon.Blend(color, color_blend)
		cached_icons[organ.bodytype][organ.organ_tag][color] = accessory_icon
	return accessory_icon
