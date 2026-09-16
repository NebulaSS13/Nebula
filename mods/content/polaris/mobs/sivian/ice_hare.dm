
/mob/living/simple_animal/passive/rabbit/ice
	name = "ice hare"
	desc = "A small horned herbivore with a tough 'ice-like' hide."

/mob/living/simple_animal/passive/rabbit/ice/get_default_animal_colours()
	var/static/list/default_colors = list(
		"base"     = "#55678a",
		"markings" = "#6b98aa",
		"socks"    = "#acbec7"
	)
	return default_colors