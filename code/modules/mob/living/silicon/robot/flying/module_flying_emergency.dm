/obj/item/robot_module/flying/emergency
	name = "emergency response drone module"
	display_name = "Emergency Response"
	channels = list("Medical" = TRUE)
	networks = list(NETWORK_MEDICAL)
	subsystems = list(/datum/nano_module/crew_monitor)
	sprites = list(
		"Drone" = "drone-medical",
		"Eyebot" = "eyebot-medical"
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/borg/sight/hud/med,
		/obj/item/scanner/health,
		/obj/item/scanner/reagent/adv,
		/obj/item/chems/borghypo/crisis,
		/obj/item/extinguisher/mini,
		/obj/item/taperoll/medical,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/weldingtool/mini,
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/crowbar,
		/obj/item/wirecutters,
		/obj/item/multitool,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/splint
	)
	synths = list(/datum/matter_synth/medicine = 15000)
	emag = /obj/item/chems/spray
	skills = list(
		SKILL_ANATOMY      = SKILL_BASIC,
		SKILL_MEDICAL      = SKILL_PROF,
		SKILL_EVA          = SKILL_EXPERT,
		SKILL_MECH         = HAS_PERK,
		SKILL_CONSTRUCTION = SKILL_EXPERT,
		SKILL_ELECTRICAL   = SKILL_EXPERT
	)

/obj/item/robot_module/flying/emergency/finalize_emag()
	. = ..()
	emag.reagents.add_reagent(/datum/reagent/acid/polyacid, 250)
	emag.SetName("Polyacid spray")

/obj/item/robot_module/flying/emergency/finalize_equipment()
	. = ..()
	for(var/thing in list(
		 /obj/item/stack/medical/ointment,
		 /obj/item/stack/medical/bruise_pack,
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
		 /obj/item/stack/medical/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.synths = list(medicine)

/obj/item/robot_module/flying/emergency/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/chems/spray/PS = emag
	if(PS && PS.reagents.total_volume < PS.volume)
		var/adding = min(PS.volume-PS.reagents.total_volume, 2*amount)
		if(adding > 0)
			PS.reagents.add_reagent(/datum/reagent/acid/polyacid, adding)
	..()
