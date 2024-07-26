/obj/item/flame/candle
	name                  = "candle"
	desc                  = "A small pillar candle. Its specially-formulated fuel-oxidizer wax mixture allows continued combustion in airless environments."
	icon                  = 'icons/obj/items/flame/candle.dmi'
	w_class               = ITEM_SIZE_TINY
	material              = /decl/material/solid/organic/wax
	lit_light_range       = 2
	_fuel                 = null
	sconce_can_hold       = TRUE
	extinguish_on_dropped = FALSE

// This is mostly just to change the scifi desc set above.
/obj/item/flame/candle/handmade
	desc = "A slender wax candle with a cotton wick."

/obj/item/flame/candle/spent
	_fuel           = 0

/obj/item/flame/candle/red
	paint_color = COLOR_RED

/obj/item/flame/candle/Initialize()

	// Enough for 27-33 minutes. 30 minutes on average, adjusted for subsystem tickrate.
	if(isnull(_fuel))
		_fuel = round(rand(27 MINUTES, 33 MINUTES) / SSobj.wait)

	var/list/available_colors = get_available_colors()
	if(LAZYLEN(available_colors))
		set_color(pick(available_colors))

	. = ..()

/obj/item/flame/candle/get_sconce_overlay()
	. = list(overlay_image(icon, "[icon_state]-sconce", color = color, flags = RESET_COLOR))
	if(lit)
		. += overlay_image(icon, "[icon_state]-sconce-lit", color = color, flags = RESET_COLOR)

/obj/item/flame/candle/on_update_icon()

	..()

	var/remaining_fuel = get_fuel()
	icon_state = get_world_inventory_state()
	switch(remaining_fuel)
		if(1500 to INFINITY)
			icon_state = "[icon_state]1"
		if(800 to 1500)
			icon_state = "[icon_state]2"
		if(1 to 800)
			icon_state = "[icon_state]3"
		else
			icon_state = "[icon_state]4"

	if(lit && remaining_fuel > 0)
		// TODO: emissives
		add_overlay(overlay_image(icon, "[icon_state]_lit", flags = RESET_COLOR))

/obj/item/flame/candle/proc/get_available_colors()
	return null

/obj/item/flame/candle/random/get_available_colors()
	var/static/list/available_colours = list(
		COLOR_WHITE,
		COLOR_DARK_GRAY,
		COLOR_RED,
		COLOR_ORANGE,
		COLOR_YELLOW,
		COLOR_GREEN,
		COLOR_BLUE,
		COLOR_INDIGO,
		COLOR_VIOLET
	)
	return available_colours

/obj/item/flame/candle/get_available_scents()
	return null

/obj/item/flame/candle/scented
	name = "scented candle"
	desc = "A candle which releases pleasant-smelling oils into the air when burned."

/obj/item/flame/candle/scented/get_available_scents()
	var/static/list/available_scents = list(
		/decl/scent_type/rose,
		/decl/scent_type/cinnamon,
		/decl/scent_type/vanilla,
		/decl/scent_type/seabreeze,
		/decl/scent_type/lavender
	)
	return available_scents

/obj/item/flame/candle/scented/incense
	name = "incense cone"
	desc = "An incense cone. It produces fragrant smoke when burned."
	icon = 'icons/obj/items/flame/incense.dmi'
	sconce_can_hold = FALSE

/obj/item/flame/candle/scented/incense/get_available_scents()
	var/static/list/available_scents = list(
		/decl/scent_type/rose,
		/decl/scent_type/citrus,
		/decl/scent_type/sage,
		/decl/scent_type/frankincense,
		/decl/scent_type/mint,
		/decl/scent_type/champa,
		/decl/scent_type/lavender,
		/decl/scent_type/sandalwood
	)
	return available_scents

/obj/item/flame/candle/scented/incense/get_available_colors()
	return null
