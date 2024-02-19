/atom/proc/take_damage(damage, damage_type = BRUTE, def_zone, damage_flags = 0, used_weapon, armor_pen, silent = FALSE, override_droplimb, skip_update_health = FALSE)
	return FALSE

/atom/proc/heal_damage(var/damage, var/damage_type = BRUTE, var/def_zone = null, var/damage_flags = 0, skip_update_health = FALSE)
	return take_damage(-(damage), damage_type, def_zone, damage_flags, skip_update_health = skip_update_health)
