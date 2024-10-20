/obj/item/food/dough
	name = "dough"
	desc = "A piece of dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "dough"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":13}'
	nutriment_desc = list("dough" = 3)
	nutriment_amt = 3
	nutriment_type = /decl/material/liquid/nutriment/bread
	backyard_grilling_product = /obj/item/food/bun
	backyard_grilling_announcement = "is baked into a simple bun."

// Dough + rolling pin = flat dough
/obj/item/food/dough/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/kitchen/rollingpin))
		var/obj/item/food/sliceable/flatdough/result = new()
		result.dropInto(loc)
		to_chat(user, "You flatten the dough.")
		qdel(src)

/obj/item/food/unleaveneddough
	name = "flat unleavened dough"
	desc = "A flattened lump of dough, made without yeast."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flat dough"
	center_of_mass = @'{"x":16,"y":16}'
	backyard_grilling_product = /obj/item/food/flatbread
	backyard_grilling_announcement = "is baked into a simple flatbread."
	nutriment_amt = 4
	nutriment_desc = "raw dough"

/obj/item/food/piecrust
	name = "pie crust"
	desc = "A dense, buttery pie crust, ready for filling."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flat dough"
	center_of_mass = @'{"x":16,"y":16}'
	nutriment_amt = 4
	nutriment_desc = "raw pie crust"

// slicable into 3x doughslices
/obj/item/food/sliceable/flatdough
	name = "flat leavened dough"
	desc = "A flattened lump of dough, made with yeast."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flat dough"
	slice_path = /obj/item/food/doughslice
	slice_num = 3
	center_of_mass = @'{"x":16,"y":16}'
	utensil_flags = UTENSIL_FLAG_COLLECT | UTENSIL_FLAG_SLICE
	nutriment_amt = 4
	nutriment_desc = "raw dough"
	// TODO: pizza base with no toppings? Some other round leavened bread product?
	backyard_grilling_product = /obj/item/food/flatbread
	backyard_grilling_announcement = "is baked into a simple flatbread."

/obj/item/food/doughslice
	name = "dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "doughslice"
	slice_path = /obj/item/food/spagetti
	slice_num = 1
	bitesize = 2
	center_of_mass = @'{"x":17,"y":19}'
	nutriment_desc = list("dough" = 1)
	nutriment_amt = 1
	nutriment_type = /decl/material/liquid/nutriment/bread
	utensil_flags = UTENSIL_FLAG_COLLECT | UTENSIL_FLAG_SLICE

/obj/item/food/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bun"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":12}'
	nutriment_desc = list("bun" = 4)
	nutriment_amt = 4
	nutriment_type = /decl/material/liquid/nutriment/bread

/obj/item/food/bunbun
	name = "\improper Bun Bun"
	desc = "A small bread monkey fashioned from two burger buns."
	icon_state = "bunbun"
	bitesize = 2
	center_of_mass = @'{"x":16,"y":8}'
	nutriment_desc = list("bun" = 8)
	nutriment_amt = 8
	nutriment_type = /decl/material/liquid/nutriment/bread