//NEVER USE THIS IT SUX	-PETETHEGOAT
//THE GOAT WAS RIGHT - RKF

var/global/list/cached_icons = list()

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
	unacidable = 0
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	var/pigment

/obj/item/chems/glass/paint/Initialize()
	. = ..()
	if(pigment)
		var/amt = round(reagents.maximum_volume/2)
		reagents.add_reagent(pigment, amt)
		reagents.add_reagent(/decl/material/liquid/paint, amt)
	else
		reagents.add_reagent(/decl/material/liquid/paint, reagents.maximum_volume)

/obj/item/chems/glass/paint/on_update_icon()
	overlays.Cut()
	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "paintbucket")
		filling.color = reagents.get_color()
		overlays += filling

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
	pigment = pick(subtypesof(/decl/material/liquid/pigment))
	. = ..()
