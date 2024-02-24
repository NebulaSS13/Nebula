/turf/proc/get_build_mode_upgrade()
	return null

/turf/space/get_build_mode_upgrade()
	return /turf/simulated/floor

/turf/open/get_build_mode_upgrade()
	return /turf/simulated/floor

/turf/simulated/floor/get_build_mode_upgrade()
	return /turf/simulated/wall

/turf/simulated/wall/get_build_mode_upgrade()
	return /turf/simulated/wall/r_wall

/turf/proc/get_build_mode_downgrade()
	return null

/turf/simulated/floor/get_build_mode_downgrade()
	return /turf/space

/turf/simulated/wall/get_build_mode_downgrade()
	return /turf/simulated/floor

/turf/simulated/wall/r_wall/get_build_mode_downgrade()
	return /turf/simulated/wall
