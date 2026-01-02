/obj/item/rig/merc
	name = "crimson hardsuit control module"
	desc = "A blood-red hardsuit module with heavy armour plates."
	icon = 'icons/clothing/rigs/rig_merc.dmi'
	suit_type = "crimson hardsuit"
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_RIFLE,
		ARMOR_LASER = ARMOR_LASER_MAJOR,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_RESISTANT,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SMALL
		)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY

	helmet = /obj/item/clothing/head/helmet/space/rig/merc
	gloves = /obj/item/clothing/gloves/rig/merc
	boots =  /obj/item/clothing/shoes/rig/merc
	chest =  /obj/item/clothing/suit/space/rig/merc
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/baton,/obj/item/energy_blade/sword,/obj/item/handcuffs)

	initial_modules = list(
		/obj/item/rig_module/mounted/lcannon,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/fabricator/energy_net
		)

/obj/item/clothing/gloves/rig/merc
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS
	icon = 'icons/clothing/rigs/gloves/gloves_merc.dmi'
/obj/item/clothing/head/helmet/space/rig/merc
	camera = /obj/machinery/camera/network/mercenary
	icon = 'icons/clothing/rigs/helmets/helmet_merc.dmi'
/obj/item/clothing/shoes/rig/merc
	icon = 'icons/clothing/rigs/boots/boots_merc.dmi'
/obj/item/clothing/suit/space/rig/merc
	icon = 'icons/clothing/rigs/chests/chest_merc.dmi'

//Has most of the modules removed
/obj/item/rig/merc/empty
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		)

/obj/item/rig/merc/empty/unlocked
	req_access = null

/obj/item/rig/merc/heavy
	name = "crimson EOD hardsuit control module"
	desc = "A blood-red hardsuit with heavy armoured plates. Judging by the abnormally thick plates, this one is for working with explosives."
	icon = 'icons/clothing/rigs/rig_merc_heavy.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_VERY_HIGH,
		ARMOR_BULLET = ARMOR_BALLISTIC_AP,
		ARMOR_LASER = ARMOR_LASER_MAJOR,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_SHIELDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SMALL
		)
	online_slowdown = 3
	offline_slowdown = 4
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0
	helmet = /obj/item/clothing/head/helmet/space/rig/merc/heavy
	gloves = /obj/item/clothing/gloves/rig/merc/heavy
	boots =  /obj/item/clothing/shoes/rig/merc/heavy
	chest =  /obj/item/clothing/suit/space/rig/merc/heavy

/obj/item/rig/merc/heavy/empty
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
	)

/obj/item/clothing/gloves/rig/merc/heavy
	icon = 'icons/clothing/rigs/gloves/gloves_merc_heavy.dmi'
/obj/item/clothing/head/helmet/space/rig/merc/heavy
	icon = 'icons/clothing/rigs/helmets/helmet_merc_heavy.dmi'
/obj/item/clothing/shoes/rig/merc/heavy
	icon = 'icons/clothing/rigs/boots/boots_merc_heavy.dmi'
/obj/item/clothing/suit/space/rig/merc/heavy
	icon = 'icons/clothing/rigs/chests/chest_merc_heavy.dmi'
