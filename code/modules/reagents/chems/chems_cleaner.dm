/decl/material/liquid/cleaner
	name = "spray cleaner"
	lore_text = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
	taste_description = "sourness"
	color = "#a5f0ee"
	touch_met = 50
	value = 0.15 // shelf price of bug spray per ml, cleaner in general is too cheap
	dirtiness = DIRTINESS_CLEAN
	turf_touch_threshold = 0.1
	uid = "chem_cleaner"
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/contaminant_cleaner
	name = "akaline detergent"
	lore_text = "A highly akaline hydrazine based detergent. Able to clean contaminants, but may release ammonia gas if used in open air."
	taste_description = "bleach"
	vapor_products = list(/decl/material/gas/ammonia = 0.5)
	color = "#213799"
	touch_met = 5
	toxicity = 5
	scent = "clean linen"
	scent_descriptor = SCENT_DESC_FRAGRANCE
	value = 0.25
	dirtiness = DIRTINESS_DECONTAMINATE
	decontamination_dose = 5
	turf_touch_threshold = 0.1
	uid = "chem_contaminant_cleaner"
	exoplanet_rarity_gas = MAT_RARITY_EXOTIC

/decl/material/liquid/cleaner/soap
	name = "soap"
	lore_text = "A soft solid compound used to clean things. Usually derived from oil or fat."
	taste_description = "waxy blandness"
	color = COLOR_BEIGE
	uid = "chem_soap"
	hardness         = MAT_VALUE_FLEXIBLE + 10
	melting_point    = 323
	ignition_point   = 353
	boiling_point    = 373
	accelerant_value = 0.3
