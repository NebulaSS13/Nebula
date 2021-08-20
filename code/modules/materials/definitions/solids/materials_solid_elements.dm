/decl/material/solid/boron
	name = "boron"
	uid = "solid_boron"
	lore_text = "Boron is a chemical element with the symbol B and atomic number 5."
	flags = MAT_FLAG_FUSION_FUEL | MAT_FLAG_FISSIBLE

	neutron_cross_section = 10
	neutron_interactions = list(
		INTERACTION_ABSORPTION = 2500
	)
	absorption_products = list(
		/decl/material/solid/lithium = 0.5,
		/decl/material/gas/helium = 0.5
	)
	neutron_absorption = 20

/decl/material/solid/lithium
	name = "lithium"
	uid = "solid_lithium"
	lore_text = "A chemical element, used as antidepressant."
	flags = MAT_FLAG_FUSION_FUEL
	taste_description = "metal"
	color = "#808080"
	value = 0.5
	narcosis = 5

/decl/material/solid/carbon
	name = "carbon"
	uid = "solid_carbon"
	lore_text = "A chemical element, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	color = "#1c1300"
	value = 0.5
	dirtiness = 30

/decl/material/solid/carbon/affect_ingest(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested && LAZYLEN(ingested.reagent_volumes) > 1)
		var/effect = 1 / (LAZYLEN(ingested.reagent_volumes) - 1)
		for(var/R in ingested.reagent_volumes)
			if(R != type)
				ingested.remove_reagent(R, removed * effect)

/decl/material/solid/phosphorus
	name = "phosphorus"
	uid = "solid_phosphorus"
	lore_text = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"
	color = "#832828"
	value = 0.5

/decl/material/solid/silicon
	name = "silicon"
	uid = "solid_silicon"
	lore_text = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	color = "#a8a8a8"
	value = 0.5

/decl/material/solid/sodium
	name = "sodium"
	uid = "solid_sodium"
	lore_text = "A chemical element, readily reacts with water."
	taste_description = "salty metal"
	color = "#808080"
	value = 0.5

/decl/material/solid/sulfur
	name = "sulfur"
	uid = "solid_sulfur"
	lore_text = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	color = "#bf8c00"
	value = 0.5

/decl/material/solid/potassium
	name = "potassium"
	uid = "solid_potassium"
	lore_text = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	color = "#a0a0a0"
	value = 0.5

/decl/material/solid/potassium/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume > 3)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 10)
		M.add_chemical_effect(CE_PULSE, 1)
