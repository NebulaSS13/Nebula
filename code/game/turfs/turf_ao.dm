#ifdef AO_USE_LIGHTING_OPACITY
#define AO_TURF_CHECK(T) (!T.has_opaque_atom || !T.permit_ao)
#define AO_SELF_CHECK(T) (!T.has_opaque_atom)
#else
#define AO_TURF_CHECK(T) (!T.density || !T.opacity || !T.permit_ao)
#define AO_SELF_CHECK(T) (!T.density && !T.opacity)
#endif

/turf
	var/permit_ao = TRUE
	var/tmp/list/ao_overlays	// Current ambient occlusion overlays. Tracked so we can reverse them without dropping all priority overlays.
	var/tmp/ao_neighbors
	var/tmp/list/ao_overlays_mimic
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
	if (z_flags & ZM_MIMIC_BELOW)
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

/turf/proc/queue_ao(rebuild = TRUE)
	if (!ao_queued)
		SSao.queue += src

	var/new_level = rebuild ? AO_UPDATE_REBUILD : AO_UPDATE_OVERLAY
	if (ao_queued < new_level)
		ao_queued = new_level

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
		var/image/I = cache["[corner]|[CORNER_INDEX]|[pixel_x]/[pixel_y]/[pixel_z]/[pixel_w]|[ALPHA]|[PLANE]"]; \
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

#define REGEN_AO(TARGET, AO_LIST, NEIGHBORS, ALPHA, PLANE) \
	if (permit_ao && NEIGHBORS != AO_ALL_NEIGHBORS) { \
		var/corner;\
		PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, 1, NORTHWEST, ALPHA, TARGET, PLANE); \
		PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, 2, SOUTHEAST, ALPHA, TARGET, PLANE); \
		PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, 3, NORTHEAST, ALPHA, TARGET, PLANE); \
		PROCESS_AO_CORNER(AO_LIST, NEIGHBORS, 4, SOUTHWEST, ALPHA, TARGET, PLANE); \
	} \
	UNSETEMPTY(AO_LIST); \
	if (AO_LIST && TARGET) { \
		TARGET.add_overlay(AO_LIST, TRUE); \
	}

/turf/proc/update_ao()
	var/list/cache = SSao.cache
	CUT_AO(shadower, ao_overlays_mimic)
	CUT_AO(src, ao_overlays)
	if (z_flags & ZM_MIMIC_BELOW)
		var/computed_depth = SSzcopy.zlev_maximums[z] - z + 1
		var/target_plane = ZM_COMPUTE_PLANE(computed_depth, ZM_SLICE_SLOT_CAP)
		REGEN_AO(shadower, ao_overlays_mimic, ao_neighbors_mimic, Z_AO_ALPHA, target_plane)
	if (AO_SELF_CHECK(src) && !(z_flags & ZM_MIMIC_NO_AO))
		REGEN_AO(src, ao_overlays, ao_neighbors, WALL_AO_ALPHA, FLOAT_PLANE)

#undef REGEN_AO
#undef PROCESS_AO_CORNER
#undef AO_TURF_CHECK
#undef AO_SELF_CHECK
