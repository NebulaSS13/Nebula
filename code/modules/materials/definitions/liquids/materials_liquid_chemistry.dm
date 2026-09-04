/decl/material/liquid/surfactant // Foam precursor
	name = "surfactant"
	uid = "liquid_surfactant"
	lore_text = "An isocyanate liquid that forms a foam when mixed with water."
	taste_description = "metal"
	color = "#9e6b38"
	value = 0.1
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/foaming_agent // Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "foaming agent"
	uid = "liquid_foaming_agent"
	lore_text = "An agent that yields metallic foam when mixed with light metal and a strong acid."
	taste_description = "metal"
	color = "#664b63"
	value = 0.1
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/foam
	name = "foam"
	uid = "liquid_foam"
	lore_text = "A frothy, sticky, well-aerated fluid."
	taste_description = "chemical blandness"
	color = "#a59da4"
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/lube
	name = "lubricant"
	uid = "liquid_lubricant"
	lore_text = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	taste_description = "slime"
	color = SYNTH_BLOOD_COLOR
	opacity = 1.0 // liquid default is 0.5, we want oil to be fully opaque so the footsteps are too
	value = 0.1
	slipperiness = 80
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC
	coated_adjective = "oily"

// Prevent oil stains from drying.
/decl/material/liquid/lube/get_time_to_dry_stain(obj/effect/decal/cleanable/blood/stain)
	return -1