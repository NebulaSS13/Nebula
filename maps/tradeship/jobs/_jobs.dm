/datum/job/cyborg
	supervisors = "your laws and the Captain"
	total_positions = 1
	spawn_positions = 1
	alt_titles = list()

/datum/job/assistant
	title = "Deck Hand"
	supervisors = "literally everyone, you bottom feeder"
	outfit_type = /decl/hierarchy/outfit/job/tradeship/hand
	alt_titles = list(
		"Cook" = /decl/hierarchy/outfit/job/tradeship/hand/cook,
		"Cargo Hand",
		"Passenger")
	hud_icon = "hudcargotechnician"

/*
/datum/job/baxxid_advisor
	title = "Baxxid Advisor"
	skill_points = 40
	supervisors = "the elders of your family, the Captain and the Trademaster"
	department_refs = list(
		DEPT_CIVILIAN,
		DEPT_COMMAND
	)
	total_positions = 1
	spawn_positions = 1

/datum/job/baxxid_advisor/is_species_allowed(var/datum/species/S)
	if(S && !istype(S))
		S = all_species[S]
	. = istype(S) && S.name == SPECIES_BAXXID
*/
