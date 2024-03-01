// Inlining to try to shave some time off init.
#define TEST_LINK(T)                                                                                            \
if(T.is_wall()) { _can_link = (wall_smooth == SMOOTH_ALL)  }                                                    \
else if(T.is_open()) { _can_link = (space_smooth == SMOOTH_ALL) }                                               \
else if(floor_smooth == SMOOTH_ALL) { _can_link = TRUE }                                                        \
else if(wall_smooth == SMOOTH_ALL && locate(/obj/structure/wall_frame) in T.contents) { _can_link = TRUE }      \
else {                                                                                                          \
	var/decl/flooring/t_flooring = T.get_flooring();                                                            \
	if(!t_flooring) {                                                                                           \
		_can_link = FALSE;                                                                                      \
	} else if(type == t_flooring?.type || t_flooring?.icon_edge_layer > icon_edge_layer) {                      \
		_can_link = TRUE;                                                                                       \
	} else if (floor_smooth == SMOOTH_WHITELIST) {                                                              \
		_can_link = FALSE;                                                                                      \
		for (var/v in flooring_whitelist) {                                                                     \
			if (istype(t_flooring, v)) {                                                                        \
				_can_link = TRUE;                                                                               \
				break;                                                                                          \
			}                                                                                                   \
		}                                                                                                       \
	} else if(floor_smooth == SMOOTH_BLACKLIST) {                                                               \
		_can_link = TRUE;                                                                                       \
		for (var/v in flooring_blacklist) {                                                                     \
			if (istype(t_flooring, v)) {                                                                        \
				_can_link = FALSE;                                                                              \
				break;                                                                                          \
			}                                                                                                   \
		}                                                                                                       \
	}                                                                                                           \
};

#define SYMMETRIC_TEST_LINK(A, B)                                                                               \
_can_link = FALSE;                                                                                              \
if(istype(A) && istype(B))                                                                                      \
{                                                                                                               \
	TEST_LINK(A)                                                                                                \
	if(_can_link) { TEST_LINK(B) }                                                                              \
};

#define ADD_FLOORING_OVERLAY(ADDING, CACHE_KEY) ADDING += _flooring_cache[CACHE_KEY];

#define SET_FLOORING_OVERLAY_LAYER(IMAGE, LAYER)                                                                \
IMAGE.layer = TURF_LAYER;                                                                                       \
if(LAYER > 0) {                                                                                                 \
	IMAGE.layer += LAYER;                                                                                       \
};

#define ADD_EXT_FLOORING_OVERLAY(ADDING, ICON, CACHE_KEY, USE_ICON_BASE, ICON_DIR, LAYER)                       \
if(!_flooring_cache[CACHE_KEY]) {                                                                               \
	I = image(icon = ICON, icon_state = USE_ICON_BASE, dir = ICON_DIR);                                         \
	if (ICON_DIR & NORTH) {                                                                                     \
		I.pixel_y = world.icon_size;                                                                            \
	} else if (ICON_DIR & SOUTH) {                                                                              \
		I.pixel_y = -world.icon_size;                                                                           \
	} if (ICON_DIR & EAST) {                                                                                    \
		I.pixel_x = world.icon_size;                                                                            \
	} else if (ICON_DIR & WEST) {                                                                               \
		I.pixel_x = -world.icon_size;                                                                           \
	};                                                                                                          \
	SET_FLOORING_OVERLAY_LAYER(I, LAYER);                                                                       \
	_flooring_cache[CACHE_KEY] = I;                                                                             \
};                                                                                                              \
ADD_FLOORING_OVERLAY(ADDING, CACHE_KEY)

#define ADD_INT_FLOORING_OVERLAY(ADDING, ICON, CACHE_KEY, USE_ICON_BASE, ICON_DIR, LAYER)                       \
if(!_flooring_cache[CACHE_KEY]) {                                                                               \
	I = image(icon = ICON, icon_state = USE_ICON_BASE, dir = ICON_DIR);                                         \
	SET_FLOORING_OVERLAY_LAYER(I, LAYER);                                                                       \
	_flooring_cache[CACHE_KEY] = I;                                                                             \
};                                                                                                              \
ADD_FLOORING_OVERLAY(ADDING, CACHE_KEY)

#define TRY_ADD_INT_EDGE(DIR, SMOOTH_CARDINAL, LAYER, CACHE_KEY)                                                \
if(!(SMOOTH_CARDINAL & DIR)) {                                                                                  \
	ADD_INT_FLOORING_OVERLAY(., icon, CACHE_KEY, _inner_edges_state, DIR, LAYER)                                \
};

#define TRY_ADD_INT_CORNER(DIR_LEFT, DIR_RIGHT, CORNER_DIR, SMOOTH_CARDINAL, SMOOTH_DIAGONAL, LAYER, CCK, JCK)  \
smooth_left  = !!(SMOOTH_CARDINAL & DIR_LEFT);                                                                  \
smooth_right = !!(SMOOTH_CARDINAL & DIR_RIGHT);                                                                 \
if(smooth_left == smooth_right) {                                                                               \
	if(smooth_left) {                                                                                           \
	    if(!(CORNER_DIR in SMOOTH_DIAGONAL)) {                                                                  \
			ADD_INT_FLOORING_OVERLAY(., icon, JCK, _inner_junction_state, CORNER_DIR, LAYER)                    \
		}                                                                                                       \
	} else {                                                                                                    \
		ADD_INT_FLOORING_OVERLAY(., icon, CCK, _inner_corner_state, CORNER_DIR, LAYER)                          \
	}                                                                                                           \
};

#define TRY_ADD_EXT_EDGE(DIR, SMOOTH_CARDINAL, SMOOTH_DIAGONAL, LAYER, CACHE_KEY)                               \
if(!(SMOOTH_CARDINAL & DIR)) {                                                                                  \
	ADD_EXT_FLOORING_OVERLAY(., icon, CACHE_KEY, _outer_edges_state, DIR, LAYER)                                \
};

#define TRY_ADD_EXT_CORNER(DIR_LEFT, DIR_RIGHT, CORNER_DIR, SMOOTH_CARDINAL, SMOOTH_DIAGONAL, LAYER, CCK, JCK)  \
if(!(CORNER_DIR in SMOOTH_DIAGONAL)) {                                                                          \
	smooth_left  = !!(SMOOTH_CARDINAL & DIR_LEFT);                                                              \
	smooth_right = !!(SMOOTH_CARDINAL & DIR_RIGHT);                                                             \
	if(smooth_left == smooth_right) {                                                                           \
		if(smooth_left) {                                                                                       \
			ADD_EXT_FLOORING_OVERLAY(., icon, JCK, _outer_junction_state, CORNER_DIR, LAYER)                    \
		} else {                                                                                                \
			ADD_EXT_FLOORING_OVERLAY(., icon, CCK, _outer_corner_state, CORNER_DIR, LAYER)                      \
		}                                                                                                       \
	}                                                                                                           \
};

/decl/flooring

	VAR_PRIVATE/_has_outer_edges
	VAR_PRIVATE/_has_outer_corners
	VAR_PRIVATE/_has_inner_edges
	VAR_PRIVATE/_has_inner_corners
	VAR_PRIVATE/_has_edge_overlays
	VAR_PRIVATE/_inner_edges_state
	VAR_PRIVATE/_inner_corner_state
	VAR_PRIVATE/_inner_junction_state
	VAR_PRIVATE/_outer_edges_state
	VAR_PRIVATE/_outer_corner_state
	VAR_PRIVATE/_outer_junction_state

	var/const/_inner_north_edge_cache         = 1
	var/const/_inner_east_edge_cache          = 2
	var/const/_inner_south_edge_cache         = 3
	var/const/_inner_west_edge_cache          = 4
	var/const/_outer_north_edge_cache         = 5
	var/const/_outer_east_edge_cache          = 6
	var/const/_outer_south_edge_cache         = 7
	var/const/_outer_west_edge_cache          = 8
	var/const/_inner_northeast_corner_cache   = 9
	var/const/_inner_northeast_junction_cache = 10
	var/const/_inner_northwest_corner_cache   = 11
	var/const/_inner_northwest_junction_cache = 12
	var/const/_inner_southeast_corner_cache   = 13
	var/const/_inner_southeast_junction_cache = 14
	var/const/_inner_southwest_corner_cache   = 15
	var/const/_inner_southwest_junction_cache = 16
	var/const/_outer_northeast_corner_cache   = 17
	var/const/_outer_northeast_junction_cache = 18
	var/const/_outer_northwest_corner_cache   = 19
	var/const/_outer_northwest_junction_cache = 20
	var/const/_outer_southeast_corner_cache   = 21
	var/const/_outer_southeast_junction_cache = 22
	var/const/_outer_southwest_corner_cache   = 23
	var/const/_outer_southwest_junction_cache = 24
	var/list/_flooring_cache[_outer_southwest_junction_cache]

/decl/flooring/proc/get_edge_overlays(var/turf/target)

	if(!_has_edge_overlays || !target)
		return

	// Predeclare vars for inlined logic macros.
	var/turf/neighbor
	var/smooth_left
	var/smooth_right
	var/smooth_cardinal = 0
	var/_can_link
	var/image/I
	var/static/all_dirs = (NORTH|SOUTH|EAST|WEST)

	// Collect directions we want to smooth in.
	for(var/step_dir in global.cardinal)
		neighbor = get_step(target, step_dir)
		SYMMETRIC_TEST_LINK(target, neighbor)
		if(_can_link)
			smooth_cardinal |= step_dir

	// If we're surrounded to NSEW we have no horizontal or vertical edges to draw.
	if(smooth_cardinal != all_dirs && _has_inner_edges)
		. = list()
		TRY_ADD_INT_EDGE(   NORTH, smooth_cardinal, icon_edge_layer, _inner_north_edge_cache)
		TRY_ADD_INT_EDGE(   EAST,  smooth_cardinal, icon_edge_layer, _inner_east_edge_cache)
		TRY_ADD_INT_EDGE(   SOUTH, smooth_cardinal, icon_edge_layer, _inner_south_edge_cache)
		TRY_ADD_INT_EDGE(   WEST,  smooth_cardinal, icon_edge_layer, _inner_west_edge_cache)

	var/list/smooth_diagonal = list()
	for(var/step_dir in global.cornerdirs)
		neighbor = get_step(target, step_dir)
		SYMMETRIC_TEST_LINK(target, neighbor)
		if(_can_link)
			smooth_diagonal |= step_dir

	// If we are entirely surrounded by neighbors, we have no capacity to do any smoothing.
	if(smooth_cardinal == all_dirs)
		var/missing_corner = FALSE
		for(var/checkdir in global.cornerdirs)
			if(!(checkdir in smooth_diagonal))
				missing_corner = TRUE
				break
		if(!missing_corner)
			return

	if(_has_outer_edges)
		LAZYINITLIST(.)
		TRY_ADD_EXT_EDGE(   NORTH, smooth_cardinal, smooth_diagonal, icon_edge_layer, _outer_north_edge_cache)
		TRY_ADD_EXT_EDGE(   EAST,  smooth_cardinal, smooth_diagonal, icon_edge_layer, _outer_east_edge_cache)
		TRY_ADD_EXT_EDGE(   SOUTH, smooth_cardinal, smooth_diagonal, icon_edge_layer, _outer_south_edge_cache)
		TRY_ADD_EXT_EDGE(   WEST,  smooth_cardinal, smooth_diagonal, icon_edge_layer, _outer_west_edge_cache)

	var/offset_layer = icon_edge_layer > 0 ? icon_edge_layer+0.001 : null // offset corners over the top of edges.
	if(_has_inner_corners)
		LAZYINITLIST(.)
		TRY_ADD_INT_CORNER( NORTH, EAST, NORTHEAST, smooth_cardinal, smooth_diagonal, offset_layer, _inner_northeast_corner_cache, _inner_northeast_junction_cache)
		TRY_ADD_INT_CORNER( NORTH, WEST, NORTHWEST, smooth_cardinal, smooth_diagonal, offset_layer, _inner_northwest_corner_cache, _inner_northwest_junction_cache)
		TRY_ADD_INT_CORNER( SOUTH, EAST, SOUTHEAST, smooth_cardinal, smooth_diagonal, offset_layer, _inner_southeast_corner_cache, _inner_southeast_junction_cache)
		TRY_ADD_INT_CORNER( SOUTH, WEST, SOUTHWEST, smooth_cardinal, smooth_diagonal, offset_layer, _inner_southwest_corner_cache, _inner_southwest_junction_cache)

	if(_has_outer_corners)
		LAZYINITLIST(.)
		TRY_ADD_EXT_CORNER( NORTH, EAST, NORTHEAST, smooth_cardinal, smooth_diagonal, offset_layer, _outer_northeast_corner_cache, _outer_northeast_junction_cache)
		TRY_ADD_EXT_CORNER( NORTH, WEST, NORTHWEST, smooth_cardinal, smooth_diagonal, offset_layer, _outer_northwest_corner_cache, _outer_northwest_junction_cache)
		TRY_ADD_EXT_CORNER( SOUTH, EAST, SOUTHEAST, smooth_cardinal, smooth_diagonal, offset_layer, _outer_southeast_corner_cache, _outer_southeast_junction_cache)
		TRY_ADD_EXT_CORNER( SOUTH, WEST, SOUTHWEST, smooth_cardinal, smooth_diagonal, offset_layer, _outer_southwest_corner_cache, _outer_southwest_junction_cache)

#undef ADD_FLOORING_OVERLAY
#undef ADD_INT_FLOORING_OVERLAY
#undef ADD_EXT_FLOORING_OVERLAY
#undef SET_FLOORING_OVERLAY_LAYER
#undef TRY_ADD_INT_CORNER
#undef TRY_ADD_INT_EDGE
#undef TRY_ADD_EXT_CORNER
#undef TRY_ADD_EXT_EDGE
