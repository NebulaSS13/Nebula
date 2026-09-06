/decl/material/liquid/mucus
	name = "mucus"
	uid = "chem_mucus"
	lore_text = "A gooey semi-liquid produced by a wide variety of organisms. In some, it's associated with disease and illness."
	taste_description = "slime"
	color = COLOR_LIQUID_WATER
	opacity = 0.5
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

/decl/material/liquid/mucus/handle_stain_dry(obj/effect/decal/cleanable/blood/stain)
	qdel(stain)
	return TRUE // skip blood handling