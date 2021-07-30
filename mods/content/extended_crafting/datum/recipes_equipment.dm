/datum/stack_recipe/furniture/equipment
	difficulty = MAT_VALUE_HARD_DIY
	req_amount = 10
	time = 10 SECONDS
	apply_material_name = FALSE

/datum/stack_recipe/furniture/equipment/morgue
	title = "morgue"
	result_type = /obj/structure/morgue

/datum/stack_recipe/furniture/equipment/crematorium
	title = "crematorium"
	result_type = /obj/structure/crematorium

/datum/stack_recipe/furniture/equipment/tank_dispenser
	title = "tank storage unit"
	result_type = /obj/structure/dispenser/empty

//fitness
/datum/stack_recipe/furniture/equipment/weightlifter
	title = "weight lifter"
	result_type = /obj/structure/fitness/weightlifter
	req_amount = 20

/datum/stack_recipe/furniture/equipment/punchingbag
	title = "punching bag"
	result_type = /obj/structure/fitness/punchingbag
	difficulty = MAT_VALUE_NORMAL_DIY

/datum/stack_recipe/furniture/equipment/critter_crate
	title = "critter crate"
	result_type = /obj/structure/closet/crate/critter

/datum/stack_recipe/furniture/equipment/iv_drip
	title = "\improper IV drip"
	result_type = /obj/structure/iv_drip
	time = 2 SECONDS
	req_amount = 5

/datum/stack_recipe/furniture/equipment/stasis_cage
	title = "stasis cage"
	result_type = /obj/structure/stasis_cage
	difficulty = MAT_VALUE_VERY_HARD_DIY
