/datum/codex_category/gases/
	name = "Gases"
	desc = "Notable gases."

/datum/codex_category/gases/Initialize()
	for(var/gas in SSmaterials.all_gasses)
		var/decl/material/mat = decls_repository.get_decl(gas)
		if(mat.hidden_from_codex)
			continue
		var/list/gas_info = list()
		gas_info+= "Specific heat: [mat.gas_specific_heat] J/(mol*K)."
		gas_info+= "Molar mass: [mat.gas_molar_mass] kg/mol."
		if(mat.gas_flags & XGM_GAS_FUEL)
			gas_info+= "It is flammable."
			if(mat.gas_burn_product)
				var/decl/material/firemat = decls_repository.get_decl(mat.gas_burn_product)
				gas_info+= "It produces [firemat.gas_name] when burned."
		if(mat.gas_flags & XGM_GAS_OXIDIZER)
			gas_info+= "It is an oxidizer, required to sustain fire."
		if(mat.gas_flags & XGM_GAS_CONTAMINANT)
			gas_info+= "It contaminates exposed clothing with residue."
		if(mat.flags & MAT_FLAG_FUSION_FUEL)
			gas_info+= "It can be used as fuel in a fusion reaction."
		if(mat.gas_condensation_point > 0 && mat.gas_condensation_point < INFINITY)
			gas_info += "It condenses at [mat.gas_condensation_point] K."
		var/datum/codex_entry/entry = new(_display_name = lowertext(trim("[mat.gas_name] (gas)")), _mechanics_text = jointext(gas_info, "<br>"))
		SScodex.add_entry_by_string(entry.display_name, entry)
		items += entry.display_name
	..()