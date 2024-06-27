/decl/stack_recipe/woven
	abstract_type     = /decl/stack_recipe/woven
	craft_stack_types = /obj/item/stack/material/bundle
	category          = "woven items"

/decl/stack_recipe/woven/can_be_made_from(stack_type, tool_type, decl/material/mat, decl/material/reinf_mat)
	if((istype(mat) ? mat.type : mat) == /decl/material/solid/organic/plantmatter/grass)
		return FALSE
	return ..()

/decl/stack_recipe/woven/basket
	result_type       = /obj/item/basket

/decl/stack_recipe/woven/banner
	result_type       = /obj/item/banner/woven

/decl/stack_recipe/tile/woven
	name              = "woven roof tile"
	craft_stack_types = /obj/item/stack/material/bundle
	required_material = /decl/material/solid/organic/plantmatter/grass/dry
	result_type       = /obj/item/stack/tile/roof/woven

/decl/stack_recipe/tile/woven/floor
	name              = "woven floor tile"
	result_type       = /obj/item/stack/tile/woven

/decl/stack_recipe/woven/bowstring
	result_type       = /obj/item/bowstring
	difficulty        = MAT_VALUE_VERY_HARD_DIY
	// TODO: cord
	craft_stack_types = list(
		/obj/item/stack/material/bundle,
		/obj/item/stack/material/thread
	)
