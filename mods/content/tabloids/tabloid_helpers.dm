// Minor fluff item for mapping in waiting rooms etc.
/proc/get_tabloid_publishers()
	var/static/list/tabloid_publishers
	if(!tabloid_publishers)
		tabloid_publishers = list()
		for(var/modpack_name in SSmodpacks.loaded_modpacks)
			var/decl/modpack/modpack = SSmodpacks.loaded_modpacks[modpack_name]
			if(length(modpack.tabloid_publishers))
				tabloid_publishers |= modpack.tabloid_publishers
	return tabloid_publishers

/proc/get_tabloid_headlines()
	var/static/list/tabloid_headlines
	if(!tabloid_headlines)
		tabloid_headlines = list()
	for(var/modpack_name in SSmodpacks.loaded_modpacks)
		var/decl/modpack/modpack = SSmodpacks.loaded_modpacks[modpack_name]
		if(length(modpack.tabloid_headlines))
			tabloid_headlines |= modpack.tabloid_headlines
	return tabloid_headlines

/proc/get_tabloid_states()
	var/static/list/tabloid_states = icon_states('mods/content/tabloids/icons/magazine.dmi')
	return tabloid_states
