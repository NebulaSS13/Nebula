#define BASIC_ARMOUR_VALUES list(DEF_MELEE = ARMOR_MELEE_MAJOR, DEF_BULLET = ARMOR_BALLISTIC_RIFLE, DEF_LASER = ARMOR_LASER_HEAVY, DEF_ENERGY = ARMOR_ENERGY_STRONG, DEF_BOMB = ARMOR_BOMB_RESISTANT,DEF_RAD  = ARMOR_RAD_SHIELDED)

/decl/material/proc/generate_armor_values()
	if(is_brittle())
		armor_degradation_speed = 1
	else
		armor_degradation_speed = max(0.01, 0.5 * (200-integrity)/200)

	var/list/armor = BASIC_ARMOUR_VALUES
	for(var/val in list(DEF_MELEE, DEF_BOMB))
		armor[val] *= hardness / 100
	armor[DEF_BOMB] *= weight / MAT_VALUE_NORMAL
	armor[DEF_BULLET] *= (hardness / 100) ** 2
	if(is_brittle())
		armor[DEF_BULLET] *= 0.2
	armor[DEF_LASER] *= (reflectiveness / 100) ** 2
	armor[DEF_ENERGY] *= reflectiveness / 100
	armor[DEF_RAD] *= (weight / 100) ** 2

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