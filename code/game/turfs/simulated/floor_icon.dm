/turf/simulated/floor/on_update_icon(var/update_neighbors = FALSE)
	. = ..()
	if(is_plating() && (is_turf_broken() || is_turf_burned())) //temp, todo
		icon = 'icons/turf/flooring/plating.dmi'
		icon_state = "dmg[rand(1,4)]"
