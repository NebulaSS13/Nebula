/turf
	/// The z-turf above us, if present.
	var/tmp/turf/above
	/// If we're a z-turf, the turf below us.
	var/tmp/turf/below
	/// If we're a non-overwrite z-turf, this holds the appearance of the bottom-most Z-turf in the z-stack.
	var/tmp/atom/movable/openspace/turf_proxy/mimic_proxy
	/// Overlay used to multiply color of all OO overlays at once.
	var/tmp/atom/movable/openspace/multiplier/shadower
	/// If this is a delegate (non-overwrite) Z-turf with a z-turf above, this is the delegate copy that's copying us.
	var/tmp/atom/movable/openspace/turf_mimic/mimic_above_copy
	/// If we're at the bottom of the stack, a proxy used to fake a below space turf.
	var/tmp/atom/movable/openspace/turf_proxy/mimic_underlay
	/// How many times this turf is currently queued - multiple queue occurrences are allowed to ensure update consistency.
	var/tmp/z_queued = 0
	/// If this Z-turf leads to space, uninterrupted.
	var/tmp/z_eventually_space = FALSE
	/// Use this appearance for our appearance instead of `appearance`. If ZM_OVERRIDE is set, *only* this will be visible, no movables will be copied.
	var/z_appearance
	var/z_flags = 0

	// debug
	var/tmp/z_depth
	var/tmp/z_generation = 0
	var/tmp/z_generation_lighting = 0
	var/tmp/turf/z_discovered_root

/turf/update_above()
	if (TURF_IS_MIMIC(above))
		above.update_mimic()

/turf/proc/update_mimic()
	if(z_flags & ZM_MIMIC_BELOW)
		z_queued += 1
		// This adds duplicates for a reason. Do not change this unless you understand how ZM queues work.
		SSzcopy.queued_turfs += src

/// Enables Z-mimic for a turf that didn't already have it enabled.
/turf/proc/enable_zmimic(additional_flags = 0)
	if (z_flags & ZM_MIMIC_BELOW)
		return FALSE

	z_flags |= ZM_MIMIC_BELOW | additional_flags
	setup_zmimic(FALSE)
	return TRUE

/// Disables Z-mimic for a turf.
/turf/proc/disable_zmimic()
	if (!(z_flags & ZM_MIMIC_BELOW))
		return FALSE

	z_flags &= ~ZM_MIMIC_BELOW
	cleanup_zmimic()
	return TRUE

/// Sets up Z-mimic for this turf. You shouldn't call this directly 99% of the time.
/turf/proc/setup_zmimic(mapload)
	var/boundary_promotion = z_flags & ZM_BOUNDARY
	if (shadower)
		CRASH("Attempt to enable Z-mimic on already-enabled turf!")
	shadower = new(src)
	SSzcopy.openspace_turfs += 1
	if (boundary_promotion)
		ZM_DEBUG_LOG("Promoting boundary [DEBUG_REF(src)] at ([x],[y],[z])")
		SSzcopy.total_boundary_promotions++

	var/turf/under = GET_BELOW(src)
	if (under)
		below = under
		below.above = src

	if (!(z_flags & (ZM_MIMIC_OVERWRITE|ZM_NO_OCCLUDE)) && mouse_opacity)
		mouse_opacity = 2

	// TODO: There should be a more efficient way to do this, but it doesn't seem to have a meaningful impact on init time as-is.
	for (var/turf/T as anything in RANGE_TURFS(src, 1))
		if (TURF_IS_MIMICKING(T))	// this also checks MIMIC_BOUNDARY
			continue
		T.z_flags |= ZM_BOUNDARY
		T.setup_zmimic_boundary(mapload)

	// Reclaim mimics -- this is necessary to fix render for MIMIC_BLUR state changes.
	if (!mapload)
		for (var/atom/movable/object in below)
			if (MOVABLE_SHALL_MIMIC(object))
				SSzcopy.discover_movable(object)

	update_mimic()

/turf/proc/setup_zmimic_boundary(mapload)
	ASSERT(!(z_flags & ZM_MIMIC_BELOW))

	SSzcopy.openspace_boundaries += 1

	var/turf/under = GET_BELOW(src)
	if (under)
		below = under
		below.above = src

	if (!mapload)
		for (var/atom/movable/object in below)
			if (MOVABLE_SHALL_MIMIC(object))
				SSzcopy.discover_movable(object)

/// Cleans up Z-mimic objects for this turf. You shouldn't call this directly 99% of the time.
/turf/proc/cleanup_zmimic()
	var/demotion = z_flags & ZM_BOUNDARY
	SSzcopy.openspace_turfs -= 1
	// Don't remove ourselves from the queue, the subsystem will explode. We'll naturally fall out of the queue.
	z_queued = 0

	// can't use QDEL_NULL as we need to supply force to qdel
	if(shadower)
		qdel(shadower, TRUE)
		shadower = null
	QDEL_NULL(mimic_above_copy)
	QDEL_NULL(mimic_underlay)

	if (demotion)
		SSzcopy.total_boundary_demotions++
		ZM_DEBUG_LOG("Demoting boundary [DEBUG_REF(src)] at ([x],[y],[z])")
	else
		for (var/atom/movable/openspace/mimic/OO in src)
			OO.owning_turf_changed()

	// If we were above a space turf, regenerate space tracking info.
	if (z_eventually_space)
		for (var/turf/T = above; above; above = above.above)
			if (!isspaceturf(T))
				T.z_eventually_space = FALSE

	if (above)
		above.update_mimic()

	if (!demotion && below)
		below.above = null
		below = null

	for (var/turf/T as anything in RANGE_TURFS(src, 1))
		if (TURF_IS_MIMIC_BOUNDARY(T))
			SSzcopy.pending_boundaries += T

/turf/proc/cleanup_zmimic_boundary()
	SSzcopy.openspace_boundaries -= 1
	for (var/atom/movable/openspace/mimic/OO in src)
		OO.owning_turf_changed()

	if (below)
		below.above = null
		below = null
