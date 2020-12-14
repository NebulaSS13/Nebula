/obj/item/robot_module/engineering
	name = "engineering robot module"
	display_name = "Engineering"
	channels = list(
		"Engineering" = 1
	)
	networks = list(
		NETWORK_ENGINEERING
	)
	software = list(
		/datum/computer_file/program/power_monitor,
		/datum/computer_file/program/supermatter_monitor
	)
	supported_upgrades = list(
		/obj/item/borg/upgrade/rcd
	)
	sprites = list(
		"Basic" = "Engineering",
		"Antique" = "engineerrobot",
		"Landmate" = "landmate",
		"Landmate - Treaded" = "engiborg+tread"
	)
	no_slip = 1
	equipment = list(
		/obj/item/flash,
		/obj/item/borg/sight/meson,
		/obj/item/extinguisher,
		/obj/item/weldingtool/largetank,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/multitool,
		/obj/item/t_scanner,
		/obj/item/scanner/gas,
		/obj/item/geiger,
		/obj/item/taperoll/engineering,
		/obj/item/taperoll/atmos,
		/obj/item/lightreplacer,
		/obj/item/paint_sprayer,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/inducer/borg,
		/obj/item/plunger,
		/obj/item/matter_decompiler,
		/obj/item/stack/material/cyborg/steel,
		/obj/item/stack/material/cyborg/aluminium,
		/obj/item/stack/material/rods/cyborg,
		/obj/item/stack/tile/floor/cyborg,
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/material/cyborg/glass/reinforced,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/material/cyborg/plasteel
	)
	can_hold = list(
		/obj/item/cell =                                         TRUE,
		/obj/item/stock_parts/circuitboard/airlock_electronics = TRUE,
		/obj/item/tracker_electronics =                          TRUE,
		/obj/item/stock_parts =                                  TRUE,
		/obj/item/frame =                                        TRUE,
		/obj/item/camera_assembly =                              TRUE,
		/obj/item/tank =                                         TRUE,
		/obj/item/stock_parts/circuitboard =                     TRUE,
		/obj/item/stock_parts/smes_coil =                        TRUE,
		/obj/item/stock_parts/computer =                         TRUE,
		/obj/item/fuel_assembly =                                TRUE,
		/obj/item/stack/material/deuterium =                     TRUE,
		/obj/item/stack/material/tritium =                       TRUE,
		/obj/item/stack/tile =                                   TRUE,
		/obj/item/stack/material =                               FALSE
	)
	synths = list(
		/datum/matter_synth/metal =    60000,
		/datum/matter_synth/glass =    40000,
		/datum/matter_synth/plasteel = 20000,
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

	var/datum/matter_synth/metal/metal =       locate() in synths
	var/datum/matter_synth/glass/glass =       locate() in synths
	var/datum/matter_synth/plasteel/plasteel = locate() in synths
	var/datum/matter_synth/wire/wire =         locate() in synths

	var/obj/item/matter_decompiler/MD = locate() in equipment
	MD.metal = metal
	MD.glass = glass

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/steel,
		 /obj/item/stack/material/cyborg/aluminium,
		 /obj/item/stack/material/rods/cyborg,
		 /obj/item/stack/tile/floor/cyborg,
		 /obj/item/stack/material/cyborg/glass/reinforced
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, metal)

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/glass/reinforced,
		 /obj/item/stack/material/cyborg/glass
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, glass)

	var/obj/item/stack/cable_coil/cyborg/C = locate() in equipment
	C.synths = list(wire)

	var/obj/item/stack/material/cyborg/plasteel/PL = locate() in equipment
	PL.synths = list(plasteel)

/obj/item/robot_module/engineering/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/lightreplacer/LR = locate() in equipment
	LR.Charge(R, amount)
	..()