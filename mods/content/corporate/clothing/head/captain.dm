/obj/item/clothing/head/helmet/space/capspace
	name = "space helmet"
	icon = 'mods/content/corporate/icons/clothing/head/capspace.dmi'
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	item_flags = 0
	max_pressure_protection = VOIDSUIT_MAX_PRESSURE
	min_pressure_protection = 0
	flags_inv = HIDEFACE|BLOCKHAIR
	permeability_coefficient = 0.01
	armor = list(
		melee = ARMOR_MELEE_MAJOR, 
		bullet = ARMOR_BALLISTIC_RESISTANT, 
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_SMALL, 
		bomb = ARMOR_BOMB_RESISTANT, 
		bio = ARMOR_BIO_SHIELDED, 
		rad = ARMOR_RAD_SMALL
		)