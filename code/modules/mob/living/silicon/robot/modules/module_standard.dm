/obj/item/robot_module/standard
	name = "standard robot module"
	display_name = "Standard"
	module_sprites = list(
		"Basic" =   'icons/mob/robots/robot_old.dmi',
		"Android" = 'icons/mob/robots/robot_droid.dmi',
		"Default" = 'icons/mob/robots/robot.dmi'
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/chems/spray/extinguisher,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/scanner/health
	)
	emag = /obj/item/energy_blade/sword
	skills = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_COMBAT       = SKILL_ADEPT,
		SKILL_MEDICAL      = SKILL_ADEPT,
		SKILL_CONSTRUCTION = SKILL_ADEPT
	)
