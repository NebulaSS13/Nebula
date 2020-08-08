//Furniture is in a separate file.
/datum/stack_crafting/recipe/butcher_hook
	name = "meat hook"
	result_type = /obj/structure/kitchenspike
	time = 40
	one_per_turf = 1
	difficulty = 1
	craftable_stack_types = list(/obj/item/stack/material/rods)
	required_tool = TOOL_WELDER

/datum/stack_crafting/recipe/ai_core
	name = "AI core"
	result_type = /obj/structure/aicore
	time = 50
	one_per_turf = 1
	difficulty = 2

/datum/stack_crafting/recipe/railing
	name = "railing"
	result_type = /obj/structure/railing
	time = 40
	on_floor = 1
	difficulty = 2
	craftable_stack_types = list(/obj/item/stack/material/rods)
	required_tool = TOOL_WELDER

/datum/stack_crafting/recipe/noticeboard
	name = "noticeboard"
	result_type = /obj/structure/noticeboard
	time = 50
	on_floor = 1
	difficulty = 2
	set_dir_on_spawn = FALSE

/datum/stack_crafting/recipe/noticeboard/spawn_result(mob/user, location, amount)
	var/obj/structure/noticeboard/board = ..()
	if(istype(board) && user)
		board.set_dir(global.reverse_dir[user.dir])
	return board

/datum/stack_crafting/recipe/campfire
	name = "campfire"
	time = 4 SECONDS
	on_floor = TRUE
	one_per_turf = TRUE
	apply_material_name = FALSE
	result_type = /obj/structure/fire_source

/datum/stack_crafting/recipe/campfire/spawn_result(mob/user, location, amount)
	var/obj/structure/fire_source/product = ..()
	for(var/mat in product.matter)
		var/decl/material/material = GET_DECL(mat)
		if(material.fuel_value > 0)
			product.fuel += material.fuel_value * round(product.matter[mat] / SHEET_MATERIAL_AMOUNT)
	return product

/datum/stack_crafting/recipe/fountain
	name               = "fountain"
	result_type         = /obj/structure/fountain/mundane
	time                = 10 SECONDS
	one_per_turf        = TRUE
	on_floor            = TRUE
	difficulty          = MAT_VALUE_VERY_HARD_DIY
	apply_material_name = TRUE
