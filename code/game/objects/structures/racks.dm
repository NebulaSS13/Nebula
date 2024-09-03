/obj/structure/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/structures/rack.dmi'
	icon_state = "rack"
	material = DEFAULT_FURNITURE_MATERIAL
	handle_generic_blending = FALSE
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR
	atom_flags = ATOM_FLAG_CLIMBABLE
	throwpass = TRUE
	parts_amount = 2
	parts_type = /obj/item/stack/material/strut
	density = TRUE
	anchored = TRUE
	structure_flags = STRUCTURE_FLAG_SURFACE

/obj/structure/rack/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/rack/LateInitialize()
	. = ..()
	var/i = -1
	for(var/obj/item/I in get_turf(src))
		if(!I.anchored && I.center_of_mass && I.simulated)
			i++
			I.pixel_x = 1  // There's a sprite layering bug for 0/0 pixelshift, so we avoid it.
			I.pixel_y = max(3-i*3, -3) + 1
			I.pixel_z = 0

/obj/structure/rack/attackby(obj/item/O, mob/user, click_params)
	. = ..()
	if(!. && !isrobot(user) && O.loc == user && user.try_unequip(O, loc))
		auto_align(O, click_params)
		return TRUE

/obj/structure/rack/holorack/dismantle_structure(mob/user)
	material = null
	reinf_material = null
	parts_type = null
	. = ..()

/obj/structure/rack/dark
	color = COLOR_GRAY40

/obj/structure/rack/walnut
	material = /decl/material/solid/organic/wood/walnut
	color = /decl/material/solid/organic/wood/walnut::color

/obj/structure/rack/ebony
	material = /decl/material/solid/organic/wood/ebony
	color = /decl/material/solid/organic/wood/ebony::color

/obj/structure/rack/mahogany
	material = /decl/material/solid/organic/wood/mahogany
	color = /decl/material/solid/organic/wood/mahogany::color
