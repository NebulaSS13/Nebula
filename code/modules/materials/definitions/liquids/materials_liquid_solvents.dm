/decl/material/liquid/acid
	name = "sulphuric acid"
	lore_text = "A very corrosive mineral acid with the molecular formula H2SO4."
	taste_description = "acid"
	color = "#db5008"
	metabolism = REM * 2
	touch_met = 50 // It's acid!
	value = 1.2
	solvent_power = MAT_SOLVENT_STRONG + 2
	solvent_melt_dose = 10

/decl/material/liquid/acid/hydrochloric //Like sulfuric, but less toxic and more acidic.
	name = "hydrochloric acid"
	lore_text = "A very corrosive mineral acid with the molecular formula HCl."
	taste_description = "stomach acid"
	color = "#808080"
	solvent_power = MAT_SOLVENT_STRONG
	solvent_melt_dose = 8
	solvent_max_damage = 30
	value = 1.5

/decl/material/liquid/acid/polyacid
	name = "polytrinic acid"
	lore_text = "Polytrinic acid is a an extremely corrosive chemical substance."
	taste_description = "acid"
	color = "#8e18a9"
	solvent_power = MAT_SOLVENT_STRONG + 7
	solvent_melt_dose = 4
	solvent_max_damage = 60
	value = 1.8

/decl/material/liquid/acid/stomach
	name = "stomach acid"
	taste_description = "coppery foulness"
	solvent_power = MAT_SOLVENT_MODERATE
	color = "#d8ff00"
	hidden_from_codex = TRUE
	value = 0

/decl/material/liquid/acetone
	name = "acetone"
	lore_text = "A colorless liquid solvent used in chemical synthesis."
	taste_description = "acid"
	color = "#808080"
	metabolism = REM * 0.2
	value = 0.1
	solvent_power = MAT_SOLVENT_MODERATE
	toxicity = 3
