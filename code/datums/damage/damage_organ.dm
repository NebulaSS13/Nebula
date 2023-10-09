/decl/damage_handler/organ
	name                 = "organ"
	usable_with_backstab = TRUE
	category_type        = /decl/damage_handler/organ


/decl/damage_handler/organ/get_armor_key(var/damage_flags)
	if(damage_flags & DAM_BIO)
		return ARMOR_BIO
	// Otherwise just not blocked by default.
	return null
