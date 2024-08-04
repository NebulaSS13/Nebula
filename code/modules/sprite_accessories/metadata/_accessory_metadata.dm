/decl/sprite_accessory_metadata
	abstract_type = /decl/sprite_accessory_metadata
	decl_flags = DECL_FLAG_MANDATORY_UID
	var/name
	var/default_value

/decl/sprite_accessory_metadata/proc/get_new_value_for(mob/user, decl/sprite_accessory/accessory_decl, current_value)
	return

/decl/sprite_accessory_metadata/proc/validate_data(value)
	return FALSE

/decl/sprite_accessory_metadata/proc/sanitize_data(value)
	return value || default_value

/decl/sprite_accessory_metadata/proc/get_metadata_options_string(datum/preferences/pref, decl/sprite_accessory_category/accessory_category_decl, decl/sprite_accessory/accessory_decl, value)
	return
