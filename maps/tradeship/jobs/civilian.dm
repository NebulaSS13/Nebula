/datum/job/standard/assistant/tradeship
	title = "Deck Hand"
	supervisors = "literally everyone, you bottom feeder"
	outfit_type = /decl/outfit/job/tradeship/hand
	alt_titles = list(
		"Cook" = /decl/outfit/job/tradeship/hand/cook,
		"Cargo Hand",
		"Passenger"
	)
	event_categories = list(ASSIGNMENT_GARDENER, ASSIGNMENT_JANITOR)

/datum/job/tradeship_helmsman
	title = "Helmsman"
	hud_icon = 'maps/tradeship/hud.dmi'
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain, so don't mess up!"
	outfit_type = /decl/outfit/job/tradeship/hand
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_PILOT    = SKILL_ADEPT
	)
	max_skill = list(
		SKILL_PILOT    = SKILL_MAX
	)
	skill_points = 10
	department_types = list(/decl/department/civilian)
	economic_power = 1
	access = list(access_bridge)
	minimal_access = list(access_bridge)
