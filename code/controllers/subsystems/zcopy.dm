/*

	Here be dragons.

*/

#define OPENTURF_MAX_DEPTH 10		// The maxiumum number of planes deep we'll go before we just dump everything on the same plane.
#define OPENTURF_PLANES_PER_DEPTH 3

#if -((ZMIMIC_MINIMUM_PLANE) - (ZMIMIC_MAXIMUM_PLANE)) != (OPENTURF_MAX_DEPTH * OPENTURF_PLANES_PER_DEPTH)
#warn ZMIMIC plane ranges are inconsistent with declared depth and planes per depth.
#endif

#define ZM_DEPTH_TO_OFFSET_RAW(X, PPD) ((PPD) * (X))
/// Compute the root offset from ZMIMIC_MAXIMUM_PLANE, sans any slot offset.
#define ZM_DEPTH_TO_OFFSET(X) ZM_DEPTH_TO_OFFSET_RAW(X, OPENTURF_PLANES_PER_DEPTH)
/// Compute the final target plane given a stack depth number and a slot offset.
#define ZM_COMPUTE_PLANE(DEPTH, SLOT) (ZMIMIC_MAXIMUM_PLANE - ZM_DEPTH_TO_OFFSET(DEPTH) + (SLOT))

#define SHADOWER_DARKENING_FACTOR 0.6	// The multiplication factor for openturf shadower darkness. Lighting will be multiplied by this.
#define SHADOWER_DARKENING_COLOR "#999999"	// The above, but as an RGB string for lighting-less turfs.

#define ZM_SLICE(Ty, D) "zm_slice_[D]_[Ty]"
#define ZM_SLICE_VIRTUAL(Ty, D) "*zm_slice_[D]_[Ty]"

// These cannot be reused within a depth since they're used to assign render targets.
#define ZM_SLICE_TY_BASIC "basic"
#define ZM_SLICE_TY_LIGHTING "lighting"
#define ZM_SLICE_TY_CAP "cap"
#define ZM_SLICE_TY_ZSUM "sum"

#define ZM_SLICE_SLOT_ROOT 0	//! Standard render. Nothing special. aka: basic plane
#define ZM_SLICE_SLOT_LIGHTING 1	//! Shadowers and other *BLEND_MULTIPLY* objects.
#define ZM_SLICE_SLOT_CAP 2	//! ZAO and other non-MULTIPLY effects that must render on top of everything else, including lighting.

#define ZM_BASEMENT_CAP_PLANE -399
#define ZM_BASEMENT_MAX_PLANE -400
#define ZM_BASEMENT_PLANES_PER_DEPTH 1
#define ZM_VSLICE_SLOT_ZSUM 0

/// How many items should we process before we check for yield? Increasing this increases efficiency, but also raises risk of overrun.
#define ZM_PUMP_RATIO 4
/// Initialize state required for ZM_MC_TRY_YIELD.
#define ZM_PUMP_INIT var/__yield

/// Check if we need to yield to the MC. This macro will sleep or break.
#define ZM_MC_TRY_YIELD if ((++__yield) >= ZM_PUMP_RATIO) { __yield = 0; if (no_mc_tick) { CHECK_TICK; } else if (MC_TICK_CHECK) { break; } }

var/list/zm_offset_to_target = list(ZM_SLICE_TY_BASIC, ZM_SLICE_TY_LIGHTING, ZM_SLICE_TY_CAP)

//#define ZM_RECORD_STATS	// This doesn't work on O7/Neb right now.

#ifdef ZM_RECORD_STATS
#define ZM_RECORD_START STAT_START_STOPWATCH
#define ZM_RECORD_STOP STAT_STOP_STOPWATCH
#define ZM_RECORD_WRITE(X...) STAT_LOG_ENTRY(##X)
#else
#define ZM_RECORD_START
#define ZM_RECORD_STOP
#define ZM_RECORD_WRITE(X...)
#endif

SUBSYSTEM_DEF(zcopy)
	name = "Z-Copy"
	wait = 1
	init_order = SS_INIT_ZCOPY
	priority = SS_PRIORITY_ZCOPY
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/queued_turfs = list()
	var/qt_idex = 1
	var/list/queued_overlays = list()
	var/qo_idex = 1

	var/list/pending_boundaries = list()
	var/pb_idex = 1

	var/openspace_overlays = 0
	var/openspace_turfs = 0
	var/openspace_boundaries = 0

	var/multiqueue_skips_turf = 0	//! How many times did we skip a redundant turf update due to not being the most recent update?
	var/multiqueue_skips_object = 0	//! How many times did we skip a redundant object update due to not being the most recent update?

	var/total_updates_turf = 0
	var/total_updates_discovery = 0
	var/total_updates_object = 0
	var/total_boundary_reocclusion = 0	//! How many times was a boundary removed by a ZM turf being changed to a non-mimic?
	var/deferred_discoveries = 0	//! How many times did we have to recursively discover? This overlaps with the discovery total.
	var/lighting_updates = 0
	var/total_boundary_promotions = 0	//! How many turfs were promoted from boundary to mimic?
	var/total_boundary_demotions = 0	//! How many turfs were demoted from mimic to boundary?
	var/total_boundary_removals = 0	//! How many boundaries were made non-z turfs?

#ifdef ZM_RECORD_STATS
	var/list/turf_stats = list()
	var/list/discovery_stats = list()
	var/list/mimic_stats = list()
#endif

	/// Highest Z level in a given Z-group for absolute layering. `zlev_maximums[z] = group_max`.
	var/list/zlev_maximums = list()
	// cached debug strings, since rebuilding this every stat() tick is wasteful given how rarely it changes
	var/list/last_zlev_max
	var/last_zgr_text

	// Caches for fixup.
	var/list/fixup_cache = list()	//! Cache of already mangled `[old_appearance] = mangled_appearance` mappings.
	var/list/fixup_known_good = list()	//! Cache of known-valid (no layering violations) appearances.

	// Fixup stats.
	var/fixup_miss = 0	//! How many appearances required active mangling?
	var/fixup_noop = 0	//! How many appearances were passed to fixup but did not require mangling?
	var/fixup_hit = 0	//! How many appearances were passed to fixup and were found in `fixup_cache` or `fixup_known_good`?
	var/fixup_miss_root = 0
	var/fixup_noop_root = 0
	var/fixup_hit_root = 0

	var/starlight_enabled = FALSE

// for admin proc-call
/datum/controller/subsystem/zcopy/proc/update_all()
	disable()
	log_debug("SSzcopy: update_all() invoked.")

	var/turf/T 	// putting the declaration up here totally speeds it up, right?
	var/num_upd = 0
	var/num_del = 0
	var/num_amupd = 0

	for (var/atom/A in world)
		if (isturf(A))
			T = A
			if (T.z_flags & ZM_MIMIC_BELOW)
				T.update_mimic()
				num_upd += 1

		else if (istype(A, /atom/movable/openspace/mimic))
			var/turf/Tloc = A.loc
			if (TURF_IS_MIMIC(Tloc))
				Tloc.update_mimic()
				num_amupd += 1
			else
				qdel(A)
				num_del += 1

		CHECK_TICK

	log_debug("SSzcopy: [num_upd + num_amupd] turf updates queued ([num_upd] direct, [num_amupd] indirect), [num_del] orphans destroyed.")

	enable()

// for admin proc-call
/datum/controller/subsystem/zcopy/proc/hard_reset()
	disable()
	log_debug("SSzcopy: hard_reset() invoked.")
	var/num_deleted = 0
	var/num_turfs = 0

	for (var/turf/T in world)
		if (T.z_queued)
			T.z_queued = 0

		CHECK_TICK

	queued_turfs.Cut()
	queued_overlays.Cut()

	var/turf/T
	for (var/atom/A in world)
		if (isturf(A))
			T = A
			if (T.z_flags & ZM_MIMIC_BELOW)
				flush_z_state(T)
				T.update_mimic()
				num_turfs += 1

		else if (istype(A, /atom/movable/openspace/mimic))
			qdel(A)
			num_deleted += 1

		CHECK_TICK

	log_ss(name, "deleted [num_deleted] overlays, and queued [num_turfs] turfs for update.")

	enable()

/datum/controller/subsystem/zcopy/stat_entry()
	var/list/entries = list(
		"",	// newline
		"ZGr: [build_zgroup_display()]",	// This is a human-readable list of the z-groups known to ZM.
		//"ZMx: [zlev_maximums.Join(", ")]",	// And this is the raw internal state.
		// This one gets broken out from the below because it's more important.
		"Q: { Tb: [pending_boundaries.len - (pb_idex - 1)] | T: [queued_turfs.len - (qt_idex - 1)] | O: [queued_overlays.len - (qo_idex - 1)] }",
		// In order: Total objects, Updated, State changes, Skipped,
		"T(O): { Tb: [openspace_boundaries] | T: [openspace_turfs] | O: [openspace_overlays] }",
		"T(U): { Tb: [total_boundary_reocclusion] | T: [total_updates_turf] | L: [lighting_updates] | O: [total_updates_object] }",
		"T(St): { BPr: [total_boundary_promotions] | BDe: [total_boundary_demotions] | BRm: [total_boundary_removals] | D: [total_updates_discovery] | DDef: [deferred_discoveries] }",
		"Sk: { T: [multiqueue_skips_turf] | O: [multiqueue_skips_object] }",
		"F(St): { H: [fixup_hit] / [fixup_hit_root] | M: [fixup_miss] / [fixup_miss_root] | N: [fixup_noop] / [fixup_noop_root] } F(C): { Mangle: [fixup_cache.len] | No-op: [fixup_known_good.len] }"
	)
	..(entries.Join("\n\t"))

// 1, 2, 3..=7, 8
/datum/controller/subsystem/zcopy/proc/build_zgroup_display()
	if (!zlev_maximums.len)
		return "<none>"

	if (zlev_maximums ~= last_zlev_max)
		return last_zgr_text

	var/list/zmx = list()
	var/idx = 1
	var/span_ctr = 0
	do
		if (zlev_maximums[idx] != idx)
			span_ctr += 1
		else if (span_ctr)
			zmx += "[idx - span_ctr]..=[idx]"
			span_ctr = 0
		else
			zmx += "[idx]"
		idx += 1
	while (idx <= zlev_maximums.len)
	last_zgr_text = jointext(zmx, ", ")
	last_zlev_max = zlev_maximums.Copy()

	return last_zgr_text

/datum/controller/subsystem/zcopy/Initialize(timeofday)
	calculate_zstack_limits()
	// Flush the queue.
	fire(FALSE, TRUE)

// If you add a new Zlevel or change Z-connections, call this.
/datum/controller/subsystem/zcopy/proc/calculate_zstack_limits()
	zlev_maximums = new(world.maxz)
	var/start_zlev = 1
	for (var/z in 1 to world.maxz)
		if (!HasAbove(z))
			for (var/member_zlev in start_zlev to z)
				zlev_maximums[member_zlev] = z
			if (z - start_zlev > OPENTURF_MAX_DEPTH)
				log_ss("zcopy", "WARNING: Z-levels [start_zlev] through [z] exceed maximum depth of [OPENTURF_MAX_DEPTH]; layering may behave strangely in this Z-stack.")
			else if (z - start_zlev > 1)
				log_ss("zcopy", "Found Z-Group: [start_zlev] -> [z] = [z - start_zlev + 1] zl")
			start_zlev = z + 1

	log_ss("zcopy", "Z-Level maximums: [json_encode(zlev_maximums)]")

/datum/controller/subsystem/zcopy/StartLoadingMap()
	suspend()

/datum/controller/subsystem/zcopy/StopLoadingMap()
	wake()

/// Fully reset Z-Mimic, rebuilding state from scratch. Use this if you change Z-stack mappings after Z-Mimic has initialized. Expensive.
/// WARNING: This is *completely unsupported*. It will probably irreversibly corrupt Z-lighting in changed Z-groups. Use at own risk.
/datum/controller/subsystem/zcopy/proc/unsupported_rebuild_z_state()
	suspend()
	UNTIL(state == SS_IDLE)

	calculate_zstack_limits()

	for (var/zlev in 1 to world.maxz)
		var/datum/level_data/level = SSmapping.levels_by_z[zlev]
		for (var/turf/T as anything in block(level.level_inner_min_x, level.level_inner_min_y, zlev, level.level_inner_max_x, level.level_inner_max_y))
			if (T.z_flags & ZM_MIMIC_BELOW)
				flush_z_state(T)
				T.below = GetBelow(T)
				T.above = GetAbove(T)
				T.update_mimic()
			CHECK_TICK
	wake()

/datum/controller/subsystem/zcopy/fire(resumed = FALSE, no_mc_tick = FALSE)
	if (!resumed)
		qt_idex = 1
		qo_idex = 1
		pb_idex = 1

	ZM_PUMP_INIT

	// This is outside of the MC_SPLIT_TICK_INIT because it should _usually_ not run, so we don't want it stealing tick allocation from the two bulk phases.
	while (pb_idex <= pending_boundaries.len)
		var/turf/boundary = pending_boundaries[pb_idex]
		pending_boundaries[pb_idex] = null
		pb_idex += 1

		if (!boundary || !boundary.z_flags || TURF_IS_MIMIC(boundary))
			continue

		var/found = FALSE
		for (var/turf/neighbor as anything in RANGE_TURFS(boundary, 1))
			if (TURF_IS_MIMIC(neighbor))	// only consider true mimics
				found = TRUE
				break

		if (!found)
			boundary.z_flags &= ~ZM_BOUNDARY
			boundary.cleanup_zmimic_boundary()
			total_boundary_removals += 1

		total_boundary_reocclusion += 1

		ZM_MC_TRY_YIELD

	if (pb_idex > 1)
		pending_boundaries.Cut(1, pb_idex)
		pb_idex = 1

	MC_SPLIT_TICK_INIT(2)
	if (!no_mc_tick)
		MC_SPLIT_TICK

	tick_turfs(no_mc_tick)

	if (!no_mc_tick)
		MC_SPLIT_TICK

	tick_mimic(no_mc_tick)

// - Turf mimic -
/datum/controller/subsystem/zcopy/proc/tick_turfs(no_mc_tick)
	ZM_PUMP_INIT
	var/list/curr_turfs = queued_turfs

	while (qt_idex <= curr_turfs.len)
		var/turf/T = curr_turfs[qt_idex]
		curr_turfs[qt_idex] = null
		qt_idex += 1

		if (!isturf(T) || !(T.z_flags & ZM_MIMIC_BELOW) || !T.z_queued)
			continue

		// If we're not at our most recent queue position, don't bother -- we're updating again later anyways.
		if (T.z_queued > 1)
			T.z_queued -= 1
			multiqueue_skips_turf += 1
			continue

		// Z-Turf on the bottom-most level, just fake-copy space (or baseturf).
		// It's impossible for anything to be on the synthetic turf, so ignore the rest of the ZM machinery.
		if (!T.below)
			ZM_RECORD_START
			flush_z_state(T)
			if (T.z_flags & ZM_OVERRIDE)
				simple_appearance_copy(T, get_base_turf_by_area(T), ZMIMIC_MAXIMUM_PLANE)
			else
				simple_appearance_copy(T, SSskybox.dust_cache["[((T.x + T.y) ^ ~(T.x * T.y) + T.z) % 25]"])

			T.z_generation += 1
			T.z_queued -= 1
			total_updates_turf += 1

			if (T.above)
				T.above.update_mimic()

			ZM_RECORD_STOP
			ZM_RECORD_WRITE(turf_stats, "Fake: [T.type] on [T.z]")

			ZM_MC_TRY_YIELD
			continue

		if (!T.shadower)	// If we don't have a shadower yet, something has gone horribly wrong.
			WARNING("Turf [T] at [T.x],[T.y],[T.z] was queued, but had no shadower.")
			continue

		T.z_generation += 1

		ZM_RECORD_START

		// We need to find the non-z turf that's visually at the bottom of this group. BOUNDARY turfs are regular turfs, so they need to not be considered here.
		// OVERRIDE turfs are considered the end of a Z-group regardless of actual connections.
		// This logic is duplicated below in analyze_openturf().
		var/turf/Td = T
		while (Td.below && (Td.z_flags & ZM_MIMIC_BELOW) && !(Td.z_flags & ZM_OVERRIDE))
			Td = Td.below

		T.z_discovered_root = Td

		// Depth must be the depth of the *visible* turf, not self.
		var/turf_depth
		// If you're getting runtimes here, you violated a ZM invariant. Not a bug in ZM, you should be notifying ZM when you resize the world.
		turf_depth = T.z_depth = zlev_maximums[Td.z] - Td.z

		var/t_target = ZM_COMPUTE_PLANE(turf_depth, ZM_SLICE_SLOT_ROOT)	// This is where the turf (but not the copied atoms) gets put.

		// Turf is set to mimic baseturf, handle that and bail.
		if (T.z_flags & ZM_OVERRIDE)
			flush_z_state(T)
			simple_appearance_copy(T, Td.z_appearance || get_base_turf_by_area(T), t_target)

			if (T.above)
				T.above.update_mimic()

			total_updates_turf += 1
			T.z_queued -= 1

			ZM_RECORD_STOP
			ZM_RECORD_WRITE(turf_stats, "Simple: [T.type] on [T.z]")

			ZM_MC_TRY_YIELD
			continue

		// If we previously were ZM_OVERRIDE, there might be an orphaned proxy.
		else if (T.mimic_underlay)
			QDEL_NULL(T.mimic_underlay)

		// Handle space parallax & starlight.
		if (T.below.z_eventually_space)
			T.z_eventually_space = TRUE
			t_target = SPACE_PLANE

		if (T.z_flags & ZM_MIMIC_OVERWRITE)
			// This openturf doesn't care about its icon, so we can just overwrite it.
			if (T.below.mimic_proxy)
				QDEL_NULL(T.below.mimic_proxy)
			T.appearance = Td.z_appearance || Td
			T.name = initial(T.name)
			T.desc = initial(T.desc)
			T.gender = initial(T.gender)
			T.opacity = FALSE
			T.plane = t_target
		else
			// Some openturfs have icons, so we can't overwrite their appearance.
			if (!T.below.mimic_proxy)
				T.below.mimic_proxy = new(T)
			var/atom/movable/openspace/turf_proxy/TO = T.below.mimic_proxy
			TO.appearance = Td.z_appearance || Td
			TO.name = T.name
			TO.gender = T.gender	// Need to grab this too so PLURAL works properly in examine.
			TO.opacity = FALSE
			TO.plane = t_target
			TO.mouse_opacity = initial(TO.mouse_opacity)

		T.queue_ao(T.ao_neighbors_mimic == null)	// If ao_neighbors hasn't been set yet, we need to do a rebuild

		// Explicitly copy turf delegates so they show up properly on below levels.
		//   I think it's possible to get this to work without discrete delegate copy objects, but I'd rather this just work.
		if ((T.below.z_flags & (ZM_MIMIC_BELOW|ZM_MIMIC_OVERWRITE)) == ZM_MIMIC_BELOW)
			// Below is a delegate, gotta explicitly copy it for recursive copy.
			if (!T.below.mimic_above_copy)
				T.below.mimic_above_copy = new(T)
			var/atom/movable/openspace/turf_mimic/DC = T.below.mimic_above_copy
			DC.appearance = T.below
			DC.mouse_opacity = initial(DC.mouse_opacity)
			DC.target_slot = ZM_SLICE_SLOT_ROOT
			DC.plane = ZM_COMPUTE_PLANE(turf_depth - 1, ZM_SLICE_SLOT_ROOT)

		else if (T.below.mimic_above_copy)
			QDEL_NULL(T.below.mimic_above_copy)

		// Handle below atoms.

		// Add everything below us to the discovery queue.
		for (var/thing in T.below)
			var/atom/movable/object = thing
			// If an atom already has an overlay, we probably don't need to discover it again.
			// ...but we need to force it if the object was salvaged from another zturf.
			if (MOVABLE_SHALL_MIMIC(object) && (!object.bound_overlay || object.bound_overlay.destruction_timer))
				discover_movable(object)

		if (!T.lighting_overlay?.needs_update)
			update_lighting(T)

		T.z_queued -= 1
		if (T.above && !T.above.z_queued)
			T.above.update_mimic()

		total_updates_turf += 1

		ZM_RECORD_STOP
		ZM_RECORD_WRITE(turf_stats, "Complex: [T.type] on [T.z]")

		ZM_MC_TRY_YIELD

	if (qt_idex > 1)
		curr_turfs.Cut(1, qt_idex)
		qt_idex = 1

/// Update the passed turf's shadower from the lighting object below it.
/datum/controller/subsystem/zcopy/proc/update_lighting(turf/target_turf)
	ASSERT(target_turf.shadower != null)
	var/atom/movable/lighting_overlay/object = target_turf.below?.lighting_overlay
	if (object)
		target_turf.shadower.copy_lighting(object)
	else
		if (target_turf.below.z_flags & ZM_NO_SHADOW)
			target_turf.shadower.color = null
		else
			target_turf.shadower.color = SHADOWER_DARKENING_COLOR

		target_turf.shadower.lighting_generation_static += 1	// other generation is updated in copy_lighting()
		target_turf.shadower.update_above()

	lighting_updates += 1
	target_turf.z_generation_lighting += 1

// - Phase: Mimic update -- actually update the mimics' appearance, order sensitive -
/datum/controller/subsystem/zcopy/proc/tick_mimic(no_mc_tick)
	ZM_PUMP_INIT
	var/list/curr_ov = queued_overlays
	while (qo_idex <= curr_ov.len)
		var/atom/movable/openspace/mimic/OO = curr_ov[qo_idex]
		curr_ov[qo_idex] = null
		qo_idex += 1

		if (QDELETED(OO) || !OO.queued)
			continue

		if (QDELETED(OO.associated_atom))	// This shouldn't happen.
			qdel(OO)
			log_debug("Z-Mimic: Received mimic with QDELETED parent ([OO.associated_atom || "<NULL>"])")

			ZM_MC_TRY_YIELD
			continue

		// Don't update unless we're at the most recent queue occurrence.
		if (OO.queued > 1)
			OO.queued -= 1
			multiqueue_skips_object += 1
			// We're decrementing a number, presumably this does not happen enough to risk overrun.
			continue

		ZM_RECORD_START

		// Actually update the overlay.
		if (OO.dir != OO.associated_atom.dir)
			OO.dir = OO.associated_atom.dir	// updates are propagated up another way, don't use set_dir
		OO.appearance = OO.associated_atom
		OO.cached_name = OO.name
		if (OO.hidden)
			OO.name = ""
		OO.z_flags = OO.associated_atom.z_flags | initial(OO.z_flags)

		if (OO.particles != OO.associated_atom.particles)
			OO.particles = OO.associated_atom.particles

		OO.plane = ZM_COMPUTE_PLANE(OO.depth, OO.target_slot)
		OO.opacity = FALSE
		OO.queued = 0

		// If an atom has explicit plane sets on its overlays/underlays, we need to mangle the appearance's overlays/underlays to align with Z-Mimic's plane usage.
		if (OO.z_flags & ZMM_MANGLE_PLANES)
			var/new_appearance = fixup_appearance_planes(OO.appearance)
			if (new_appearance)
				OO.appearance = new_appearance
				OO.have_performed_fixup = TRUE

		if (OO.bound_overlay)	// If we have a bound overlay, queue it too.
			OO.update_above()

		total_updates_object += 1

		ZM_RECORD_STOP
		ZM_RECORD_WRITE(mimic_stats, OO.mimiced_type)

		ZM_MC_TRY_YIELD

	if (qo_idex > 1)
		curr_ov.Cut(1, qo_idex)
		qo_idex = 1

// only_reset: do not queue for update, only update layering info
// return: is-invalid
/datum/controller/subsystem/zcopy/proc/discover_movable(atom/movable/object, only_reset = FALSE)
	ASSERT(!QDELETED(object))
	if(init_state < SS_INITSTATE_STARTED)
		return FALSE // no-op, discover_movable is only valid during or after zcopy init

	if (!isturf(object.loc))
		return TRUE
	var/turf/Tloc = object.loc
	var/turf/T = Tloc.above

	// ???
	ASSERT(T != null)

	ZM_RECORD_START

	var/atom/movable/defer
	if (!object.bound_overlay)
		var/atom/movable/openspace/mimic/M = new(T)
		object.bound_overlay = M
		M.associated_atom = object
		if (T.z_flags & ZM_BOUNDARY)
			M.hidden = TRUE
		if (MOVABLE_IS_BELOW_ZTURF(M))
			defer = M

	var/override_depth
	var/original_type = object.type
	var/original_z = object.z

	switch (object.type)
		// Depth for recursive mimic needs to be inherited.
		if (/atom/movable/openspace/mimic)
			var/atom/movable/openspace/mimic/OOO = object
			original_type = OOO.mimiced_type
			override_depth = OOO.override_depth
			original_z = OOO.original_z

		// If this is a turf proxy (the mimic for a non-OVERWRITE turf), it needs to respect space parallax if relevant.
		if (/atom/movable/openspace/turf_proxy)
			if (T.z_eventually_space)
				// Yes, this is an awful hack; I don't want to add yet another override_* var.
				override_depth = (ZMIMIC_MAXIMUM_PLANE - SPACE_PLANE)/OPENTURF_PLANES_PER_DEPTH	// TODO: Please not this -- while it's valid, this is awful.

	var/atom/movable/openspace/mimic/OO = object.bound_overlay

	// If the OO was queued for destruction but was claimed by another OT, stop the destruction timer.
	if (OO.destruction_timer)
		deltimer(OO.destruction_timer)
		OO.destruction_timer = null

	OO.depth = override_depth || min(zlev_maximums[T.z] - original_z, OPENTURF_MAX_DEPTH)
	OO.target_slot = 0

	switch (original_type)
		// These types need to be pushed a layer down for bigturfs to function correctly.
		if (/atom/movable/openspace/turf_proxy, /atom/movable/openspace/turf_mimic)
			OO.depth += 1
		if (/atom/movable/openspace/multiplier)
			// Ignore override depth for these.
			OO.depth = min(zlev_maximums[OO.z] - original_z + 1, OPENTURF_MAX_DEPTH)
			OO.target_slot = ZM_SLICE_SLOT_LIGHTING

	OO.mimiced_type = original_type
	OO.override_depth = override_depth
	OO.original_z = original_z

	if (only_reset)
		// We're only trying to rebuild layering information, no need to update the appearance.
		OO.plane = ZM_COMPUTE_PLANE(OO.depth, OO.target_slot)
	else
		// Multi-queue to maintain ordering of updates to these
		//   queueing it multiple times will result in only the most recent
		//   actually processing.
		OO.queued += 1
		queued_overlays += OO

	total_updates_discovery += 1

	ZM_RECORD_STOP
	ZM_RECORD_WRITE(discovery_stats, "Depth [OO.depth] on [OO.z]")

	if (defer)
		deferred_discoveries += 1
		.(defer, only_reset)

	return FALSE

/datum/controller/subsystem/zcopy/proc/flush_z_state(turf/T)
	if (T.below) // Z-Mimic turfs aren't necessarily above another turf.
		if (T.below.mimic_above_copy)
			QDEL_NULL(T.below.mimic_above_copy)
		if (T.below.mimic_proxy)
			QDEL_NULL(T.below.mimic_proxy)

	QDEL_NULL(T.mimic_underlay)
	for (var/atom/movable/openspace/mimic/OO in T)
		qdel(OO)

/datum/controller/subsystem/zcopy/proc/simple_appearance_copy(turf/T, new_appearance, target_plane)
	if (T.z_flags & ZM_MIMIC_OVERWRITE)
		T.appearance = new_appearance
		T.name = initial(T.name)
		T.desc = initial(T.desc)
		T.gender = initial(T.gender)
		if (T.plane == DEFAULT_PLANE && target_plane)
			T.plane = target_plane
	else
		// Some openturfs have icons, so we can't overwrite their appearance.
		if (!T.mimic_underlay)
			T.mimic_underlay = new(T)
		var/atom/movable/openspace/turf_proxy/TO = T.mimic_underlay
		TO.appearance = new_appearance
		TO.name = T.name
		TO.gender = T.gender	// Need to grab this too so PLURAL works properly in examine.
		TO.mouse_opacity = initial(TO.mouse_opacity)
		if (TO.plane == DEFAULT_PLANE && target_plane)
			TO.plane = target_plane

// Recurse: for self, check if planes are invalid, if yes; return fixed appearance
// For each of overlay,underlay, call fixup_appearance_planes; if it returns a new appearance, replace self

/// Generate a new appearance from `appearance` with planes mangled to work with Z-Mimic. Do not pass a depth.
/datum/controller/subsystem/zcopy/proc/fixup_appearance_planes(appearance, depth = 0)

	// Adding this to guard against a reported runtime - supposed to be impossible, so cause is unclear.
	if(!appearance)
		return null

	if (fixup_known_good[appearance])
		fixup_hit += 1
		if (depth == 0)
			fixup_hit_root += 1
		return null
	if (fixup_cache[appearance])
		fixup_hit += 1
		if (depth == 0)
			fixup_hit_root += 1
		return fixup_cache[appearance]

	ZM_DEBUG_LOG("Plane fixup: considering appearance with name [appearance:name || "<null>"] and icon [appearance:icon || "<unknown>"] | [appearance:icon_state || "<unknown>"]")

	// If you have more than 4 layers of overlays within overlays, I dunno what to say.
	if (depth > 4)
		var/icon_name = "[appearance:icon]"
		WARNING("Fixup of appearance with icon [icon_name || "<unknown file>"] exceeded maximum recursion limit, bailing")
		return null

	var/plane_needs_fix = FALSE

	// Don't fixup the root object's plane.
	if (depth > 0)
		switch (appearance:plane)
			if (DEFAULT_PLANE, FLOAT_PLANE)
				// fine
				EMPTY_BLOCK_GUARD
			else
				plane_needs_fix = TRUE

	// Scan & fix overlays
	var/list/fixed_overlays
	if (appearance:overlays:len)
		var/mutated = FALSE
		var/fixed_appearance
		for (var/i in 1 to appearance:overlays:len)
			if ((fixed_appearance = .(appearance:overlays[i], depth + 1)))
				mutated = TRUE
				if (!fixed_overlays)
					fixed_overlays = new(appearance:overlays.len)
				fixed_overlays[i] = fixed_appearance

		if (mutated)
			for (var/i in 1 to fixed_overlays.len)
				if (fixed_overlays[i] == null)
					fixed_overlays[i] = appearance:overlays[i]

	// Scan & fix underlays
	var/list/fixed_underlays
	if (appearance:underlays:len)
		var/mutated = FALSE
		var/fixed_appearance
		for (var/i in 1 to appearance:underlays:len)
			if ((fixed_appearance = .(appearance:underlays[i], depth + 1)))
				mutated = TRUE
				if (!fixed_underlays)
					fixed_underlays = new(appearance:underlays.len)
				fixed_underlays[i] = fixed_appearance

		if (mutated)
			for (var/i in 1 to fixed_underlays.len)
				if (fixed_underlays[i] == null)
					fixed_underlays[i] = appearance:underlays[i]

	// If we did nothing (no violations), don't bother creating a new appearance
	if (!plane_needs_fix && !fixed_overlays && !fixed_underlays)
		fixup_noop += 1
		if (depth == 0)
			fixup_noop_root += 1
		fixup_known_good[appearance] = TRUE
		return null

	fixup_miss += 1
	if (depth == 0)
		fixup_miss_root += 1

	var/mutable_appearance/MA = new(appearance)
	if (plane_needs_fix)
		MA.plane = depth == 0 ? DEFAULT_PLANE : FLOAT_PLANE
		MA.layer = FLY_LAYER	// probably fine

	if (fixed_overlays)
		MA.overlays = fixed_overlays

	if (fixed_underlays)
		MA.underlays = fixed_underlays

	fixup_cache[appearance] = MA.appearance

	return MA

/client
	var/list/zm_objs = list()

/datum/controller/subsystem/zcopy/proc/CreateSlice(client/C, path, depth)
	ASSERT(ispath(path))
	var/obj/mimic_master/slice/slice = new path(null, depth)
	C.screen += slice
	LAZYADD(C.zm_objs[slice.slice_prefix], slice)

/datum/controller/subsystem/zcopy/proc/CreatePrimordialSlice(client/C, path)
	var/obj/mimic_master/master = new path
	C.screen += master
	LAZYADD(C.zm_objs["primordial"], master)

/datum/controller/subsystem/zcopy/proc/CreatePlanesFor(client/C)
	for (var/i in 0 to OPENTURF_MAX_DEPTH)
		CreateSlice(C, /obj/mimic_master/slice/basic, i)
		CreateSlice(C, /obj/mimic_master/slice/shadower_master, i)
		CreateSlice(C, /obj/mimic_master/slice/cap, i)
		CreateSlice(C, /obj/mimic_master/slice/virtual/zsum, i)

	CreatePrimordialSlice(C, /obj/mimic_master/plane_zero)

#define FMT_DEPTH(X) (X == null ? "(null)" : X)
#define FMT_OK(X) (X) ? "<font color='green'>OK</font>" : "<font color='red'>MISMATCH</font>"

// This is a dummy object used so overlays can be shown in the analyzer.
/atom/movable/openspace/debug

/atom/movable/openspace/debug/turf
	var/turf/parent
	var/computed_depth

/atom/movable/openspace/debug/shadower
	var/associated_depth

/client/proc/analyze_openturf(turf/T)
	set name = "Analyze Openturf"
	set desc = "Show the layering of an openturf and everything it's mimicking."
	set category = "Debug"

	if (!check_rights(R_DEBUG))
		return

	var/real_update_count = 0
	var/claimed_update_count = T.z_queued
	var/list/tq = SSzcopy.queued_turfs.Copy()
	for (var/turf/Tu in tq)
		if (Tu == T)
			real_update_count += 1

		CHECK_TICK

	var/list/temp_objects = list()

	// Manually compute stack information to check connections
	var/turf/Tscan = T
	var/list/computed_stack = list()
	if (TURF_IS_MIMIC(T))	// non-mimic turfs can enter this proc due to boundaries
		while (Tscan && (Tscan.z_flags & ZM_MIMIC_BELOW) && !(Tscan.z_flags & ZM_OVERRIDE))
			computed_stack += Tscan
			Tscan = GetBelow(Tscan)

		// terminating/root turf
		computed_stack += Tscan
	else
		Tscan = null

	var/root = "(null)"
	if (T.z_discovered_root)
		root = "[T.z_discovered_root] (z [T.z_discovered_root.z], ty [T.z_discovered_root.type], \ref[T.z_discovered_root])"

	var/computed_root = "(null)"
	if (Tscan)
		computed_root = "[Tscan] (z [Tscan.z], ty [Tscan.type], \ref[Tscan])"

	var/is_above_space = T.is_above_space()
	var/list/out = list(
		"<head><meta charset='utf-8'/></head><body>",
		"<h1>Analysis of [T] at [T.x],[T.y],[T.z]</h1>",
		"<b>Queue occurrences:</b> [T.z_queued]",
		"<b>Above space:</b> Apparent [T.z_eventually_space ? "Yes" : "No"], Actual [is_above_space ? "Yes" : "No"] - [FMT_OK(T.z_eventually_space == is_above_space)]",
		"<b>Root:</b> [FMT_OK(T.z_discovered_root == Tscan)]",
		"- Apparent [root]",
		"- Actual [computed_root]",
		"<b>Z Flags</b>: [english_list(bitfield2list(T.z_flags, global.mimic_defines), "(none)")]",
		"<b>Has Shadower:</b> [T.shadower ? "Yes" : "No"]",
		"<b>Has turf proxy:</b> [T.mimic_proxy ? "Yes" : "No"]",
		"<b>Has above copy:</b> [T.mimic_above_copy ? "Yes" : "No"]",
		"<b>Has mimic underlay:</b> [T.mimic_underlay ? "Yes" : "No"]",
		"<b>Below:</b> [!T.below ? "(nothing)" : "[T.below] at [T.below.x],[T.below.y],[T.below.z]"]",
		"<b>Depth:</b> [FMT_DEPTH(T.z_depth)] [T.z_depth == OPENTURF_MAX_DEPTH ? "(max)" : ""]",
		"<b>Generation:</b> [T.z_generation] general, [T.z_generation_lighting] lighting",
		"<b>Update count:</b> Claimed [claimed_update_count], Actual [real_update_count] - [FMT_OK(claimed_update_count == real_update_count)]"
	)

	var/list/found_oo = list(T)
	var/list/shadow_stack = list(T.shadower)
	var/list/apparent_stack = list()

	for (var/turf/Tbelow = T; TURF_IS_MIMIC(Tbelow); Tbelow = Tbelow.below)
		var/atom/movable/openspace/debug/turf/VTO = new
		VTO.computed_depth = SSzcopy.zlev_maximums[Tbelow.z] - Tbelow.z
		VTO.appearance = Tbelow
		VTO.parent = Tbelow
		VTO.plane = ZM_COMPUTE_PLANE(VTO.computed_depth, ZM_SLICE_SLOT_ROOT)
		found_oo += VTO
		temp_objects += VTO
		shadow_stack += Tbelow.shadower
		apparent_stack += Tbelow

	// manually add root, since above loop (intentionally) omits it
	if (apparent_stack.len)
		apparent_stack += apparent_stack[apparent_stack.len]?:below

	if (computed_stack ~= apparent_stack)
		out += "<b>Z-stack</b>: <font color='green'>OK</font>"
		out += SSzcopy.debug_fmt_turf_list(computed_stack)
	else
		out += "<b>Z-stack</b>: <font color='red'>MISMATCH</font>"
		out += "Expected:"
		out += SSzcopy.debug_fmt_turf_list(computed_stack)
		out += "Actual:"
		out += SSzcopy.debug_fmt_turf_list(apparent_stack)

	out += "<hr/>"

	if (!TURF_IS_MIMIC(T))
		out += "<h3>Not a mimic.</h3>"
	else if (!T.below)
		out += "<h3>Using synthetic rendering (Not Z).</h3>"
	else if (T.z_flags & ZM_OVERRIDE)
		out += "<h3>Using synthetic rendering (OVERRIDE) — override is [T.z_appearance ? "MANUAL" : "BASETURF (resolved to [get_base_turf_by_area(T)])"].</h3>"

	for (var/atom/movable/openspace/O in T)
		found_oo += O

	for (var/atom/movable/shadower in shadow_stack)
		if (shadower.overlays.len)
			for (var/overlay in shadower.overlays)
				var/atom/movable/openspace/debug/shadower/D = new
				D.associated_depth = shadower.loc:z_depth
				D.appearance = overlay
				if (D.plane < -10000)	// FLOAT_PLANE
					D.plane = T.shadower.plane
				found_oo += D
				temp_objects += D

	sortTim(found_oo, GLOBAL_PROC_REF(cmp_planelayer))

	var/list/atoms_list_list = list()
	for (var/thing in found_oo)
		var/atom/A = thing
		var/pl = "[A.plane]"
		LAZYINITLIST(atoms_list_list[pl])
		atoms_list_list[pl] += A

	if (atoms_list_list["[DEFAULT_PLANE]"])
		out += "<strong>Non-Z</strong>"
		SSzcopy.debug_fmt_planelist(atoms_list_list["[DEFAULT_PLANE]"], out, T)

		atoms_list_list -= "[DEFAULT_PLANE]"

	if (atoms_list_list["[LIGHTING_PLANE]"])
		out += "<strong>Upper lighting plane</strong>"
		SSzcopy.debug_fmt_planelist(atoms_list_list["[LIGHTING_PLANE]"], out, T)

		atoms_list_list -= "[LIGHTING_PLANE]"

	for (var/d in 0 to OPENTURF_MAX_DEPTH)
		var/list/local_temp = list()
		var/list/offsets = list()
		var/local_acc = 0
		for (var/offset in (OPENTURF_PLANES_PER_DEPTH - 1) to 0 step -1)
			var/ident = zm_offset_to_target[offset + 1]
			var/plane = ZM_COMPUTE_PLANE(d, offset)
			var/plane_str = "[plane]"

			offsets += plane

			local_temp += "<strong>Depth [d] ([ident]), plane [plane], computed target <code>[ZM_SLICE(zm_offset_to_target[offset + 1], d)]</code></strong>"
			SSzcopy.debug_fmt_planelist(atoms_list_list[plane_str], local_temp, T)
			local_acc += length(atoms_list_list[plane_str])
			atoms_list_list -= plane_str	// remove the found plane so we can find orphans

		// potentially wasted work (strings above are built eagerly), but it's a debug verb
		if (local_acc)
			out += local_temp
		else
			out += "<strong>Depth [d], planes [jointext(offsets, "/")] — empty</strong>"

	if (atoms_list_list["[SPACE_PLANE]"])	// Space parallax plane
		out += "<strong>Space parallax plane</strong> ([SPACE_PLANE])"
		SSzcopy.debug_fmt_planelist(atoms_list_list["[SPACE_PLANE]"], out, T)
		atoms_list_list -= "[SPACE_PLANE]"

	log_debug("atoms_list_list => [json_encode(atoms_list_list)]")
	for (var/key in atoms_list_list)
		out += "<strong style='color: red;'>Unknown plane: [key]</strong>"
		SSzcopy.debug_fmt_planelist(atoms_list_list[key], out, T)

		out += "<hr/>"

	out += "</body>"

	show_browser(usr, out.Join("<br>"), "size=1200x950;window=openturfanalysis-\ref[T]")

	for (var/item in temp_objects)
		qdel(item)

// Yes, I know this proc is a bit of a mess. Feel free to clean it up.
/datum/controller/subsystem/zcopy/proc/debug_fmt_thing(atom/A, list/out, turf/original)
	if (istype(A, /atom/movable/openspace/mimic))
		var/atom/movable/openspace/mimic/OO = A
		var/base = "<li>[fmt_label("Mimic", A)] plane [A.plane], layer [A.layer], depth [FMT_DEPTH(OO.depth)], override depth [FMT_DEPTH(OO.override_depth)], [OO.reset_generation] resets"
		if (QDELETED(OO.associated_atom))	// This shouldn't happen, but can if the deletion hook is not working.
			return "[base] - [OO.type] copying <unknown> ([OO.mimiced_type]) - <font color='red'>ORPHANED</font></em></li>"

		var/atom/movable/AA = OO.associated_atom
		var/copied_type = AA.type == OO.mimiced_type ? "[AA.type] \[direct\]" : "[AA.type], eventually [OO.mimiced_type]"
		if (OO.mimiced_type == /atom/movable/openspace/mimic)	// This is invalid, these should always be a 'real' type.
			copied_type += " <font color='red'>CORRUPT</font>"
		return "[base], associated Z-level [AA.z] - [OO.type] copying [AA] ([copied_type])</li>"

	else if (istype(A, /atom/movable/openspace/turf_mimic))
		var/atom/movable/openspace/turf_mimic/DC = A
		return "<li>[fmt_label("Turf Mimic", A)] plane [A.plane], layer [A.layer], Z-level [A.z], delegate of \icon[DC.delegate] [DC.delegate] ([DC.delegate.type])</li>"

	else if (isturf(A))
		if (A == original)
			return "<li>[fmt_label("Turf", A)] plane [A.plane], layer [A.layer], depth [FMT_DEPTH(A:z_depth)], Z-level [A.z] - [A] ([A.type]) - <font color='green'>SELF</font></li>"

		else	// foreign turfs - not visible here, but sometimes good for figuring out layering -- showing these is currently not enabled
			return "<li>[fmt_label("Foreign Turf", A)] <em><font color='#646464'>plane [A.plane], layer [A.layer], depth [FMT_DEPTH(A:z_depth)], Z-level [A.z] - [A] ([A.type])</font></em> - <font color='red'>FOREIGN</font></em></li>"


	else if (A.type == /atom/movable/openspace/multiplier)
		return "<li>[fmt_label("Shadower", A)] plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type]), generation dyn [A:lighting_generation], static [A:lighting_generation_static]</li>"

	else if (A.type == /atom/movable/openspace/debug/shadower)	// These are fake objects that exist just to show the shadower's overlays in this list.
		return "<li>[fmt_label("Shadower True Overlay", A, vv = FALSE)] depth [A:associated_depth], plane [A.plane], layer [A.layer] - <font color='grey'>VIRTUAL</font></li>"

	else if (A.type == /atom/movable/openspace/debug/turf)
		var/atom/movable/openspace/debug/turf/VTO = A
		return "<li>[fmt_label("VTO", VTO.parent)] <em><font color='#646464'>plane [VTO.plane], layer [VTO.layer], computed depth [FMT_DEPTH(VTO.computed_depth)] - [VTO.parent] ([VTO.parent.type])</font></em> - <font color='red'>FOREIGN</font>"

	else if (A.type == /atom/movable/openspace/turf_proxy)
		return "<li>[fmt_label("Turf Proxy", A)] plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type])</li>"

	else
		return "<li>[fmt_label("?", A)] plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type])</li>"

/datum/controller/subsystem/zcopy/proc/fmt_label(label, atom/target, vv = TRUE)
	. = "\icon[target] <b>\[[label]\]</b> "
	if (vv)
		. += "(<a href='?_src_=vars;Vars=\ref[target]'>VV</a>) "

/datum/controller/subsystem/zcopy/proc/debug_fmt_planelist(list/things, list/out, turf/original)
	if (things)
		out += "<ul>"
		for (var/thing in things)
			out += debug_fmt_thing(thing, out, original)
		out += "</ul>"
	else
		out += "<em>No atoms.</em>"

/datum/controller/subsystem/zcopy/proc/debug_fmt_turf_list(list/turf/turfs)
	var/list/working = list("<ul>")
	for (var/item in turfs)
		var/turf/T = astype(item, /turf)
		if (!T)
			working += "<li>(<font color='red'>Non-turf: [item?:type || "<null>"]</font>)</li>"
			continue

		var/list/flags = bitfield2list(T.z_flags, global.mimic_defines)
		var/flags_text = "(none)"
		if (flags.len)
			flags_text = "<code>[flags.Join(" | ")]</code>"

		working += "<li>[T.z]: [T], <code>[T.type]</code>, flags [flags_text]</li>"

	working += "</ul>"

	return working.Join("\n")

#undef FMT_DEPTH
#undef FMT_OK
#undef ZM_RECORD_START
#undef ZM_RECORD_STOP
#undef ZM_RECORD_WRITE

#ifdef ZM_RECORD_STATS
/client/proc/zms_display_turf()
	set name = "ZM Stats - 1Turf"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	if (!length(SSzcopy.turf_stats))
		alert("No stats.")
		return

	render_stats(SSzcopy.turf_stats, src)

/client/proc/zms_display_discovery()
	set name = "ZM Stats - 2Discovery"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	if (!length(SSzcopy.discovery_stats))
		alert("No stats.")
		return

	render_stats(SSzcopy.discovery_stats, src)

/client/proc/zms_display_mimic()
	set name = "ZM Stats - 3Mimic"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	if (!length(SSzcopy.mimic_stats))
		alert("No stats.")
		return

	render_stats(SSzcopy.mimic_stats, src)

#endif
