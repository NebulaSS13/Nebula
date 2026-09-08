/turf
	/// The z-turf above us, if present.
	var/tmp/turf/above
	/// If we're a z-turf, the turf below us.
	var/tmp/turf/below
	/// If we're a non-replace z-turf, this holds the appearance of the bottom-most Z-turf in the z-stack.
	var/tmp/atom/movable/openspace/turf_proxy/mimic_proxy
	/// Holder object for lighting copy. This is not necessary for shadow rendering.
	var/tmp/atom/movable/openspace/multiplier/shadower
	/// If this is a non-replace Z-turf with a z-turf above, this is the turf mimic that's copying us.
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
	/// If this is true, has no atoms below it (recursively) and is above space -- we can just copy space's appearance directly instead of going through ZM.
	var/tmp/z_allow_fastinit = FALSE
	/// Were we a MIMIC_REPLACE turf last time we were updated?
	var/tmp/z_was_replaced = FALSE
	var/tmp/z_was_fastinit = FALSE

	// debug
	var/tmp/z_depth
	var/tmp/z_generation = 0
	var/tmp/z_generation_lighting = 0
	var/tmp/turf/z_discovered_root
	var/tmp/z_appearance_resets = 0

#ifdef ZM_ENH_DEBUG
	var/tmp/list/z_ao_intermediates
#endif

/turf/update_above()
	if (above && (above.z_flags & ZM_FLAGS_CAN_TURF_UPDATE))
		above.update_mimic()

/**
	Reset our appearance to an initial state, used to undo MIMIC_REPLACE. The default implementation is best effort, but will probably not be sufficient for some types.
	Calling parent is not required.
*/
/turf/proc/reset_appearance()
	z_appearance_resets++
	appearance = type
	update_icon()
	compile_overlays()

/turf/proc/update_mimic()
	if(z_flags & ZM_FLAGS_CAN_TURF_UPDATE)
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
	SSzcopy.openspace_turfs += 1
	if (boundary_promotion)
		ZM_DEBUG_LOG("Promoting boundary [src] ([type]) at ([x],[y],[z])")
		SSzcopy.total_boundary_promotions++

	var/turf/under = GET_BELOW(src)
	if (under)
		below = under
		below.above = src

	if (!(z_flags & (ZM_MIMIC_REPLACE | ZM_NO_OCCLUDE)) && mouse_opacity)
		mouse_opacity = MOUSE_OPACITY_PRIORITY

	if (!mapload)
		// TODO: There should be a more efficient way to do this, but it doesn't seem to have a meaningful impact on init time as-is.
		for (var/turf/T as anything in RANGE_TURFS(src, 1))
			if (TURF_IS_MIMICKING(T))	// this also checks MIMIC_BOUNDARY
				continue
			T.z_flags |= ZM_BOUNDARY
			T.setup_zmimic_boundary(FALSE)

		// Reclaim mimics -- this is necessary to fix render for MIMIC_BLUR state changes.
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

#ifdef ZM_VISUALLY_BIG_STOPS_VB_PROPAGATION
		// If we're above a VISUALLY_BIG, apply it to ourselves so things above us also see it.
		// ...but if *we're* visually big, assume that we'll occlude the thing below us and skip it to save creating a bunch of turf proxies on boundary turfs.
		if ((under.z_flags & (ZM_VISUALLY_BIG | ZM_OVER_VB)) && !(z_flags & ZM_VISUALLY_BIG))
			z_flags |= ZM_OVER_VB

			update_mimic()
#else
		if ((under.z_flags & (ZM_VISUALLY_BIG | ZM_OVER_VB)))
			z_flags |= ZM_OVER_VB

			update_mimic()
#endif

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
		ZM_DEBUG_LOG("Demoting boundary [src] ([type]) at ([x],[y],[z])")
	else
		for (var/atom/movable/openspace/mimic/OO in src)
			OO.owning_turf_changed()

	// If we were above a space turf, regenerate space tracking info.
	if (z_eventually_space)
		for (var/turf/T = above; above; above = above.above)
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

	if (z_flags & ZM_OVER_VB)
		for (var/turf/T = src; T; T = T.above)
			T.z_flags &= ~ZM_OVER_VB
			if (T.below?.mimic_proxy)
				QDEL_NULL(T.below.mimic_proxy)

	if (below)
		below.above = null
		below = null
