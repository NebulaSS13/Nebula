/obj/structure/drying_rack/sifwood
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/obj/structure/chair/wood/wings/sifwood
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/obj/structure/door/sifwood
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/obj/structure/table/sifwood
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/obj/structure/table/bench/sifwood
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/obj/structure/table/bench/sifwood/padded
	icon_state = "padded_preview"
	reinf_material = /decl/material/solid/organic/wood/sif
	felted = TRUE

/obj/structure/fire_source/firepit/sifwood/Initialize()
	new /obj/item/stack/material/log/mapped/sif/fifteen(src)
	. = ..()

/obj/structure/boat/sifwood
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color

/obj/item/oar/sifwood
	material = /decl/material/solid/organic/wood/sif
	color = /decl/material/solid/organic/wood/sif::color
