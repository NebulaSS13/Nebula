// Light rigs are not space-capable, but don't suffer excessive slowdown or sight issues when depowered.
/obj/item/rig/light
	name = "light suit control module"
	desc = "A lighter, less armoured rig suit."
	suit_type = "light suit"
	icon = 'icons/clothing/rigs/rig_light.dmi'
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/baton,/obj/item/handcuffs,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/cell)
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED
		)
	siemens_coefficient = 0.4
	emp_protection = 10
	online_slowdown = 0
	item_flags = ITEM_FLAG_THICKMATERIAL
	offline_slowdown = TINT_NONE
	offline_vision_restriction = TINT_NONE
	max_pressure_protection = LIGHT_RIG_MAX_PRESSURE
	min_pressure_protection = 0

	chest =  /obj/item/clothing/suit/space/rig/light
	helmet = /obj/item/clothing/head/helmet/space/rig/light
	boots =  /obj/item/clothing/shoes/magboots/rig/light
	gloves = /obj/item/clothing/gloves/rig/light

/obj/item/clothing/suit/space/rig/light
	name = "suit"
	breach_threshold = 18 //comparable to voidsuits
	icon = 'icons/clothing/rigs/chests/chest_light.dmi'
/obj/item/clothing/gloves/rig/light
	name = "gloves"
	icon = 'icons/clothing/rigs/gloves/gloves_light.dmi'
/obj/item/clothing/shoes/magboots/rig/light
	name = "shoes"
	icon = 'icons/clothing/rigs/boots/boots_light.dmi'
/obj/item/clothing/head/helmet/space/rig/light
	name = "hood"
	icon = 'icons/clothing/rigs/helmets/helmet_light.dmi'

/obj/item/rig/light/hacker
	name = "cybersuit control module"
	suit_type = "cyber"
	desc = "An advanced powered armour suit with many cyberwarfare enhancements. Comes with built-in insulated gloves for safely tampering with electronics."
	icon = 'icons/clothing/rigs/rig_hacker.dmi'
	req_access = list(access_hacked)
	airtight = 0
	seal_delay = 5 //not being vacuum-proof has an upside I guess

	helmet = /obj/item/clothing/head/lightrig/hacker
	chest =  /obj/item/clothing/suit/lightrig/hacker
	gloves = /obj/item/clothing/gloves/lightrig/hacker
	boots =  /obj/item/clothing/shoes/lightrig/hacker

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/datajack,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/voice,
		/obj/item/rig_module/vision,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/rig/light/hacker/unlocked
	req_access = null

//The cybersuit is not space-proof. It does however, have good siemens_coefficient values
/obj/item/clothing/head/lightrig/hacker
	name = "HUD"
	item_flags = 0
	icon = 'icons/clothing/rigs/helmets/helmet_hacker.dmi'
/obj/item/clothing/suit/lightrig/hacker
	siemens_coefficient = 0.2
	icon = 'icons/clothing/rigs/chests/chest_hacker.dmi'
/obj/item/clothing/shoes/lightrig/hacker
	siemens_coefficient = 0.2
	item_flags = ITEM_FLAG_NOSLIP | ITEM_FLAG_MAGNETISED //All the other rigs have magboots anyways, hopefully gives the hacker suit something more going for it.
	icon = 'icons/clothing/rigs/boots/boots_hacker.dmi'
/obj/item/clothing/gloves/lightrig/hacker
	siemens_coefficient = 0
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS
	icon = 'icons/clothing/rigs/gloves/gloves_hacker.dmi'

/obj/item/rig/light/stealth
	name = "stealth suit control module"
	suit_type = "stealth"
	desc = "A highly advanced and expensive suit designed for covert operations."
	req_access = list(access_hacked)
	initial_modules = list(
		/obj/item/rig_module/stealth_field,
		/obj/item/rig_module/vision
	)

/obj/item/rig/light/stealth/unlocked
	req_access = null
