/obj/item/robot_module/flying/emergency
	name = "emergency response drone module"
	display_name = "Emergency Response"
	channels = list("Medical" = TRUE)
	camera_channels = list(CAMERA_CHANNEL_MEDICAL)
	software = list(
		/datum/computer_file/program/suit_sensors
	)
	module_sprites = list(
		"Drone" = 'icons/mob/robots/flying/flying_medical.dmi',
		"Eyebot" = 'icons/mob/robots/flying/eyebot_medical.dmi'
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/borg/sight/hud/med,
		/obj/item/scanner/health,
		/obj/item/scanner/breath,
		/obj/item/scanner/reagent/adv,
		/obj/item/chems/borghypo/crisis,
		/obj/item/chems/spray/extinguisher/mini,
		/obj/item/stack/tape_roll/barricade_tape/medical,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/weldingtool/mini,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/multitool,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/bandage,
		/obj/item/stack/medical/splint
	)
	synths = list(/datum/matter_synth/medicine = 15000)
	emag = /obj/item/chems/spray
	skills = list(
		SKILL_LITERACY     = SKILL_ADEPT,
		SKILL_ANATOMY      = SKILL_BASIC,
		SKILL_MEDICAL      = SKILL_PROF,
		SKILL_EVA          = SKILL_EXPERT,
		SKILL_CONSTRUCTION = SKILL_EXPERT,
		SKILL_ELECTRICAL   = SKILL_EXPERT
	)

/obj/item/robot_module/flying/emergency/finalize_emag()
	. = ..()
	emag.add_to_reagents(/decl/material/liquid/acid/polyacid, 250)
	emag.SetName("Polyacid spray")

/obj/item/robot_module/flying/emergency/finalize_equipment()
	. = ..()
	for(var/thing in list(
		 /obj/item/stack/medical/ointment,
		 /obj/item/stack/medical/bandage,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.uses_charge = 1
		stack.charge_costs = list(1000)

/obj/item/robot_module/flying/emergency/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	for(var/thing in list(
		 /obj/item/stack/medical/ointment,
		 /obj/item/stack/medical/bandage,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.synths = list(medicine)

/obj/item/robot_module/flying/emergency/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/chems/spray/PS = emag
	if(PS && PS.reagents.total_volume < PS.volume)
		var/adding = min(PS.volume-PS.reagents.total_volume, 2*amount)
		if(adding > 0)
			PS.add_to_reagents(/decl/material/liquid/acid/polyacid, adding)
	..()
