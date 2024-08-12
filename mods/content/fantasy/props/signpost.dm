/obj/effect/departure_signpost
	name       = "border post"
	desc       = "A tall lamplit signpost marking the edge of the region. Beyond lies distant kingdoms."
	icon       = 'mods/content/fantasy/icons/structures/signpost.dmi'
	icon_state = ICON_STATE_WORLD
	color      = /decl/material/solid/organic/wood/walnut::color
	density    = TRUE
	opacity    = FALSE
	anchored   = TRUE
	simulated  = FALSE
	pixel_z    = 12

	var/lit_light_power = /obj/item/flame/fuelled/lantern::lit_light_power
	var/lit_light_range = /obj/item/flame/fuelled/lantern::lit_light_range
	var/lit_light_color = /obj/item/flame/fuelled/lantern::lit_light_color

/obj/effect/departure_signpost/Initialize()
	. = ..()
	set_light(lit_light_range, lit_light_power, lit_light_color)
	update_icon()

/obj/effect/departure_signpost/on_update_icon()
	. = ..()
	add_overlay(overlay_image(icon, "[icon_state]-lamp", /decl/material/solid/metal/copper::color, RESET_COLOR))
	var/image/glow = emissive_overlay(icon, "[icon_state]-lamp-glow", color = lit_light_color)
	glow.appearance_flags |= RESET_COLOR
	add_overlay(glow)

/obj/effect/departure_signpost/attackby(obj/item/used_item, mob/user)
	SHOULD_CALL_PARENT(FALSE)
	return TRUE

/obj/effect/departure_signpost/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	var/choice = alert(user, "Are you sure you wish to depart? This will permanently remove your character from the round.", "Venture Forth?", "No", "Yes")
	if(choice != "Yes" || QDELETED(user) || user.incapacitated() || QDELETED(src) || !user.Adjacent(src))
		return TRUE
	var/obj/effect/dummy/fadeout = new(get_turf(user))
	fadeout.set_dir(dir)
	fadeout.appearance = user // grab appearance before ghostizing in case they fall over etc
	switch(dir)
		if(NORTH)
			animate(fadeout, pixel_z =  32, alpha = 0, time = 1 SECOND)
		if(SOUTH)
			animate(fadeout, pixel_z = -32, alpha = 0, time = 1 SECOND)
		if(EAST)
			animate(fadeout, pixel_w =  32, alpha = 0, time = 1 SECOND)
		if(WEST)
			animate(fadeout, pixel_w = -32, alpha = 0, time = 1 SECOND)
		else
			animate(fadeout, alpha = 0, time = 1 SECOND)
	QDEL_IN(fadeout, 1 SECOND)
	despawn_character(user)
	return TRUE

// Premade types for mapping.
/obj/effect/departure_signpost/north
	dir = NORTH

/obj/effect/departure_signpost/south
	dir = SOUTH

/obj/effect/departure_signpost/east
	dir = EAST

/obj/effect/departure_signpost/west
	dir = WEST
