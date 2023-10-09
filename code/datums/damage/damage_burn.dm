/decl/damage_handler/burn
	name                      = "burn"
	applies_to_machinery      = TRUE
	blocked_by_ablative       = TRUE
	can_ignite_reagents       = TRUE
	damage_verb               = "sizzles"
	usable_with_backstab      = TRUE
	causes_limb_damage        = TRUE
	projectile_damage_divisor = 1.5
	barrier_damage_multiplier = 0.75
	item_damage_flags         = DAM_LASER
	category_type             = /decl/damage_handler/burn

/decl/damage_handler/burn/get_armor_key(var/damage_flags)
	if(damage_flags & DAM_LASER)
		return ARMOR_LASER
	if(damage_flags & DAM_EXPLODE)
		return ARMOR_BOMB
	return ARMOR_ENERGY
