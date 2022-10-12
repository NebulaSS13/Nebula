/decl/codex_category/fusion_reaction
	name = "Fusion Reactions"
	desc = "A list of fusion reactions that the R-UST tokamak can ignite."

/decl/codex_category/fusion_reaction/Populate()
	var/list/reactions = decls_repository.get_decls_of_subtype(/decl/fusion_reaction)
	for(var/rtype in reactions)
		var/decl/fusion_reaction/reaction = reactions[rtype]
		if(reaction.hidden_from_codex)
			continue

		var/decl/material/p_mat = GET_DECL(reaction.p_react)
		var/decl/material/s_mat = GET_DECL(reaction.s_react)
		var/list/reaction_info = list()
		reaction_info += "Fusion between [p_mat.name] and [s_mat.name] can be achieved with a plasma temperature of [T0C + reaction.minimum_reaction_temperature] Kelvin or higher."
		reaction_info += "This reaction consumes [initial(reaction.energy_consumption)] heat unit\s and produces [reaction.energy_production] heat unit\s."
		reaction_info += "The process has an instability rating of [reaction.instability] and a radiation rating of [reaction.radiation]."

		if(LAZYLEN(reaction.products))
			var/list/products_list = list()
			for(var/P in reaction.products)
				if(ispath(P, /decl/material))
					var/decl/material/product_mat = GET_DECL(P)
					products_list |= product_mat.name
			reaction_info += "In the process of [p_mat.name]-[s_mat.name] fusion, [english_list(products_list)] [LAZYLEN(products_list) == 1 ? "is" : "are"] produced."
		else
			reaction_info += "Nothing is produced in the process of [p_mat.name]-[s_mat.name] fusion."

		var/datum/codex_entry/entry = new(
			_display_name = "[reaction.codex_name || "[p_mat.name]-[s_mat.name]"] (fusion reaction)",
			_mechanics_text = jointext(reaction_info, "<br>")
		)
		items |= entry.name
	. = ..()