#define BASIC_ARMOUR_VALUES list(ARMOR_MELEE = ARMOR_MELEE_MAJOR, ARMOR_BULLET = ARMOR_BALLISTIC_RIFLE, ARMOR_LASER = ARMOR_LASER_HEAVY, ARMOR_ENERGY = ARMOR_ENERGY_STRONG, ARMOR_BOMB = ARMOR_BOMB_RESISTANT,ARMOR_RAD  = ARMOR_RAD_SHIELDED)

/decl/material/proc/generate_armor_values()
	if(is_brittle())
		armor_degradation_speed = 1
	else
		armor_degradation_speed = max(0.01, 0.5 * (200-integrity)/200)

	var/list/armor = BASIC_ARMOUR_VALUES
	for(var/val in list(ARMOR_MELEE, ARMOR_BOMB))
		armor[val] *= hardness / 100
	armor[ARMOR_BOMB] *= weight / MAT_VALUE_NORMAL
	armor[ARMOR_BULLET] *= (hardness / 100) ** 2
	if(is_brittle())
		armor[ARMOR_BULLET] *= 0.2
	armor[ARMOR_LASER] *= (reflectiveness / 100) ** 2
	armor[ARMOR_ENERGY] *= reflectiveness / 100
	armor[ARMOR_RAD] *= (weight / 100) ** 2

	//Sanitizing the list, rounding and discarding empty entries
	for(var/val in armor)
		armor[val] = round(armor[val], 3)
		if(armor[val] < 1)
			armor -= val

	basic_armor = armor

/decl/material/proc/get_armor(coef=1)
	if(!length(basic_armor))
		return list()
	var/list/armor = basic_armor.Copy()
	if(coef == 1)
		return armor
	for(var/val in armor)
		armor[val] = round(coef * armor[val], 3)
		if(armor[val] < 1)
			armor -= val
	return armor

#undef BASIC_ARMOUR_VALUES