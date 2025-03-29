/obj/item/food/dough
	name = "leavened dough"
	desc = "A piece of dough."
	icon = 'icons/obj/food/baked/dough.dmi'
	icon_state = ICON_STATE_WORLD
	bitesize = 2
	center_of_mass = @'{"x":16,"y":13}'
	nutriment_desc = list("raw dough" = 3)
	nutriment_amt = 3
	nutriment_type = /decl/material/liquid/nutriment/bread
	backyard_grilling_product = /obj/item/food/bun
	backyard_grilling_announcement = "is baked into a simple bun."

// Dough + rolling pin = flat dough
/obj/item/food/dough/attackby(obj/item/used_item, mob/user)
	if(!istype(used_item,/obj/item/rollingpin))
		return ..()
	var/obj/item/food/sliceable/flatdough/result = new()
	result.dropInto(loc)
	to_chat(user, "You flatten the dough.")
	qdel(src)
	return TRUE

// slicable into 3x doughslices
/obj/item/food/sliceable/flatdough
	name = "flat leavened dough"
	desc = "A flattened lump of dough, made with yeast."
	icon = 'icons/obj/food/baked/flattened_dough.dmi'
	icon_state = ICON_STATE_WORLD
	slice_path = /obj/item/food/doughslice
	slice_num = 3
	center_of_mass = @'{"x":16,"y":16}'
	utensil_flags = UTENSIL_FLAG_COLLECT | UTENSIL_FLAG_SLICE
	nutriment_amt = 4
	nutriment_desc = list("raw dough" = 1)
	// TODO: pizza base with no toppings? Some other round leavened bread product?
	backyard_grilling_product = /obj/item/food/flatbread
	backyard_grilling_announcement = "is baked into a simple flatbread."

/obj/item/food/doughslice
	name = "leavened dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/food/baked/sliced_dough.dmi'
	icon_state = ICON_STATE_WORLD
	bitesize = 2
	center_of_mass = @'{"x":17,"y":19}'
	nutriment_desc = list("raw dough" = 1)
	nutriment_amt = 1
	nutriment_type = /decl/material/liquid/nutriment/bread
	utensil_flags = UTENSIL_FLAG_COLLECT
