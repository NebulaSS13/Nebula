/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl

	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

/decl/sprite_accessory
	abstract_type = /decl/sprite_accessory
	decl_flags = DECL_FLAG_MANDATORY_UID
	var/name                                       // The preview name of the accessory
	var/icon                                       // the icon file the accessory is located in
	var/icon_state                                 // the icon_state of the accessory
	var/required_gender = null                     // Restricted to specific genders. null matches any
	var/list/species_allowed = list(SPECIES_HUMAN) // Restrict some styles to specific root species names
	var/list/subspecies_allowed                    // Restrict some styles to specific species names, irrespective of root species name
	var/body_flags_allowed = null                  // Restrict some styles to specific bodytype flags
	var/body_flags_denied =  null                  // Restrict some styles to specific bodytype flags
	var/list/bodytype_categories_allowed = null    // Restricts some styles to specific bodytype categories
	var/list/bodytype_categories_denied = null     // Restricts some styles to specific bodytype categories

	var/do_colouration = 1                         // Whether or not the accessory can be affected by colouration
	var/blend = ICON_ADD
	var/flags = 0

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
	return TRUE

/decl/sprite_accessory/proc/get_validatable_icon_state()
	return icon_state

/decl/sprite_accessory/validate()
	. = ..()
	if(!icon)
		. += "missing icon"
	else
		var/actual_icon_state = get_validatable_icon_state()
		if(!actual_icon_state)
			. += "missing icon_state"
		else if(!check_state_in_icon(actual_icon_state, icon))
			. += "missing icon state \"[actual_icon_state]\" in [icon]"
