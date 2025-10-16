// Frames
/obj/item/frame/light
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	build_machine_type = /obj/machinery/light
	reverse = 1

/obj/item/frame/light/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-item"
	material = /decl/material/solid/metal/steel
	build_machine_type = /obj/machinery/light/small

/obj/item/frame/light/spot
	name = "spotlight fixture frame"
	icon_state = "tube-construct-item"
	material = /decl/material/solid/metal/steel
	build_machine_type = /obj/machinery/light/spot

/obj/item/frame/light/nav
	name = "navigation light fixture frame"
	icon_state = "tube-construct-item"
	material = /decl/material/solid/metal/steel
	build_machine_type = /obj/machinery/light/navigation

/obj/item/machine_chassis/flamp
	name = "lamp fixture frame"
	desc = "A bare frame for a standing lamp fixture. Must be secured to the floor with a wrench."
	icon = 'icons/obj/floorlamp.dmi'
	icon_state = "flamp-construct-item"
	w_class = ITEM_SIZE_STRUCTURE
	material = /decl/material/solid/metal/steel
	build_type = /obj/machinery/light/flamp/noshade/deconstruct

// Partially-constructed presets for mapping
/obj/machinery/light/fixture
	icon_state = "tube-construct-stage1"

/obj/machinery/light/fixture/Initialize(mapload, d, populate_parts)
	. = ..(mapload, d, populate_parts = FALSE)
	construct_state.post_construct(src)

/obj/machinery/light/small/fixture
	icon_state = "bulb-construct-stage1"

/obj/machinery/light/small/fixture/Initialize(mapload, d, populate_parts)
	. = ..(mapload, d, populate_parts = FALSE)
	construct_state.post_construct(src)

// Subtype used for creation via crafting.
/obj/machinery/light/flamp/noshade/deconstruct
	light_type = null
	panel_open = TRUE
	construct_state = /decl/machine_construction/wall_frame/no_wires/simple