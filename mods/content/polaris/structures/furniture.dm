/obj/structure/drying_rack/sif
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/obj/structure/chair/wood/wings/sif
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/obj/structure/door/sif
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/obj/structure/table/sif
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/obj/structure/table/bench/sif
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/obj/structure/table/bench/sif/padded
	icon_state = "padded_preview"
	reinf_material = /decl/material/solid/organic/wood/sif
	felted = TRUE

/obj/structure/fire_source/firepit/sif/Initialize()
	new /obj/item/stack/material/log/mapped/sif/fifteen(src)
	. = ..()

/obj/structure/boat/sif
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/obj/structure/boat/dragon/sif
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/obj/item/oar/sif
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color
