// OUTFITS
#define TRADESHIP_OUTFIT_JOB_NAME(job_name) ("Tradeship - Job - " + job_name)

/decl/hierarchy/outfit/job/tradeship
	hierarchy_type = /decl/hierarchy/outfit/job/tradeship
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store_str
	l_ear = null
	r_ear = null

/decl/hierarchy/outfit/job/tradeship/misc/crewman
	name = TRADESHIP_OUTFIT_JOB_NAME("Crewman")
	pda_type = /obj/item/modular_computer/pda/heads/hop
	id_type = /obj/item/card/id/tradeship/misc/crewman
	