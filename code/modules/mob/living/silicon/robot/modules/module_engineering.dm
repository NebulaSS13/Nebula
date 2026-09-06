/obj/item/robot_module/engineering
	name = "engineering robot module"
	display_name = "Engineering"
	channels = list(
		"Engineering" = 1
	)
	camera_channels = list(
		CAMERA_CHANNEL_ENGINEERING
	)
	software = list(
		/datum/computer_file/program/power_monitor
	)
	supported_upgrades = list(
		/obj/item/borg/upgrade/rcd
	)
	module_sprites = list(
		"Basic"              = 'icons/mob/robots/robot_engineer_old.dmi',
		"Antique"            = 'icons/mob/robots/robot_engineer_old_alt.dmi',
		"Landmate"           = 'icons/mob/robots/robot_engineer.dmi',
		"Landmate - Treaded" = 'icons/mob/robots/robot_engineer_treaded.dmi'
	)
	has_nonslip_feet  = TRUE
	has_magnetic_feet = TRUE
	equipment = list(
		/obj/item/flash,
		/obj/item/borg/sight/meson,
		/obj/item/chems/spray/extinguisher,
		/obj/item/weldingtool/largetank,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar/brace_jack,
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
		/obj/item/plunger/unbreakable,
		/obj/item/matter_decompiler,
		/obj/item/stack/material/cyborg/steel,
		/obj/item/stack/material/cyborg/aluminium,
		/obj/item/stack/material/rods/cyborg,
		/obj/item/stack/tile/floor/cyborg,
		/obj/item/stack/tile/roof/cyborg,
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/material/cyborg/glass/reinforced,
		/obj/item/stack/material/cyborg/fiberglass,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/material/cyborg/plasteel
	)
	synths = list(
		/datum/matter_synth/metal =      60000,
		/datum/matter_synth/glass =      40000,
		/datum/matter_synth/plasteel =   20000,
		/datum/matter_synth/wire
	)
	emag = /obj/item/baton/robot/electrified_arm
	skills = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_ATMOS        = SKILL_PROF,
		SKILL_ENGINES      = SKILL_PROF,
		SKILL_CONSTRUCTION = SKILL_PROF,
		SKILL_ELECTRICAL   = SKILL_PROF,
		SKILL_COMPUTER     = SKILL_EXPERT
	)

/obj/item/robot_module/engineering/finalize_synths()

	var/datum/matter_synth/metal/metal =           locate() in synths
	var/datum/matter_synth/glass/glass =           locate() in synths
	var/datum/matter_synth/plasteel/plasteel =     locate() in synths
	var/datum/matter_synth/wire/wire =             locate() in synths

	var/obj/item/matter_decompiler/MD = locate() in equipment
	MD.metal = metal
	MD.glass = glass

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

/obj/item/robot_module/engineering/respawn_consumable(var/mob/living/silicon/robot/robot, var/amount)
	var/obj/item/lightreplacer/LR = locate() in equipment
	LR.Charge(robot, amount)
	..()