/obj/item/chems/food/butchery/meat
	name           = "meat"
	desc           = "A slab of meat."
	icon           = 'icons/obj/items/butchery/meat1.dmi'
	icon_state     = "meat"
	slice_path     = /obj/item/chems/food/cutlet/raw
	slice_num      = 3
	filling_color  = "#ff1c1c"
	center_of_mass = @'{"x":16,"y":14}'
	bitesize       = 3
	utensil_flags  = UTENSIL_FLAG_COLLECT | UTENSIL_FLAG_SLICE
	drying_wetness = 60
	dried_type     = /obj/item/chems/food/jerky/meat
	nutriment_type = /decl/material/solid/organic/meat
	nutriment_amt  = 9

/obj/item/chems/food/butchery/meat/proc/get_meat_icons()
	var/static/list/meat_icons = list(
		'icons/obj/items/butchery/meat1.dmi',
		'icons/obj/items/butchery/meat2.dmi',
		'icons/obj/items/butchery/meat3.dmi'
	)
	return meat_icons

/obj/item/chems/food/butchery/meat/Initialize(ml, material_key, mob/living/donor)
	icon = pick(get_meat_icons())
	return ..()

/obj/item/chems/food/butchery/meat/syntiflesh
	name = "synthetic meat"
	desc = "A slab of flesh synthetized from reconstituted biomass or artificially grown from chemicals."

// Seperate definitions because some food likes to know if it's human.
// TODO: rewrite kitchen code to check a var on the meat item so we can remove
// all these sybtypes.
/obj/item/chems/food/butchery/meat/human

/obj/item/chems/food/butchery/meat/monkey
	//same as plain meat

/obj/item/chems/food/butchery/meat/corgi
	name = "corgi meat"
	desc = "Tastes like... well, you know."

/obj/item/chems/food/butchery/meat/beef
	name = "beef slab"
	desc = "The classic red meat."

/obj/item/chems/food/butchery/meat/goat
	name = "chevon slab"
	desc = "Goat meat, to the uncultured."

/obj/item/chems/food/butchery/meat/chicken
	name = "chicken piece"
	desc = "It tastes like you'd expect."
	material = /decl/material/solid/organic/meat/chicken

/obj/item/chems/food/butchery/meat/chicken/game
	name = "game bird piece"
	desc = "Fresh game meat, harvested from some wild bird."

/obj/item/chems/food/butchery/meat/corgi
	name = "corgi meat"
	desc = "Tastes like... well you know..."
