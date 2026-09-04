/obj/structure/chair/bench/pew
	name = "pew"
	desc = "A long bench with a backboard, commonly found in places of worship, courtrooms and so on. Not known for being particularly comfortable."
	icon = 'icons/obj/structures/furniture/pew.dmi'

/obj/structure/chair/bench/pew/get_material_icon()
	return material?.pew_icon || initial(icon)

/obj/structure/chair/bench/pew/mahogany
	color    = /decl/material/solid/organic/wood/mahogany::color
	material = /decl/material/solid/organic/wood/mahogany

/obj/structure/chair/bench/pew/ebony
	color    = /decl/material/solid/organic/wood/ebony::color
	material = /decl/material/solid/organic/wood/ebony
