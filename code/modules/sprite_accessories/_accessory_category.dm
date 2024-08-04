/decl/sprite_accessory_category
	decl_flags    = DECL_FLAG_MANDATORY_UID
	abstract_type = /decl/sprite_accessory_category
	/// A name to display in preferences.
	var/name
	/// A base abstract accessory type for this category.
	var/base_accessory_type
	/// A maximum number of selections. Ignored if null.
	var/max_selections
	/// A default always-available type used as a fallback.
	var/default_accessory
	/// Set to FALSE for categories where multiple selection is allowed (markings)
	var/single_selection        = TRUE
	/// Set to TRUE to apply these markings as defaults when bodytype is set.
	var/always_apply_defaults   = FALSE
	/// Whether the accessories in this category are cleared when prefs are applied.
	var/clear_in_pref_apply     = FALSE

/decl/sprite_accessory_category/validate()
	. = ..()
	if(!name)
		. += "no name set"
	if(!ispath(base_accessory_type, /decl/sprite_accessory))
		. += "invalid base accessory type: [base_accessory_type || "null"]"
	if(single_selection && !default_accessory)
		. += "single selection set but no default accessory set"
