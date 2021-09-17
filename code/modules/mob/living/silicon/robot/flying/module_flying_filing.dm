/obj/item/robot_module/flying/filing
	name = "filing drone module"
	display_name = "Filing"
	channels = list(
		"Service" = TRUE,
		"Supply" = TRUE
		)
	module_sprites = list("Drone" = 'icons/mob/robots/flying/flying_service.dmi')
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
		/obj/item/megaphone,
		/obj/item/stack/package_wrap/cyborg
	)
	software = list(
		/datum/computer_file/program/wordprocessor,
		/datum/computer_file/program/supply
	)
	emag = /obj/item/stamp/chameleon
	synths = list(/datum/matter_synth/package_wrap)
	skills = list(
		SKILL_LITERACY            = SKILL_ADEPT,
		SKILL_FINANCE             = SKILL_PROF,
		SKILL_COMPUTER            = SKILL_EXPERT,
		SKILL_SCIENCE             = SKILL_EXPERT,
		SKILL_DEVICES             = SKILL_EXPERT
	)

/obj/item/robot_module/flying/filing/finalize_synths()
	. = ..()
	var/datum/matter_synth/package_wrap =       locate() in synths
	var/obj/item/stack/package_wrap/cyborg/PW = locate() in equipment
	PW.synths = list(package_wrap)
