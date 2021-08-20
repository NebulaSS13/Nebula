/datum/job/tradeship_deckhand
	title = "Deck Hand"
	event_categories = list("Janitor", "Gardener")
	total_positions = -1
	spawn_positions = -1
	supervisors = "literally everyone, you bottom feeder"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/hand
	alt_titles = list(
		"Cook" = /decl/hierarchy/outfit/job/tradeship/hand/cook,
		"Cargo Hand",
		"Passenger")
	department_types = list(/decl/department/civilian)
	economic_power = 1
	access = list()
	minimal_access = list()
	event_categories = list(ASSIGNMENT_GARDENER, ASSIGNMENT_JANITOR)

/datum/job/tradeship_deckhand/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()
