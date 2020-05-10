/datum/extension/armor/proc/get_capabilities_description()
	. = list()

	var/list/descriptors = decls_repository.get_decls_of_type(/decl/protection_type)
	for(var/T in descriptors)
		var/decl/protection_type/armortype = descriptors[T]
		if(armortype.armor_key in armor_values)
			. += armortype.get_description(armor_values[armortype.armor_key])

/datum/extension/armor/toggle/get_capabilities_description()
	. = ..()
	. += "It only provides protection when activated"

/datum/extension/armor/ablative/get_capabilities_description()
	. = ..()
	. += "It degrades as it blocks damage"


// Generic non-bomb brute damage
/decl/protection_type
	var/armor_key = "melee"

/decl/protection_type/proc/get_description(value)
	switch(value)
		if(1 to ARMOR_MELEE_SMALL - 1)
			. = "It provides minimal protection against blunt and edged weapons"
		if(ARMOR_MELEE_SMALL to ARMOR_MELEE_KNIVES - 1)
			. = "It provides a bit of protection against blunt and edged weapons" 
		if(ARMOR_MELEE_KNIVES to ARMOR_MELEE_RESISTANT - 1)
			. = "It will blunt most knife attacks and provides some padding against blunt weapons"
		if(ARMOR_MELEE_RESISTANT to ARMOR_MELEE_MAJOR - 1)
			. = "It will likely blunt even large blades like swords, and cushion impacts from heavy weapons"
		if(ARMOR_MELEE_MAJOR to ARMOR_MELEE_VERY_HIGH - 1)
			. = "It provides good protection even against more penetrating melee weapons"
		if(ARMOR_MELEE_VERY_HIGH to ARMOR_MELEE_SHIELDED - 1)
			. = "It will let you shrug off all but most powerful or armor piercing melee attacks"
		if(ARMOR_MELEE_SHIELDED to INFINITY)
			. = "It makes you almost invulnerable against melee weapons"

// Brute projectile attacks
/decl/protection_type/ballistic
	armor_key = "bullet"

/decl/protection_type/ballistic/get_description(value)
	switch(value)
		if(1 to ARMOR_BALLISTIC_SMALL - 1)
			. = "It provides close to no protection against the bullets"
		if(ARMOR_BALLISTIC_SMALL to ARMOR_BALLISTIC_PISTOL - 1)
			. = "It provides minor padding against the kinetics"
		if(ARMOR_BALLISTIC_PISTOL to ARMOR_BALLISTIC_RESISTANT - 1)
			. = "It is rated to protect against the common pistol rounds"
		if(ARMOR_BALLISTIC_RESISTANT to ARMOR_BALLISTIC_RIFLE - 1)
			. = "It is rated to protect against the most handguns, but rifles will still blow through"
		if(ARMOR_BALLISTIC_RIFLE to ARMOR_BALLISTIC_AP - 1)
			. = "It is rated to protect against the rifle rounds"
		if(ARMOR_BALLISTIC_AP to ARMOR_BALLISTIC_HEAVY - 1)
			. = "It is rated to protect against most armor-piercing rounds"
		if(ARMOR_BALLISTIC_HEAVY to INFINITY)
			. = "It is on par with lighter tanks in terms of ballistic protection"

// Concentrated burn attacks
/decl/protection_type/laser
	armor_key = "laser"

/decl/protection_type/laser/get_description(value)
	switch(value)
		if(1 to ARMOR_LASER_SMALL - 1)
			. = "It provides close to no protection against the laser beams"
		if(ARMOR_LASER_SMALL to ARMOR_LASER_HANDGUNS - 1)
			. = "It is rated to protect against the beams of smaller laser handguns"
		if(ARMOR_LASER_HANDGUNS to ARMOR_LASER_RIFLES - 1)
			. = "It is rated to protect against the beams of laser handguns"
		if(ARMOR_LASER_RIFLES to ARMOR_LASER_HEAVY - 1)
			. = "It is rated to protect against the beams of full sized laser rifles"
		if(ARMOR_LASER_HEAVY to INFINITY)
			. = "It is on par with lighter tanks in terms of laser protection"

// Dispersed burn attacks
/decl/protection_type/energy
	armor_key = "energy"

/decl/protection_type/energy/get_description(value)
	switch(value)
		if(1 to ARMOR_ENERGY_SMALL - 1)
			. = "It provides some shielding against the heat and other energies"
		if(ARMOR_ENERGY_SMALL to ARMOR_ENERGY_RESISTANT - 1)
			. = "It provides shielding against the heat and other energies"
		if(ARMOR_ENERGY_RESISTANT to ARMOR_ENERGY_STRONG - 1)
			. = "It provides good shielding against the heat and other energies"
		if(ARMOR_ENERGY_STRONG to INFINITY)
			. = "It provides almost complete shielding against the heat and other energies"

// Damage from explosions
/decl/protection_type/bomb
	armor_key = " bomb"

/decl/protection_type/bomb/get_description(value)
	switch(value)
		if(1 to ARMOR_BOMB_PADDED - 1)
			. = "It provides minor padding against the explosions"
		if(ARMOR_BOMB_MINOR to ARMOR_BOMB_RESISTANT - 1)
			. = "It provides padding and insulation against the explosions"
		if(ARMOR_ENERGY_RESISTANT to INFINITY - 1)
			. = "It provides major padding and insulation against the explosions"
	
// Biohazards
/decl/protection_type/bio
	armor_key = "bio"

/decl/protection_type/bio/get_description(value)
	switch(value)
		if(1 to ARMOR_BIO_SMALL - 1)
			. = "It provides minor protection against biohazards"
		if(ARMOR_BIO_SMALL to ARMOR_BIO_STRONG - 1)
			. = "It provides appreciable protection against biohazards"
		if(ARMOR_BIO_STRONG to INFINITY)
			. = "It provides almost complete protection against biohazards"

// Radiation
/decl/protection_type/rad
	armor_key = "rad"

/decl/protection_type/rad/get_description(value)
	switch(value)
		if(1 to ARMOR_RAD_SMALL - 1)
			. = "It provides minor shielding against radaition"
		if(ARMOR_BIO_SMALL to ARMOR_RAD_RESISTANT - 1)
			. = "It provides shielding against radaition"
		if(ARMOR_RAD_RESISTANT to ARMOR_RAD_SHIELDED - 1)
			. = "It provides strong shielding against radaition"
		if(ARMOR_RAD_SHIELDED to INFINITY)
			. = "It provides almost complete shielding against radaition"