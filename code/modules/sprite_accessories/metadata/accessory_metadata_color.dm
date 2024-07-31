/decl/sprite_accessory_metadata/color
	name = "Color"
	default_value = COLOR_BLACK
	uid = "sa_metadata_color"

/decl/sprite_accessory_metadata/color/validate_data(value)
	return istext(value) && (length(value) == 7 || length(value) == 9)

/decl/sprite_accessory_metadata/color/get_metadata_options_string(datum/preferences/pref, decl/sprite_accessory_category/accessory_category_decl, decl/sprite_accessory/accessory_decl, value)
	if(!value || !validate(value))
		value = default_value
	return "[COLORED_SQUARE(value)] <a href='byond://?src=\ref[pref];acc_cat_decl=\ref[accessory_category_decl];acc_decl=\ref[accessory_decl];acc_metadata=\ref[src]'>Change</a>"

/decl/sprite_accessory_metadata/color/get_new_value_for(mob/user, decl/sprite_accessory/accessory_decl, current_value)
	return input(user, "Choose a [lowertext(name)] for your [accessory_decl.name]: ", CHARACTER_PREFERENCE_INPUT_TITLE, current_value) as color|null

/decl/sprite_accessory_metadata/color/alt
	name = "Secondary Color"
	uid = "sa_metadata_color_alt"
