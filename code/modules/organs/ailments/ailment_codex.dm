/datum/codex_entry/guide/ailments
	name = "Guide to Medical Ailments"
	mechanics_text = "Ailments are minor medical conditions that can crop up during a round. They aren't life-threatening, and frequently aren't anything more than slightly annoying, and treating them is generally straightforward."
	lore_text = "Day to day life can exert stress on the body, which can manifest in small, non-critical medical conditions like a sore back or a headache. 9/10 doctors recommend a visit to your local physician for treatment before they compound into a chronic or acute condition."
	var/show_robotics_recipes = FALSE
	var/name_column = "Ailment"
	var/treatment_column = "Recommended treatment"

/datum/codex_entry/guide/ailments/robotic
	name = "Prosthetic Faults"
	lore_text = "Prosthetic limbs can be prone to debilitating and often dangerous faults, especially if exposed to hostile conditions."
	mechanics_text = "EMP damage or improper installation can cause prosthetic limbs to develop problems, some of them more serious than others."
	show_robotics_recipes = TRUE
	name_column = "Fault"
	treatment_column = "Recommended repair"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/proc/get_chem_effect_display_name(effect)
	switch(effect)
		if(CE_PAINKILLER)
			return "painkillers"
		if(CE_ANTIBIOTIC)
			return "antibiotics"
		if(CE_ALCOHOL)
			return "alcohol"
		if(CE_ALCOHOL_TOXIC)
			return "alcohol overdose"
		if(CE_ANTITOX)
			return "antitoxins"
		if(CE_TOXIN)
			return "toxins"
		if(CE_SEDATE)
			return "sedative drugs"
		if(CE_ENERGETIC)
			return "stimulant drugs"
	return null

/datum/codex_entry/guide/ailments/New()
	var/list/ailment_table = list("<table border = 1px>")
	ailment_table += "<tr><td><b>[name_column]</b></td><td><b>[treatment_column]</b></td></tr>"
	for(var/atype in subtypesof(/datum/ailment))
		var/datum/ailment/ailment = get_ailment_reference(atype)
		if(!ailment.name || show_robotics_recipes != ailment.applies_to_prosthetics || ailment.hidden_from_codex)
			continue
		ailment_table += "<tr><td>[ailment.name]</td><td>"
		var/list/ailment_cures = list()
		var/list/treated_by_types = islist(ailment.treated_by_item_type) ? ailment.treated_by_item_type : list(ailment.treated_by_item_type)
		for(var/obj/item/thing as anything in treated_by_types) // if you put a non-item in here you deserve to have your face eaten by runtime errors
			ailment_cures += "[ailment.treated_by_item_cost] x [initial(thing.name)]"
		if(ailment.treated_by_reagent_type)
			if(islist(ailment.treated_by_reagent_type))
				for(var/mat_type in ailment.treated_by_reagent_type)
					var/decl/material/mat = GET_DECL(mat_type)
					ailment_cures += "[ailment.treated_by_reagent_dosage]u [mat.name]"
			else
				var/decl/material/mat = GET_DECL(ailment.treated_by_reagent_type)
				ailment_cures += "[ailment.treated_by_reagent_dosage]u [mat.name]"
		if(ailment.treated_by_chem_effect)
			ailment_cures += get_chem_effect_display_name(ailment.treated_by_chem_effect)
		if(!length(ailment_cures))
			ailment_cures += "Unknown."
		ailment_table += "[jointext(ailment_cures,"<br>")]</td></tr>"
	ailment_table += "</table>"
	mechanics_text = "[mechanics_text]<br><h2>Known [name]</h2>[jointext(ailment_table, "")]"
	..()