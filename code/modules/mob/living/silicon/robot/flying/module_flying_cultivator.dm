/obj/item/robot_module/flying/cultivator
	name = "cultivator drone module"
	display_name = "Cultivator"
	channels = list(
		"Science" = TRUE,
		"Service" = TRUE
	)
	module_sprites = list("Drone" = 'icons/mob/robots/flying/flying_hydro.dmi')

	equipment = list(
		/obj/item/plants,
		/obj/item/wirecutters/clippers,
		/obj/item/tool/hoe/mini/unbreakable,
		/obj/item/tool/axe/hatchet/unbreakable,
		/obj/item/chems/glass/bucket,
		/obj/item/scalpel/laser,
		/obj/item/circular_saw,
		/obj/item/chems/spray/extinguisher,
		/obj/item/gripper/cultivator,
		/obj/item/scanner/plant,
		/obj/item/robot_harvester
	)
	emag = /obj/item/energy_blade/machete
	skills = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_BOTANY    = SKILL_MAX,
		SKILL_COMBAT    = SKILL_EXPERT,
		SKILL_CHEMISTRY = SKILL_EXPERT,
		SKILL_SCIENCE   = SKILL_EXPERT,
	)