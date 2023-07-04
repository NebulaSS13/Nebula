/datum/job/assistant
	title = "Civilian"
	total_positions = -1
	spawn_positions = -1
	supervisors = "Whoever you allow"
	economic_power = 1
	access = list()
	minimal_access = list()
	alt_titles = list("Resident","Tourist","Socialite","Visitor", "Expat", "Entrepreneur")
	outfit_type = /decl/hierarchy/outfit/job/assistant
	department_types = list(/decl/department/civilian)

/datum/job/assistant/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()

/decl/hierarchy/outfit/job/assistant
	name = "Job - Civilian"

/datum/job/chaplain
	title = "Chaplain"
	department_types = list(/decl/department/civilian)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the District Council, and your faith"
	access = list(
		access_morgue,
		access_chapel_office,
		access_crematorium,
		access_maint_tunnels
	)
	minimal_access = list(
		access_morgue,
		access_chapel_office,
		access_crematorium
	)
	alt_titles = list("Priest","Rabbi","Imam","Faith Counselor","Preacher")
	outfit_type = /decl/hierarchy/outfit/job/chaplain
	is_holy = TRUE
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_BASIC
	)
	skill_points = 20
	software_on_spawn = list(/datum/computer_file/program/reports)

//Food
/datum/job/bartender
	title = "Bartender"
	department_types = list(/decl/department/service)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the District Clerk"
	access = list(
		access_hydroponics,
		access_bar,
		access_kitchen
	)
	minimal_access = list(access_bar)
	alt_titles = list("Waiting Staff","Barkeep","Mixologist","Barista")
	outfit_type = /decl/hierarchy/outfit/job/service/bartender
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_COOKING   = SKILL_BASIC,
		SKILL_BOTANY    = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_BASIC
	)

/datum/job/chef
	title = "Chef"
	department_types = list(/decl/department/service)
	total_positions = 2
	spawn_positions = 2
	supervisors = "the District Clerk"
	access = list(
		access_hydroponics,
		access_bar,
		access_kitchen
	)
	minimal_access = list(access_kitchen)
	alt_titles = list("Restaurant Cashier","Cook","Restaurant Host")
	outfit_type = /decl/hierarchy/outfit/job/service/chef
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_COOKING   = SKILL_ADEPT,
		SKILL_BOTANY    = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_BASIC
	)

/datum/job/hydro
	title = "Gardener"
	department_types = list(/decl/department/service)
	total_positions = 2
	spawn_positions = 1
	supervisors = "the district clerk"
	access = list(
		access_hydroponics,
		access_bar,
		access_kitchen
	)
	minimal_access = list(access_hydroponics)
	alt_titles = list("Botanist")
	outfit_type = /decl/hierarchy/outfit/job/service/gardener
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_BOTANY    = SKILL_BASIC,
		SKILL_CHEMISTRY = SKILL_BASIC
	)
	event_categories = list(ASSIGNMENT_GARDENER)

//Cargo
/datum/job/qm
	title = "Shipping Manager"
	department_types = list(/decl/department/supply)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Admiralty Shipping Home Office."
	economic_power = 5
	access = list(
		access_maint_tunnels,
		access_mailsorting,
		access_cargo,
		access_cargo_bot,
		access_qm,
		access_mining,
		access_mining_station
	)
	minimal_access = list(
		access_maint_tunnels,
		access_mailsorting,
		access_cargo,
		access_cargo_bot,
		access_qm,
		access_mining,
		access_mining_station
	)
	minimal_player_age = 3
	ideal_character_age = 40
	alt_titles = list("Supply Chief", "Delivery Post Supervisor")
	outfit_type = /decl/hierarchy/outfit/job/cargo/qm
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_BASIC,
		SKILL_HAULING  = SKILL_BASIC,
		SKILL_EVA      = SKILL_BASIC,
		SKILL_PILOT    = SKILL_BASIC
	)
	max_skill = list(
		SKILL_PILOT    = SKILL_MAX
	)
	skill_points = 18
	software_on_spawn = list(
		/datum/computer_file/program/supply,
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/reports
	)

/datum/job/cargo_tech
	title = "Shipping Technician"
	department_types = list(/decl/department/supply)
	total_positions = 2
	spawn_positions = 2
	supervisors = "the shipping manager and the admiralty shipping company"
	access = list(
		access_maint_tunnels,
		access_mailsorting,
		access_cargo,
		access_cargo_bot,
		access_qm,
		access_mining,
		access_mining_station
	)
	minimal_access = list(
		access_maint_tunnels,
		access_cargo,
		access_cargo_bot,
		access_mailsorting
	)
	alt_titles = list("Delivery Assistant")
	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_BASIC,
		SKILL_HAULING  = SKILL_BASIC
	)
	max_skill = list(
		SKILL_PILOT    = SKILL_MAX
	)
	software_on_spawn = list(
		/datum/computer_file/program/supply,
		/datum/computer_file/program/deck_management,
		/datum/computer_file/program/reports
	)

/datum/job/mining
	title = "Miner"
	department_types = list(/decl/department/supply)
	total_positions = 3
	spawn_positions = 3
	supervisors = "the shipping manager and the admiralty shipping company"
	economic_power = 5
	access = list(
		access_maint_tunnels,
		access_mailsorting,
		access_cargo,
		access_cargo_bot,
		access_qm,
		access_mining,
		access_mining_station
	)
	minimal_access = list(
		access_mining,
		access_mining_station,
		access_mailsorting
	)
	alt_titles = list("Drill Technician","Prospector")
	outfit_type = /decl/hierarchy/outfit/job/cargo/mining
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_HAULING  = SKILL_ADEPT,
		SKILL_EVA      = SKILL_BASIC
	)
	max_skill = list(
		SKILL_PILOT    = SKILL_MAX
	)

/datum/job/janitor
	title = "Sanitation Technician"
	department_types = list(/decl/department/service)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the district clerk"
	access = list(
		access_janitor,
		access_maint_tunnels,
		access_engine,
		access_research,
		access_sec_doors,
		access_medical
	)
	minimal_access = list(
		access_janitor,
		access_maint_tunnels,
		access_engine,
		access_research,
		access_sec_doors,
		access_medical
	)
	alt_titles = list("District Custodian","Street Sweeper", "Waste Collector")
	outfit_type = /decl/hierarchy/outfit/job/service/janitor
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_HAULING  = SKILL_BASIC
	)
	event_categories = list(ASSIGNMENT_JANITOR)

//More or less assistants
/datum/job/librarian
	title = "Librarian"
	department_types = list(/decl/department/civilian)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the district council"
	access = list(
		access_library,
		access_maint_tunnels
	)
	minimal_access = list(access_library)
	alt_titles = list("Assistant Curator")
	outfit_type = /decl/hierarchy/outfit/job/librarian
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_BASIC
	)
	skill_points = 20
	software_on_spawn = list(/datum/computer_file/program/reports)

/datum/job/lawyer
	title = "District Hall Secretary"
	department_types = list(/decl/department/support)
	total_positions = 2
	spawn_positions = 2
	supervisors = "the district clerk and mayor"
	economic_power = 7
	access = list(
		access_lawyer,
		access_sec_doors,
		access_maint_tunnels,
		access_bridge
	)
	minimal_access = list(
		access_lawyer,
		access_sec_doors,
		access_bridge
	)
	minimal_player_age = 10
	outfit_type = /decl/hierarchy/outfit/job/internal_affairs_agent
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_BASIC
	)
	skill_points = 20
	software_on_spawn = list(/datum/computer_file/program/reports)

/obj/item/card/id/cargo
	name = "identification card"
	desc = "A card issued to cargo staff."
	detail_color = COLOR_BROWN

/obj/item/card/id/cargo/head
	name = "identification card"
	desc = "A card which represents service and planning."
	extra_details = list("goldstripe")

/obj/item/card/id/civilian/internal_affairs_agent
	detail_color = COLOR_NAVY_BLUE
