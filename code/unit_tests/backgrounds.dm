/datum/unit_test/background
	name = "BACKGROUND: All Species Background Values Shall Be Of Valid Types And Length"

/datum/unit_test/background/start_test()

	var/list/all_background_categories = decls_repository.get_decls_of_subtype(/decl/background_category)
	var/fails = 0
#ifdef UNIT_TEST
	var/list/check_flags = global.all_background_flags.Copy()
	for(var/cat_type in all_background_categories)
		var/decl/background_category/background_cat = all_background_categories[cat_type]
		for(var/background_flag in check_flags)
			if(background_cat.background_flags & check_flags[background_flag])
				check_flags -= background_flag
	if(length(check_flags))
		fails++
		log_bad("Set of map background categories missing background flags: [english_list(check_flags)]")
#endif

	for(var/decl/species/species as anything in decls_repository.get_decls_of_subtype_unassociated(/decl/species))
		if(!islist(species.default_background_info))
			fails++
			log_bad("Default background info for [species.type] is not a list.")
		else
			for(var/cat_type in species.default_background_info)
				if(!(cat_type in all_background_categories))
					fails++
					log_bad("Default background info for [species.type] contains invalid tag '[cat_type]'.")
				else
					var/val = species.default_background_info[cat_type]
					if(!val)
						fails++
						log_bad("Default background value '[val]' for [species.type] tag '[cat_type]' is null, must be a type.")
					else if(istext(val))
						fails++
						log_bad("Default background value '[val]' for [species.type] tag '[cat_type]' is text, must be a type.")
					else
						var/decl/background_detail/background = GET_DECL(val)
						if(!istype(background))
							fails++
							log_bad("Default background value '[val]' for [species.type] tag '[cat_type]' is not a valid background label.")
						else if(background.category != cat_type)
							fails++
							log_bad("Default background value '[val]' for [species.type] tag '[cat_type]' does not match background datum category ([background.category] must equal [cat_type]).")
						else if(!background.description)
							fails++
							log_bad("Default background value '[val]' for [species.type] tag '[cat_type]' does not have a description set.")

		if(!islist(species.force_background_info))
			fails++
			log_bad("Forced background info for [species.type] is not a list.")
		else
			for(var/cat_type in species.force_background_info)
				if(!(cat_type in all_background_categories))
					fails++
					log_bad("Forced background info for [species.type] contains invalid tag '[cat_type]'.")
				else
					var/val = species.force_background_info[cat_type]
					if(!val)
						fails++
						log_bad("Forced background value for [species.type] tag '[cat_type]' is null, must be a type.")
					else if(istext(val))
						fails++
						log_bad("Forced background value for [species.type] tag '[cat_type]' is text, must be a type.")
					else
						var/decl/background_detail/background = GET_DECL(val)
						if(!istype(background))
							fails++
							log_bad("Forced background value '[val]' for [species.type] tag '[cat_type]' is not a valid background label.")
						else if(background.category != cat_type)
							fails++
							log_bad("Forced background value '[val]' for [species.type] tag '[cat_type]' does not match background datum category ([background.category] must equal [cat_type]).")
						else if(!background.description)
							fails++
							log_bad("Forced background value '[val]' for [species.type] tag '[cat_type]' does not have a description set.")

		if(!islist(species.available_background_info))
			fails++
			log_bad("Available background info for [species.type] is not a list.")
		else
			for(var/cat_type in all_background_categories)
				if(!islist(species.available_background_info[cat_type]))
					fails++
					log_bad("Available background info for [species.type] tag '[cat_type]' is invalid type, must be a list.")
				else if(!LAZYLEN(species.available_background_info[cat_type]))
					fails++
					log_bad("Available background info for [species.type] tag '[cat_type]' is empty, must have at least one entry.")
				else
					for(var/val in species.available_background_info[cat_type])
						if(istext(val))
							log_bad("Available background value '[val]' for [species.type] tag '[cat_type]' is text, must be a type.")
						else
							var/decl/background_detail/background = GET_DECL(val)
							if(!istype(background))
								fails++
								log_bad("Available background value '[val]' for [species.type] tag '[cat_type]' is not a valid background label.")
							else if(background.category != cat_type)
								fails++
								log_bad("Available background value '[val]' for [species.type] tag '[cat_type]' does not match background datum category ([background.category] must equal [cat_type]).")
							else if(!background.description)
								fails++
								log_bad("Available background value '[val]' for [species.type] tag '[cat_type]' does not have a description set.")

	if(fails > 0)
		fail("[fails] invalid background value(s)")
	else
		pass("All background values are valid.")
	return 1

