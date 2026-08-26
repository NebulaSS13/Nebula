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
#define ZM_COMPUTE_DEPTH(Z) min((SSzcopy.zlev_maximums[Z] - (Z)), OPENTURF_MAX_DEPTH)

#define SHADOWER_DARKENING_COLOR "#999999"	// The multiplication factor for openturf shadower darkness. The lighting slice is multiplied by this.

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

#define ZM_BASEMENT_MAX_PLANE -400
#define ZM_BASEMENT_PLANES_PER_DEPTH 1
#define ZM_VSLICE_SLOT_ZSUM 0

/// How many items should we process before we check for yield? Increasing this increases efficiency, but also raises risk of overrun. This was tuned for world.fps = 100.
#define ZM_PUMP_RATIO 4
/// Initialize state required for ZM_MC_TRY_YIELD.
#define ZM_PUMP_INIT var/__yield

/// Check if we need to yield to the MC. This macro will sleep or break.
#define ZM_MC_TRY_YIELD if ((++__yield) >= ZM_PUMP_RATIO) { __yield = 0; if (no_mc_tick) { CHECK_TICK; } else if (MC_TICK_CHECK) { break; } }

var/global/list/zm_offset_to_target = list(ZM_SLICE_TY_BASIC, ZM_SLICE_TY_LIGHTING, ZM_SLICE_TY_CAP)

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
	var/openspace_multipliers = 0

	var/multiqueue_skips_turf = 0	//! How many times did we skip a redundant turf update due to not being the most recent update?
	var/multiqueue_skips_object = 0	//! How many times did we skip a redundant object update due to not being the most recent update?

	var/total_updates_turf = 0
	var/total_updates_discovery = 0
	var/total_updates_object = 0
	var/total_boundary_reocclusion = 0	//! How many times was a boundary removed by a ZM turf being changed to a non-mimic?
	var/deferred_discoveries = 0	//! How many times did we have to recursively discover? This overlaps with the discovery total.
	var/discovery_invalid = 0
	var/lighting_updates = 0
	var/total_boundary_promotions = 0	//! How many turfs were promoted from boundary to mimic?
	var/total_boundary_demotions = 0	//! How many turfs were demoted from mimic to boundary?
	var/total_boundary_removals = 0	//! How many boundaries were made non-z turfs?
	var/total_space_zeroinit = 0
	var/total_space_fastinit = 0
	var/total_large_boundary_proxy_creations = 0	// How many times did we create a boundary intermediate image?
	var/total_large_boundary_scans = 0	// How many times did we need to perform a scan for boundary intermediates (OVER_VB underlay holders)?

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

	/// Looks like a shadower, isn't really. Glorified image, only a movable for AO purposes.
	var/atom/movable/openspace/fake_multiplier/fake_shadower = new

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
		"T(O): { Tb: [openspace_boundaries] | T: [openspace_turfs] | O: [openspace_overlays] | Sh: [openspace_multipliers] }",
		"T(U): { Tb: [total_boundary_reocclusion] | T: [total_updates_turf] | L: [lighting_updates] | O: [total_updates_object] }",
		"T(St): { BPr: [total_boundary_promotions] | BDe: [total_boundary_demotions] | BRm: [total_boundary_removals] | D: [total_updates_discovery] | DDef: [deferred_discoveries] }",
		"T(VB): { Scan: [total_large_boundary_scans] | New: [total_large_boundary_proxy_creations] }",
		"Sk: { T: [multiqueue_skips_turf] | O: [multiqueue_skips_object] | DInv: [discovery_invalid] | SZero: [total_space_zeroinit] | SFast: [total_space_fastinit] }",
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
	var/boundaries = 0
	var/t = REALTIMEOFDAY
	for (var/turf/T in world)
		if (TURF_IS_MIMIC(T))
			for (var/turf/boundary in RANGE_TURFS(T, 1))
				if (!TURF_IS_MIMICKING(boundary))
					boundary.z_flags |= ZM_BOUNDARY
					boundary.setup_zmimic_boundary(TRUE)
					boundaries++
		CHECK_TICK

	log_ss(name, "discovered [boundaries] boundaries in [(t - timeofday)/10] seconds!")

	// Flush the queue.
	fire(FALSE, TRUE)

/// (Re)generate Z-group information. You should run this every time world.maxz (or z-connections) change. ZM's behavior is undefined between resizing the world and calling this proc.
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

		// Visually big turfs are allowed to update even if they aren't strictly mimic turfs.
		if (!isturf(T) || !T.z_queued)
			continue

		// If we're not at our most recent queue position, don't bother -- we're updating again later anyways.
		if (T.z_queued > 1)
			T.z_queued -= 1
			multiqueue_skips_turf += 1
			continue

		if (!(T.z_flags & ZM_FLAGS_CAN_TURF_UPDATE))
			continue

		// Z-Turf on the bottom-most level, just fake-copy space (or baseturf).
		// It's impossible for anything to be on the synthetic turf, so ignore the rest of the ZM machinery.
		if (!T.below)
			if (!(T.z_flags & ZM_MIMIC_BELOW))	// don't care about doing this for boundaries (please don't make space a bigturf)
				continue

			ZM_RECORD_START
			flush_z_state(T)
			if (T.z_flags & ZM_OVERRIDE)
				simple_appearance_copy(T, get_base_turf_by_area(T), ZMIMIC_MAXIMUM_PLANE)
			else
				simple_appearance_copy(T, SSskybox.dust_cache["[((T.x + T.y) ^ ~(T.x * T.y) + T.z) % 25]"])
				T.z_eventually_space = TRUE

			T.z_generation += 1
			T.z_queued -= 1
			total_updates_turf += 1

			if (T.above)
				T.above.update_mimic()

			ZM_RECORD_STOP
			ZM_RECORD_WRITE(turf_stats, "Fake: [T.type] on [T.z]")

			ZM_MC_TRY_YIELD
			continue

		T.z_generation += 1

		ZM_RECORD_START

		// We need to find the non-z turf that's visually at the bottom of this group. BOUNDARY turfs are regular turfs, so they need to not be considered here.
		// OVERRIDEs also don't copy the things below them, so they're considered a termination point too.
		// This logic is duplicated below in analyze_openturf().
		var/list/ao_intermediates	//! This is a list of turfs in the z-stack that have AO that we need to manually copy.
		var/list/extra_underlays	//! This is a list of boundary turf appearances used to fake multi-turf copy for large turfs below non-large turfs.
		var/turf/Td = T

		while (Td.below && ZM_TURF_DOES_NOT_TERMINATE_ROOT_SCAN(Td))
			Td = Td.below
			if (Td && (!isnull(Td.ao_neighbors) && Td.ao_neighbors != AO_ALL_NEIGHBORS) || (!isnull(Td.ao_neighbors_mimic) && Td.ao_neighbors_mimic != AO_ALL_NEIGHBORS))
				LAZYADD(ao_intermediates, Td)

		// If our root is above a VISUALLY_BIG and is a boundary (OVER_VB can't be set on non-BOUNDARY), we need to do a second root scan to find the VB turf(s).
		if (Td.z_flags & ZM_OVER_VB)
			total_large_boundary_scans++
			var/turf/Tvbr = Td

			// This is a fairly cold path, so it's not worth microoptimizing it. ~800 turfs of ~100,000 considered trigger it on O7.
			while (Tvbr.below && ZM_TURF_DOES_NOT_TERMINATE_VB_SCAN(Tvbr))
				Tvbr = Tvbr.below

				if (Tvbr.z_flags & ZM_VISUALLY_BIG)
					var/mutable_appearance/fatass = new(Tvbr)
					var/depth = ZM_COMPUTE_DEPTH(Tvbr.z)
					fatass.plane = ZM_COMPUTE_PLANE(depth, ZM_SLICE_SLOT_ROOT)
					// can't just nuke overlays since they're used for smoothing, but we don't want AO overlays
					if (Tvbr.ao_overlays)
						fatass.overlays -= Tvbr.ao_overlays
					if (Tvbr.ao_overlays_mimic)
						fatass.overlays -= Tvbr.ao_overlays_mimic

					LAZYADD(extra_underlays, fatass)
					total_large_boundary_proxy_creations++

		T.z_discovered_root = Td

		// Depth must be the depth of the *visible* turf, not self.
		// If you're getting runtimes here, you violated a ZM invariant. Not a bug in ZM, you should be notifying ZM when you resize the world.
		var/turf_depth = T.z_depth = zlev_maximums[Td.z] - Td.z
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

		var/list/intermediate_ao_overlays
		if (ao_intermediates && !Td.z_appearance)
#ifdef ZM_ENH_DEBUG
			T.z_ao_intermediates = ao_intermediates
#endif
			for (var/turf/ao_contributor in ao_intermediates)
				var/depth = ZM_COMPUTE_DEPTH(ao_contributor.z)
				// Make sure the analyzer's overlay logic remains in sync with this logic.
				var/target_plane_self = ZM_COMPUTE_PLANE(depth, ZM_SLICE_SLOT_ROOT)
				var/target_plane_z_ao = ZM_COMPUTE_PLANE(depth + 1, ZM_SLICE_SLOT_CAP)
				// this may allocate the list, though it will modify it in place if it exists
				intermediate_ao_overlays = ao_contributor.zm_render_foreign_ao_to(Td, intermediate_ao_overlays, target_plane_self, target_plane_z_ao)

		if (T.z_flags & ZM_MIMIC_REPLACE)
			// This openturf doesn't care about its icon, so we can just overwrite it.
			if (T.below.mimic_proxy)
				QDEL_NULL(T.below.mimic_proxy)
			T.appearance = Td.z_appearance || Td
			if (length(T.overlays))
				T.our_overlays = T.overlays.Copy()	// We call into SSoverlays for AO, so make sure we don't lose the mimic overlays.
			else
				T.our_overlays = null
			if (Td.ao_overlays)
				T.cut_overlay(Td.ao_overlays)
			if (Td.ao_overlays_mimic)
				T.cut_overlay(Td.ao_overlays_mimic)
			if (intermediate_ao_overlays)
				T.add_overlay(intermediate_ao_overlays)

			if (extra_underlays)
				T.underlays += extra_underlays

			T.name = initial(T.name)
			T.desc = initial(T.desc)
			T.gender = initial(T.gender)
			T.opacity = FALSE
			T.plane = t_target
			T.z_was_replaced = TRUE
		else
			// Some openturfs have icons, so we can't overwrite their appearance.
			if (!T.below.mimic_proxy)
				T.below.mimic_proxy = new(T)	// TODO: Why is this on the below turf when it's ours?
			var/atom/movable/openspace/turf_proxy/TO = T.below.mimic_proxy
			TO.appearance = Td.z_appearance || Td
			TO.name = T.name
			TO.gender = T.gender	// Need to grab this too so PLURAL works properly in examine.
			TO.opacity = FALSE
			TO.plane = t_target
			if (length(TO.overlays))
				TO.our_overlays = TO.overlays.Copy()
			else
				TO.our_overlays = null
			if (Td.ao_overlays)
				TO.cut_overlay(Td.ao_overlays)
			if (Td.ao_overlays_mimic)
				TO.cut_overlay(Td.ao_overlays_mimic)
			if (intermediate_ao_overlays)
				TO.add_overlay(intermediate_ao_overlays)

			if (TO.overlay_queued)
				TO.compile_overlays()

			if (extra_underlays)
				TO.underlays += extra_underlays

			TO.mouse_opacity = initial(TO.mouse_opacity)
			if (T.z_was_replaced)	// best effort attempt to reset the appearance to something sane
				T.reset_appearance()
				T.z_was_replaced = FALSE

		// If ao_neighbors hasn't been set yet, we need to do a rebuild.
		// For efficiency, we also handle regular AO for Z-turfs to avoid double-updating due to subsystem init order.
		if (T.ao_neighbors == null || T.ao_neighbors_mimic == null)
			T.queue_ao(TRUE, TRUE)
		else if (T.z_flags & ZM_MIMIC_REPLACE)	// If it hasn't been replaced, we won't have lost these.
			T.apply_ao()

		if (T.overlay_queued)
			T.compile_overlays()

		// More than one turf can be visible when a z-stack contains a non-REPLACE z-turf, so we need to create a holder object to hold the non-root turf appearance for this level.
		if ((T.below.z_flags & (ZM_MIMIC_BELOW | ZM_MIMIC_REPLACE)) == ZM_MIMIC_BELOW)
			// Below is a delegate, gotta explicitly copy it for recursive copy.
			if (!T.below.mimic_above_copy)
				T.below.mimic_above_copy = new(T)
			var/atom/movable/openspace/turf_mimic/DC = T.below.mimic_above_copy
			DC.appearance = T.below
			DC.mouse_opacity = initial(DC.mouse_opacity)
			DC.target_slot = ZM_SLICE_SLOT_ROOT
			var/target_depth = ZM_COMPUTE_DEPTH(T.below.z)
			DC.plane = ZM_COMPUTE_PLANE(target_depth, ZM_SLICE_SLOT_ROOT)

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
	var/atom/movable/lighting_overlay/object = target_turf.below?.lighting_overlay
	if (object /*&& object.icon_state != LIGHTING_TRANSPARENT_ICON_STATE*/)	// This logically should work, but it causes rendering artifacts instead.
		if (!target_turf.shadower)
			target_turf.shadower = new(target_turf)
			openspace_multipliers += 1
		target_turf.shadower.copy_lighting(object)
	else if (target_turf.shadower)
		// If a turf is not using Z-AO, we can delete the extant shadower.
		if (target_turf.ao_neighbors_mimic == AO_ALL_NEIGHBORS || !AO_Z_SELF_CHECK(target_turf))
			qdel(target_turf.shadower, TRUE)
		else if (object)	// Otherwise we need to update if it's there to avoid half-broken shadowers. No need to *create* it, though.
			target_turf.shadower.copy_lighting(object)

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

		OO.plane = OO.override_plane || ZM_COMPUTE_PLANE(OO.depth, OO.target_slot)
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
		ZM_RECORD_WRITE(mimic_stats, OO.mimicked_type)

		ZM_MC_TRY_YIELD

	if (qo_idex > 1)
		curr_ov.Cut(1, qo_idex)
		qo_idex = 1

// only_reset: do not queue for update, only update layering info
// return: is-invalid
/datum/controller/subsystem/zcopy/proc/discover_movable(atom/movable/object)
	ASSERT(!QDELETED(object))

	if (!isturf(object.loc) || !MOVABLE_SHALL_MIMIC(object))	// We have to check this again here since atoms might change their eligibility during Initialize().
		discovery_invalid++
		return TRUE
	var/turf/Tloc = object.loc
	var/turf/T = Tloc.above || GetAbove(Tloc)	// it is valid for Tloc itself to not be a mimic due to LOOKAHEAD/LOOKBESIDE

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

	var/atom/movable/openspace/mimic/OO = object.bound_overlay

	// If the OO was queued for destruction but was claimed by another OT, stop the destruction timer.
	if (OO.destruction_timer)
		deltimer(OO.destruction_timer)
		OO.destruction_timer = null

	update_mimic_layering(OO)

	// Multi-queue to maintain ordering of updates to these
	//   queueing it multiple times will result in only the most recent
	//   actually processing.
	OO.queued += 1
	queued_overlays += OO

	total_updates_discovery += 1

	ZM_RECORD_STOP
	ZM_RECORD_WRITE(discovery_stats, "[OO.mimicked_type] on [OO.z]")

	if (defer)
		deferred_discoveries += 1
		.(defer)

	return FALSE

/// Regenerate a mimic's layering and render slice membership information. This does not recursively update. It's valid to call this on a mimic that is located on a non-mimic turf, but it must be on a turf.
/datum/controller/subsystem/zcopy/proc/update_mimic_layering(atom/movable/openspace/mimic/target_mimic)
	var/override_plane
	var/original_type = target_mimic.associated_atom.type
	var/original_z = target_mimic.associated_atom.z

	var/turf/T = target_mimic.loc
	if (!isturf(T))
		CRASH("Attempt to generate mimic layering for orphaned mimic.")

	// If we're mimicking another ZM object, copy its target render slot. This will handle blur for turf objects as well as the lighting slot for shadowers.
	var/target_slot = astype(target_mimic.associated_atom, /atom/movable/openspace)?.target_slot || ZM_SLICE_SLOT_ROOT

	switch (target_mimic.associated_atom.type)
		// Depth for recursive mimic needs to be inherited.
		if (/atom/movable/openspace/mimic)
			var/atom/movable/openspace/mimic/OOO = target_mimic.associated_atom
			original_type = OOO.mimicked_type
			override_plane = OOO.override_plane
			original_z = OOO.original_z

		// Turf mimics are a special case of mimic: they mimic non-REPLACE turfs so midspan turfs render. Their visual z-level is the z-level of their copied turf.
		if (/atom/movable/openspace/turf_mimic)
			var/atom/movable/openspace/turf_mimic/TM = target_mimic.associated_atom
			original_z = TM.delegate.z

		// If this is a turf proxy (the mimic for a non-REPLACE turf), it needs to respect space parallax if relevant.
		if (/atom/movable/openspace/turf_proxy)
			if (T.z_eventually_space)
				override_plane = SPACE_PLANE

		// Multipliers are more or less just a special case of movable mimic. Like with the turf_mimic, their visual z-level is the z-level of their associated lighting overlay.
		if (/atom/movable/openspace/multiplier)
			var/atom/movable/openspace/multiplier/M = target_mimic.associated_atom
			original_z = M.source_z

	if (override_plane)
		target_mimic.depth = -1
	else
		target_mimic.depth = ZM_COMPUTE_DEPTH(original_z)

	target_mimic.target_slot = target_slot
	target_mimic.mimicked_type = original_type
	target_mimic.override_plane = override_plane
	target_mimic.original_z = original_z

	// We're only trying to rebuild layering information, no need to update the appearance.
	target_mimic.plane = override_plane || ZM_COMPUTE_PLANE(target_mimic.depth, target_mimic.target_slot)

/// Update if a mimic should be hidden from right-click, usually by it being underneath a non-mimic turf.
/datum/controller/subsystem/zcopy/proc/update_mimic_occlusion(atom/movable/openspace/mimic/target_mimic)
#ifdef ZM_ENH_DEBUG
	var/old_state = target_mimic.hidden
#endif

	var/turf/T = target_mimic.loc
	if (!isturf(T))
		ZM_DEBUG_LOG("Mimic of [target_mimic.associated_atom] ([target_mimic.associated_atom.type]) is being hidden because of a non-turf loc")
		target_mimic.hidden = ZM_HIDE_NONMIMIC
	else if (!MOVABLE_IS_ON_ZTURF(target_mimic))	// If this movable isn't under a z-turf, hide it to avoid cluttering the right-click menu.
		target_mimic.hidden = ZM_HIDE_NONMIMIC
	else
		target_mimic.hidden = 0

		// If this movable is under a click-opaque turf and that turf has opted into hiding atoms, hide this movable.
		if (T.mouse_opacity == 2 && (T.z_flags & ZM_HIDE_ATOMS))
			target_mimic.hidden |= ZM_HIDE_OPAQUE
		else
			target_mimic.hidden &= ~ZM_HIDE_OPAQUE

		// If this movable is under a boundary, hide it from right-click since the client shouldn't be able to see it.
		// 	...but if the movable is a LOOKAHEAD/LOOKBESIDE atom, the client probably *can* see it, so avoid hiding those.
		// Mimics inherit z flags from their associated mimic, so we can just check those.
		if ((T.z_flags & ZM_BOUNDARY) && !(target_mimic.z_flags & (ZMM_LOOKAHEAD | ZMM_LOOKBESIDE)))
			target_mimic.hidden |= ZM_HIDE_BOUNDARY
		else
			target_mimic.hidden &= ~ZM_HIDE_BOUNDARY

#ifdef ZM_ENH_DEBUG
	if (old_state != target_mimic.hidden)
		var/old_f = jointext(bitfield2list(old_state, mimic_hide_defines), " | ")
		var/new_f = jointext(bitfield2list(target_mimic.hidden, mimic_hide_defines), " | ")
		ZM_DEBUG_LOG("Occlusion: mimic transitioning from state ([old_f]) to ([new_f])")
#endif

	if (target_mimic.hidden)
		target_mimic.name = ""
	else
		target_mimic.name = target_mimic.cached_name

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
	if (T.z_flags & ZM_MIMIC_REPLACE)
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
			if (FLOAT_PLANE)
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

/datum/controller/subsystem/zcopy/proc/CreatePlanesFor(client/C)
	for (var/i in 0 to OPENTURF_MAX_DEPTH)
		CreateSlice(C, /obj/mimic_master/slice/basic, i)
		CreateSlice(C, /obj/mimic_master/slice/shadower_master, i)
		CreateSlice(C, /obj/mimic_master/slice/cap, i)
		CreateSlice(C, /obj/mimic_master/slice/virtual/zsum, i)

#define FMT_DEPTH(X) (X == null ? "(null)" : X)
#define FMT_OK(X) (X) ? "<font color='green'>OK</font>" : "<font color='red'>MISMATCH</font>"
/// if ROOT is FALSE, also check ALTERNATE and show indeterminate if true
#define FMT_MAYBE(ROOT, ALTERNATE) ((ROOT) ? "<font color='green'>OK</font>" : ((ALTERNATE) ? "<font color='orange'>INDETERMINATE</font> (undefined for this entity)" : "<font color='red'>MISMATCH</font>"))
#define FMT_YESNO(X) ((X) ? "Yes" : "No")

// This is a dummy object used so overlays can be shown in the analyzer.
/atom/movable/openspace/debug

/atom/movable/openspace/debug/turf
	var/turf/parent
	var/computed_depth

/atom/movable/openspace/debug/ao
	var/neighbors
	var/is_z = FALSE
	var/turf/associated_turf

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
	var/alist/lighting_overlays = alist()

	if (T.lighting_overlay)
		lighting_overlays[ZM_COMPUTE_DEPTH(T.lighting_overlay.z)] = T.lighting_overlay

	// Manually compute stack information to check connections
	var/turf/Tscan = T
	var/list/computed_stack = list(T)

	while (HasBelow(Tscan.z) && ZM_TURF_DOES_NOT_TERMINATE_Z_STACK(Tscan))
		Tscan = GetBelow(Tscan)
		computed_stack += Tscan
		if (Tscan.lighting_overlay)
			lighting_overlays[ZM_COMPUTE_DEPTH(Tscan.lighting_overlay.z)] = Tscan.lighting_overlay

	var/turf/true_root = T
	while (HasBelow(true_root.z) && ZM_TURF_DOES_NOT_TERMINATE_ROOT_SCAN(true_root))
		true_root = GetBelow(true_root)

	var/root = "(null)"
	if (T.z_discovered_root)
		root = "[T.z_discovered_root] (z [T.z_discovered_root.z], ty [T.z_discovered_root.type], \ref[T.z_discovered_root])"

	var/computed_root = "[true_root] (z [true_root.z], ty [true_root.type], \ref[true_root])"

	var/above_label = "(no above)"
	if (T.above)
		above_label = "[SSzcopy.fmt_label("Above", T.above, recurse = TRUE)] [T.above] (<code>[T.above.type]</code>)"

	var/below_label = "(no below)"
	if (T.below)
		below_label = "[SSzcopy.fmt_label("Below", T.below, recurse = TRUE)] [T.below] (<code>[T.below.type]</code>)"

	var/is_above_space = T.is_above_space()
	var/list/out = list(
		"<head><meta charset='utf-8'/></head><body>",
		"<h1>Analysis of [T] at [T.x],[T.y],[T.z] (<a href='?_src_=vars;zm_analyze=\ref[T]'>refresh</a>)</h1>",
		"<b>Connections:</b> [above_label] / [below_label]",
		"<b>Queue occurrences:</b> [T.z_queued]",
		// boundaries don't compute eventually_space, nor do non-z turfs
		"<b>Above space:</b> Apparent: [FMT_YESNO(T.z_eventually_space)], Actual: [FMT_YESNO(is_above_space)] - [FMT_MAYBE(T.z_eventually_space == is_above_space, !TURF_IS_MIMIC(T))]",
		"<b>Root:</b> [FMT_MAYBE(T.z_discovered_root == true_root, T.z_was_fastinit || !TURF_IS_MIMIC(T))]",	// fast init doesn't set this, nor do boundaries, nor do non-z turfs
		"- Apparent [root]" + (T.z_was_fastinit ? " (fast init)" : ""),
		"- Actual [computed_root]",
		"<b>Z Flags</b>: [english_list(bitfield2list(T.z_flags, global.mimic_defines), "(none)")]",
		"<b>Has shadower:</b> [FMT_YESNO(T.shadower)]",
		"<b>Has turf proxy:</b> [FMT_YESNO(T.mimic_proxy)]",
		"<b>Has above copy:</b> [FMT_YESNO(T.mimic_above_copy)]",
		"<b>Has mimic underlay:</b> [FMT_YESNO(T.mimic_underlay)]",
		"<b>Fast init:</b> Allowed: [FMT_YESNO(T.z_allow_fastinit)] / Used: [FMT_YESNO(T.z_was_fastinit)]",
		"<b>Was replaced:</b> [T.z_was_replaced ? "Yes" : "No"]",
		"<b>Depth:</b> [FMT_DEPTH(T.z_depth)] [T.z_depth == OPENTURF_MAX_DEPTH ? "(max)" : ""]",
		"<b>Generation:</b> [T.z_generation] general, [T.z_generation_lighting] lighting",
		"<b>Update count:</b> Claimed [claimed_update_count], Actual [real_update_count] - [FMT_OK(claimed_update_count == real_update_count)]"
	)

	var/list/found_oo = list(T)

#ifdef ZM_ENH_DEBUG
	// This involves keeping a ton of extra lists around, so it's only available if enhanced ZM debugging is on.
	if (LAZYLEN(T.z_ao_intermediates))
		for (var/turf/ao_turf in (T.z_ao_intermediates + T))
			var/depth = ZM_COMPUTE_DEPTH(ao_turf.z)
			if (ao_turf.ao_neighbors != AO_ALL_NEIGHBORS && ao_turf.ao_neighbors != null && length(ao_turf.ao_overlays))
				var/atom/movable/openspace/debug/ao/aod = new
				aod.neighbors = ao_turf.ao_neighbors
				aod.associated_turf = ao_turf

				aod.plane = ZM_COMPUTE_PLANE(depth, ZM_SLICE_SLOT_ROOT)
				aod.pixel_x = ao_turf.ao_overlays[1]:pixel_x
				aod.pixel_y = ao_turf.ao_overlays[1]:pixel_y
				found_oo += aod

			if (ao_turf.ao_neighbors_mimic != AO_ALL_NEIGHBORS && ao_turf.ao_neighbors_mimic != null && length(ao_turf.ao_overlays_mimic))
				var/atom/movable/openspace/debug/ao/aod = new
				aod.neighbors = ao_turf.ao_neighbors_mimic
				aod.associated_turf = ao_turf
				aod.is_z = TRUE

				aod.plane = ZM_COMPUTE_PLANE(depth + 1, ZM_SLICE_SLOT_CAP)
				aod.pixel_x = ao_turf.ao_overlays_mimic[1]:pixel_x
				aod.pixel_y = ao_turf.ao_overlays_mimic[1]:pixel_y
				found_oo += aod

#endif

	var/list/apparent_stack = list(T)

	var/turf/Tbelow = T
	while (Tbelow.below && ZM_TURF_DOES_NOT_TERMINATE_Z_STACK(Tbelow))
		Tbelow = Tbelow.below

		var/atom/movable/openspace/debug/turf/VTO = new
		VTO.computed_depth = SSzcopy.zlev_maximums[Tbelow.z] - Tbelow.z
		VTO.appearance = Tbelow
		VTO.parent = Tbelow
		VTO.plane = ZM_COMPUTE_PLANE(VTO.computed_depth, ZM_SLICE_SLOT_ROOT)
		found_oo += VTO
		temp_objects += VTO
		apparent_stack += Tbelow

	// manually add root, since above loop (intentionally) omits it
	if (apparent_stack.len)
		var/turf/apparent_root = apparent_stack[apparent_stack.len]?:below
		if (apparent_root)	// This can be null if a mimic turf is above nothing, which is valid.
			apparent_stack += apparent_root

	if (computed_stack ~= apparent_stack)
		out += "<b>Z-stack:</b> <font color='green'>OK</font>"
		out += SSzcopy.debug_fmt_turf_list(computed_stack, true_root)
	else
		out += "<b>Z-stack:</b> <font color='red'>MISMATCH</font>"
		out += "Expected:"
		out += SSzcopy.debug_fmt_turf_list(computed_stack, true_root)
		out += "Actual:"
		out += SSzcopy.debug_fmt_turf_list(apparent_stack, true_root)

	if (!TURF_IS_MIMICKING(T))
		out += "<h3>Not a mimic.</h3>"
	else if (!T.below)
		out += "<h3>Using synthetic rendering (Not Z).</h3>"
	else if (T.z_flags & ZM_OVERRIDE)
		out += "<h3>Using synthetic rendering (OVERRIDE) — override is [T.z_appearance ? "MANUAL" : "BASETURF (resolved to [get_base_turf_by_area(T)])"].</h3>"

	out += "<hr/>"

	for (var/atom/movable/openspace/O in T)
		found_oo += O

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
		out += "<strong>Lighting plane</strong>"
		SSzcopy.debug_fmt_planelist(atoms_list_list["[LIGHTING_PLANE]"], out, T)

		atoms_list_list -= "[LIGHTING_PLANE]"

	for (var/d in 0 to OPENTURF_MAX_DEPTH)
		var/list/local_temp = list()
		var/list/offsets = list()
		var/local_acc = 0

		if (d in lighting_overlays)
			out += "<strong><em><font color='#646464'>Depth [d], foreign lighting</font></em></strong>"
			out += SSzcopy.debug_fmt_thing(lighting_overlays[d], T)

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

	if (atoms_list_list["[SKYBOX_PLANE]"])
		out += "<strong>Skybox plane</strong> ([SKYBOX_PLANE])"
		SSzcopy.debug_fmt_planelist(atoms_list_list["[SKYBOX_PLANE]"], out, T)
		atoms_list_list -= "[SKYBOX_PLANE]"

	for (var/key in atoms_list_list)
		out += "<strong style='color: red;'>Unknown plane: [key]</strong>"
		SSzcopy.debug_fmt_planelist(atoms_list_list[key], out, T)

		out += "<hr/>"

	out += "</body>"

	show_browser(usr, out.Join("<br>"), "size=1200x950;window=openturfanalysis-\ref[T]")

	for (var/item in temp_objects)
		qdel(item)

// Yes, I know this proc is a bit of a mess. Feel free to clean it up.
/datum/controller/subsystem/zcopy/proc/debug_fmt_thing(atom/A, turf/original)
	if (istype(A, /atom/movable/openspace/mimic))
		var/atom/movable/openspace/mimic/OO = A
		var/base = "[fmt_label("Mimic", A)] plane [A.plane], layer [A.layer], depth [FMT_DEPTH(OO.depth)], override depth [FMT_DEPTH(OO.override_plane)]"
		if (QDELETED(OO.associated_atom))	// This shouldn't happen, but can if the deletion hook is not working.
			return "[base] - [OO.type] copying <unknown> ([OO.mimicked_type]) - <font color='red'>ORPHANED</font></em>"

		var/atom/movable/AA = OO.associated_atom
		var/copied_type = AA.type == OO.mimicked_type ? "[AA.type] \[direct\]" : "[AA.type], eventually [OO.mimicked_type]"
		if (OO.mimicked_type == /atom/movable/openspace/mimic)	// This is invalid, these should always be a 'real' type.
			copied_type += " <font color='red'>CORRUPT</font>"
		return "[base], associated Z-level [AA.z] - [OO.type] copying [AA] ([copied_type])"

	else if (istype(A, /atom/movable/openspace/turf_mimic))
		var/atom/movable/openspace/turf_mimic/DC = A
		return "[fmt_label("Turf Mimic", A)] plane [A.plane], layer [A.layer], Z-level [A.z], delegate of \icon[DC.delegate] [DC.delegate] ([DC.delegate.type])"

	else if (isturf(A))
		if (A == original)
			return "[fmt_label("Turf", A)] plane [A.plane], layer [A.layer], depth [FMT_DEPTH(A:z_depth)], Z-level [A.z] - [A] ([A.type]) - <font color='green'>SELF</font>"

		else	// foreign turfs - not visible here, but sometimes good for figuring out layering -- showing these is currently not enabled
			return "[fmt_label("Foreign Turf", A)] <em><font color='#646464'>plane [A.plane], layer [A.layer], depth [FMT_DEPTH(A:z_depth)], Z-level [A.z] - [A] ([A.type])</font></em> - <font color='red'>FOREIGN</font></em>"

	else if (A.type == /atom/movable/lighting_overlay)
		var/computed_depth = ZM_COMPUTE_DEPTH(A.z)
		var/base = "[fmt_label("Lighting Overlay", A)] <em><font color='#646464'>computed depth [FMT_DEPTH(computed_depth)]</font></em>"
		if (A == original.lighting_overlay)
			base += " - <font color='green'>OURS</font>"
		else
			base += " - <font color='red'>FOREIGN</font>"
		return base

	else if (A.type == /atom/movable/openspace/multiplier)
		var/base = "[fmt_label("Shadower", A)] plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type]), generation [A:lighting_generation]"
		if (A.z != original.z)
			base += " - <font color='red'>FOREIGN</font>"
		return base

	else if (A.type == /atom/movable/openspace/debug/ao)	// Fake objects holding state of AO from both our turf as well as midspan AO intermediate turfs.
		var/atom/movable/openspace/debug/ao/aod = A
		var/neighbor_text = english_list(bitfield2list(aod.neighbors, n_neighbors))
		var/label = aod.is_z ? "Z-AO True Overlay" : "AO True Overlay"
		return "[fmt_label(label, A, vv = FALSE)] plane [aod.plane], layer [aod.layer], pixel x/y [aod.pixel_x]/[aod.pixel_y], neighbors [neighbor_text], associated turf [fmt_label(aod.associated_turf, aod.associated_turf, TRUE, TRUE)] - <font color='grey'>VIRTUAL</font>"

	else if (A.type == /atom/movable/openspace/debug/turf)
		var/atom/movable/openspace/debug/turf/VTO = A
		return "[fmt_label("Foreign Turf", VTO.parent, recurse = TRUE)] <em><font color='#646464'>plane [VTO.plane], layer [VTO.layer], computed depth [FMT_DEPTH(VTO.computed_depth)] - [VTO.parent] ([VTO.parent.type])</font></em> - <font color='red'>FOREIGN</font>"

	else if (A.type == /atom/movable/openspace/turf_proxy)
		return "[fmt_label("Turf Proxy", A)] plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type])"

	else
		return "[fmt_label("?", A)] plane [A.plane], layer [A.layer], Z-level [A.z] - [A] ([A.type])"

/datum/controller/subsystem/zcopy/proc/fmt_label(label, atom/target, vv = TRUE, recurse = FALSE)
	. = "\icon[target] <b>\[[label]\]</b> "
	if (vv)
		. += "(<a href='?_src_=vars;Vars=\ref[target]'>VV</a>"

	if (recurse)
		. += ", <a href='?_src_=vars;zm_analyze=\ref[target]'>OA</a>) "
	else if (vv)
		. += ") "

/datum/controller/subsystem/zcopy/proc/debug_fmt_planelist(list/things, list/out, turf/original)
	if (things)
		out += "<ul>"
		for (var/thing in things)
			out += "<li>" + debug_fmt_thing(thing, original) + "</li>"
		out += "</ul>"
	else
		out += "<em>No atoms.</em>"

/datum/controller/subsystem/zcopy/proc/debug_fmt_turf_list(list/turf/turfs, turf/root)
	var/list/working = list("<ul>")
	for (var/item in turfs)
		var/turf/T = astype(item, /turf)
		if (!T)
			working += "<li>(<font color='red'>Non-turf: [item?:type || "(null)"]</font>)</li>"
			continue

		var/list/flags = bitfield2list(T.z_flags, global.mimic_defines)
		var/flags_text = "(none)"
		if (flags.len)
			flags_text = "<code>[flags.Join(" | ")]</code>"

		var/terminating_text = ""
		var/prefix_text = "[T.z]"
		if (item == root)
			terminating_text = " - <b>ROOT</b>"
			prefix_text = "<b>[prefix_text]</b>"

		working += "<li>[prefix_text]: [T], <code>[T.type]</code>, flags [flags_text][terminating_text]</li>"

	working += "</ul>"

	return working.Join("\n")

#undef FMT_DEPTH
#undef FMT_OK
#undef FMT_MAYBE
#undef FMT_YESNO
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
