//Plumbing / hygiene
/datum/stack_recipe/furniture/hygiene
	time = 10 SECONDS
	apply_material_name = FALSE
	on_floor = TRUE
	req_amount = 5
	difficulty = MAT_VALUE_HARD_DIY

/datum/stack_recipe/furniture/hygiene/drain/bath
	title = "toggleable drain"
	result_type = /obj/structure/hygiene/drain/bath

/datum/stack_recipe/furniture/hygiene/drain
	title = "drain"
	result_type = /obj/structure/hygiene/drain

/datum/stack_recipe/furniture/hygiene/faucet
	title = "faucet"
	result_type = /obj/structure/hygiene/faucet

/datum/stack_recipe/furniture/hygiene/shower
	title = "shower"
	result_type = /obj/structure/hygiene/shower

/datum/stack_recipe/furniture/hygiene/kitchen_sink
	title = "kitchen sink"
	result_type = /obj/structure/hygiene/sink/kitchen

/datum/stack_recipe/furniture/hygiene_material
	time = 10 SECONDS
	apply_material_name = TRUE
	on_floor = TRUE
	req_amount = 5
	difficulty = MAT_VALUE_HARD_DIY

/datum/stack_recipe/furniture/hygiene_material/sink
	title = "sink"
	result_type = /obj/structure/hygiene/sink

/datum/stack_recipe/furniture/hygiene_material/urinal
	title = "urinal"
	result_type = /obj/structure/hygiene/urinal

/datum/stack_recipe/furniture/hygiene_material/toilet
	title = "toilet"
	result_type = /obj/structure/hygiene/toilet

