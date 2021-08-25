/datum/map/nexus
	default_job_type = /datum/job/nexus_crew
	default_department_type = /decl/department/nexus_crew
	allowed_jobs = list(/datum/job/nexus_crew)
	id_hud_icons = 'maps/nexus/hud.dmi'

/datum/job/nexus_crew
	title = "Nexus Crew"
	total_positions = -1
	spawn_positions = -1
	supervisors = "your conscience"
	economic_power = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/nexus_crew
	department_types = list(/decl/department/nexus_crew)

/decl/hierarchy/outfit/job/nexus_crew
	name = "Job - Nexus Crewmember"
