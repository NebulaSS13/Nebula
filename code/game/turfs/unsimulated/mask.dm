/turf/unsimulated/mask
	name = "mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"

/turf/unsimulated/mask_alt // just a second mask type for maps needing two random map runs
	name = "mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"
	color = COLOR_SILVER

// Why do these exist? Are they just for typechecks when generating random maps? Does the flooding code even run for unsim turfs?
/turf/unsimulated/mask/flooded
	flooded = /decl/material/liquid/water
	color = COLOR_LIQUID_WATER

/turf/unsimulated/mask/flooded/salt
	contaminant_reagent_type = /decl/material/solid/sodiumchloride
	contaminant_proportion = 0.10 // 1:10 salt:water, NOT 10% salt