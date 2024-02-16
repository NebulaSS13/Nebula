/decl/hierarchy/outfit/shaded_hills
	abstract_type = /decl/hierarchy/outfit/shaded_hills

/decl/hierarchy/outfit/shaded_hills/wanderer
	name    = "Shaded Hills - Wanderer"
	uniform = /obj/item/clothing/pants/loincloth
	shoes   = /obj/item/clothing/shoes/sandal

/datum/map/shaded_hills
	allowed_jobs = list(/datum/job/shaded_hills/wanderer)
	default_job_type = /datum/job/shaded_hills/wanderer
	default_department_type = /decl/department/shaded_hills

/decl/department/shaded_hills
	abstract_type = /decl/department/shaded_hills

/decl/department/shaded_hills
	name = "Denizens"

/datum/job/shaded_hills
	abstract_type = /datum/job/shaded_hills

/datum/job/shaded_hills/wanderer
	title = "Wanderer"
	spawn_positions = -1
	total_positions = -1
	outfit_type = /decl/hierarchy/outfit/shaded_hills/wanderer

/obj/abstract/landmark/start/wanderer
	name = "Wanderer"
