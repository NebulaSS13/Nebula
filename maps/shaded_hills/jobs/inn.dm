/decl/department/shaded_hills/inn
	name                    = "Inn Workers"
	colour                  = "#404e68"
	display_color           = "#8c96c4"

/datum/job/shaded_hills/inn
	abstract_type           = /datum/job/shaded_hills/inn
	department_types        = list(/decl/department/shaded_hills/inn)

/datum/job/shaded_hills/inn/innkeeper
	title                   = "Innkeeper"
	supervisors             = "your business and self-interest"
	description             = "You are the proprietor of the inn, directing your employees and ensuring guests are treated properly, whatever you think that may mean."
	spawn_positions         = 1
	total_positions         = 1
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/innkeeper
	head_position           = TRUE
	req_admin_notify        = TRUE
	guestbanned             = TRUE
	must_fill               = TRUE
	not_random_selectable   = TRUE
	min_skill               = list(
		// notably: no athletics requirement, and no literacy requirement but i'm less certain on that
		SKILL_FINANCE       = SKILL_BASIC, // at least competent enough to keep the inn running
		SKILL_COOKING       = SKILL_ADEPT, // and should at least be skilled enough to run the inn on their own
	)
	max_skill               = list(
		SKILL_CHEMISTRY     = SKILL_ADEPT, // a bit more leeway than most jobs, but still not as good as the herbalist
	)
	skill_points            = 22
	lock_keys = list(
		"inn backroom" = /decl/material/solid/metla/silver,
		"inn interior" = /decl/material/solid/metal/copper,
		"inn exterior" = /decl/material/solid/metal/iron
	)

/obj/abstract/landmark/start/shaded_hills/innkeeper
	name                    = "Innkeeper"

/datum/job/shaded_hills/inn/inn_worker
	title                   = "Inn Worker"
	supervisors             = "the innkeeper"
	description             = "You work at the inn, though your exact duties are nebulous. You may be a cook in the kitchen, someone who keeps the lanterns lit and the furniture from falling apart, or something else entirely; either way, you have to earn your keep."
	spawn_positions         = 3
	total_positions         = 3
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/inn_worker
	min_skill               = list(
		SKILL_HAULING       = SKILL_BASIC, // must be fit enough to do basic tasks around the inn
		SKILL_COOKING       = SKILL_BASIC, // and should be skilled enough to do basic cooking/farming work
		SKILL_BOTANY        = SKILL_BASIC,
	)
	skill_points            = 18
	lock_keys = list(
		"inn interior" = /decl/material/solid/metal/copper,
		"inn exterior" = /decl/material/solid/metal/iron
	)

/obj/abstract/landmark/start/shaded_hills/inn_worker
	name                    = "Inn Worker"

/datum/job/shaded_hills/inn/bartender
	title                   = "Bartender"
	supervisors             = "the innkeeper"
	description             = "You work the bar at the inn and ensure that patrons are fed, slaked, and merry. If you keep the hearth lit and prepare fresh food and drink, you will certainly earn your keep."
	spawn_positions         = 2
	total_positions         = 2
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/bartender
	min_skill               = list(
		SKILL_COOKING       = SKILL_EXPERT // skilled with food and drink
	)
	skill_points            = 18
	lock_keys = list(
		"inn interior" = /decl/material/solid/metal/copper,
		"inn exterior" = /decl/material/solid/metal/iron
	)

/obj/abstract/landmark/start/shaded_hills/bartender
	name                    = "Bartender"

/datum/job/shaded_hills/inn/farmer
	title                   = "Farmer"
	supervisors             = "your self-interest"
	description             = "You grow crops both for your own subsistence and to sell to others like the innkeeper or general store. You are knowledgeable of local plants grown for sustenance, but your knowledge of niche herbs may be spottier."
	spawn_positions         = 3
	total_positions         = 3
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/farmer
	min_skill               = list(
		SKILL_HAULING       = SKILL_ADEPT, // farming can be demanding work
		SKILL_BOTANY        = SKILL_ADEPT, // must be skilled enough to have plants reliably survive when planted
	)
	skill_points            = 18
	lock_keys = list(
		"farmhouse" = /decl/material/solid/metal/copper
	)

/obj/abstract/landmark/start/shaded_hills/farmer
	name                    = "Farmer"
