/datum/stack_crafting/recipe/rod
	name = "rod"
	result_type = /obj/item/stack/material/rods
	res_amount = 2
	max_res_amount = 60
	time = 5
	difficulty = 1

/datum/stack_crafting/recipe/rod/spawn_result(user, location, amount)
	var/obj/item/stack/S = new result_type(location, amount, use_material)
	if(user)
		S.add_to_stacks(user, 1)
	return S

/datum/stack_crafting/recipe/sheet
	name = "sheet"
	result_type = /obj/item/stack/material
	res_amount = 1
	req_amount = 2
	max_res_amount = 60
	time = 5
	difficulty = 1
	craftable_stack_types = list(/obj/item/stack/material/rods)
	required_tool = TOOL_WELDER

/datum/stack_crafting/recipe/sheet/spawn_result(user, location, amount)
	var/obj/item/stack/S = new result_type(location, amount, use_material)
	if(user)
		S.add_to_stacks(user, 1)
	return S

// Tiles
/datum/stack_crafting/recipe/tile
	res_amount = 4
	max_res_amount = 20
	time = 5
	difficulty = 1
	apply_material_name = FALSE

/datum/stack_crafting/recipe/tile/spawn_result(user, location, amount)
	var/obj/item/stack/S = ..()
	if(istype(S))
		S.amount = amount
		if(user)
			S.add_to_stacks(user, 1)
	return S

/datum/stack_crafting/recipe/tile/metal/floor
	name = "regular floor tile"
	result_type = /obj/item/stack/tile/floor

/datum/stack_crafting/recipe/tile/metal/roof
	name = "roofing tile"
	result_type = /obj/item/stack/tile/roof

/datum/stack_crafting/recipe/tile/metal/mono
	name = "mono floor tile"
	result_type = /obj/item/stack/tile/mono

/datum/stack_crafting/recipe/tile/metal/mono_dark
	name = "dark mono floor tile"
	result_type = /obj/item/stack/tile/mono/dark

/datum/stack_crafting/recipe/tile/metal/grid
	name = "grid floor tile"
	result_type = /obj/item/stack/tile/grid

/datum/stack_crafting/recipe/tile/metal/ridged
	name = "ridged floor tile"
	result_type = /obj/item/stack/tile/ridge

/datum/stack_crafting/recipe/tile/metal/tech_grey
	name = "grey techfloor tile"
	result_type = /obj/item/stack/tile/techgrey

/datum/stack_crafting/recipe/tile/metal/tech_grid
	name = "grid techfloor tile"
	result_type = /obj/item/stack/tile/techgrid

/datum/stack_crafting/recipe/tile/metal/tech_maint
	name = "dark techfloor tile"
	result_type = /obj/item/stack/tile/techmaint

/datum/stack_crafting/recipe/tile/metal/dark
	name = "dark floor tile"
	result_type = /obj/item/stack/tile/floor_dark

/datum/stack_crafting/recipe/tile/light/floor
	name = "white floor tile"
	result_type = /obj/item/stack/tile/floor_white

/datum/stack_crafting/recipe/tile/light/freezer
	name = "freezer floor tile"
	result_type = /obj/item/stack/tile/floor_freezer

/datum/stack_crafting/recipe/tile/wood
	name = "wood floor tile"
	result_type = /obj/item/stack/tile/wood

/datum/stack_crafting/recipe/tile/mahogany
	name = "mahogany floor tile"
	result_type = /obj/item/stack/tile/mahogany

/datum/stack_crafting/recipe/tile/maple
	name = "maple floor tile"
	result_type = /obj/item/stack/tile/maple

/datum/stack_crafting/recipe/tile/ebony
	name = "ebony floor tile"
	difficulty = 3
	result_type = /obj/item/stack/tile/ebony

/datum/stack_crafting/recipe/tile/walnut
	name = "walnut floor tile"
	result_type = /obj/item/stack/tile/walnut


/datum/stack_crafting/recipe/tile/metal/pool
	name = "pool floor tile"
	result_type = /obj/item/stack/tile/pool
