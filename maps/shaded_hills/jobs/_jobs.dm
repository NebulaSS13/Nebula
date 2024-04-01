/datum/map/shaded_hills
	id_hud_icons = 'maps/shaded_hills/icons/hud.dmi'

/decl/hierarchy/outfit/job/shaded_hills
	name = "Shaded Hills Outfit"
	abstract_type = /decl/hierarchy/outfit/job/shaded_hills
	id_type = null
	pda_type = null
	l_ear = null

/decl/hierarchy/outfit/job/shaded_hills/wanderer
	name    = "Shaded Hills - Wanderer"
	uniform = /obj/item/clothing/pants/loincloth
	shoes   = /obj/item/clothing/shoes/sandal

/datum/map/shaded_hills
	allowed_jobs = list(/datum/job/shaded_hills/wanderer)
	default_job_type = /datum/job/shaded_hills/wanderer
	default_department_type = /decl/department/shaded_hills/denizens

/decl/department/shaded_hills
	abstract_type = /decl/department/shaded_hills

/decl/department/shaded_hills/denizens
	name = "Denizens"

/datum/job/shaded_hills
	abstract_type = /datum/job/shaded_hills
	department_types = list(
		/decl/department/shaded_hills/denizens
	)

/datum/job/shaded_hills/wanderer
	title = "Wanderer"
	spawn_positions = -1
	total_positions = -1
	outfit_type = /decl/hierarchy/outfit/job/shaded_hills/wanderer

/obj/abstract/landmark/start/wanderer
	name = "Wanderer"
