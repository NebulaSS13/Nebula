/datum/stack_recipe/furniture/dogbed
	title = "dog bed"
	result_type = /obj/structure/dogbed
	req_amount = 4

/datum/stack_recipe/furniture/mattress
	title = "mattress"
	result_type = /obj/structure/mattress
	req_amount = 5

/datum/stack_recipe/furniture/ironing_board
	title = "ironing board"
	result_type = /obj/item/roller/ironingboard
	req_amount = 4
	apply_material_name = FALSE

/datum/stack_recipe/furniture/roller_bed
	title = "roller bed"
	result_type = /obj/item/roller
	req_amount = 4
	apply_material_name = FALSE

/datum/stack_recipe/furniture/mop_bucket
	title = "mop bucket"
	result_type = /obj/structure/mopbucket
	time = 2 SECONDS
	req_amount = 4

/datum/stack_recipe/furniture/wheelchair
	title = "wheelchair"
	result_type = /obj/item/wheelchair_kit
	apply_material_name = FALSE

/datum/stack_recipe/furniture/large_wood_crate
	title = "large wooden shipping crate"
	time = 8 SECONDS
	difficulty = MAT_VALUE_EASY_DIY
	apply_material_name = FALSE
	req_amount = 12
	result_type = /obj/structure/largecrate

/datum/stack_recipe/furniture/large_wood_crate/ore_box
	title = "large wooden ore box"
	result_type = /obj/structure/ore_box

/datum/stack_recipe/furniture/fountain
	title = "fountain"
	result_type = /obj/structure/fountain/mundane
	time = 10 SECONDS
	req_amount = 30
	apply_material_name = FALSE
	difficulty = MAT_VALUE_VERY_HARD_DIY
