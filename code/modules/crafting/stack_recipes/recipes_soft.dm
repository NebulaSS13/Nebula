/decl/stack_recipe/soft
	time                        = 1 SECOND
	abstract_type               = /decl/stack_recipe/soft
	craft_stack_types           = null
	forbidden_craft_stack_types = list(
		/obj/item/stack/material/bundle,
		/obj/item/stack/material/thread,
		/obj/item/stack/material/bolt
	)
	required_min_hardness       = 0
	required_max_hardness       = MAT_VALUE_SOFT
	validation_material         = /decl/material/solid/clay
	crafting_extra_cost_factor  = 1 // No wastage for just resculpting materials.

/decl/stack_recipe/soft/teapot
	result_type                 = /obj/item/chems/glass/handmade/teapot

/decl/stack_recipe/soft/cup
	result_type                 = /obj/item/chems/glass/handmade/cup

/decl/stack_recipe/soft/mug
	result_type                 = /obj/item/chems/glass/handmade/mug

/decl/stack_recipe/soft/vase
	result_type                 = /obj/item/chems/glass/handmade/vase

/decl/stack_recipe/soft/bowl
	result_type                 = /obj/item/chems/glass/handmade/bowl

/decl/stack_recipe/soft/jar
	result_type                 = /obj/item/chems/glass/handmade/jar

/decl/stack_recipe/soft/bottle
	result_type                 = /obj/item/chems/glass/handmade/bottle

/decl/stack_recipe/soft/bottle_wide
	result_type                 = /obj/item/chems/glass/handmade/bottle/wide

/decl/stack_recipe/soft/bottle_tall
	result_type                 = /obj/item/chems/glass/handmade/bottle/tall

/decl/stack_recipe/soft/stack
	name                        = "brick"
	name_plural                 = "bricks"
	result_type                 = /obj/item/stack/material/brick

/decl/stack_recipe/soft/bar
	name                        = "bar"
	name_plural                 = "bars"
	result_type                 = /obj/item/stack/material/bar

/decl/stack_recipe/soft/stack/spawn_result(mob/user, location, amount, decl/material/mat, decl/material/reinf_mat, paint_color, spent_type, spent_amount = 1)
	var/obj/item/stack/S = ..()
	if(istype(S))
		S.amount = amount
		if(user)
			S.add_to_stacks(user, 1)
	return S

/decl/stack_recipe/soft/stack/bar
	name                        = "bar"
	name_plural                 = "bars"
	result_type                 = /obj/item/stack/material/bar
	result_type                 = /obj/item/stack/material/bar/wax

/decl/stack_recipe/soft/stack/large_lump
	name                        = "large lump"
	name_plural                 = "large lumps"
	result_type                 = /obj/item/stack/material/lump/large

/decl/stack_recipe/soft/stack/small_lump
	name                        = "small lump"
	name_plural                 = "small lumps"
	result_type                 = /obj/item/stack/material/lump

/decl/stack_recipe/soft/crucible
	result_type = /obj/item/chems/crucible

/decl/stack_recipe/soft/mould
	name = "mould, blank"
	result_type = /obj/item/chems/mould
	category = "moulds"

/decl/stack_recipe/soft/mould/crucible
	name = "mould, crucible"
	result_type = /obj/item/chems/mould/crucible

/decl/stack_recipe/soft/mould/rod
	name = "mould, rod"
	result_type = /obj/item/chems/mould/rod

/decl/stack_recipe/soft/mould/ingot
	name = "mould, ingot"
	result_type = /obj/item/chems/mould/ingot

/decl/stack_recipe/soft/sculpture
	abstract_type               = /decl/stack_recipe/soft/sculpture
	one_per_turf                = TRUE
	on_floor                    = TRUE
	category                    = "sculptures"

/decl/stack_recipe/soft/sculpture/snowman
	result_type                 = /obj/structure/snowman

/decl/stack_recipe/soft/sculpture/snowspider
	result_type                 = /obj/structure/snowman/spider
	difficulty                  = MAT_VALUE_HARD_DIY

/decl/stack_recipe/soft/sculpture/snowbot
	result_type                 = /obj/structure/snowman/bot
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
