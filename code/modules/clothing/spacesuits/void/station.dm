// Station voidsuits

//Engineering
/obj/item/clothing/head/helmet/space/void/engineering
	name = "engineering voidsuit helmet"
	desc = "A sturdy looking voidsuit helmet rated to protect against radiation."
	icon = 'icons/clothing/spacesuit/void/engineering/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	siemens_coefficient = 0.3

/obj/item/clothing/suit/space/void/engineering
	name = "engineering voidsuit"
	desc = "A run-of-the-mill service voidsuit with all the plating and radiation protection required for industrial work in vacuum."
	icon = 'icons/clothing/spacesuit/void/engineering/suit.dmi'
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	siemens_coefficient = 0.3
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/storage/toolbox,/obj/item/storage/briefcase/inflatable,/obj/item/t_scanner,/obj/item/rcd)

/obj/item/clothing/suit/space/void/engineering/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 1)

/obj/item/clothing/suit/space/void/engineering/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/engineering
	boots = /obj/item/clothing/shoes/magboots

//Mining
/obj/item/clothing/head/helmet/space/void/mining
	name = "mining voidsuit helmet"
	desc = "A scuffed voidsuit helmet with a boosted communication system and reinforced armor plating."
	icon = 'icons/clothing/spacesuit/void/mining/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
		)
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE

/obj/item/clothing/suit/space/void/mining
	name = "mining voidsuit"
	desc = "A grimy, decently armored voidsuit with purple blazes and extra insulation."
	icon = 'icons/clothing/spacesuit/void/mining/suit.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
		)
	max_pressure_protection = ENG_VOIDSUIT_MAX_PRESSURE
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/stack/flag,/obj/item/suit_cooling_unit,/obj/item/storage/ore,/obj/item/t_scanner,/obj/item/pickaxe, /obj/item/rcd)

/obj/item/clothing/suit/space/void/mining/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/mining

//Medical
/obj/item/clothing/head/helmet/space/void/medical
	name = "medical voidsuit helmet"
	desc = "A bulbous voidsuit helmet with minor radiation shielding and a massive visor."
	icon = 'icons/clothing/spacesuit/void/medical/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)

/obj/item/clothing/suit/space/void/medical
	name = "medical voidsuit"
	desc = "A sterile voidsuit with minor radiation shielding and a suite of self-cleaning technology. Standard issue in most orbital medical facilities."
	icon = 'icons/clothing/spacesuit/void/medical/suit.dmi'
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/storage/firstaid,/obj/item/scanner/health,/obj/item/stack/medical)
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)

/obj/item/clothing/suit/space/void/medical/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/medical
	boots = /obj/item/clothing/shoes/magboots

//Security
/obj/item/clothing/head/helmet/space/void/security
	name = "security voidsuit helmet"
	desc = "A comfortable voidsuit helmet with cranial armor and eight-channel surround sound."
	icon = 'icons/clothing/spacesuit/void/sec/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
		)
	siemens_coefficient = 0.3

/obj/item/clothing/suit/space/void/security
	name = "security voidsuit"
	desc = "A somewhat clumsy voidsuit layered with impact and laser-resistant armor plating. Specially designed to dissipate minor electrical charges."
	icon = 'icons/clothing/spacesuit/void/sec/suit.dmi'
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
		)
	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/baton)
	siemens_coefficient = 0.3

/obj/item/clothing/suit/space/void/security/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/security
	boots = /obj/item/clothing/shoes/magboots

//Atmospherics
/obj/item/clothing/head/helmet/space/void/atmos
	desc = "A flame-retardant voidsuit helmet with a self-repairing visor and light anti-radiation shielding."
	name = "atmospherics voidsuit helmet"
	icon = 'icons/clothing/spacesuit/void/atmos/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE

/obj/item/clothing/suit/space/void/atmos
	desc = "A durable voidsuit with advanced temperature-regulation systems as well as minor radiation protection. Well worth the price."
	name = "atmos voidsuit"
	icon = 'icons/clothing/spacesuit/void/atmos/suit.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank,
		/obj/item/suit_cooling_unit,
		/obj/item/storage/toolbox,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/t_scanner,
		/obj/item/rcd
	)

/obj/item/clothing/suit/space/void/atmos/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/atmos
	boots = /obj/item/clothing/shoes/magboots

//Surplus Voidsuits

//Engineering
/obj/item/clothing/head/helmet/space/void/engineering/alt
	name = "reinforced engineering voidsuit helmet"
	desc = "A heavy, radiation-shielded voidsuit helmet with a surprisingly comfortable interior."
	icon = 'icons/clothing/spacesuit/void/engineering_alt/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)

/obj/item/clothing/suit/space/void/engineering/alt
	name = "reinforced engineering voidsuit"
	desc = "A bulky industrial voidsuit. It's a few generations old, but a reliable design and radiation shielding make up for the lack of climate control."
	icon = 'icons/clothing/spacesuit/void/engineering_alt/suit.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)

/obj/item/clothing/suit/space/void/engineering/alt/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 2)

/obj/item/clothing/suit/space/void/engineering/alt/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/engineering/alt
	boots = /obj/item/clothing/shoes/magboots

//Mining
/obj/item/clothing/head/helmet/space/void/mining/alt
	name = "frontier mining voidsuit helmet"
	desc = "An armored voidsuit helmet. Someone must have through they were pretty cool when they painted a mohawk on it."
	icon = 'icons/clothing/spacesuit/void/mining_alt/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
		)

/obj/item/clothing/suit/space/void/mining/alt
	name = "frontier mining voidsuit"
	desc = "A cheap prospecting voidsuit. What it lacks in comfort it makes up for in armor plating and street cred."
	icon = 'icons/clothing/spacesuit/void/mining_alt/suit.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_RESISTANT,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
		)

/obj/item/clothing/suit/space/void/mining/alt/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/mining/alt

//Medical
/obj/item/clothing/head/helmet/space/void/medical/alt
	name = "streamlined medical voidsuit helmet"
	desc = "A trendy, lightly radiation-shielded voidsuit helmet trimmed in a fetching blue."
	icon = 'icons/clothing/spacesuit/void/medical_alt/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)

/obj/item/clothing/suit/space/void/medical/alt
	name = "streamlined medical voidsuit"
	desc = "A more recent and stylish model of Vey-Med voidsuit, with a minor upgrade to radiation shielding."
	icon = 'icons/clothing/spacesuit/void/medical_alt/suit.dmi'
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/storage/firstaid,/obj/item/scanner/health,/obj/item/stack/medical)
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)

/obj/item/clothing/suit/space/void/medical/alt/Initialize()
	. = ..()
	LAZYSET(slowdown_per_slot, slot_wear_suit_str, 0)

/obj/item/clothing/suit/space/void/medical/alt/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/medical/alt
	boots = /obj/item/clothing/shoes/magboots

//Security
/obj/item/clothing/head/helmet/space/void/security/alt
	name = "riot security voidsuit helmet"
	desc = "A somewhat tacky voidsuit helmet, a fact mitigated by heavy armor plating."
	icon = 'icons/clothing/spacesuit/void/sec_alt/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR)

/obj/item/clothing/suit/space/void/security/alt
	name = "riot security voidsuit"
	desc = "A heavily armored voidsuit, designed to intimidate people who find black intimidating. Surprisingly slimming."
	icon = 'icons/clothing/spacesuit/void/sec_alt/suit.dmi'
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR)
	allowed = list(/obj/item/gun,/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/baton)

/obj/item/clothing/suit/space/void/security/alt/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/security/alt
	boots = /obj/item/clothing/shoes/magboots

//Atmospherics
/obj/item/clothing/head/helmet/space/void/atmos/alt
	name = "heavy duty atmospherics voidsuit helmet"
	desc = "A voidsuit helmet plated with an expensive heat and radiation resistant ceramic."
	icon = 'icons/clothing/spacesuit/void/atmos_alt/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)

/obj/item/clothing/suit/space/void/atmos/alt
	name = "heavy duty atmos voidsuit"
	desc = "An expensive voidsuit, rated to withstand extreme heat and even minor radiation without exceeding room temperature within."
	icon = 'icons/clothing/spacesuit/void/atmos_alt/suit.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
	)

/obj/item/clothing/suit/space/void/atmos/alt/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/atmos/alt
	boots = /obj/item/clothing/shoes/magboots

//Misc
/obj/item/clothing/head/helmet/space/void/engineering/salvage
	name = "salvage voidsuit helmet"
	desc = "A heavily modified salvage voidsuit helmet. It has been fitted with radiation-resistant plating."
	icon = 'icons/clothing/spacesuit/void/salvage/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)

/obj/item/clothing/suit/space/void/engineering/salvage
	name = "salvage voidsuit"
	desc = "A hand-me-down salvage voidsuit. It has obviously had a lot of repair work done to its radiation shielding."
	icon = 'icons/clothing/spacesuit/void/salvage/suit.dmi'
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_RESISTANT
		)
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/storage/toolbox,/obj/item/storage/briefcase/inflatable,/obj/item/t_scanner,/obj/item/rcd)

/obj/item/clothing/suit/space/void/engineering/salvage/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/engineering/salvage
	boots = /obj/item/clothing/shoes/magboots

//Pilot
/obj/item/clothing/head/helmet/space/void/pilot
	desc = "An atmos resistant helmet for space and planet exploration."
	name = "pilot voidsuit helmet"
	icon = 'icons/clothing/spacesuit/void/pilot/helmet.dmi'
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)

/obj/item/clothing/suit/space/void/pilot
	desc = "An atmos resistant voidsuit for space and planet exploration."
	name = "pilot voidsuit"
	icon = 'icons/clothing/spacesuit/void/pilot/suit.dmi'
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit,/obj/item/storage/toolbox,/obj/item/storage/briefcase/inflatable,/obj/item/t_scanner,/obj/item/rcd)

/obj/item/clothing/suit/space/void/pilot/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/pilot
	boots = /obj/item/clothing/shoes/magboots

