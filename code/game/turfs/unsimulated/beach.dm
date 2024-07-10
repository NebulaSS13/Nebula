/turf/unsimulated/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'
	turf_flags = TURF_FLAG_BACKGROUND
	abstract_type = /turf/unsimulated/beach

/turf/unsimulated/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/unsimulated/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/unsimulated/beach/water
	name = "Water"
	icon_state = "water"
	turf_flags = TURF_FLAG_BACKGROUND | TURF_IS_WET | TURF_IS_HOLOMAP_PATH

/turf/unsimulated/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)
