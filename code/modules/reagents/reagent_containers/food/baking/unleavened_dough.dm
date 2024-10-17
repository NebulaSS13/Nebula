/obj/item/food/sliceable/unleaveneddough
	name = "unleavened dough"
	desc = "A flattened lump of dough, made without yeast."
	icon = 'icons/obj/food/baked/flattened_dough.dmi'
	icon_state = ICON_STATE_WORLD
	center_of_mass = @'{"x":16,"y":16}'
	backyard_grilling_product = /obj/item/food/flatbread
	backyard_grilling_announcement = "is baked into a simple flatbread."
	nutriment_amt = 4
	nutriment_desc = "raw dough"
	slice_path = /obj/item/food/unleaveneddoughslice
	slice_num = 3

/obj/item/food/unleaveneddoughslice
	name = "unleavened dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/food/baked/sliced_dough.dmi'
	icon_state = ICON_STATE_WORLD
	slice_path = /obj/item/food/spagetti
	slice_num = 1
	bitesize = 2
	center_of_mass = @'{"x":17,"y":19}'
	nutriment_desc = list("raw dough" = 1)
	nutriment_amt = 1
	nutriment_type = /decl/material/liquid/nutriment/bread
	utensil_flags = UTENSIL_FLAG_COLLECT | UTENSIL_FLAG_SLICE
