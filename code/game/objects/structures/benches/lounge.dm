/obj/structure/chair/bench/lounge
	name       = "lounge"
	desc       = "An elegant lounge, perfect for reclining on."
	icon       = 'icons/obj/structures/furniture/lounge.dmi'

// Just use the existing icon.
/obj/structure/chair/bench/lounge/get_material_icon()
	return icon || initial(icon)

/obj/structure/chair/bench/lounge/mapped
	color          = /decl/material/solid/organic/wood/mahogany::color
	material       = /decl/material/solid/organic/wood/mahogany
	initial_padding_material = /decl/material/solid/organic/cloth
	initial_padding_color  = COLOR_RED_GRAY
