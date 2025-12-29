/datum/map/ministation
	default_job_type = /datum/job/ministation/wastrel
	default_department_type = /decl/department/wasteland
	id_hud_icons = 'maps/ministation/hud.dmi'
	allowed_jobs = list(
	//Where the NCR homies at
		//Command roles
		/datum/job/ministation/ncr/co,
		/datum/job/ministation/ncr/nco/firstsergeant,
		/datum/job/ministation/ncr/nco/sergeant,
		/datum/job/ministation/ncr/nco,

		//Specialized roles
		/datum/job/ministation/ncr/specialist,

		//Grunts
		/datum/job/ministation/ncr/trooper,
		/datum/job/ministation/ncr,

		//Non-combat roles
		/datum/job/ministation/ncr/osi,
		/datum/job/ministation/ncr/supply,
		/datum/job/ministation/ncr/offduty,

		//Ranger
		/datum/job/ministation/ncr/vetranger,
		/datum/job/ministation/ncr/sgtranger,
		/datum/job/ministation/ncr/ranger,

	//Brotherhood of Sneed
		/datum/job/ministation/bos/headpaladin,
		/datum/job/ministation/bos/headknight,
		/datum/job/ministation/bos/headscribe,
		/datum/job/ministation/bos/snrpaladin,
		/datum/job/ministation/bos/snrknight,
		/datum/job/ministation/bos/snrscribe,
		/datum/job/ministation/bos/paladin,
		/datum/job/ministation/bos/knight,
		/datum/job/ministation/bos/scribe,
		/datum/job/ministation/bos,

	//Town Roles
		/datum/job/ministation/town/alderman,
		/datum/job/ministation/town/merchant,
		/datum/job/ministation/town/provost,
		/datum/job/ministation/town/citizen,


	//Legion
		//Officers
		/datum/job/ministation/legion/centurion,
		/datum/job/ministation/legion/dec/vet,
		/datum/job/ministation/legion/dec/prime,
		/datum/job/ministation/legion/dec,

		//Soldiers
		/datum/job/ministation/legion/vet,
		/datum/job/ministation/legion/prime,
		/datum/job/ministation/legion/recruit,
		/datum/job/ministation/legion/scout,

		//Other
		/datum/job/ministation/legion/camp/auxilia,
		/datum/job/ministation/legion/camp,

	)
