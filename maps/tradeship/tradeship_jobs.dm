/datum/map/tradeship
	default_job_type = /datum/job/standard/assistant/tradeship
	default_department_type = /decl/department/civilian
	default_law_type = /datum/ai_laws/corporate
	allowed_jobs = list(
		/datum/job/standard/assistant/tradeship,
		/datum/job/standard/captain/tradeship,
		/datum/job/tradeship_first_mate,
		/datum/job/standard/cmo/tradeship,
		/datum/job/standard/doctor/tradeship,
		/datum/job/standard/chief_engineer/tradeship,
		/datum/job/standard/engineer/tradeship,
		/datum/job/standard/rd/tradeship,
		/datum/job/standard/scientist/tradeship,
		/datum/job/standard/robot
	)

/obj/machinery/suit_cycler/tradeship
	boots = /obj/item/clothing/shoes/magboots
	req_access = list()
	initial_access = list()
	locked = FALSE

/obj/machinery/suit_cycler/tradeship/Initialize()
	if(prob(75))
		suit = pick(list(
			/obj/item/clothing/suit/space/void/mining,
			/obj/item/clothing/suit/space/void/engineering,
			/obj/item/clothing/suit/space/void/expedition,
			/obj/item/clothing/suit/space/void/excavation,
			/obj/item/clothing/suit/space/void/engineering/salvage
		))
	if(prob(75))
		helmet = pick(list(
			/obj/item/clothing/head/helmet/space/void/mining,
			/obj/item/clothing/head/helmet/space/void/engineering,
			/obj/item/clothing/head/helmet/space/void/expedition,
			/obj/item/clothing/head/helmet/space/void/excavation,
			/obj/item/clothing/head/helmet/space/void/engineering/salvage
		))
	. = ..()
