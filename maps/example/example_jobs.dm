/datum/map/example
	default_job_type = /datum/job/example

/datum/job/example
	title = "Tourist"
	total_positions = -1
	spawn_positions = -1
	supervisors = "your conscience"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/example_tourist
	department_types = list(/decl/department/example)

/decl/hierarchy/outfit/job/example_tourist
	name = OUTFIT_JOB_NAME("Example Tourist")
