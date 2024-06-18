/decl/material/solid/stone/cult
	name = "disturbing stone"
	uid = "solid_stone_cult"
	icon_base = 'icons/turf/walls/cult.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_cult.dmi'
	color = "#402821"
	shard_type = SHARD_STONE_PIECE
	conductive = 0
	construction_difficulty = MAT_VALUE_NORMAL_DIY
	hidden_from_codex = TRUE
	reflectiveness = MAT_VALUE_DULL
	exoplanet_rarity_plant = MAT_RARITY_NOWHERE
	exoplanet_rarity_gas = MAT_RARITY_NOWHERE

/decl/material/solid/stone/cult/place_dismantled_girder(var/turf/target)
	return list(new /obj/structure/girder/cult(target))

/decl/material/solid/stone/cult/reinforced
	name = "runic inscriptions"
	uid = "solid_runes_cult"

/decl/butchery_data/occult
	meat_material = /decl/material/solid/stone/cult
	meat_type     = /obj/item/stack/material/lump
	bone_material = /decl/material/solid/stone/cult/reinforced

	skin_material = null
	skin_type     = null
	skin_amount   = null

	gut_amount    = null
	gut_material  = null
	gut_type      = null
