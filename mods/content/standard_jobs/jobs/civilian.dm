/datum/job/standard/assistant
	title = "Assistant"
	hud_icon_state = "hudassistant"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	economic_power = 1
	access = list()
	minimal_access = list()
	alt_titles = list("Technical Assistant","Medical Intern","Research Assistant","Visitor")
	outfit_type = /decl/outfit/job/generic/assistant
	department_types = list(/decl/department/civilian)

/datum/job/standard/assistant/get_access()
	if(get_config_value(/decl/config/toggle/assistant_maint))
		return list(access_maint_tunnels)
	return list()

/datum/job/standard/chaplain
	title = "Chaplain"
	hud_icon_state = "hudchaplain" // TODO: not always a crucifix
	department_types = list(/decl/department/civilian)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
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
	outfit_type = /decl/outfit/job/chaplain
	is_holy = TRUE
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_BASIC
	)
	skill_points = 20
	software_on_spawn = list(/datum/computer_file/program/reports)

//Food
/datum/job/standard/bartender
	title = "Bartender"
	department_types = list(/decl/department/service)
	hud_icon_state = "hudbartender"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	access = list(
		access_hydroponics,
		access_bar,
		access_kitchen
	)
	minimal_access = list(
		access_hydroponics,
		access_bar,
		access_kitchen
	)
	minimal_access = list(access_bar)
	alt_titles = list("Barista")
	outfit_type = /decl/outfit/job/service/bartender
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_COOKING   = SKILL_BASIC,
	    SKILL_BOTANY    = SKILL_BASIC,
	    SKILL_CHEMISTRY = SKILL_BASIC
	)

/datum/job/standard/chef
	title = "Chef"
	hud_icon_state = "hudchef"
	department_types = list(/decl/department/service)
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	access = list(
		access_hydroponics,
		access_bar,
		access_kitchen
	)
	minimal_access = list(access_kitchen)
	alt_titles = list("Cook")
	outfit_type = /decl/outfit/job/service/chef
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_COOKING   = SKILL_ADEPT,
	    SKILL_BOTANY    = SKILL_BASIC,
	    SKILL_CHEMISTRY = SKILL_BASIC
	)

/datum/job/standard/hydro
	title = "Gardener"
	hud_icon_state = "hudgardener"
	department_types = list(/decl/department/service)
	total_positions = 2
	spawn_positions = 1
	supervisors = "the head of personnel"
	access = list(
		access_hydroponics,
		access_bar,
		access_kitchen
	)
	minimal_access = list(access_hydroponics)
	alt_titles = list("Hydroponicist")
	outfit_type = /decl/outfit/job/service/gardener
	min_skill = list(
		SKILL_LITERACY  = SKILL_ADEPT,
		SKILL_BOTANY    = SKILL_BASIC,
	    SKILL_CHEMISTRY = SKILL_BASIC
	)
	event_categories = list(ASSIGNMENT_GARDENER)

//Cargo
/datum/job/standard/qm
	title = "Quartermaster"
	hud_icon_state = "hudqm"
	department_types = list(/decl/department/supply)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
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
	outfit_type = /decl/outfit/job/cargo/qm
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

/datum/job/standard/cargo_tech
	title = "Cargo Technician"
	department_types = list(/decl/department/supply)
	total_positions = 2
	spawn_positions = 2
	hud_icon_state = "hudcargo"
	supervisors = "the quartermaster and the head of personnel"
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
	outfit_type = /decl/outfit/job/cargo/cargo_tech
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

/datum/job/standard/mining
	title = "Shaft Miner"
	hud_icon_state = "hudminer"
	department_types = list(/decl/department/supply)
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster and the head of personnel"
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
	alt_titles = list(
		"Drill Technician",
		"Prospector"
	)
	outfit_type = /decl/outfit/job/cargo/mining
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_HAULING  = SKILL_ADEPT,
	    SKILL_EVA      = SKILL_BASIC
	)
	max_skill = list(
		SKILL_PILOT    = SKILL_MAX
	)

/datum/job/standard/janitor
	title = "Janitor"
	department_types = list(/decl/department/service)
	total_positions = 1
	spawn_positions = 1
	hud_icon_state = "hudjanitor"
	supervisors = "the head of personnel"
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
	alt_titles = list(
		"Custodian",
		"Sanitation Technician"
	)
	outfit_type = /decl/outfit/job/service/janitor
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_HAULING  = SKILL_BASIC
	)
	event_categories = list(ASSIGNMENT_JANITOR)

//More or less assistants
/datum/job/standard/librarian
	title = "Librarian"
	hud_icon_state = "hudlibrarian"
	department_types = list(/decl/department/civilian)
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	access = list(
		access_library,
		access_maint_tunnels
	)
	minimal_access = list(access_library)
	alt_titles = list("Journalist")
	outfit_type = /decl/outfit/job/librarian
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_BASIC
	)
	skill_points = 20
	software_on_spawn = list(/datum/computer_file/program/reports)

/datum/job/standard/lawyer
	title = "Internal Affairs Agent"
	hud_icon_state = "hudia"
	department_types = list(/decl/department/support)
	total_positions = 2
	spawn_positions = 2
	supervisors = "company officials and Corporate Regulations"
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
	outfit_type = /decl/outfit/job/internal_affairs_agent
	min_skill = list(
		SKILL_LITERACY = SKILL_ADEPT,
		SKILL_FINANCE  = SKILL_BASIC
	)
	skill_points = 20
	software_on_spawn = list(/datum/computer_file/program/reports)

/datum/job/standard/lawyer/equip_job(var/mob/living/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(H)

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
