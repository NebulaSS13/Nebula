/datum/codex_category/materials/
	name = "Materials"
	desc = "Various natural and artificial materials."

/datum/codex_category/materials/Initialize()
	for(var/thing in SSmaterials.materials)
		var/decl/material/mat = thing
		if(!mat.hidden_from_codex)
			var/datum/codex_entry/entry = new(_display_name = "[mat.solid_name] (material)")
			entry.lore_text = mat.lore_text
			entry.antag_text = mat.antag_text
			var/list/material_info = list(mat.mechanics_text)

			material_info += "Its melting point is [mat.melting_point] K."

			if(mat.ore_compresses_to && mat.ore_compresses_to != mat.type)
				var/decl/material/M = decls_repository.get_decl(mat.ore_compresses_to)
				material_info += "It can be compressed into [M.solid_name]."

			if(mat.ore_smelts_to && mat.ore_smelts_to != mat.type)
				var/decl/material/M = decls_repository.get_decl(mat.ore_smelts_to)
				material_info += "It can be smelted into [M.solid_name]."

			if(mat.brute_armor < 2)
				material_info += "It is weak to physical impacts."
			else if(mat.brute_armor > 2)
				material_info += "It is [mat.brute_armor > 4 ? "very " : null]resistant to physical impacts."
			else
				material_info += "It has average resistance to physical impacts."

			if(mat.burn_armor < 2)
				material_info += "It is weak to applied energy."
			else if(mat.burn_armor > 2)
				material_info += "It is [mat.burn_armor > 4 ? "very " : null]resistant to applied energy."
			else
				material_info += "It has average resistance to applied energy."

			if(mat.conductive)
				material_info += "It conducts electricity."
			else
				material_info += "It does not conduct electricity."
			
			if(mat.opacity < 0.5)
				material_info += "It is transparent."

			if(mat.weight <= MAT_VALUE_LIGHT)
				material_info += "It is very light."
			else if(mat.weight >= MAT_VALUE_HEAVY)
				material_info += "It is very heavy."
			else
				material_info += "It is of average weight."

			var/decl/material/steel = SSmaterials.materials_by_name[MAT_STEEL]
			var/comparison = round(mat.hardness / steel.hardness, 0.1)
			if(comparison >= 0.9 && comparison <= 1.1)
				material_info += "It is as hard as steel."
			else if (comparison < 0.9)
				comparison = round(1/max(comparison,0.01),0.1)
				material_info += "It is ~[comparison] times softer than steel."
			else
				material_info += "It is ~[comparison] times harder than steel."

			comparison = round(mat.integrity / steel.integrity, 0.1)
			if(comparison >= 0.9 && comparison <= 1.1)
				material_info += "It is as durable as steel."
			else if (comparison < 0.9)
				comparison = round(1/comparison,0.1)
				material_info += "It is ~[comparison] times structurally weaker than steel."
			else
				material_info += "It is ~[comparison] times more durable than steel."

			if(mat.solvent_power > MAT_SOLVENT_NONE)
				if(mat.solvent_power <= MAT_SOLVENT_MILD)
					material_info += "It is a mild solvent."
				else if(mat.solvent_power <= MAT_SOLVENT_MODERATE)
					material_info += "It is a moderately strong solvent, capable of removing ink."
				else if(mat.solvent_power <= MAT_SOLVENT_STRONG)
					material_info += "It is a strong solvent and will burn exposed skin on contact."

			if(LAZYLEN(mat.dissolves_into))
				var/chems = list()
				for(var/chemical in mat.dissolves_into)
					var/decl/material/R = chemical
					chems += "[initial(R.name)] ([mat.dissolves_into[chemical]*100]%)"

				var/solvent_needed
				if(mat.dissolves_in <= MAT_SOLVENT_NONE)
					solvent_needed = "any liquid"
				else if(mat.dissolves_in <= MAT_SOLVENT_MILD)
					solvent_needed = "a mild solvent, like water"
				else if(mat.dissolves_in <= MAT_SOLVENT_MODERATE)
					solvent_needed = "a moderately strong solvent, like acetone"
				else if(mat.dissolves_in <= MAT_SOLVENT_STRONG)
					solvent_needed = "a strong solvent, like sulphuric acid"

				material_info += "The following chemicals can be extracted from it with [solvent_needed] solvent:<br> [english_list(chems)]"

			if(LAZYLEN(mat.alloy_materials))
				var/parts = list()
				for(var/alloy_part in mat.alloy_materials)
					var/decl/material/part = SSmaterials.materials_by_name[alloy_part]
					parts += "[mat.alloy_materials[alloy_part]]u [part.name]"
				material_info += "It is an alloy of the following materials: [english_list(parts)]"

			if(mat.radioactivity)
				material_info += "It is radioactive."

			if(mat.flags & MAT_FLAG_FUSION_FUEL)
				material_info += "It can be used as fusion fuel."

			if(mat.flags & MAT_FLAG_UNMELTABLE)
				material_info += "It is impossible to melt."

			if(mat.flags & MAT_FLAG_BRITTLE)
				material_info += "It is brittle and can shatter under strain."

			if(mat.flags & MAT_FLAG_PADDING)
				material_info += "It can be used to pad furniture."

			entry.mechanics_text = jointext(material_info,"<br>")
			SScodex.add_entry_by_string(entry.display_name, entry)
			items += entry.display_name
	..()