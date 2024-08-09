/obj/item/food/butchery/meat
	name                           = "slab"
	desc                           = "A slab of meat."
	icon                           = 'icons/obj/items/butchery/meat1.dmi'
	icon_state                     = ICON_STATE_WORLD
	slice_path                     = /obj/item/food/butchery/cutlet/raw
	slice_num                      = 3
	filling_color                  = "#ff1c1c"
	center_of_mass                 = @'{"x":16,"y":14}'
	bitesize                       = 3
	utensil_flags                  = UTENSIL_FLAG_COLLECT | UTENSIL_FLAG_SLICE
	drying_wetness                 = 60
	dried_type                     = /obj/item/food/jerky/meat
	nutriment_type                 = /decl/material/solid/organic/meat
	nutriment_amt                  = 9
	w_class                        = ITEM_SIZE_NORMAL
	backyard_grilling_product      = /obj/item/food/meatsteak/grilled
	backyard_grilling_announcement = "sizzles as it is grilled to medium-rare."

/obj/item/food/butchery/meat/proc/get_meat_icons()
	var/static/list/meat_icons = list(
		'icons/obj/items/butchery/meat1.dmi',
		'icons/obj/items/butchery/meat2.dmi',
		'icons/obj/items/butchery/meat3.dmi'
	)
	return meat_icons

/obj/item/food/butchery/meat/Initialize(mapload, material_key, skip_plate = FALSE, mob/living/donor)
	icon = pick(get_meat_icons())
	return ..()

/obj/item/food/butchery/meat/syntiflesh
	desc = "A slab of flesh synthetized from reconstituted biomass or artificially grown from chemicals."
	meat_name = "synthetic"

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/food/butchery/meat/human

/obj/item/food/butchery/meat/monkey
	//same as plain meat

/obj/item/food/butchery/meat/beef
	desc = "The classic red meat."
	meat_name = "beef"

/obj/item/food/butchery/meat/goat
	desc = "Goat meat, to the uncultured."
	meat_name = "chevon"

/obj/item/food/butchery/meat/chicken
	name = "piece"
	desc = "It tastes like you'd expect."
	material = /decl/material/solid/organic/meat/chicken
	meat_name = "chicken"

/obj/item/food/butchery/meat/chicken/game
	desc = "Fresh game meat, harvested from some wild bird."
	meat_name = "fowl"

/obj/item/food/butchery/meat/corgi
	desc = "Tastes like... well you know..."
	meat_name = "dog"
