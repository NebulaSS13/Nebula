/obj/item/robot_module/flying/repair
	name = "repair drone module"
	display_name = "Repair"
	channels = list ("Engineering" = TRUE)
	camera_channels = list(CAMERA_CHANNEL_ENGINEERING)
	software = list(
		/datum/computer_file/program/power_monitor
	)
	module_sprites = list(
		"Drone" = 'icons/mob/robots/flying/flying_engineering.dmi',
		"Eyebot" = 'icons/mob/robots/flying/eyebot_engineering.dmi'
	)
	equipment = list(
		/obj/item/borg/sight/meson,
		/obj/item/chems/spray/extinguisher,
		/obj/item/weldingtool/largetank,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/multitool,
		/obj/item/t_scanner,
		/obj/item/scanner/gas,
		/obj/item/geiger,
		/obj/item/stack/tape_roll/barricade_tape/engineering,
		/obj/item/stack/tape_roll/barricade_tape/atmos,
		/obj/item/gripper,
		/obj/item/gripper/no_use/loader,
		/obj/item/lightreplacer,
		/obj/item/paint_sprayer,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/inducer/borg,
		/obj/item/stack/material/cyborg/steel,
		/obj/item/stack/material/cyborg/aluminium,
		/obj/item/stack/material/rods/cyborg,
		/obj/item/stack/tile/floor/cyborg,
		/obj/item/stack/tile/roof/cyborg,
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/material/cyborg/glass/reinforced,
		/obj/item/stack/material/cyborg/fiberglass,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/material/cyborg/plasteel,
		/obj/item/plunger/unbreakable
	)
	synths = list(
		/datum/matter_synth/metal = 	 30000,
		/datum/matter_synth/glass = 	 20000,
		/datum/matter_synth/plasteel = 	 10000,
		/datum/matter_synth/wire
	)
	emag = /obj/item/baton/robot/electrified_arm
	skills = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_ATMOS        = SKILL_PROF,
		SKILL_ENGINES      = SKILL_PROF,
		SKILL_CONSTRUCTION = SKILL_PROF,
		SKILL_ELECTRICAL   = SKILL_PROF
	)

/obj/item/robot_module/flying/repair/finalize_synths()
	. = ..()
	var/datum/matter_synth/metal/metal =           locate() in synths
	var/datum/matter_synth/glass/glass =           locate() in synths
	var/datum/matter_synth/plasteel/plasteel =     locate() in synths
	var/datum/matter_synth/wire/wire =             locate() in synths

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/steel,
		 /obj/item/stack/material/cyborg/aluminium,
		 /obj/item/stack/material/rods/cyborg,
		 /obj/item/stack/tile/floor/cyborg,
		 /obj/item/stack/tile/roof/cyborg,
		 /obj/item/stack/material/cyborg/glass/reinforced
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, metal)

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/glass/reinforced,
		 /obj/item/stack/material/cyborg/glass,
		 /obj/item/stack/material/cyborg/fiberglass
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, glass)

	var/obj/item/stack/cable_coil/cyborg/C = locate() in equipment
	C.synths = list(wire)

	var/obj/item/stack/material/cyborg/plasteel/PL = locate() in equipment
	PL.synths = list(plasteel)
	. = ..()

/obj/item/robot_module/flying/repair/respawn_consumable(var/mob/living/silicon/robot/robot, var/amount)
	var/obj/item/lightreplacer/LR = locate() in equipment
	if(LR)
		LR.Charge(robot, amount)
	..()
