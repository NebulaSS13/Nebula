/datum/job/submap/bearcat_captain
	title = "Independant Captain"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/bearcat/captain
	supervisors = "your bottom line"
	info = "Your ship has suffered a catastrophic amount of damage, leaving it dark and crippled in the depths of \
	unexplored space. The Captain is dead, leaving you, previously the First Mate in charge. Organize what's left of \
	your crew, and maybe you'll be able to survive long enough to be rescued."

/datum/job/submap/bearcat_crewman
	title = "Independant Crewman"
	supervisors = "the Captain"
	total_positions = 3
	outfit_type = /decl/hierarchy/outfit/job/bearcat/crew
	info = "Your ship has suffered a catastrophic amount of damage, leaving it dark and crippled in the depths of \
	unexplored space. Work together with the Acting Captain and what's left of the crew, and maybe you'll be able \
	to survive long enough to be rescued."

/decl/hierarchy/outfit/job/bearcat
	abstract_type = /decl/hierarchy/outfit/job/bearcat
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store_str
	r_pocket = /obj/item/radio
	l_ear = null
	r_ear = null

/decl/hierarchy/outfit/job/bearcat/crew
	name = "Bearcat - Job - FTU Crew"
	id_type = /obj/item/card/id/bearcat

/decl/hierarchy/outfit/job/bearcat/captain
	name     = "Bearcat - Job - FTU Captain"
	pants    = /obj/item/clothing/pants/baggy/casual/classicjeans
	uniform  = /obj/item/clothing/shirt/hawaii/random
	shoes    = /obj/item/clothing/shoes/color/black
	pda_type = /obj/item/modular_computer/pda/heads/captain
	id_type  = /obj/item/card/id/bearcat_captain

/obj/abstract/submap_landmark/spawnpoint/captain
	name = "Independant Captain"

/obj/abstract/submap_landmark/spawnpoint/crewman
	name = "Independant Crewman"
