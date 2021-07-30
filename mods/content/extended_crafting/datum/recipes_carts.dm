//Carts
/datum/stack_recipe/cart
	time = 8 SECONDS
	req_amount = 20
	difficulty = MAT_VALUE_HARD_DIY
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
