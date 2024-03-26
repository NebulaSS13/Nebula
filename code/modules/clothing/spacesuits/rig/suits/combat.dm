/obj/item/rig/combat
	name = "combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat."
	suit_type = "combat hardsuit"
	icon = 'icons/clothing/rigs/rig_security.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_RIFLE,
		ARMOR_LASER = ARMOR_LASER_MAJOR,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_RESISTANT,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_RESISTANT
		)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/handcuffs,
		/obj/item/t_scanner,
		/obj/item/rcd,
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/multitool,
		/obj/item/radio,
		/obj/item/scanner/gas,
		/obj/item/briefcase/inflatable,
		/obj/item/baton,
		/obj/item/gun,
		/obj/item/firstaid,
		/obj/item/chems/hypospray,
		/obj/item/chems/inhaler,
		/obj/item/roller,
		/obj/item/suit_cooling_unit
	)

	chest =  /obj/item/clothing/suit/space/rig/combat
	helmet = /obj/item/clothing/head/helmet/space/rig/combat
	boots =  /obj/item/clothing/shoes/magboots/rig/combat
	gloves = /obj/item/clothing/gloves/rig/combat

/obj/item/clothing/head/helmet/space/rig/combat
	icon = 'icons/clothing/rigs/helmets/helmet_security.dmi'
/obj/item/clothing/suit/space/rig/combat
	icon = 'icons/clothing/rigs/chests/chest_security.dmi'
/obj/item/clothing/shoes/magboots/rig/combat
	icon = 'icons/clothing/rigs/boots/boots_security.dmi'
/obj/item/clothing/gloves/rig/combat
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS
	icon = 'icons/clothing/rigs/gloves/gloves_security.dmi'

/obj/item/rig/combat/equipped
	initial_modules = list(
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit
		)

//Extremely OP, hardly standard issue equipment
//Now a little less OP
/obj/item/rig/military
	name = "military hardsuit control module"
	desc = "An austere hardsuit used by paramilitary groups and real soldiers alike."
	icon = 'icons/clothing/rigs/rig_military.dmi'
	suit_type = "military hardsuit"
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_AP,
		ARMOR_LASER = ARMOR_LASER_RIFLES,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_RESISTANT,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/handcuffs,
		/obj/item/t_scanner,
		/obj/item/rcd,
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/multitool,
		/obj/item/radio,
		/obj/item/scanner/gas,
		/obj/item/briefcase/inflatable,
		/obj/item/baton,
		/obj/item/gun,
		/obj/item/firstaid,
		/obj/item/chems/hypospray,
		/obj/item/chems/inhaler,
		/obj/item/roller,
		/obj/item/suit_cooling_unit
	)

	chest =  /obj/item/clothing/suit/space/rig/military
	helmet = /obj/item/clothing/head/helmet/space/rig/military
	boots =  /obj/item/clothing/shoes/magboots/rig/military
	gloves = /obj/item/clothing/gloves/rig/military

/obj/item/clothing/head/helmet/space/rig/military
	icon = 'icons/clothing/rigs/helmets/helmet_military.dmi'
/obj/item/clothing/suit/space/rig/military
	icon = 'icons/clothing/rigs/chests/chest_military.dmi'
/obj/item/clothing/shoes/magboots/rig/military
	icon = 'icons/clothing/rigs/boots/boots_military.dmi'
/obj/item/clothing/gloves/rig/military
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS
	icon = 'icons/clothing/rigs/gloves/gloves_military.dmi'

/obj/item/rig/military/equipped
	initial_modules = list(
		/obj/item/rig_module/mounted/egun,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/cooling_unit
		)
