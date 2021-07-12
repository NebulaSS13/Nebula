/obj/item/robot_module/medical
	name = "medical robot module"
	associated_department = /decl/department/medical
	channels = list(
		"Medical" = TRUE
	)
	networks = list(
		NETWORK_MEDICAL
	)
	software = list(
		/datum/computer_file/program/crew_manifest
	)
	can_be_pushed = 0

/obj/item/robot_module/medical/build_equipment()
	. = ..()
	equipment += new /obj/item/robot_rack/roller(src, 1)

/obj/item/robot_module/medical/surgeon
	name = "surgeon robot module"
	display_name = "Surgeon"
	sprites = list(
		"Basic" = "Medbot",
		"Standard" = "surgeon",
		"Advanced Droid" = "droid-medical",
		"Needles" = "medicalrobot"
		)
	equipment = list(
		/obj/item/flash,
		/obj/item/borg/sight/hud/med,
		/obj/item/scanner/health,
		/obj/item/chems/borghypo/surgeon,
		/obj/item/incision_manager,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/cautery,
		/obj/item/bonegel,
		/obj/item/sutures,
		/obj/item/bonesetter,
		/obj/item/circular_saw,
		/obj/item/surgicaldrill,
		/obj/item/gripper/organ,
		/obj/item/shockpaddles/robot,
		/obj/item/crowbar,
		/obj/item/stack/nanopaste,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/chems/dropper
	)
	synths = list(
		/datum/matter_synth/medicine = 10000,
	)
	emag = /obj/item/chems/spray
	skills = list(
		SKILL_LITERACY    = SKILL_ADEPT,
		SKILL_ANATOMY     = SKILL_PROF,
		SKILL_MEDICAL     = SKILL_EXPERT,
		SKILL_CHEMISTRY   = SKILL_ADEPT,
		SKILL_DEVICES     = SKILL_EXPERT
	)

/obj/item/robot_module/medical/surgeon/finalize_equipment()
	. = ..()
	for(var/thing in list(
		 /obj/item/stack/nanopaste,
		 /obj/item/stack/medical/advanced/bruise_pack
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.uses_charge = 1
		stack.charge_costs = list(1000)

/obj/item/robot_module/medical/surgeon/finalize_emag()
	. = ..()
	emag.reagents.add_reagent(/decl/material/liquid/acid/polyacid, 250)
	emag.SetName("Polyacid spray")

/obj/item/robot_module/medical/surgeon/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	for(var/thing in list(
		 /obj/item/stack/nanopaste,
		 /obj/item/stack/medical/advanced/bruise_pack
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.synths = list(medicine)

/obj/item/robot_module/medical/surgeon/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	if(emag)
		var/obj/item/chems/spray/PS = emag
		PS.reagents.add_reagent(/decl/material/liquid/acid/polyacid, 2 * amount)
	..()

/obj/item/robot_module/medical/crisis
	name = "crisis robot module"
	display_name = "Crisis"
	sprites = list(
		"Basic" = "Medbot",
		"Standard" = "surgeon",
		"Advanced Droid" = "droid-medical",
		"Needles" = "medicalrobot"
	)
	equipment = list(
		/obj/item/crowbar,
		/obj/item/flash,
		/obj/item/borg/sight/hud/med,
		/obj/item/scanner/health,
		/obj/item/scanner/reagent/adv,
		/obj/item/robot_rack/body_bag,
		/obj/item/chems/borghypo/crisis,
		/obj/item/shockpaddles/robot,
		/obj/item/chems/dropper/industrial,
		/obj/item/chems/syringe,
		/obj/item/gripper/chemistry,
		/obj/item/extinguisher/mini,
		/obj/item/taperoll/medical,
		/obj/item/inflatable_dispenser/robot,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/splint
	)
	synths = list(
		/datum/matter_synth/medicine = 15000
	)
	emag = /obj/item/chems/spray
	skills = list(
		SKILL_LITERACY    = SKILL_ADEPT,
		SKILL_ANATOMY     = SKILL_BASIC,
		SKILL_MEDICAL     = SKILL_PROF,
		SKILL_CHEMISTRY   = SKILL_ADEPT,
		SKILL_EVA         = SKILL_EXPERT
	)

/obj/item/robot_module/medical/crisis/finalize_equipment()
	. = ..()
	for(var/thing in list(
		 /obj/item/stack/medical/ointment,
		 /obj/item/stack/medical/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.uses_charge = 1
		stack.charge_costs = list(1000)

/obj/item/robot_module/medical/crisis/finalize_emag()
	. = ..()
	emag.reagents.add_reagent(/decl/material/liquid/acid/polyacid, 250)
	emag.SetName("Polyacid spray")

/obj/item/robot_module/medical/crisis/finalize_synths()
	. = ..()
	var/datum/matter_synth/medicine/medicine = locate() in synths
	for(var/thing in list(
		 /obj/item/stack/medical/ointment,
		 /obj/item/stack/medical/bruise_pack,
		 /obj/item/stack/medical/splint
		))
		var/obj/item/stack/medical/stack = locate(thing) in equipment
		stack.synths = list(medicine)

/obj/item/robot_module/medical/crisis/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	var/obj/item/chems/syringe/S = locate() in equipment
	if(S.mode == 2)
		S.reagents.clear_reagents()
		S.mode = initial(S.mode)
		S.desc = initial(S.desc)
		S.update_icon()
	if(emag)
		var/obj/item/chems/spray/PS = emag
		PS.reagents.add_reagent(/decl/material/liquid/acid/polyacid, 2 * amount)
	..()
