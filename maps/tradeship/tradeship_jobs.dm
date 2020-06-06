/datum/map/tradeship
	default_assistant_title = "Deck Hand"
	allowed_jobs = list(
		/datum/job/tradeship_captain,
		/datum/job/tradeship_engineer/head,
		/datum/job/tradeship_doctor,
		/datum/job/tradeship_researcher/head,
		/datum/job/tradeship_first_mate,
		/datum/job/cyborg,
		/datum/job/assistant,
		/datum/job/tradeship_engineer,
		/datum/job/tradeship_doctor/head,
		/datum/job/tradeship_researcher,
		/datum/job/yinglet/worker,
		/datum/job/yinglet/scout,
		/datum/job/yinglet/patriarch,
		/datum/job/yinglet/matriarch
	)
	species_to_job_whitelist = list(
		/datum/species/baxxid = list(
			/datum/job/assistant
		),
		/datum/species/yinglet = list(
			/datum/job/yinglet/worker,
			/datum/job/yinglet/scout,
			/datum/job/yinglet/patriarch,
			/datum/job/yinglet/matriarch,
			/datum/job/assistant,
			/datum/job/tradeship_engineer,
			/datum/job/cyborg,
			/datum/job/tradeship_doctor,
			/datum/job/tradeship_researcher
		),
		/datum/species/yinglet/southern = list(
			/datum/job/yinglet/worker,
			/datum/job/yinglet/scout,
			/datum/job/yinglet/patriarch,
			/datum/job/yinglet/matriarch,
			/datum/job/assistant,
			/datum/job/tradeship_engineer,
			/datum/job/cyborg,
			/datum/job/tradeship_doctor,
			/datum/job/tradeship_researcher
		)
	)
