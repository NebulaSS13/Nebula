/turf/simulated/wall/uranium
	icon_state = "metal"
	color = COLOR_GREEN
	material = /decl/material/solid/metal/uranium

/datum/map_template/ruin/exoplanet/radshrine
	name = "radshrine"
	id = "radshrine"
	description = "A small radioactive shrine dedicated to an anomaly."
	suffixes = list("radshrine/radshrine.dmm")
	cost = 1
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT