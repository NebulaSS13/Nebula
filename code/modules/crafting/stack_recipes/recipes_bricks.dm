/decl/stack_recipe/bricks
	abstract_type = /decl/stack_recipe/bricks
	craft_stack_types = /obj/item/stack/material/brick

/decl/stack_recipe/bricks/furniture
	abstract_type = /decl/stack_recipe/bricks/furniture
	one_per_turf = 1
	on_floor = 1
	difficulty = 2
	time = 5

/decl/stack_recipe/bricks/furniture/planting_bed
	name = "planting bed"
	result_type = /obj/machinery/portable_atmospherics/hydroponics/soil
	req_amount = 3
	time = 10

/decl/stack_recipe/bricks/furniture/planting_bed/spawn_result(mob/user, location, amount)
	return new result_type(location)

/decl/stack_recipe/bricks/fountain
	name               = "fountain"
	result_type         = /obj/structure/fountain/mundane
	time                = 10 SECONDS
	one_per_turf        = TRUE
	on_floor            = TRUE
	difficulty          = MAT_VALUE_VERY_HARD_DIY
	apply_material_name = TRUE

/decl/stack_recipe/turfs/wall/brick
	name = "brick wall"
	result_type = /turf/simulated/wall/brick
	craft_stack_types = /obj/item/stack/material/brick
