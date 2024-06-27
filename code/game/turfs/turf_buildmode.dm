/turf/proc/get_build_mode_upgrade()
	return null

/turf/space/get_build_mode_upgrade()
	return /turf/floor/plating

/turf/open/get_build_mode_upgrade()
	return /turf/floor/plating

/turf/floor/plating/get_build_mode_upgrade()
	return /turf/floor/tiled

/turf/floor/get_build_mode_upgrade()
	return /turf/wall

/turf/wall/get_build_mode_upgrade()
	return /turf/wall/r_wall

/turf/proc/get_build_mode_downgrade()
	return null

/turf/floor/get_build_mode_downgrade()
	return /turf/floor/plating

/turf/floor/plating/get_build_mode_downgrade()
	return /turf/open

/turf/wall/get_build_mode_downgrade()
	return /turf/floor/plating

/turf/wall/r_wall/get_build_mode_downgrade()
	return /turf/wall
