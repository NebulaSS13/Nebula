/obj/item/robot_module/drone
	name = "drone module"
	hide_on_manifest  = 1
	has_nonslip_feet  = TRUE
	has_magnetic_feet = TRUE
	camera_channels   = list(
		CAMERA_CHANNEL_ENGINEERING
	)
	languages = list(
		/decl/language/human/common = FALSE
	)
	equipment = list(
		/obj/item/weldingtool,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/multitool,
		/obj/item/t_scanner,
		/obj/item/lightreplacer,
		/obj/item/gripper,
		/obj/item/mop/advanced,
		/obj/item/gripper/no_use/loader,
		/obj/item/chems/spray/extinguisher/mini,
		/obj/item/paint_sprayer,
		/obj/item/inducer/borg,
		/obj/item/plunger/unbreakable,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/chems/spray/cleaner/drone,
		/obj/item/borg/sight/hud/jani,
		/obj/item/tank/jetpack/carbondioxide,
		/obj/item/matter_decompiler,
		/obj/item/stack/material/cyborg/steel,
		/obj/item/stack/material/rods/cyborg,
		/obj/item/stack/tile/floor/cyborg,
		/obj/item/stack/tile/roof/cyborg,
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/material/cyborg/glass/reinforced,
		/obj/item/stack/material/cyborg/fiberglass,
		/obj/item/stack/tile/wood/cyborg,
		/obj/item/stack/material/cyborg/wood,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/material/cyborg/plastic
	)
	synths = list(
		/datum/matter_synth/metal =   25000,
		/datum/matter_synth/glass =   25000,
		/datum/matter_synth/wood =    2000,
		/datum/matter_synth/plastic = 1000,
		/datum/matter_synth/wire =    30
	)
	emag = /obj/item/gun/energy/plasmacutter
	skills = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_ATMOS        = SKILL_EXPERT,
		SKILL_ENGINES      = SKILL_EXPERT,
		SKILL_CONSTRUCTION = SKILL_EXPERT,
		SKILL_ELECTRICAL   = SKILL_EXPERT
	)

/obj/item/robot_module/drone/finalize_equipment(var/mob/living/silicon/robot/robot)
	. = ..()
	if(istype(robot))
		robot.set_internals(locate(/obj/item/tank/jetpack/carbondioxide) in equipment)

/obj/item/robot_module/drone/finalize_emag()
	. = ..()
	emag.SetName("Plasma Cutter")

/obj/item/robot_module/drone/finalize_synths()
	. = ..()
	var/datum/matter_synth/metal/metal =     locate() in synths
	var/datum/matter_synth/glass/glass =     locate() in synths
	var/datum/matter_synth/wood/wood =       locate() in synths
	var/datum/matter_synth/plastic/plastic = locate() in synths
	var/datum/matter_synth/wire/wire =       locate() in synths

	var/obj/item/matter_decompiler/MD = locate() in equipment
	MD.metal = metal
	MD.glass = glass
	MD.wood = wood
	MD.plastic = plastic

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/steel,
		 /obj/item/stack/material/rods/cyborg,
		 /obj/item/stack/tile/floor/cyborg,
		 /obj/item/stack/tile/roof/cyborg,
		 /obj/item/stack/material/cyborg/glass/reinforced
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, metal)

	for(var/thing in list(
		 /obj/item/stack/material/cyborg/glass,
		 /obj/item/stack/material/cyborg/glass/reinforced,
		 /obj/item/stack/material/cyborg/fiberglass
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, glass)

	for(var/thing in list(
		 /obj/item/stack/tile/wood/cyborg,
		 /obj/item/stack/material/cyborg/wood
		))
		var/obj/item/stack/stack = locate(thing) in equipment
		LAZYDISTINCTADD(stack.synths, wood)

	var/obj/item/stack/cable_coil/cyborg/C = locate() in equipment
	C.synths = list(wire)

	var/obj/item/stack/material/cyborg/plastic/P = locate() in equipment
	P.synths = list(plastic)

/obj/item/robot_module/drone/respawn_consumable(var/mob/living/silicon/robot/robot, var/amount)
	..()
	var/obj/item/chems/spray/cleaner/drone/SC = locate() in equipment
	SC.add_to_reagents(/decl/material/liquid/cleaner, 8 * amount)
	var/obj/item/lightreplacer/LR = locate() in equipment
	LR.Charge(robot, amount)

/obj/item/robot_module/drone/construction
	name = "construction drone module"
	hide_on_manifest = 1
	channels = list(
		"Engineering" = 1
	)

/obj/item/robot_module/drone/construction/Initialize()
	equipment += /obj/item/rcd/borg
	. = ..()
