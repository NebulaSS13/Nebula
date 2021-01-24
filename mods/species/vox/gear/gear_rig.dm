/obj/item/rig/vox
	name = "alien rig control module"
	desc = "A strange rig. Parts of it writhe and squirm as if alive. The visor looks more like a thick membrane."
	suit_type = "alien rig"
	icon = 'mods/species/vox/icons/rig/rig.dmi'
	armor = list(
		melee = ARMOR_MELEE_MAJOR, 
		bullet = ARMOR_BALLISTIC_RESISTANT, 
		laser = ARMOR_LASER_HANDGUNS, 
		energy = ARMOR_ENERGY_RESISTANT, 
		bomb = ARMOR_BOMB_PADDED, 
		bio = ARMOR_BIO_SHIELDED, 
		rad = ARMOR_RAD_SHIELDED
		)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE

	chest =      /obj/item/clothing/suit/space/rig/vox_rig
	helmet =     /obj/item/clothing/head/helmet/space/rig/vox_rig
	boots =      /obj/item/clothing/shoes/magboots/rig/vox_rig
	gloves =     /obj/item/clothing/gloves/rig/vox_rig
	air_supply = /obj/item/tank/nitrogen
	
	allowed = list(
		/obj/item/flashlight, 
		/obj/item/tank, 
		/obj/item/ammo_magazine, 
		/obj/item/ammo_casing, 
		/obj/item/ammo_magazine/shotholder, 
		/obj/item/handcuffs, 
		/obj/item/radio, 
		/obj/item/baton, 
		/obj/item/gun, 
		/obj/item/pickaxe
	)
	
	online_slowdown = 1

	initial_modules = list(
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/clothing/head/helmet/space/rig/vox_rig
	icon = 'mods/species/vox/icons/rig/helmet.dmi'
/obj/item/clothing/head/helmet/space/rig/vox_rig/Initialize()
	. = ..()
	bodytype_restricted = list(BODYTYPE_VOX)
/obj/item/clothing/suit/space/rig/vox_rig
	icon = 'mods/species/vox/icons/rig/chest.dmi'
/obj/item/clothing/suit/space/rig/vox_rig/Initialize()
	. = ..()
	bodytype_restricted = list(BODYTYPE_VOX)
/obj/item/clothing/shoes/magboots/rig/vox_rig
	icon = 'mods/species/vox/icons/rig/boots.dmi'
/obj/item/clothing/shoes/magboots/rig/vox_rig/Initialize()
	. = ..()
	bodytype_restricted = list(BODYTYPE_VOX)
/obj/item/clothing/gloves/rig/vox_rig
	icon = 'mods/species/vox/icons/rig/gloves.dmi'
	siemens_coefficient = 0
/obj/item/clothing/gloves/rig/vox_rig/Initialize()
	. = ..()
	bodytype_restricted = list(BODYTYPE_VOX)
