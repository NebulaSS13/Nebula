var/global/list/_primary_reagent_to_condiment_appearance
/proc/get_condiment_appearance(primary_reagent, condiment_key)
	if(!global._primary_reagent_to_condiment_appearance)
		global._primary_reagent_to_condiment_appearance = list()
		for(var/decl/condiment_appearance/condiment in decls_repository.get_decls_of_type_unassociated(/decl/condiment_appearance))
			if(condiment.condiment_type)
				if(condiment.condiment_key)
					global._primary_reagent_to_condiment_appearance["[condiment.condiment_type]-[condiment.condiment_key]"] = condiment
				else
					global._primary_reagent_to_condiment_appearance[condiment.condiment_type] = condiment
	if(condiment_key)
		return global._primary_reagent_to_condiment_appearance["[primary_reagent]-[condiment_key]"]
	return global._primary_reagent_to_condiment_appearance[primary_reagent]

/decl/condiment_appearance
	abstract_type = /decl/condiment_appearance
	var/condiment_type
	var/condiment_key
	var/condiment_name
	var/condiment_desc
	var/condiment_icon
	var/condiment_center_of_mass

/decl/condiment_appearance/validate()
	. = ..()
	if(condiment_type)
		if(!ispath(condiment_type, /decl/material))
			. += "invalid condiment type"
		else
			for(var/decl/condiment_appearance/other_condiment in decls_repository.get_decls_of_type_unassociated(/decl/condiment_appearance))
				if(other_condiment != src && other_condiment.condiment_type == condiment_type && condiment_key == other_condiment.condiment_key)
					. += "non-unique condiment '[condiment_type]' overlaps with [other_condiment.type]"

	if(!isicon(condiment_icon))
		. += "invalid or null icon"
