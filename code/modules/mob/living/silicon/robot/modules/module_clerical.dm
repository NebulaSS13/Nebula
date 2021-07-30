/obj/item/robot_module/clerical
	channels = list(
		"Service" = TRUE
	)
	skills = list(
		SKILL_LITERACY            = SKILL_ADEPT,
		SKILL_FINANCE             = SKILL_PROF,
		SKILL_COMPUTER            = SKILL_EXPERT,
		SKILL_SCIENCE             = SKILL_EXPERT,
		SKILL_DEVICES             = SKILL_EXPERT
	)
	software = list(
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/supply
	)

/obj/item/robot_module/clerical/butler
	name = "service robot module"
	display_name = "Service"
	sprites = list(
		"Waitress" = "Service",
		"Kent" = "toiletbot",
		"Bro" = "Brobot",
		"Rich" = "maximillion",
		"Default" = "Service2"
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/gripper/service,
		/obj/item/chems/glass/bucket,
		/obj/item/minihoe,
		/obj/item/hatchet,
		/obj/item/scanner/plant,
		/obj/item/storage/plants,
		/obj/item/robot_harvester,
		/obj/item/kitchen/rollingpin,
		/obj/item/knife/kitchen,
		/obj/item/crowbar,
		/obj/item/rsf,
		/obj/item/chems/dropper/industrial,
		/obj/item/flame/lighter/zippo,
		/obj/item/storage/tray/robotray,
		/obj/item/chems/borghypo/service
	)
	emag = /obj/item/chems/drinks/bottle/small/beer
	skills = list(
		SKILL_LITERACY            = SKILL_ADEPT,
		SKILL_COMPUTER            = SKILL_EXPERT,
		SKILL_COOKING             = SKILL_PROF,
		SKILL_BOTANY              = SKILL_PROF,
		SKILL_MEDICAL             = SKILL_BASIC,
		SKILL_CHEMISTRY           = SKILL_ADEPT
	)

/obj/item/robot_module/clerical/butler/finalize_equipment()
	. = ..()
	var/obj/item/rsf/M = locate() in equipment
	M.stored_matter = 30
	var/obj/item/flame/lighter/zippo/L = locate() in equipment
	L.lit = 1

/obj/item/robot_module/clerical/butler/finalize_emag()
	. = ..()
	if(emag)
		var/datum/reagents/R = emag.create_reagents(50)
		R.add_reagent(/decl/material/liquid/paralytics, 10)
		R.add_reagent(/decl/material/liquid/sedatives, 15)
		R.add_reagent(/decl/material/liquid/ethanol/beer, 20)
		R.add_reagent(/decl/material/solid/ice, 5)
		emag.SetName("Mickey Finn's Special Brew")

/obj/item/robot_module/general/butler/respawn_consumable(var/mob/living/silicon/robot/R, var/amount)
	..()
	var/obj/item/chems/condiment/enzyme/E = locate() in equipment
	E.reagents.add_reagent(/decl/material/liquid/enzyme, 2 * amount)
	if(emag)
		var/obj/item/chems/drinks/bottle/small/beer/B = emag
		B.reagents.add_reagent(/decl/material/liquid/ethanol/beer, amount * 0.4)
		B.reagents.add_reagent(/decl/material/solid/ice,         amount * 0.1)
		B.reagents.add_reagent(/decl/material/liquid/paralytics,   amount * 0.2)
		B.reagents.add_reagent(/decl/material/liquid/sedatives,    amount * 0.3)

/obj/item/robot_module/clerical/general
	name = "clerical robot module"
	display_name = "Clerical"
	channels = list(
		"Service" = TRUE,
		"Supply" =  TRUE
	)
	sprites = list(
		"Waitress" = "Service",
		"Kent" =     "toiletbot",
		"Bro" =      "Brobot",
		"Rich" =     "maximillion",
		"Default" =  "Service2"
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/pen/robopen,
		/obj/item/form_printer,
		/obj/item/gripper/clerical,
		/obj/item/hand_labeler,
		/obj/item/stamp,
		/obj/item/stamp/denied,
		/obj/item/destTagger,
		/obj/item/crowbar,
		/obj/item/stack/package_wrap/cyborg
	)
	emag = /obj/item/stamp/chameleon
	synths = list(
		/datum/matter_synth/package_wrap
	)

/obj/item/robot_module/clerical/general/finalize_synths()
	. = ..()
	var/datum/matter_synth/package_wrap/wrap = locate() in synths
	var/obj/item/stack/package_wrap/cyborg/wrap_item = locate() in equipment
	wrap_item.synths = list(wrap)
