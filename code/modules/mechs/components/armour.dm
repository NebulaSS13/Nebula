/datum/extension/armor/mech
	under_armor_mult = 0.3

/obj/item/robot_parts/robot_component/armour/exosuit
	name = "exosuit armour plating"
	armor = list(
		melee = ARMOR_MELEE_MAJOR, 
		bullet = ARMOR_BALLISTIC_PISTOL, 
		laser = ARMOR_LASER_HANDGUNS, 
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
		)
	origin_tech = "{'materials':1}"
	material = /decl/material/solid/metal/steel

/obj/item/robot_parts/robot_component/armour/exosuit/radproof
	name = "radiation-proof armour plating"
	desc = "A fully enclosed radiation hardened shell designed to protect the pilot from radiation"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT, 
		bullet = ARMOR_BALLISTIC_PISTOL, 
		laser = ARMOR_LASER_HANDGUNS, 
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED, 
		rad = ARMOR_RAD_SHIELDED
		)
	origin_tech = "{'materials':3}"
	material = /decl/material/solid/metal/steel

/obj/item/robot_parts/robot_component/armour/exosuit/em
	name = "EM-shielded armour plating"
	desc = "A shielded plating that sorrounds the eletronics and protects them from electromagnetic radiation"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT , 
		bullet = ARMOR_BALLISTIC_SMALL, 
		laser = ARMOR_LASER_SMALL, 
		energy = ARMOR_ENERGY_SHIELDED, 
		bomb = ARMOR_BOMB_MINOR, 
		bio = ARMOR_BIO_SHIELDED, 
		rad = ARMOR_RAD_SMALL
		)
	origin_tech = "{'materials':3}"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/robot_parts/robot_component/armour/exosuit/combat
	name = "heavy combat plating"
	desc = "Plating designed to deflect incoming attacks and explosions"
	armor = list(
		melee = ARMOR_MELEE_MAJOR, 
		bullet = ARMOR_BALLISTIC_RESISTANT, 
		laser = ARMOR_LASER_HANDGUNS, 
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_RESISTANT, 
		bio = ARMOR_BIO_SHIELDED
		)
	origin_tech = "{'materials':5}"
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/robot_parts/robot_component/armour/exosuit/Initialize()
	. = ..()
	set_extension(src, /datum/extension/armor/mech, armor)