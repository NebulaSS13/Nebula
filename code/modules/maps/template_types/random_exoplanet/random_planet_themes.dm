/datum/map_template/planetoid/random/proc/select_themes(var/datum/planetoid_data/gen_data)
	//Apply forced theme if there's one
	if(gen_data._theme_forced)
		LAZYADD(gen_data.themes, new gen_data._theme_forced)
		return

	var/themes_num = min(length(possible_themes), rand(1, max_themes))
	var/list/possible = possible_themes?.Copy()
	for(var/i = 1 to themes_num)
		var/datum/exoplanet_theme/T = pickweight(possible)
		LAZYADD(gen_data.themes, new T)
		possible -= T