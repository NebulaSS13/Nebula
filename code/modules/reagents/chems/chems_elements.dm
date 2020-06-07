/decl/material/chem/ammonia
	name = "ammonia"
	taste_description = "mordant"
	taste_mult = 2
	lore_text = "A caustic substance commonly used in fertilizer or household cleaners."
	color = "#404030"
	metabolism = REM * 0.5
	overdose = 5
	value = 0.5

/decl/material/chem/carbon
	name = "carbon"
	lore_text = "A chemical element, the building block of life."
	taste_description = "sour chalk"
	taste_mult = 1.5
	color = "#1c1300"
	value = 0.5
	dirtiness = 30

/decl/material/chem/carbon/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested && LAZYLEN(ingested.reagent_volumes) > 1)
		var/effect = 1 / (LAZYLEN(ingested.reagent_volumes) - 1)
		for(var/R in ingested.reagent_volumes)
			if(R != type)
				ingested.remove_reagent(R, removed * effect)

/decl/material/chem/lithium
	name = "lithium"
	lore_text = "A chemical element, used as antidepressant."
	taste_description = "metal"
	color = "#808080"
	value = 0.5
	narcosis = 5

/decl/material/chem/mercury
	name = "mercury"
	lore_text = "A chemical element."
	taste_mult = 0 //mercury apparently is tasteless. IDK
	color = "#484848"
	value = 0.5
	narcosis = 5

/decl/material/chem/phosphorus
	name = "phosphorus"
	lore_text = "A chemical element, the backbone of biological energy carriers."
	taste_description = "vinegar"
	color = "#832828"
	value = 0.5

/decl/material/chem/potassium
	name = "potassium"
	lore_text = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	taste_description = "sweetness" //potassium is bitter in higher doses but sweet in lower ones.
	color = "#a0a0a0"
	value = 0.5

/decl/material/chem/potassium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/volume = REAGENT_VOLUME(holder, type)
	if(volume > 3)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 10)
		M.add_chemical_effect(CE_PULSE, 1)

/decl/material/chem/radium
	name = "radium"
	lore_text = "Radium is an alkaline earth metal. It is extremely radioactive."
	taste_description = "the color blue, and regret"
	color = "#c7c7c7"
	value = 0.5
	radioactivity = 12

/decl/material/chem/silicon
	name = "silicon"
	lore_text = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	color = "#a8a8a8"
	value = 0.5

/decl/material/chem/sodium
	name = "sodium"
	lore_text = "A chemical element, readily reacts with water."
	taste_description = "salty metal"
	color = "#808080"
	value = 0.5

/decl/material/chem/sulfur
	name = "sulfur"
	lore_text = "A chemical element with a pungent smell."
	taste_description = "old eggs"
	color = "#bf8c00"
	value = 0.5

/decl/material/chem/tungsten
	name = "tungsten"
	lore_text = "A chemical element, and a strong oxidising agent."
	taste_mult = 0 //no taste
	color = "#dcdcdc"
	value = 0.5
