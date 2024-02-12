/decl/material/solid/slag
	name = "slag"
	uid = "solid_slag"
	color = "#2e3a07"
	ore_name = "slag"
	ore_desc = "Someone messed up..."
	ore_icon_overlay = "lump"
	hidden_from_codex = TRUE
	reflectiveness = MAT_VALUE_DULL
	wall_support_value = MAT_VALUE_LIGHT
	dissolves_into = list(
		/decl/material/solid/sand =    0.5,
		/decl/material/solid/metal/iron =      0.2,
		/decl/material/solid/metal/aluminium = 0.05,
		/decl/material/solid/phosphorus =      0.05,
		/decl/material/gas/sulfur_dioxide =    0.05,
		/decl/material/gas/carbon_dioxide =    0.05
	)
	value = 0.1
	default_solid_form = /obj/item/stack/material/lump
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

	// Slag can be reclaimed into more useful forms by grinding it up and mixing it with strong acid.
	dissolves_in = MAT_SOLVENT_STRONG
	dissolves_into = list(
		/decl/material/solid/sand =    0.7,
		/decl/material/solid/metal/iron =      0.1,
		/decl/material/solid/metal/aluminium = 0.05,
		/decl/material/solid/phosphorus =      0.05,
		/decl/material/gas/sulfur_dioxide =    0.05,
		/decl/material/gas/carbon_dioxide =    0.05
	)
