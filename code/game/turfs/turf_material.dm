/turf/proc/get_default_material()
	return null

/turf/proc/set_turf_materials(decl/material/new_material, decl/material/new_reinf_material, force, decl/material/new_girder_material, skip_update)
	return

// TODO: Unify the strata_override var and related get_strata_material_type overrides somewhere, like in an extension or on /turf.
/turf/proc/get_strata_material_type()
	//Try to grab the material we picked for the level from the level data
	var/datum/level_data/LD = SSmapping.levels_by_z[z]
	if(!LD._level_setup_completed && !LD._has_warned_uninitialized_strata)
		LD.warn_bad_strata(src) //If we haven't warned yet dump a stack trace and warn that strata was set before init
	return LD.strata_base_material.type