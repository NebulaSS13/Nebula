/obj/item/robot_module/syndicate
	name = "illegal robot module"
	display_name = "Illegal"
	hide_on_manifest = 1
	upgrade_locked = TRUE
	module_sprites = list(
		"Dread" = 'icons/mob/robots/robot_security.dmi'
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/energy_blade/sword,
		/obj/item/gun/energy/laser,
		/obj/item/crowbar,
		/obj/item/card/emag,
		/obj/item/tank/jetpack/carbondioxide
	)
	var/id

/obj/item/robot_module/syndicate/Initialize()
	for(var/decl/skill/skill in global.using_map.get_available_skills())
		skills[skill.type] = SKILL_EXPERT
	. = ..()

/obj/item/robot_module/syndicate/build_equipment(var/mob/living/silicon/robot/R)
	. = ..()
	id = R.idcard
	equipment += id

/obj/item/robot_module/syndicate/finalize_equipment(var/mob/living/silicon/robot/R)
	R.internals = locate(/obj/item/tank/jetpack/carbondioxide) in equipment
	. = ..()

/obj/item/robot_module/syndicate/Destroy()
	equipment -= id
	id = null
	. = ..()
