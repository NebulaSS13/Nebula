/decl/material/waste
	name = "slag"
	stack_type = null
	icon_colour = "#2e3a07"
	ore_name = "slag"
	ore_desc = "Someone messed up..."
	ore_icon_overlay = "lump"
	hidden_from_codex = TRUE
	reflectiveness = MAT_VALUE_DULL
	wall_support_value = 0

/decl/material/cult
	name = "disturbing stone"
	icon_base = "cult"
	icon_colour = "#402821"
	icon_reinf = "reinf_cult"
	shard_type = SHARD_STONE_PIECE
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	hidden_from_codex = TRUE
	reflectiveness = MAT_VALUE_DULL

/decl/material/cult/place_dismantled_girder(var/turf/target, var/decl/material/reinf_material)
	new /obj/structure/girder/cult(target)

/decl/material/cult/reinf
	name = "runic inscriptions"
	