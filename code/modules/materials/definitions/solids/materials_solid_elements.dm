/decl/material/solid/boron
	name = "boron"
	uid = "solid_boron"
	lore_text = "Boron is a chemical element with the symbol B and atomic number 5."
	melting_point = 2349
	boiling_point = 4200
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
	melting_point = 453
	boiling_point = 1615
	flags = MAT_FLAG_FUSION_FUEL
	taste_description = "metal"
	color = "#808080"
	value = 0.5
	narcosis = 5

/decl/material/solid/carbon
	name = "carbon"
	uid = "solid_carbon"
	lore_text = "A chemical element, the building block of life."
	melting_point = 3800
	boiling_point = 4300
	taste_description = "sour chalk"
	taste_mult = 1.5
	color = "#1c1300"
	value = 0.5
	dirtiness = 30

/decl/material/solid/carbon/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested && LAZYLEN(ingested.reagent_volumes) > 1)
		var/effect = 1 / (LAZYLEN(ingested.reagent_volumes) - 1)
		for(var/R in ingested.reagent_volumes)
			if(R != type)
				ingested.remove_reagent(R, removed * effect)

/decl/material/solid/carbon/ashes
	name = "ashes"
	uid = "solid_ashes"
	lore_text = "The powdery remains of burned organic material."
	color = "#5c5c5c"
	dissolves_in = MAT_SOLVENT_MODERATE
	// Todo: calcium
	dissolves_into = list(
		/decl/material/solid/carbon = 1
	)

/decl/material/solid/phosphorus
	name = "phosphorus"
	uid = "solid_phosphorus"
	lore_text = "A chemical element, the backbone of biological energy carriers."
	melting_point = 317
	boiling_point = 550
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
	melting_point = 1687
	boiling_point = 3173
	taste_description = "salty metal"
	color = "#808080"
	value = 0.5

/decl/material/solid/sulfur
	name = "sulfur"
	uid = "solid_sulfur"
	lore_text = "A chemical element with a pungent smell."
	melting_point = 388
	boiling_point = 717
	taste_description = "old eggs"
	color = "#bf8c00"
	value = 0.5

/decl/material/solid/potassium
	name = "potassium"
	uid = "solid_potassium"
	lore_text = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	melting_point = 336
	boiling_point = 1032
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	color = "#a0a0a0"
	value = 0.5

/decl/material/solid/potassium/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume > 3)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 10)
		M.add_chemical_effect(CE_PULSE, 1)
