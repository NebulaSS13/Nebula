/obj/structure/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/structures/rack.dmi'
	icon_state = "rack"
	material = DEFAULT_FURNITURE_MATERIAL
	handle_generic_blending = FALSE
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	throwpass = TRUE
	parts_amount = 2
	parts_type = /obj/item/stack/material/strut
	density = TRUE
	anchored = TRUE

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

/obj/structure/rack/holorack/dismantle()
	material = null
	reinf_material = null
	parts_type = null
	. = ..()

/obj/structure/rack/dark
	color = COLOR_GRAY40
