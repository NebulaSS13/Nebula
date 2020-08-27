/obj/item/robot_module/flying/ascent
	name = "\improper Ascent drone module"
	display_name = "Ascent"
	upgrade_locked = TRUE
	hide_on_manifest = TRUE
	sprites = list(
		"Drone" = "drone-ascent"
	)
	// The duplicate clustertools in this list are so that they can set up to
	// hack doors, windows etc. without having to constantly cycle through tools.
	equipment = list(
		/obj/item/flash,
		/obj/item/gun/energy/particle/small,
		/obj/item/multitool/mantid,
		/obj/item/clustertool,
		/obj/item/clustertool,
		/obj/item/clustertool,
		/obj/item/soap,
		/obj/item/mop/advanced,
		/obj/item/plunger,
		/obj/item/weldingtool/electric/mantid,
		/obj/item/extinguisher,
		/obj/item/t_scanner,
		/obj/item/scanner/gas,
		/obj/item/scanner/health,
		/obj/item/geiger,
		/obj/item/gripper,
		/obj/item/gripper/no_use/loader,
		/obj/item/inducer/borg,
		/obj/item/stack/medical/resin,
		/obj/item/surgicaldrill,
		/obj/item/hemostat,
		/obj/item/bonesetter,
		/obj/item/circular_saw,
		/obj/item/stack/material/cyborg/steel,
		/obj/item/stack/material/cyborg/aluminium,
		/obj/item/stack/material/rods/cyborg,
		/obj/item/stack/tile/floor/cyborg,
		/obj/item/stack/material/cyborg/glass,
		/obj/item/stack/material/cyborg/glass/reinforced,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/material/cyborg/plasteel,
		/obj/item/stack/nanopaste
	)
	synths = list(
		/datum/matter_synth/metal = 	30000,
		/datum/matter_synth/glass = 	20000,
		/datum/matter_synth/plasteel = 	10000,
		/datum/matter_synth/nanite =    10000,
		/datum/matter_synth/wire
	)

	languages = list(
		/decl/language/mantid          = TRUE,
		/decl/language/mantid/nonvocal = TRUE,
		/decl/language/mantid/worldnet = TRUE
	)

	skills = list(
		SKILL_BUREAUCRACY	= SKILL_ADEPT,
		SKILL_FINANCE		= SKILL_EXPERT,
		SKILL_EVA			= SKILL_EXPERT,
		SKILL_MECH			= HAS_PERK,
		SKILL_PILOT			= SKILL_EXPERT,
		SKILL_HAULING		= SKILL_EXPERT,
		SKILL_COMPUTER		= SKILL_EXPERT,
		SKILL_BOTANY		= SKILL_EXPERT,
		SKILL_COOKING		= SKILL_EXPERT,
		SKILL_COMBAT		= SKILL_EXPERT,
		SKILL_WEAPONS		= SKILL_EXPERT,
		SKILL_FORENSICS		= SKILL_EXPERT,
		SKILL_CONSTRUCTION	= SKILL_EXPERT,
		SKILL_ELECTRICAL	= SKILL_EXPERT,
		SKILL_ATMOS			= SKILL_EXPERT,
		SKILL_ENGINES		= SKILL_EXPERT,
		SKILL_DEVICES		= SKILL_EXPERT,
		SKILL_SCIENCE		= SKILL_EXPERT,
		SKILL_MEDICAL		= SKILL_EXPERT,
		SKILL_ANATOMY		= SKILL_EXPERT,
		SKILL_CHEMISTRY		= SKILL_EXPERT
	)

// Copypasted from repair bot - todo generalize this step.
/obj/item/robot_module/flying/ascent/finalize_synths()
	. = ..()
	var/datum/matter_synth/metal/metal =       locate() in synths
	var/datum/matter_synth/glass/glass =       locate() in synths
	var/datum/matter_synth/plasteel/plasteel = locate() in synths
	var/datum/matter_synth/wire/wire =         locate() in synths
	var/datum/matter_synth/nanite/nanite =     locate() in synths

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

	var/obj/item/stack/nanopaste/N = locate() in equipment
	N.synths = list(nanite)

	. = ..()

/obj/item/robot_module/flying/ascent/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/stack/medical/resin/drone/resin = locate() in equipment
	if(!resin)
		resin = new(src, 1)
		equipment += resin
	if(resin.get_amount() < resin.get_max_amount())
		resin.add(1)
	..()

/obj/item/robot_module/flying/ascent/finalize_equipment()
	. = ..()
	var/obj/item/stack/nanopaste/N = locate() in equipment
	N.uses_charge = 1
	N.charge_costs = list(1000)

/mob/living/silicon/robot/flying/ascent
	desc = "A small, sleek, dangerous-looking hover-drone."
	speak_statement = "clicks"
	speak_exclamation = "rasps"
	speak_query = "chirps"
	lawupdate =      FALSE
	scrambledcodes = TRUE
	speed = -2
	icon_state = "drone-ascent"
	spawn_sound = 'mods/ascent/sounds/ascent1.ogg'
	cell =   /obj/item/cell/mantid
	laws =   /datum/ai_laws/ascent
	idcard = /obj/item/card/id/ascent
	module = /obj/item/robot_module/flying/ascent
	req_access = list(access_ascent)
	silicon_radio = null
	var/global/ascent_drone_count = 0

/mob/living/silicon/robot/flying/ascent/add_ion_law(law)
	return FALSE

/mob/living/silicon/robot/flying/ascent/Initialize()
	. = ..()
	remove_language(/decl/language/binary)
	default_language = /decl/language/mantid/nonvocal

/mob/living/silicon/robot/flying/ascent/initialize_components()
	components["actuator"] =       new/datum/robot_component/actuator/ascent(src)
	components["power cell"] =     new/datum/robot_component/cell/ascent(src)
	components["diagnosis unit"] = new/datum/robot_component/diagnosis_unit(src)
	components["armour"] =         new/datum/robot_component/armour/light(src)

// Since they don't have binary, camera or radio to soak
// damage, they get some hefty buffs to cell and actuator.
/datum/robot_component/actuator/ascent
	max_damage = 100
/datum/robot_component/cell/ascent
	max_damage = 100

/mob/living/silicon/robot/flying/ascent/Initialize()
	. = ..()
	name = "[uppertext(pick(GLOB.gyne_geoforms))]-[++ascent_drone_count]"

// Sorry, you're going to have to actually deal with these guys.
/mob/living/silicon/robot/flying/ascent/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	emp_act(2)

/mob/living/silicon/robot/flying/ascent/emp_act(severity)
	confused = min(confused + rand(3, 5), (severity == 1 ? 40 : 30))