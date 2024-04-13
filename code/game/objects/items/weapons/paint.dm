//NEVER USE THIS IT SUX	-PETETHEGOAT
//THE GOAT WAS RIGHT - RKF

/obj/item/chems/glass/paint
	desc = "It's a paint bucket."
	name = "paint bucket"
	icon = 'icons/obj/items/paint_bucket.dmi'
	icon_state = "paintbucket"
	item_state = "paintcan"
	material = /decl/material/solid/metal/aluminium
	w_class = ITEM_SIZE_NORMAL
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[10,20,30,60]"
	volume = 60
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	var/pigment

/obj/item/chems/glass/paint/populate_reagents()
	var/amt = reagents.maximum_volume
	if(pigment)
		amt = round(amt/2)
		add_to_reagents(pigment, amt)
	add_to_reagents(/decl/material/liquid/paint, amt)

/obj/item/chems/glass/paint/on_update_icon()
	. = ..()
	if(reagents?.total_volume)
		add_overlay(overlay_image('icons/obj/reagentfillings.dmi', "paintbucket", reagents.get_color()))

/obj/item/chems/glass/paint/red
	name = "red paint bucket"
	pigment = /decl/material/liquid/pigment/red

/obj/item/chems/glass/paint/yellow
	name = "yellow paint bucket"
	pigment = /decl/material/liquid/pigment/yellow

/obj/item/chems/glass/paint/green
	name = "green paint bucket"
	pigment = /decl/material/liquid/pigment/green

/obj/item/chems/glass/paint/blue
	name = "blue paint bucket"
	pigment = /decl/material/liquid/pigment/blue

/obj/item/chems/glass/paint/purple
	name = "purple paint bucket"
	pigment = /decl/material/liquid/pigment/purple

/obj/item/chems/glass/paint/black
	name = "black paint bucket"
	pigment = /decl/material/liquid/pigment/black

/obj/item/chems/glass/paint/white
	name = "white paint bucket"
	pigment = /decl/material/liquid/pigment/white

/obj/item/chems/glass/paint/random
	name = "odd paint bucket"

/obj/item/chems/glass/paint/random/Initialize()
	pigment = pick(decls_repository.get_decl_paths_of_subtype(/decl/material/liquid/pigment))
	. = ..()
