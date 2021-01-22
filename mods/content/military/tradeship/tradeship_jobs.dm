/datum/job
	allowed_branches = list(
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
	)
	required_language = /decl/language/human/common

/datum/map/tradeship
	default_law_type = /datum/ai_laws/corporate
	default_assistant_title = "Crewman"
	allowed_jobs = list(
		/datum/job/tradeship_commanding_officer, /datum/job/tradeship_executive_officer, /datum/job/tradeship_bridge_officer, /datum/job/tradeship_enlisted_advisor,
		/datum/job/tradeship_cso, /datum/job/tradeship_roboticist, /datum/job/tradeship_scientist,
		/datum/job/tradeship_pathfinder, /datum/job/tradeship_pilot, /datum/job/tradeship_explorer,
		/datum/job/tradeship_ce, /datum/job/tradeship_engineer,
		/datum/job/tradeship_cmo, /datum/job/tradeship_physician, /datum/job/tradeship_medical_technician, 
		/datum/job/tradeship_cos, /datum/job/tradeship_brig_chief, /datum/job/tradeship_forensic_technician, /datum/job/tradeship_security_guard,
		/datum/job/tradeship_quartermaster, /datum/job/tradeship_cargo_technician, /datum/job/tradeship_prospector,
		/datum/job/tradeship_bartender, /datum/job/tradeship_cook, /datum/job/tradeship_chaplain, /datum/job/tradeship_janitor
	)

/obj/machinery/suit_cycler/tradeship
	boots = /obj/item/clothing/shoes/magboots
	req_access = list()

/obj/machinery/suit_cycler/tradeship/Initialize()
	if(prob(75))
		suit = pick(list(
			/obj/item/clothing/suit/space/void/mining, 
			/obj/item/clothing/suit/space/void/engineering, 
			/obj/item/clothing/suit/space/void/pilot, 
			/obj/item/clothing/suit/space/void/excavation, 
			/obj/item/clothing/suit/space/void/engineering/salvage
		))
	if(prob(75))
		helmet = pick(list(
			/obj/item/clothing/head/helmet/space/void/mining, 
			/obj/item/clothing/head/helmet/space/void/engineering, 
			/obj/item/clothing/head/helmet/space/void/pilot, 
			/obj/item/clothing/head/helmet/space/void/excavation, 
			/obj/item/clothing/head/helmet/space/void/engineering/salvage
		))
	. = ..()