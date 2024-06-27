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
	camera_channels = list(
		CAMERA_CHANNEL_MINE
	)
	module_sprites = list(
		"Basic"          = 'icons/mob/robots/robot_miner_old.dmi',
		"Advanced Droid" = 'icons/mob/robots/robot_droid_miner.dmi',
		"Treadhead"      = 'icons/mob/robots/robot_miner.dmi'
	)
	supported_upgrades = list(
		/obj/item/borg/upgrade/jetpack
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/borg/sight/meson,
		/obj/item/wrench,
		/obj/item/screwdriver,
		/obj/item/ore,
		/obj/item/tool/drill/advanced,
		/obj/item/sheetsnatcher/borg,
		/obj/item/gripper/miner,
		/obj/item/scanner/mining,
		/obj/item/crowbar
	)
	emag = /obj/item/gun/energy/plasmacutter
	skills = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_PILOT        = SKILL_EXPERT,
		SKILL_EVA          = SKILL_PROF,
		SKILL_CONSTRUCTION = SKILL_EXPERT
	)

/obj/item/robot_module/miner/handle_emagged()
	var/obj/item/tool/drill/advanced/D = locate() in equipment
	if(D)
		equipment -= D
		qdel(D)
	D = new /obj/item/tool/drill/diamond(src)
	D.canremove = FALSE
	equipment += D
