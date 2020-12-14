/obj/item/robot_module/research
	name = "research module"
	display_name = "Research"
	channels = list(
		"Science" = TRUE
	)
	networks = list(
		NETWORK_RESEARCH
	)
	sprites = list(
		"Droid" = "droid-science"
	)
	can_hold = list(
		/obj/item/cell =                         TRUE,
		/obj/item/stock_parts =                  TRUE,
		/obj/item/mmi =                          TRUE,
		/obj/item/robot_parts =                  TRUE,
		/obj/item/borg/upgrade =                 TRUE,
		/obj/item/flash =                        TRUE,
		/obj/item/organ/internal/brain =         TRUE,
		/obj/item/organ/internal/posibrain =     TRUE,
		/obj/item/stack/cable_coil =             TRUE,
		/obj/item/stock_parts/circuitboard =     TRUE,
		/obj/item/slime_extract =                TRUE,
		/obj/item/chems/glass =                  TRUE,
		/obj/item/chems/food/snacks/monkeycube = TRUE,
		/obj/item/stock_parts/computer =         TRUE,
		/obj/item/transfer_valve =               TRUE,
		/obj/item/assembly/signaler =            TRUE,
		/obj/item/assembly/timer =               TRUE,
		/obj/item/assembly/igniter =             TRUE,
		/obj/item/assembly/infra =               TRUE,
		/obj/item/tank =                         TRUE,
		/obj/item/stack/material =               FALSE
	)
	equipment = list(
		/obj/item/flash,
		/obj/item/portable_destructive_analyzer,
		/obj/item/robotanalyzer,
		/obj/item/card/robot,
		/obj/item/wrench,
		/obj/item/screwdriver,
		/obj/item/weldingtool/mini,
		/obj/item/wirecutters,
		/obj/item/crowbar,
		/obj/item/scalpel/laser3,
		/obj/item/circular_saw,
		/obj/item/extinguisher/mini,
		/obj/item/chems/syringe,
		/obj/item/stack/nanopaste
	)
	can_hold = list(
		/obj/item/chems/glass =         TRUE,
		/obj/item/chems/pill =          TRUE,
		/obj/item/chems/ivbag =         TRUE,
		/obj/item/storage/pill_bottle = TRUE
	)
	synths = list(
		/datum/matter_synth/nanite = 10000
	)
	emag = /obj/prefab/hand_teleporter
	skills = list(
		SKILL_LITERACY            = SKILL_ADEPT,
		SKILL_FINANCE             = SKILL_EXPERT,
		SKILL_COMPUTER            = SKILL_PROF,
		SKILL_SCIENCE             = SKILL_PROF,
		SKILL_DEVICES             = SKILL_PROF,
		SKILL_ANATOMY             = SKILL_ADEPT,
		SKILL_CHEMISTRY           = SKILL_ADEPT,
		SKILL_BOTANY              = SKILL_EXPERT,
		SKILL_ELECTRICAL          = SKILL_EXPERT
	)
/obj/item/robot_module/research/finalize_equipment()
	. = ..()
	var/obj/item/stack/nanopaste/N = locate() in equipment
	N.uses_charge = 1
	N.charge_costs = list(1000)

/obj/item/robot_module/research/finalize_synths()
	. = ..()
	var/datum/matter_synth/nanite/nanite = locate() in synths
	var/obj/item/stack/nanopaste/N = locate() in equipment
	N.synths = list(nanite)
