/obj/item/robot_module/miner
	name = "miner robot module"
	display_name = "Miner"
	software = list(
		/datum/computer_file/program/supply
	)
	channels = list(
		"Supply" = TRUE,
		"Science" = TRUE
	)
	networks = list(
		NETWORK_MINE
	)
	sprites = list(
		"Basic" = "Miner_old",
		"Advanced Droid" = "droid-miner",
		"Treadhead" = "Miner"
	)
	supported_upgrades = list(
		/obj/item/borg/upgrade/jetpack
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/borg/sight/meson,
		/obj/item/wrench,
		/obj/item/screwdriver,
		/obj/item/storage/ore,
		/obj/item/pickaxe/borgdrill,
		/obj/item/storage/sheetsnatcher/borg,
		/obj/item/scanner/mining,
		/obj/item/crowbar
	)
	can_hold = list(
		/obj/item/cell =                                 TRUE,
		/obj/item/stock_parts =                          TRUE,
		/obj/item/stock_parts/circuitboard/miningdrill = TRUE
	)
	emag = /obj/item/gun/energy/plasmacutter
	skills = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_PILOT        = SKILL_EXPERT,
		SKILL_EVA          = SKILL_PROF,
		SKILL_CONSTRUCTION = SKILL_EXPERT
	)

/obj/item/robot_module/miner/handle_emagged()
	var/obj/item/pickaxe/D = locate(/obj/item/pickaxe/borgdrill) in equipment
	if(D)
		equipment -= D
		qdel(D)
	D = new /obj/item/pickaxe/diamonddrill(src)
	D.canremove = FALSE
	equipment += D
