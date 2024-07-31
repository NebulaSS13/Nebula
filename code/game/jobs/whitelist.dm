#define WHITELISTFILE "data/whitelist.txt"

var/global/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(get_config_value(/decl/config/toggle/usewhitelist))
		load_whitelist()
	return 1

/proc/load_whitelist()
	whitelist = file2list(WHITELISTFILE)
	if(!length(whitelist))
		whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!whitelist)
		return 0
	return ("[M.ckey]" in whitelist)

var/global/list/alien_whitelist = list()
/hook/startup/proc/loadAlienWhitelist()
	if(get_config_value(/decl/config/toggle/use_alien_whitelist))
		if(get_config_value(/decl/config/toggle/use_alien_whitelist_sql))
			if(!load_alienwhitelistSQL())
				to_world_log("Could not load alienwhitelist via SQL")
		else
			load_alienwhitelist()
	return 1

/proc/load_alienwhitelist()
	var/text = safe_file2text("config/alienwhitelist.txt", FALSE)
	if (!text)
		log_misc("Failed to load config/alienwhitelist.txt")
		return FALSE
	alien_whitelist = splittext(text, "\n")
	to_world_log("Loaded [length(alien_whitelist)] whitelist [length(alien_whitelist) == 1 ? "entry" : "entries"] from text file.")
	return TRUE

/proc/load_alienwhitelistSQL()
	var/DBQuery/query = dbcon.NewQuery("SELECT * FROM `whitelist`")
	if(!query.Execute())
		to_world_log(dbcon.ErrorMsg())
		return FALSE
	while(query.NextRow())
		var/list/row = query.GetRowData()
		if(alien_whitelist[row["ckey"]])
			var/list/A = alien_whitelist[row["ckey"]]
			A.Add(row["race"])
		else
			alien_whitelist[row["ckey"]] = list(row["race"])
	return TRUE

/proc/is_species_whitelisted(mob/M, var/species_name)
	var/decl/species/S = get_species_by_key(species_name)
	return is_alien_whitelisted(M, S)

/proc/is_alien_whitelisted(mob/M, var/species)

	if(!M || !species)
		return FALSE

	// Forbidden languages do not care about admin rights.
	if(istype(species,/decl/language))
		var/decl/language/L = species
		if(L.flags & LANG_FLAG_FORBIDDEN)
			return FALSE

	if(check_rights(R_ADMIN, FALSE, M))
		return TRUE

	if(istype(species,/decl/language))
		var/decl/language/L = species
		if(L.flags & LANG_FLAG_RESTRICTED)
			return FALSE
		if(!get_config_value(/decl/config/toggle/use_alien_whitelist) || !(L.flags & LANG_FLAG_WHITELISTED))
			return TRUE
		return whitelist_lookup(L.name, M.ckey)

	if(istype(species,/decl/species))
		var/decl/species/S = species
		if(S.spawn_flags & SPECIES_IS_RESTRICTED)
			return FALSE
		if(!get_config_value(/decl/config/toggle/use_alien_whitelist) || !(S.spawn_flags & SPECIES_IS_WHITELISTED))
			return TRUE
		return whitelist_lookup(S.get_root_species_name(M), M.ckey)

	// Check for arbitrary text whitelisting.
	return istext(species) ? whitelist_lookup(species, M.ckey) : FALSE

/proc/whitelist_lookup(var/item, var/ckey)
	if(!alien_whitelist)
		return FALSE

	if(get_config_value(/decl/config/toggle/use_alien_whitelist_sql))
		//SQL Whitelist
		if(!(ckey in alien_whitelist))
			return FALSE
		var/list/whitelisted = alien_whitelist[ckey]
		if(lowertext(item) in whitelisted)
			return TRUE
	else
		//Config File Whitelist
		for(var/s in alien_whitelist)
			if(findtext(s,"[ckey] - [item]"))
				return TRUE
			if(findtext(s,"[ckey] - All"))
				return TRUE
	return FALSE

#undef WHITELISTFILE
