//Furniture is in a separate file.
/datum/stack_recipe/butcher_hook
	title = "meat hook"
	result_type = /obj/structure/kitchenspike
	time = 40
	one_per_turf = 1
	difficulty = 1

/datum/stack_recipe/ai_core
	title = "AI core"
	result_type = /obj/structure/aicore
	time = 50
	one_per_turf = 1
	difficulty = 2

/datum/stack_recipe/railing
	title = "railing"
	result_type = /obj/structure/railing
	time = 40
	on_floor = 1
	difficulty = 2

/datum/stack_recipe/noticeboard
	title = "noticeboard"
	result_type = /obj/structure/noticeboard
	time = 50
	on_floor = 1
	difficulty = 2
	set_dir_on_spawn = FALSE

/datum/stack_recipe/noticeboard/spawn_result(mob/user, location, amount)
	var/obj/structure/noticeboard/board = ..()
	if(istype(board) && user)
		board.set_dir(global.reverse_dir[user.dir])
	return board

/datum/stack_recipe/campfire
	title = "campfire"
	time = 4 SECONDS
	on_floor = TRUE
	one_per_turf = TRUE
	apply_material_name = FALSE
	result_type = /obj/structure/fire_source

/datum/stack_recipe/campfire/spawn_result(mob/user, location, amount)
	var/obj/structure/fire_source/product = ..()
	for(var/mat in product.matter)
		var/decl/material/material = GET_DECL(mat)
		if(material.accelerant_value > FUEL_VALUE_NONE)
			product.fuel += material.accelerant_value * round(product.matter[mat] / SHEET_MATERIAL_AMOUNT)
	return product

/datum/stack_recipe/fountain
	title               = "fountain"
	result_type         = /obj/structure/fountain/mundane
	time                = 10 SECONDS
	one_per_turf        = TRUE
	on_floor            = TRUE
	difficulty          = MAT_VALUE_VERY_HARD_DIY
	apply_material_name = TRUE
