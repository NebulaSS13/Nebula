/decl/stack_recipe/hardness/integrity
	abstract_type = /decl/stack_recipe/hardness/integrity
	required_integrity = 50

/decl/stack_recipe/hardness/integrity/furniture
	abstract_type = /decl/stack_recipe/hardness/integrity/furniture
	one_per_turf = 1
	on_floor = 1
	difficulty = 2
	time = 5

/decl/stack_recipe/hardness/integrity/furniture/door
	name = "door"
	result_type = /obj/structure/door
	time = 50

/decl/stack_recipe/hardness/integrity/furniture/barricade
	name = "barricade"
	result_type = /obj/structure/barricade
	time = 50

/decl/stack_recipe/hardness/integrity/furniture/banner_frame
	name = "banner frame"
	result_type = /obj/structure/banner_frame
	time = 25

/decl/stack_recipe/hardness/integrity/furniture/coatrack
	name = "coat rack"
	result_type = /obj/structure/coatrack

/decl/stack_recipe/hardness/integrity/furniture/stool
	name = "stool"
	result_type = /obj/item/stool
	category = "seating"

/decl/stack_recipe/hardness/integrity/furniture/bar_stool
	name = "bar stool"
	result_type = /obj/item/stool/bar
	category = "seating"

/decl/stack_recipe/hardness/integrity/furniture/pew
	name = "pew, right"
	result_type = /obj/structure/bed/chair/pew
	category = "seating"

/decl/stack_recipe/hardness/integrity/furniture/pew/left
	name = "pew, left"
	result_type = /obj/structure/bed/chair/pew/left

/decl/stack_recipe/hardness/integrity/furniture/closet
	name = "closet"
	result_type = /obj/structure/closet
	time = 15

/decl/stack_recipe/hardness/integrity/furniture/tank_dispenser
	name = "tank dispenser"
	result_type = /obj/structure/tank_rack
	time = 15

/decl/stack_recipe/hardness/integrity/furniture/coffin
	name = "coffin"
	result_type = /obj/structure/closet/coffin
	time = 15

/decl/stack_recipe/hardness/integrity/furniture/chair
	name = "chair"
	result_type = /obj/structure/bed/chair
	time = 10
	category = "seating"

/decl/stack_recipe/hardness/integrity/furniture/chair/padded
	result_type = /obj/structure/bed/chair/padded

/decl/stack_recipe/hardness/integrity/furniture/chair/office
	name = "office chair"

/decl/stack_recipe/hardness/integrity/furniture/chair/office/comfy
	result_type = /obj/structure/bed/chair/office/comfy
	name = "office comfy chair"

/decl/stack_recipe/hardness/integrity/furniture/chair/comfy
	result_type = /obj/structure/bed/chair/comfy
	name = "comfy chair"

/decl/stack_recipe/hardness/integrity/furniture/chair/arm
	result_type = /obj/structure/bed/chair/armchair
	name = "armchair"

/decl/stack_recipe/hardness/integrity/furniture/chair/roundedchair
	result_type = /obj/structure/bed/chair/rounded
	name = "rounded chair"

/decl/stack_recipe/hardness/integrity/lock
	name = "lock"
	result_type = /obj/item/lock_construct
	time = 20

/decl/stack_recipe/hardness/integrity/key
	name = "key"
	result_type = /obj/item/key
	time = 10

/decl/stack_recipe/hardness/integrity/rod
	name = "rod"
	result_type = /obj/item/stack/material/rods
	res_amount = 2
	max_res_amount = 60
	time = 5
	difficulty = 1

/decl/stack_recipe/hardness/integrity/rod/spawn_result(user, location, amount)
	var/obj/item/stack/S = new result_type(location, amount, use_material)
	if(user)
		S.add_to_stacks(user, 1)
	return S
