/decl/material/liquid/surfactant // Foam precursor
	name = "surfacant"
	uid = "liquid_surfacant"
	lore_text = "A isocyanate liquid that forms a foam when mixed with water."
	taste_description = "metal"
	color = "#9e6b38"
	value = 0.1

/decl/material/liquid/foaming_agent // Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "foaming agent"
	uid = "liquid_foaming_agent"
	lore_text = "A agent that yields metallic foam when mixed with light metal and a strong acid."
	taste_description = "metal"
	color = "#664b63"
	value = 0.1

/decl/material/liquid/lube
	name = "lubricant"
	uid = "liquid_lubricant"
	lore_text = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	taste_description = "slime"
	color = SYNTH_BLOOD_COLOR
	value = 0.1
	slipperiness = 80
