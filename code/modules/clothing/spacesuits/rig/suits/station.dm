/obj/item/rig/light/internalaffairs
	name = "augmented tie"
	suit_type = "augmented suit"
	desc = "Prepare for paperwork."
	icon = 'icons/clothing/rigs/rig_paperwork.dmi'
	siemens_coefficient = 0.9
	online_slowdown = 0
	offline_slowdown = 0
	offline_vision_restriction = 0

	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/briefcase, /obj/item/secure_storage/briefcase)

	req_access = list(access_lawyer)

	gloves = null
	helmet = null
	boots = null
	chest = /obj/item/clothing/suit/space/rig/internal_affairs

	hides_uniform = 0

/obj/item/clothing/suit/space/rig/internal_affairs
	icon = 'icons/clothing/rigs/chests/chest_paperwork.dmi'

/obj/item/rig/light/internalaffairs/equipped
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/device/paperdispenser,
		/obj/item/rig_module/device/pen,
		/obj/item/rig_module/device/stamp,
		/obj/item/rig_module/cooling_unit
	)

/obj/item/rig/industrial
	name = "industrial suit control module"
	suit_type = "industrial hardsuit"
	desc = "A heavy, powerful rig used by construction crews and mining corporations."
	icon = 'icons/clothing/rigs/rig.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MAJOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	online_slowdown = 3
	offline_slowdown = 10
	vision_restriction = TINT_MODERATE
	offline_vision_restriction = TINT_BLIND
	emp_protection = -20
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0

	chest = /obj/item/clothing/suit/space/rig/industrial
	helmet = /obj/item/clothing/head/helmet/space/rig/industrial
	boots = /obj/item/clothing/shoes/magboots/rig/industrial
	gloves = /obj/item/clothing/gloves/rig/industrial

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/stack/flag,
		/obj/item/ore,
		/obj/item/t_scanner,
		/obj/item/tool,
		/obj/item/rcd
	)

/obj/item/clothing/head/helmet/space/rig/industrial
	camera = /obj/machinery/camera/network/mining
	icon = 'icons/clothing/rigs/helmets/helmet.dmi'
/obj/item/clothing/suit/space/rig/industrial
	icon = 'icons/clothing/rigs/chests/chest.dmi'
/obj/item/clothing/shoes/magboots/rig/industrial
	icon = 'icons/clothing/rigs/boots/boots.dmi'
/obj/item/clothing/gloves/rig/industrial
	icon = 'icons/clothing/rigs/gloves/gloves.dmi'
	siemens_coefficient = 0

/obj/item/rig/industrial/equipped

	initial_modules = list(
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/rig/industrial/unlocked
	req_access = null

/obj/item/rig/eva
	name = "EVA hardsuit control module"
	suit_type = "EVA hardsuit"
	desc = "A light rig for repairs and maintenance to the outside of habitats and vessels."
	icon = 'icons/clothing/rigs/rig_eva.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_MINOR,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_BOMB = ARMOR_BOMB_MINOR,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
		)
	online_slowdown = 0
	offline_vision_restriction = TINT_HEAVY

	chest =  /obj/item/clothing/suit/space/rig/eva
	helmet = /obj/item/clothing/head/helmet/space/rig/eva
	boots =  /obj/item/clothing/shoes/magboots/rig/eva
	gloves = /obj/item/clothing/gloves/rig/eva

	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/toolbox,/obj/item/briefcase/inflatable,/obj/item/inflatable_dispenser,/obj/item/t_scanner,/obj/item/rcd)

	req_access = list(access_engine_equip)

/obj/item/clothing/head/helmet/space/rig/eva
	camera = /obj/machinery/camera/network/engineering
	icon = 'icons/clothing/rigs/helmets/helmet_eva.dmi'
/obj/item/clothing/suit/space/rig/eva
	icon = 'icons/clothing/rigs/chests/chest_eva.dmi'
/obj/item/clothing/shoes/magboots/rig/eva
	icon = 'icons/clothing/rigs/boots/boots_eva.dmi'
/obj/item/clothing/gloves/rig/eva
	icon = 'icons/clothing/rigs/gloves/gloves_eva.dmi'

/obj/item/rig/eva/equipped
	initial_modules = list(
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/rig/eva/unlocked
	req_access = null

/obj/item/rig/ce
	name = "advanced engineering hardsuit control module"
	suit_type = "engineering hardsuit"
	desc = "An advanced hardsuit that protects against hazardous, low pressure environments. Shines with a high polish. Appears compatible with the physiology of most species."
	icon = 'icons/clothing/rigs/rig_engineering.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_SMALL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_SMALL,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
		)
	online_slowdown = 0
	offline_vision_restriction = TINT_HEAVY
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE // this is passed to the rig suit components when deployed, including the helmet.

	boots = /obj/item/clothing/shoes/magboots/rig/ce
	chest = /obj/item/clothing/suit/space/rig/ce
	helmet = /obj/item/clothing/head/helmet/space/rig/ce
	gloves = /obj/item/clothing/gloves/rig/ce

	allowed = list(
		/obj/item/gun,
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/ore,
		/obj/item/toolbox,
		/obj/item/briefcase/inflatable,
		/obj/item/inflatable_dispenser,
		/obj/item/t_scanner,
		/obj/item/tool,
		/obj/item/rcd
	)

	req_access = list(access_ce)
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0

/obj/item/rig/ce/equipped
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/grenade_launcher/mfoam,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/clothing/suit/space/rig/ce
	icon = 'icons/clothing/rigs/chests/chest_engineering.dmi'

/obj/item/clothing/head/helmet/space/rig/ce
	icon = 'icons/clothing/rigs/helmets/helmet_engineering.dmi'
	camera = /obj/machinery/camera/network/engineering

/obj/item/clothing/gloves/rig/ce
	icon = 'icons/clothing/rigs/gloves/gloves_engineering.dmi'
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/ce
	icon = 'icons/clothing/rigs/boots/boots_engineering.dmi'

/obj/item/rig/hazmat
	name = "\improper AMI control module"
	suit_type = "hazmat hardsuit"
	desc = "An Anomalous Material Interaction hardsuit, a cutting-edge design, protects the wearer against the strangest energies the universe can throw at it."
	icon = 'icons/clothing/rigs/rig_science.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_STRONG,
		ARMOR_BOMB = ARMOR_BOMB_RESISTANT,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
		)
	online_slowdown = 1
	offline_vision_restriction = TINT_HEAVY

	chest =  /obj/item/clothing/suit/space/rig/hazmat
	helmet = /obj/item/clothing/head/helmet/space/rig/hazmat
	boots =  /obj/item/clothing/shoes/magboots/rig/hazmat
	gloves = /obj/item/clothing/gloves/rig/hazmat

	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/stack/flag,
		/obj/item/excavation,
		/obj/item/tool,
		/obj/item/scanner/health,
		/obj/item/scanner/breath,
		/obj/item/measuring_tape,
		/obj/item/ano_scanner,
		/obj/item/depth_scanner,
		/obj/item/core_sampler,
		/obj/item/gps,
		/obj/item/pinpointer/radio,
		/obj/item/radio/beacon,
		/obj/item/bag/fossils
	)

	anomaly_shielding = 1
	req_access = list(access_tox)

/obj/item/clothing/head/helmet/space/rig/hazmat
	camera = /obj/machinery/camera/network/research
	icon = 'icons/clothing/rigs/helmets/helmet_science.dmi'
/obj/item/clothing/suit/space/rig/hazmat
	icon = 'icons/clothing/rigs/chests/chest_science.dmi'
/obj/item/clothing/shoes/magboots/rig/hazmat
	icon = 'icons/clothing/rigs/boots/boots_science.dmi'
/obj/item/clothing/gloves/rig/hazmat
	icon = 'icons/clothing/rigs/gloves/gloves_science.dmi'

/obj/item/rig/hazmat/equipped
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/cooling_unit,
		)

/obj/item/rig/medical
	name = "rescue suit control module"
	suit_type = "rescue hardsuit"
	desc = "A durable suit designed for medical rescue in high risk areas."
	icon = 'icons/clothing/rigs/rig_medical.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_RESISTANT,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_RESISTANT,
		ARMOR_BOMB = ARMOR_BOMB_PADDED,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_SHIELDED
		)
	online_slowdown = 1
	offline_vision_restriction = TINT_HEAVY

	chest =  /obj/item/clothing/suit/space/rig/medical
	helmet = /obj/item/clothing/head/helmet/space/rig/medical
	boots =  /obj/item/clothing/shoes/magboots/rig/medical
	gloves = /obj/item/clothing/gloves/rig/medical

	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/firstaid,/obj/item/scanner/health,/obj/item/scanner/breath,/obj/item/stack/medical,/obj/item/roller,/obj/item/auto_cpr,/obj/item/inflatable_dispenser)

	req_access = list(access_medical_equip)

/obj/item/clothing/head/helmet/space/rig/medical
	camera = /obj/machinery/camera/network/medbay
	icon = 'icons/clothing/rigs/helmets/helmet_medical.dmi'
/obj/item/clothing/suit/space/rig/medical
	icon = 'icons/clothing/rigs/chests/chest_medical.dmi'
/obj/item/clothing/shoes/magboots/rig/medical
	icon = 'icons/clothing/rigs/boots/boots_medical.dmi'
/obj/item/clothing/gloves/rig/medical
	icon = 'icons/clothing/rigs/gloves/gloves_medical.dmi'

/obj/item/rig/medical/equipped
	initial_modules = list(
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/vision/medhud,
		/obj/item/rig_module/device/defib,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/rig/hazard
	name = "hazard hardsuit control module"
	suit_type = "hazard hardsuit"
	desc = "A security hardsuit designed for prolonged EVA in dangerous environments."
	icon = 'icons/clothing/rigs/rig_hazard.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_MAJOR,
		ARMOR_BULLET = ARMOR_BALLISTIC_PISTOL,
		ARMOR_LASER = ARMOR_LASER_HANDGUNS,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_RESISTANT,
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_BLIND

	chest =  /obj/item/clothing/suit/space/rig/hazard
	helmet = /obj/item/clothing/head/helmet/space/rig/hazard
	boots =  /obj/item/clothing/shoes/magboots/rig/hazard
	gloves = /obj/item/clothing/gloves/rig/hazard

	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/handcuffs,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/baton)
	anomaly_shielding = 1

/obj/item/clothing/head/helmet/space/rig/hazard
	camera = /obj/machinery/camera/network/security
	icon = 'icons/clothing/rigs/helmets/helmet_hazard.dmi'
/obj/item/clothing/suit/space/rig/hazard
	icon = 'icons/clothing/rigs/chests/chest_hazard.dmi'
/obj/item/clothing/shoes/magboots/rig/hazard
	icon = 'icons/clothing/rigs/boots/boots_hazard.dmi'
/obj/item/clothing/gloves/rig/hazard
	icon = 'icons/clothing/rigs/gloves/gloves_hazard.dmi'

/obj/item/rig/hazard/equipped
	initial_modules = list(
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/taser,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/rig/hazard/unlocked
	req_access = null

/obj/item/rig/zero
	name = "null suit control module"
	suit_type = "null hardsuit"
	desc = "A very lightweight suit designed to allow use inside mechs and starfighters. It feels like you're wearing nothing at all."
	icon = 'icons/clothing/rigs/rig_null.dmi'
	armor = list(
		ARMOR_BIO = ARMOR_BIO_SHIELDED,
		ARMOR_RAD = ARMOR_RAD_MINOR
		)
	online_slowdown = 0
	offline_slowdown = 1
	offline_vision_restriction = TINT_HEAVY //You're wearing a flash protective space suit without light compensation, think it makes sense
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)

	chest =  /obj/item/clothing/suit/space/rig/zero
	helmet = /obj/item/clothing/head/helmet/space/rig/zero
	boots = null
	gloves = null
	max_pressure_protection = null
	min_pressure_protection = 0

	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit)
	//Bans the most common combat items, idea is that this isn't a mass built shouldergun rig.
	banned_modules = list(/obj/item/rig_module/grenade_launcher,/obj/item/rig_module/mounted,/obj/item/rig_module/fabricator )
	req_access = list()

/obj/item/clothing/head/helmet/space/rig/zero
	camera = null
	desc = "A bubble helmet that maximizes the field of view. A state-of-the-art holographic display provides a stream of information"
	icon = 'icons/clothing/rigs/helmets/helmet_null.dmi'

/obj/item/clothing/suit/space/rig/zero
	breach_threshold = 18
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_FEET|SLOT_ARMS|SLOT_HANDS|SLOT_TAIL
	icon = 'icons/clothing/rigs/chests/chest_null.dmi'
