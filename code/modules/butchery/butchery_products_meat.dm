/obj/item/food/butchery/meat
	name                           = "slab"
	desc                           = "A slab of meat."
	icon                           = 'icons/obj/food/butchery/meat1.dmi'
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
	w_class                        = ITEM_SIZE_SMALL
	backyard_grilling_product      = /obj/item/food/meatsteak/grilled
	backyard_grilling_announcement = "sizzles as it is grilled to medium-rare."

/obj/item/food/butchery/meat/proc/get_meat_icons()
	var/static/list/meat_icons = list(
		'icons/obj/food/butchery/meat1.dmi',
		'icons/obj/food/butchery/meat2.dmi',
		'icons/obj/food/butchery/meat3.dmi'
	)
	return meat_icons

/obj/item/food/butchery/meat/Initialize(mapload, material_key, skip_plate = FALSE, mob/living/donor)
	icon = pick(get_meat_icons())
	return ..()

/obj/item/food/butchery/meat/syntiflesh
	desc = "A slab of flesh synthesized from reconstituted biomass or artificially grown from chemicals."
	meat_name = "synthetic"

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/food/butchery/meat/human

/obj/item/food/butchery/meat/monkey
	//same as plain meat

/obj/item/food/butchery/meat/beef
	desc = "The classic red meat."
	butchery_data = /decl/butchery_data/animal/ruminant/cow

/obj/item/food/butchery/meat/goat
	desc = "Goat meat, to the uncultured."
	butchery_data = /decl/butchery_data/animal/ruminant/goat

/obj/item/food/butchery/meat/chicken
	name = "piece"
	desc = "It tastes like you'd expect."
	material = /decl/material/solid/organic/meat/chicken
	color = /decl/material/solid/organic/meat/chicken::color
	butchery_data = /decl/butchery_data/animal/small/fowl/chicken

/obj/item/food/butchery/meat/chicken/game
	desc = "Fresh game meat, harvested from some wild bird."
	butchery_data = /decl/butchery_data/animal/small/fowl

/obj/item/food/butchery/meat/corgi
	desc = "Tastes like... well, you know..."
	butchery_data = /decl/butchery_data/animal/corgi

/obj/item/food/butchery/meat/xeno
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	color = "#43de18" // todo: add xenomeat material and use material alteration
	material_alteration = MAT_FLAG_ALTERATION_NONE
	center_of_mass = @'{"x":16,"y":10}'
	bitesize = 6
	butchery_data = /decl/butchery_data/xeno

/obj/item/food/butchery/meat/xeno/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/acid/polyacid, 6)

/obj/item/food/butchery/meat/bear
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	butchery_data = /decl/butchery_data/animal/space_bear

/obj/item/food/butchery/meat/bear/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/amphetamines, 5)
