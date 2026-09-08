/turf
	var/permit_ao = TRUE
	var/tmp/list/ao_overlays	//! Current ambient occlusion overlays. Tracked so we can reverse them without dropping all priority overlays.
	var/tmp/ao_neighbors
	var/tmp/list/ao_overlays_mimic	//! AO overlays for the Z depth effect.
	var/tmp/ao_neighbors_mimic
	var/ao_queued = AO_UPDATE_NONE

/turf/proc/regenerate_ao()
	for(var/thing in RANGE_TURFS(src, 1))
		var/turf/their_turf = thing
		their_turf = their_turf.resolve_to_actual_turf()
		if(their_turf.permit_ao)
			their_turf.queue_ao(TRUE)

/turf/proc/calculate_ao_neighbors()
	ao_neighbors = 0
	ao_neighbors_mimic = 0
	if (!permit_ao)
		return

	var/turf/T
	if (AO_Z_SELF_CHECK(src))
		CALCULATE_NEIGHBORS(src, ao_neighbors_mimic, T, (T.z_flags & ZM_MIMIC_BELOW))

	if (AO_SELF_CHECK(src) && !(z_flags & ZM_MIMIC_NO_AO))
		CALCULATE_NEIGHBORS(src, ao_neighbors, T, AO_TURF_CHECK(T))

/proc/make_ao_image(corner, i, px = 0, py = 0, pz = 0, pw = 0, alpha, plane)
	var/list/cache = SSao.cache
	var/cstr = "[corner]"
	// PROCESS_AO_CORNER below also uses this cache, check it before changing this key.
	var/key = "[cstr]|[i]|[px]/[py]/[pz]/[pw]|[alpha]|[plane]"

	var/image/I = image('icons/turf/flooring/shadows.dmi', cstr, dir = BITFLAG(i-1))
	I.alpha = alpha
	I.blend_mode = BLEND_OVERLAY
	I.appearance_flags = RESET_ALPHA|RESET_COLOR|TILE_BOUND
	I.layer = AO_LAYER
	if (plane)
		I.plane = plane
	// If there's an offset, counteract it.
	if (px || py || pz || pw)
		I.pixel_x = -px
		I.pixel_y = -py
		I.pixel_z = -pz
		I.pixel_w = -pw

	. = cache[key] = I

/turf/proc/queue_ao(rebuild = TRUE, synchronous = FALSE)
	if (!ao_queued && !synchronous)
		SSao.queue += src

	var/new_level = rebuild ? AO_UPDATE_REBUILD : AO_UPDATE_OVERLAY
	if (ao_queued < new_level)
		ao_queued = new_level

	if (synchronous)
		SSao.updates_sync++
		update_ao()

/turf/proc/update_ao()
	if (ao_queued == AO_UPDATE_REBUILD)
		var/old_n = ao_neighbors
		var/old_z = ao_neighbors_mimic
		calculate_ao_neighbors()
		if (old_n != ao_neighbors || old_z != ao_neighbors_mimic)
			apply_ao()
	else
		apply_ao()

	ao_queued = AO_UPDATE_NONE

#define PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, CORNER_INDEX, CDIR, ALPHA, TARGET, PLANE) \
	corner = 0; \
	if (NEIGHBORS & (BITFLAG(CDIR))) { \
		corner |= 2; \
	} \
	if (NEIGHBORS & (BITFLAG(turn(CDIR, 45)))) { \
		corner |= 1; \
	} \
	if (NEIGHBORS & (BITFLAG(turn(CDIR, -45)))) { \
		corner |= 4; \
	} \
	if (corner != 7) {	/* 7 is the 'no shadows' state, no reason to add overlays for it. */ \
		var/image/I = cache["[corner]|[CORNER_INDEX]|[TARGET.pixel_x]/[TARGET.pixel_y]/[TARGET.pixel_z]/[TARGET.pixel_w]|[ALPHA]|[PLANE]"]; \
		if (!I) { \
			I = make_ao_image(corner, CORNER_INDEX, TARGET.pixel_x, TARGET.pixel_y, TARGET.pixel_z, TARGET.pixel_w, ALPHA, PLANE)	/* this will also add the image to the cache. */ \
		} \
		LAZYADD(AO_LIST, I); \
	}

#define CUT_AO(TARGET, AO_LIST) \
	if (AO_LIST) { \
		TARGET.cut_overlay(AO_LIST, TRUE); \
		AO_LIST.Cut(); \
	}

#define GENERATE_AO(TARGET, AO_LIST, NEIGHBORS, ALPHA, PLANE) \
	if (permit_ao && NEIGHBORS != AO_ALL_NEIGHBORS) { \
		var/corner;\
		PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, 1, NORTHWEST, ALPHA, TARGET, PLANE); \
		PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, 2, SOUTHEAST, ALPHA, TARGET, PLANE); \
		PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, 3, NORTHEAST, ALPHA, TARGET, PLANE); \
		PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, 4, SOUTHWEST, ALPHA, TARGET, PLANE); \
	} \
	UNSETEMPTY(AO_LIST);

/turf/proc/apply_ao()
	var/list/cache = SSao.cache
	if (shadower)
		CUT_AO(shadower, ao_overlays_mimic)
	CUT_AO(src, ao_overlays)
	if (AO_Z_SELF_CHECK(src))
		var/computed_depth = ZM_COMPUTE_DEPTH(z) + 1
		var/target_plane = ZM_COMPUTE_PLANE(computed_depth, ZM_SLICE_SLOT_CAP)
		// We may not have a shadower yet, so we're going to use Z-Copy's fake shadower as a stand-in.
		GENERATE_AO(SSzcopy.fake_shadower, ao_overlays_mimic, ao_neighbors_mimic, Z_AO_ALPHA, target_plane)
		if (ao_overlays_mimic)
			if (!shadower)
				shadower = new(src)
				shadower.source_z = z - 1
				SSzcopy.openspace_multipliers += 1
			shadower.add_overlay(ao_overlays_mimic, TRUE, now = TRUE)

	if (AO_SELF_CHECK(src) && !(z_flags & ZM_MIMIC_NO_AO))
		GENERATE_AO(src, ao_overlays, ao_neighbors, WALL_AO_ALPHA, DEFAULT_PLANE)
		if (ao_overlays)
			add_overlay(ao_overlays, TRUE, now = TRUE)

/// Render AO into a given lazylist for ZM using a specified atom as the reference for pixel_(x|y).
/turf/proc/zm_render_foreign_ao_to(atom/reference, list/target, target_plane_self, target_plane_zm_ao)
	var/list/cache = SSao.cache
	if (AO_SELF_CHECK(src) && !(z_flags & ZM_MIMIC_NO_AO))
		GENERATE_AO(reference, target, ao_neighbors, WALL_SECONDARY_AO_ALPHA, target_plane_self)
	if (AO_Z_SELF_CHECK(src))
		GENERATE_AO(reference, target, ao_neighbors_mimic, Z_AO_SECONDARY_ALPHA, target_plane_zm_ao)
	. = target

#undef GENERATE_AO
#undef PROCESS_AO_CORNER
