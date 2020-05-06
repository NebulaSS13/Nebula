// Ice is a drink for some reason.
/decl/material/drink/ice
	name = "ice"
	lore_text = "Frozen water, your dentist wouldn't like you chewing this."
	taste_description = "ice"
	taste_mult = 1.5
	icon_colour = "#619494"
	adj_temp = -5
	hydration = 10

	glass_name = "ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."
	glass_icon = DRINK_ICON_NOISY

	heating_message = "cracks and melts."
	heating_products = list(MAT_WATER)
	heating_point = 299 // This is about 26C, higher than the actual melting point of ice but allows drinks to be made properly without weird workarounds.
