/obj/item/clothing/head/helmet/space/capspace
	name = "space helmet"
	icon = 'mods/content/corporate/icons/clothing/head/capspace.dmi'
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	item_flags = 0
	max_pressure_protection = VOIDSUIT_MAX_PRESSURE
	min_pressure_protection = 0
	flags_inv = HIDEEARS|HIDEEYES|BLOCK_HEAD_HAIR
	permeability_coefficient = 0.01
	armor = list(
		DEF_MELEE = ARMOR_MELEE_MAJOR, 
		DEF_BULLET = ARMOR_BALLISTIC_RESISTANT, 
		DEF_LASER = ARMOR_LASER_HANDGUNS,
		DEF_ENERGY = ARMOR_ENERGY_SMALL, 
		DEF_BOMB = ARMOR_BOMB_RESISTANT, 
		DEF_BIO = ARMOR_BIO_SHIELDED, 
		DEF_RAD = ARMOR_RAD_SMALL
		)