/decl/damage_handler/brute
	name                      = "brute"
	blocked_by_ablative       = TRUE
	can_ignite_reagents       = TRUE // Why?
	usable_with_backstab      = TRUE
	causes_limb_damage        = TRUE
	projectile_damage_divisor = 2
	barrier_damage_multiplier = 0.5
	category_type             = /decl/damage_handler/brute

/decl/damage_handler/brute/get_armor_key(var/damage_flags)
	if(damage_flags & DAM_BULLET)
		return ARMOR_BULLET
	if(damage_flags & DAM_EXPLODE)
		return ARMOR_BOMB
	return ARMOR_MELEE
