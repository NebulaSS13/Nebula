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

/datum/stack_recipe/railing/handrail
	title = "handrail"
	result_type = /obj/structure/handrail

/datum/stack_recipe/noticeboard
	title = "noticeboard"
	result_type = /obj/structure/noticeboard
	time = 50
	on_floor = 1
	difficulty = 2

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
		if(material.fuel_value > 0)
			product.fuel += material.fuel_value * round(product.matter[mat] / SHEET_MATERIAL_AMOUNT)
	return product

/datum/stack_recipe/mop_bucket
	title = "mop bucket"
	result_type = /obj/structure/mopbucket
	time = 2 SECONDS
	one_per_turf = 1
	on_floor = 1
	apply_material_name = FALSE

/datum/stack_recipe/iv_drip
	title = "\improper IV drip"
	result_type = /obj/structure/iv_drip
	time = 2 SECONDS
	one_per_turf = 1
	on_floor = 1
	apply_material_name = FALSE

/datum/stack_recipe/stasis_cage
	title = "stasis cage"
	result_type = /obj/structure/stasis_cage
	time = 10 SECONDS
	one_per_turf = 1
	on_floor = 1
	apply_material_name = FALSE
	difficulty = MAT_VALUE_VERY_HARD_DIY

/datum/stack_recipe/fountain
	title = "fountain"
	result_type = /obj/structure/fountain/mundane
	time = 10 SECONDS
	one_per_turf = 1
	on_floor = 1
	apply_material_name = FALSE
	difficulty = MAT_VALUE_VERY_HARD_DIY

//Carts
/datum/stack_recipe/cart
	time = 8 SECONDS
	req_amount = 20
	difficulty = MAT_VALUE_NORMAL_DIY
	apply_material_name = FALSE

/datum/stack_recipe/cart/janitor
	title = "janitor cart"
	result_type = /obj/structure/janitorialcart

/datum/stack_recipe/cart/trash
	title = "trash cart"
	result_type = /obj/structure/closet/crate/trashcart

/datum/stack_recipe/cart/biohazard
	title = "biohazard cart"
	result_type = /obj/structure/closet/crate/secure/biohazard

/datum/stack_recipe/cart/biohazard_waste
	title = "biowaste disposal cart"
	result_type = /obj/structure/closet/crate/secure/biohazard/alt
