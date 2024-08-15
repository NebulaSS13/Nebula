/datum/map/example
	default_job_type = /datum/job/example
	default_department_type = /decl/department/example
	id_hud_icons = 'maps/example/hud.dmi'

/datum/job/example
	title = "Tourist"
	total_positions = -1
	spawn_positions = -1
	supervisors = "your conscience"
	description = "You need to goof off, have fun, and be silly."
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/outfit/job/tourist
	department_types = list(
		/decl/department/example
		)

/decl/outfit/job/tourist
	name = "Job - Testing Site Tourist"
