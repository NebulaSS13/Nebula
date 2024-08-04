/obj/item/chems/cooking_vessel/baking_dish
	name               = "baking dish"
	desc               = "A large baking dish for baking things."
	icon               = 'icons/obj/food/cooking_vessels/baking_dish.dmi'
	volume             = 100
	cooking_category   = RECIPE_CATEGORY_BAKING_DISH
	presentation_flags = PRESENTATION_FLAG_NAME
	obj_flags          = OBJ_FLAG_HOLLOW | OBJ_FLAG_INSULATED_HANDLE // TODO: dynamically add/remove OBJ_FLAG_INSULATED_HANDLE based on handle material?
	material           = /decl/material/solid/stone/ceramic

/obj/item/chems/cooking_vessel/baking_dish/earthenware
	material = /decl/material/solid/stone/pottery

// Baking dishes have to be in a kiln or oven (structure or machine) to cook.
// Holding it in your hands or having it on a turf doesn't count.
// TODO: Refactor to use COOKING_HEAT_INDIRECT and air temperature!
/obj/item/chems/cooking_vessel/baking_dish/Process()
	if(!(istype(loc, /obj/structure) || istype(loc, /obj/machinery)))
		return
	return ..()