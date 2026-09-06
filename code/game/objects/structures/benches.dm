/obj/structure/table/bench
	name = "bench frame"
	icon = 'icons/obj/bench.dmi'
	icon_state = "solid_preview"
	desc = "It's a bench, for putting things on. Or standing on, if you really want to."
	top_surface_noun = "seat"
	can_flip = FALSE
	can_place_items = FALSE
	density = FALSE
	mob_offset = 0

/obj/structure/table/bench/reinforce_table()
	return FALSE

/obj/structure/table/bench/update_material_name(override_name)
	if(reinf_material)
		name = "[reinf_material.solid_name] bench"
	else if(material)
		name = "[material.solid_name] bench frame"
	else
		name = "bench frame"

/obj/structure/table/bench/CanPass(atom/movable/mover)
	return TRUE

/obj/structure/table/bench/frame
	icon_state = "frame"
	reinf_material = null

/obj/structure/table/bench/steel
	icon_state = "solid_preview"
	color = COLOR_GRAY40
	reinf_material = /decl/material/solid/metal/steel

/obj/structure/table/bench/wooden
	icon_state = "solid_preview"
	color = WOOD_COLOR_GENERIC
	material = /decl/material/solid/organic/wood/oak
	reinf_material = /decl/material/solid/organic/wood/oak

/obj/structure/table/bench/padded
	icon_state = "padded_preview"
	material = /decl/material/solid/metal/steel
	reinf_material = /decl/material/solid/metal/steel
	felted = TRUE

/obj/structure/table/bench/glass
	color = COLOR_DEEP_SKY_BLUE
	alpha = 77
	reinf_material = /decl/material/solid/glass

/obj/structure/table/bench/marble
	color = COLOR_OFF_WHITE
	reinf_material = /decl/material/solid/stone/marble
