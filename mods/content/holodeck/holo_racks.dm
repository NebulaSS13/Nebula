/obj/structure/rack/holorack
	holographic = TRUE
	worthless = TRUE
	color = COLOR_OFF_WHITE
	material = /decl/material/solid/metal/aluminium/holographic
	reinf_material = /decl/material/solid/metal/aluminium/holographic

/obj/structure/rack/holorack/dismantle_structure(mob/user)
	material = null
	reinf_material = null
	parts_type = null
	. = ..()