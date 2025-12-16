/obj/item/chems/glass/bucket/paint
	name = "paint bucket"
	desc = "It's a paint bucket."
	icon = 'icons/obj/items/paint_bucket.dmi'
	material = /decl/material/solid/metal/aluminium
	w_class = ITEM_SIZE_NORMAL
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[10,20,30,60]"
	chem_volume = 60
	var/pigment

/obj/item/chems/glass/bucket/paint/populate_reagents()
	var/amt = REAGENT_MAXIMUM_VOLUME(reagents)
	if(pigment)
		amt = round(amt/2)
		add_to_reagents(pigment, amt)
	add_to_reagents(/decl/material/liquid/paint, amt)

/obj/item/chems/glass/bucket/paint/get_edible_material_amount(mob/eater)
	return 0

/obj/item/chems/glass/bucket/paint/get_utensil_food_type()
	return null

/obj/item/chems/glass/bucket/paint/red
	name = "red paint bucket"
	pigment = /decl/material/liquid/pigment/red

/obj/item/chems/glass/bucket/paint/yellow
	name = "yellow paint bucket"
	pigment = /decl/material/liquid/pigment/yellow

/obj/item/chems/glass/bucket/paint/green
	name = "green paint bucket"
	pigment = /decl/material/liquid/pigment/green

/obj/item/chems/glass/bucket/paint/blue
	name = "blue paint bucket"
	pigment = /decl/material/liquid/pigment/blue

/obj/item/chems/glass/bucket/paint/purple
	name = "purple paint bucket"
	pigment = /decl/material/liquid/pigment/purple

/obj/item/chems/glass/bucket/paint/black
	name = "black paint bucket"
	pigment = /decl/material/liquid/pigment/black

/obj/item/chems/glass/bucket/paint/white
	name = "white paint bucket"
	pigment = /decl/material/liquid/pigment/white

/obj/item/chems/glass/bucket/paint/random
	name = "odd paint bucket"

/obj/item/chems/glass/bucket/paint/random/Initialize()
	pigment = pick(decls_repository.get_decl_paths_of_subtype(/decl/material/liquid/pigment))
	. = ..()
