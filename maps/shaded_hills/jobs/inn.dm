/decl/department/shaded_hills/inn
	name                    = "Inn Workers"
	colour                  = "#404e68"
	display_color           = "#8c96c4"

/datum/job/shaded_hills/inn
	abstract_type           = /datum/job/shaded_hills/inn
	department_types        = list(/decl/department/shaded_hills/inn)

/datum/job/shaded_hills/inn/innkeeper
	title                   = "Innkeeper"
	spawn_positions         = 1
	total_positions         = 1
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/innkeeper
	head_position           = TRUE
	req_admin_notify        = TRUE
	guestbanned             = TRUE
	must_fill               = TRUE
	not_random_selectable   = TRUE
	lock_keys = list(
		"inn interior" = /decl/material/solid/metal/copper,
		"inn exterior" = /decl/material/solid/metal/iron
	)

/obj/abstract/landmark/start/shaded_hills/innkeeper
	name                    = "Innkeeper"

/datum/job/shaded_hills/inn/inn_worker
	title                   = "Inn Worker"
	spawn_positions         = 3
	total_positions         = 3
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/inn_worker

/obj/abstract/landmark/start/shaded_hills/inn_worker
	name                    = "Inn Worker"

/datum/job/shaded_hills/inn/bartender
	title                   = "Bartender"
	spawn_positions         = 2
	total_positions         = 2
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/bartender

/obj/abstract/landmark/start/shaded_hills/bartender
	name                    = "Bartender"

/datum/job/shaded_hills/inn/farmer
	title                   = "Farmer"
	spawn_positions         = 3
	total_positions         = 3
	outfit_type             = /decl/hierarchy/outfit/job/shaded_hills/farmer

/obj/abstract/landmark/start/shaded_hills/farmer
	name                    = "Farmer"
