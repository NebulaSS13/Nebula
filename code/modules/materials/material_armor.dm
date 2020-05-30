#define BASIC_ARMOUR_VALUES list(melee = ARMOR_MELEE_MAJOR, bullet = ARMOR_BALLISTIC_RIFLE, laser = ARMOR_LASER_HEAVY, energy = ARMOR_ENERGY_STRONG, bomb = ARMOR_BOMB_RESISTANT,rad  = ARMOR_RAD_SHIELDED)

/decl/material/proc/generate_armor_values()
	if(is_brittle())
		armor_degradation_speed = 1
	else
		armor_degradation_speed = max(0.01, 0.5 * (200-integrity)/200)

	var/list/armor = BASIC_ARMOUR_VALUES
	for(var/val in list("melee", "bomb"))
		armor[val] *= hardness / 100
	armor["bomb"] *= weight / MAT_VALUE_NORMAL
	armor["bullet"] *= (hardness / 100) ** 2
	if(is_brittle())
		armor["bullet"] *= 0.2
	armor["laser"] *= (reflectiveness / 100) ** 2
	armor["energy"] *= reflectiveness / 100
	armor["rad"] *= (weight / 100) ** 2

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