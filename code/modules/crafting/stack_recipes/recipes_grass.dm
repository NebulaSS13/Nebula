/decl/stack_recipe/woven
	abstract_type               = /decl/stack_recipe/woven
	craft_stack_types           = /obj/item/stack/material/bundle
	category                    = "woven items"
	forbidden_craft_stack_types = null
	validation_material         = /decl/material/solid/organic/plantmatter/grass/dry

// TODO: make this check a material property. tensile strength? dryness?
// literally anything but a direct type equality check please
/decl/stack_recipe/woven/can_be_made_from(stack_type, tool_type, decl/material/mat, decl/material/reinf_mat)
	if((istype(mat) ? mat.type : mat) == /decl/material/solid/organic/plantmatter/grass)
		return FALSE
	return ..()

/decl/stack_recipe/woven/rug
	result_type                 = /obj/structure/rug/crafted
	one_per_turf                = TRUE
	on_floor                    = TRUE
	category                    = "furniture"
	uid                         = "stack_recipe_woven_rug"

/decl/stack_recipe/woven/basket
	result_type                 = /obj/item/basket
	uid                         = "stack_recipe_woven_basket"

/decl/stack_recipe/woven/large_basket
	result_type                 = /obj/item/basket/large
	uid                         = "stack_recipe_woven_basket_large"

/decl/stack_recipe/woven/banner
	result_type                 = /obj/item/banner/woven
	uid                         = "stack_recipe_woven_banner"

/decl/stack_recipe/tile/woven
	name                        = "woven roof tile"
	craft_stack_types           = /obj/item/stack/material/bundle
	required_material           = /decl/material/solid/organic/plantmatter/grass/dry
	result_type                 = /obj/item/stack/tile/roof/woven
	forbidden_craft_stack_types = null
	uid                         = "stack_recipe_woven_roof_tile"

/decl/stack_recipe/tile/woven/floor
	name                        = "woven floor tile"
	result_type                 = /obj/item/stack/tile/woven
	uid                         = "stack_recipe_woven_floor_tile"

/decl/stack_recipe/woven/bowstring
	result_type                 = /obj/item/bowstring
	difficulty                  = MAT_VALUE_VERY_HARD_DIY
	// TODO: cord
	craft_stack_types           = list(
		/obj/item/stack/material/bundle,
		/obj/item/stack/material/thread
	)
	uid                         = "stack_recipe_woven_bowstring"

/decl/stack_recipe/woven/dummy
	result_type                 = /obj/item/training_dummy/straw
	uid                         = "stack_recipe_woven_dummy"
