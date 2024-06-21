/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "shuttle"
	turf_flags = TURF_IS_HOLOMAP_PATH

/turf/unsimulated/floor/can_climb_from_below(var/mob/climber)
	return TRUE

/turf/unsimulated/floor/infinity //non-doomsday version for transit and wizden
	name = "\proper infinity"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace"
	desc = "Looks like eternity."

/turf/unsimulated/mask
	name = "mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"

/turf/unsimulated/mask_alt // just a second mask type for maps needing two random map runs
	name = "mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"
	color = COLOR_SILVER

/turf/unsimulated/mask/flooded
	flooded = /decl/material/liquid/water
	color = COLOR_LIQUID_WATER

/turf/unsimulated/floor/rescue_base
	icon_state = "asteroidfloor"

/turf/unsimulated/floor/shuttle_ceiling
	icon_state = "reinforced"

/turf/unsimulated/floor/snow
	name = "snow"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "0"

/turf/unsimulated/floor/ice
	name = "ice"
	icon = 'icons/turf/flooring/ice.dmi'
	icon_state = "0"
	color = COLOR_SKY_BLUE

/turf/unsimulated/floor/snow_plating
	name = "snowy plating"
	icon = 'icons/turf/flooring/snow_plating.dmi'
	icon_state = "snowplating"
