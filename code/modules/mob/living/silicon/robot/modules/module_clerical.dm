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
	module_sprites = list(
		"Waitress" = 'icons/mob/robots/robot_service_old.dmi',
		"Kent" =     'icons/mob/robots/robot_toiletbot.dmi',
		"Bro" =      'icons/mob/robots/robot_service_bro.dmi',
		"Rich" =     'icons/mob/robots/robot_maximillion.dmi',
		"Default" =  'icons/mob/robots/robot_service.dmi'
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/gripper/service,
		/obj/item/chems/glass/bucket,
		/obj/item/tool/hoe/mini,
		/obj/item/tool/axe/hatchet,
		/obj/item/scanner/plant,
		/obj/item/plants,
		/obj/item/robot_harvester,
		/obj/item/rollingpin,
		/obj/item/knife/kitchen,
		/obj/item/crowbar,
		/obj/item/rsf,
		/obj/item/chems/dropper/industrial,
		/obj/item/flame/fuelled/lighter/zippo,
		/obj/item/plate/tray/robotray,
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
	var/obj/item/flame/fuelled/lighter/zippo/L = locate() in equipment
	L.lit = TRUE

/obj/item/robot_module/clerical/butler/finalize_emag()
	. = ..()
	if(emag)
		var/datum/reagents/reagent = emag.create_reagents(50)
		reagent.add_reagent(/decl/material/liquid/paralytics, 10)
		reagent.add_reagent(/decl/material/liquid/sedatives, 15)
		reagent.add_reagent(/decl/material/liquid/alcohol/beer, 20)
		reagent.add_reagent(/decl/material/solid/ice, 5)
		emag.SetName("Mickey Finn's Special Brew")

/obj/item/robot_module/general/butler/respawn_consumable(var/mob/living/silicon/robot/robot, var/amount)
	..()
	var/obj/item/chems/condiment/enzyme/E = locate() in equipment
	E.add_to_reagents(/decl/material/liquid/enzyme, 2 * amount)
	if(emag)
		var/obj/item/chems/drinks/bottle/small/beer/B = emag
		B.add_to_reagents(/decl/material/liquid/alcohol/beer, amount * 0.4)
		B.add_to_reagents(/decl/material/solid/ice,         amount * 0.1)
		B.add_to_reagents(/decl/material/liquid/paralytics,   amount * 0.2)
		B.add_to_reagents(/decl/material/liquid/sedatives,    amount * 0.3)

/obj/item/robot_module/clerical/general
	name = "clerical robot module"
	display_name = "Clerical"
	channels = list(
		"Service" = TRUE,
		"Supply" =  TRUE
	)
	module_sprites = list(
		"Waitress" = 'icons/mob/robots/robot_service_old.dmi',
		"Kent" =     'icons/mob/robots/robot_toiletbot.dmi',
		"Bro" =      'icons/mob/robots/robot_service_bro.dmi',
		"Rich" =     'icons/mob/robots/robot_maximillion.dmi',
		"Default" =  'icons/mob/robots/robot_service.dmi'
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
