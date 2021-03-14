/decl/codex_category/substances
	name = "Substances"
	desc = "Various natural and artificial substances."

/decl/codex_category/substances/Initialize()
	for(var/thing in SSmaterials.materials)
		var/decl/material/mat = thing
		if(!mat.hidden_from_codex)
			var/datum/codex_entry/entry = new(_display_name = "[mat.name] (substance)", _associated_strings = list("[mat.name] pill"))
			var/new_lore_text = initial(mat.lore_text) 
			if(mat.taste_description)
				new_lore_text = "[new_lore_text]<br>It apparently tastes of [mat.taste_description]."
			entry.lore_text = new_lore_text
			entry.antag_text = mat.antag_text
			var/list/material_info = list(mat.mechanics_text)

			var/list/production_strings = list()
			for(var/react in SSmaterials.chemical_reactions_by_result[thing])
				var/datum/chemical_reaction/reaction = react
				if(!reaction.name || reaction.hidden_from_codex)
					continue
				var/list/reactant_values = list()
				for(var/reactant_id in reaction.required_reagents)
					var/decl/material/reactant = reactant_id
					reactant_values += "[reaction.required_reagents[reactant_id]]u [lowertext(initial(reactant.name))]"
				if(!reactant_values.len)
					continue
				var/list/catalysts = list()
				for(var/catalyst_id in reaction.catalysts)
					var/decl/material/catalyst = catalyst_id
					catalysts += "[reaction.catalysts[catalyst_id]]u [lowertext(initial(catalyst.name))]"
				var/decl/material/result = reaction.result
				if(catalysts.len)
					production_strings += "Mixing [english_list(reactant_values)], catalyzed by [english_list(catalysts)], producing [reaction.result_amount]u [lowertext(initial(result.name))]."
				else
					production_strings += "Mixing [english_list(reactant_values)], producing [reaction.result_amount]u [lowertext(initial(result.name))]."

			if(length(production_strings))
				material_info += "<br>This substance can be produced by:<ul>"
				for(var/prodstr in production_strings)
					material_info += "<li>[prodstr]</li>"
				material_info += "</ul>"

			material_info += "<br>This substance has the following properties:<ul>"
			material_info += "<li>Its melting point is [mat.melting_point] K.</li>"
			material_info += "<li>Its boiling point is [mat.boiling_point] K.</li>"
			if(mat.solvent_power > MAT_SOLVENT_NONE)
				if(mat.solvent_power <= MAT_SOLVENT_MILD)
					material_info += "<li>It is a mild solvent.</li>"
				else if(mat.solvent_power <= MAT_SOLVENT_MODERATE)
					material_info += "<li>It is a moderately strong solvent, capable of removing ink.</li>"
				else if(mat.solvent_power <= MAT_SOLVENT_STRONG)
					material_info += "<li>It is a strong solvent and will burn exposed skin on contact.</li>"
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
				material_info += "<li>It can be dissolved with [solvent_needed] solvent, producing [english_list(chems)].</li>"
			if(mat.radioactivity)
				material_info += "<li>It is radioactive.</li>"
			if(mat.flags & MAT_FLAG_FUSION_FUEL)
				material_info += "<li>It can be used in a fusion reaction.</li>"
			if(mat.ore_compresses_to && mat.ore_compresses_to != mat.type)
				var/decl/material/M = GET_DECL(mat.ore_compresses_to)
				material_info += "<li>It can be compressed into [M.solid_name].</li>"
			if(length(mat.heating_products))
				var/list/heat_prod = list()
				for(var/mtype in mat.heating_products)
					var/decl/material/M = GET_DECL(mtype)
					heat_prod += "[mat.heating_products[mtype] * 100]% [M.solid_name]"
				material_info += "<li>It can be smelted into [english_list(heat_prod)] at a temperature of [mat.heating_point] Kelvin.</li>"
			if(length(mat.chilling_products))
				var/list/chill_prod = list()
				for(var/mtype in mat.chilling_products)
					var/decl/material/M = GET_DECL(mtype)
					chill_prod += "[mat.chilling_products[mtype] * 100]% [M.solid_name]"
				material_info += "<li>It can be cooled into [english_list(chill_prod)] at a temperature of [mat.chilling_point] Kelvin.</li>"

			material_info += "</ul>"

			material_info += "As a gas or vapor, it has the following properties:<ul>"
			var/list/gas_info = list()
			gas_info+= "<li>It has a specific heat of [mat.gas_specific_heat] J/(mol*K).</li>"
			gas_info+= "<li>It has a molar mass of [mat.gas_molar_mass] kg/mol.</li>"
			if(mat.gas_flags & XGM_GAS_FUEL)
				gas_info+= "<li>It is flammable.</li>"
				if(mat.burn_product)
					var/decl/material/firemat = GET_DECL(mat.burn_product)
					gas_info+= "<li>It produces [firemat.gas_name] when burned.</li>"
			if(mat.gas_flags & XGM_GAS_OXIDIZER)
				gas_info+= "<li>It is an oxidizer, required to sustain fire.</li>"
			if(mat.gas_flags & XGM_GAS_CONTAMINANT)
				gas_info+= "<li>It contaminates exposed clothing with residue.</li>"
			if(mat.flags & MAT_FLAG_FUSION_FUEL)
				gas_info+= "<li>It can be used as fuel in a fusion reaction.</li>"
			if(mat.gas_condensation_point > 0 && mat.gas_condensation_point < INFINITY)
				gas_info += "<li>It condenses at [mat.gas_condensation_point] K.</li>"
			material_info += "</ul>"

			material_info += "As a building or crafting material, it has the following properties:<ul>"
			if(mat.brute_armor < 2)
				material_info += "<li>It is weak to physical impacts.</li>"
			else if(mat.brute_armor > 2)
				material_info += "<li>It is [mat.brute_armor > 4 ? "very " : null]resistant to physical impacts.</li>"
			else
				material_info += "<li>It has average resistance to physical impacts.</li>"
			if(mat.burn_armor < 2)
				material_info += "<li>It is weak to applied energy.</li>"
			else if(mat.burn_armor > 2)
				material_info += "<li>It is [mat.burn_armor > 4 ? "very " : null]resistant to applied energy.</li>"
			else
				material_info += "<li>It has average resistance to applied energy.</li>"
			if(mat.conductive)
				material_info += "<li>It conducts electricity.</li>"
			else
				material_info += "<li>It does not conduct electricity.</li>"
			if(mat.opacity < 0.5)
				material_info += "<li>It is transparent.</li>"
			if(mat.weight <= MAT_VALUE_LIGHT)
				material_info += "<li>It is very light.</li>"
			else if(mat.weight >= MAT_VALUE_HEAVY)
				material_info += "<li>It is very heavy.</li>"
			else
				material_info += "<li>It is of average weight.</li>"
			var/decl/material/steel = SSmaterials.materials_by_name[/decl/material/solid/metal/steel]
			var/comparison = round(mat.hardness / steel.hardness, 0.1)
			if(comparison >= 0.9 && comparison <= 1.1)
				material_info += "<li>It is as hard as steel.</li>"
			else if (comparison < 0.9)
				comparison = round(1/max(comparison,0.01),0.1)
				material_info += "<li>It is ~[comparison] times softer than steel.</li>"
			else
				material_info += "<li>It is ~[comparison] times harder than steel.</li>"
			comparison = round(mat.integrity / steel.integrity, 0.1)
			if(comparison >= 0.9 && comparison <= 1.1)
				material_info += "<li>It is as durable as steel.</li>"
			else if (comparison < 0.9)
				comparison = round(1/comparison,0.1)
				material_info += "<li>It is ~[comparison] times structurally weaker than steel.</li>"
			else
				material_info += "<li>It is ~[comparison] times more durable than steel.</li>"
			if(mat.flags & MAT_FLAG_UNMELTABLE)
				material_info += "<li>It is impossible to dissolve.</li>"
			if(mat.flags & MAT_FLAG_BRITTLE)
				material_info += "<li>It is brittle and can shatter under strain.</li>"
			if(mat.flags & MAT_FLAG_PADDING)
				material_info += "<li>It can be used to pad furniture.</li>"
			material_info += "</ul>"

			entry.mechanics_text = jointext(material_info, null)
			SScodex.add_entry_by_string(entry.display_name, entry)
			items += entry.display_name
	. = ..()