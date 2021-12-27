/datum/map/debug
	default_job_type = /datum/job/debug
	default_department_type = /decl/department/debug
	id_hud_icons = 'maps/debug/hud.dmi'

/datum/job/debug
	title = "Tourist"
	total_positions = -1
	spawn_positions = -1
	supervisors = "your conscience"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/debug_tourist
	department_types = list(/decl/department)

/decl/hierarchy/outfit/job/debug_tourist
	name = "Job - Testing Site Tourist"
