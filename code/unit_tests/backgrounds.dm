/datum/unit_test/background
	name = "BACKGROUND - All Species Background Values Shall Be Of Valid Types And Length"

/datum/unit_test/background/start_test()

	var/list/all_background_tokens = global.using_map.get_background_categories()

	var/fails = 0
	for(var/species_name in get_all_species())
		var/decl/species/species = get_species_by_key(species_name)
		if(!islist(species.default_background_info))
			fails++
			log_bad("Default background info for [species_name] is not a list.")
		else
			for(var/cat_type in species.default_background_info)
				if(!(cat_type in all_background_tokens))
					fails++
					log_bad("Default background info for [species_name] contains invalid tag '[cat_type]'.")
				else
					var/val = species.default_background_info[cat_type]
					if(!val)
						fails++
						log_bad("Default background value '[val]' for [species_name] tag '[cat_type]' is null, must be a type.")
					else if(istext(val))
						fails++
						log_bad("Default background value '[val]' for [species_name] tag '[cat_type]' is text, must be a type.")
					else
						var/decl/background_detail/background = GET_DECL(val)
						if(!istype(background))
							fails++
							log_bad("Default background value '[val]' for [species_name] tag '[cat_type]' is not a valid background label.")
						else if(background.category != cat_type)
							fails++
							log_bad("Default background value '[val]' for [species_name] tag '[cat_type]' does not match background datum category ([background.category] must equal [cat_type]).")
						else if(!background.description)
							fails++
							log_bad("Default background value '[val]' for [species_name] tag '[cat_type]' does not have a description set.")

		if(!islist(species.force_background_info))
			fails++
			log_bad("Forced background info for [species_name] is not a list.")
		else
			for(var/cat_type in species.force_background_info)
				if(!(cat_type in all_background_tokens))
					fails++
					log_bad("Forced background info for [species_name] contains invalid tag '[cat_type]'.")
				else
					var/val = species.force_background_info[cat_type]
					if(!val)
						fails++
						log_bad("Forced background value for [species_name] tag '[cat_type]' is null, must be a type.")
					else if(istext(val))
						fails++
						log_bad("Forced background value for [species_name] tag '[cat_type]' is text, must be a type.")
					else
						var/decl/background_detail/background = GET_DECL(val)
						if(!istype(background))
							fails++
							log_bad("Forced background value '[val]' for [species_name] tag '[cat_type]' is not a valid background label.")
						else if(background.category != cat_type)
							fails++
							log_bad("Forced background value '[val]' for [species_name] tag '[cat_type]' does not match background datum category ([background.category] must equal [cat_type]).")
						else if(!background.description)
							fails++
							log_bad("Forced background value '[val]' for [species_name] tag '[cat_type]' does not have a description set.")

		if(!islist(species.available_background_info))
			fails++
			log_bad("Available background info for [species_name] is not a list.")
		else
			for(var/cat_type in all_background_tokens)
				if(!islist(species.available_background_info[cat_type]))
					fails++
					log_bad("Available background info for [species_name] tag '[cat_type]' is invalid type, must be a list.")
				else if(!LAZYLEN(species.available_background_info[cat_type]))
					fails++
					log_bad("Available background info for [species_name] tag '[cat_type]' is empty, must have at least one entry.")
				else
					for(var/val in species.available_background_info[cat_type])
						if(istext(val))
							log_bad("Available background value '[val]' for [species_name] tag '[cat_type]' is text, must be a type.")
						else
							var/decl/background_detail/background = GET_DECL(val)
							if(!istype(background))
								fails++
								log_bad("Available background value '[val]' for [species_name] tag '[cat_type]' is not a valid background label.")
							else if(background.category != cat_type)
								fails++
								log_bad("Available background value '[val]' for [species_name] tag '[cat_type]' does not match background datum category ([background.category] must equal [cat_type]).")
							else if(!background.description)
								fails++
								log_bad("Available background value '[val]' for [species_name] tag '[cat_type]' does not have a description set.")

	if(fails > 0)
		fail("[fails] invalid background value(s)")
	else
		pass("All background values are valid.")
	return 1

