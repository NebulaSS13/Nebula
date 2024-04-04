#define LEVELS_ARE_Z_CONNECTED(ZA, ZB) ((ZA > 0 && ZB > 0 && ZA <= world.maxz && ZB <= world.maxz) && ((ZA == ZB) || ((length(SSmapping.connected_z_cache) >= ZA && SSmapping.connected_z_cache[ZA] && length(SSmapping.connected_z_cache[ZA]) >= ZB) ? SSmapping.connected_z_cache[ZA][ZB] : SSmapping.are_connected_levels(ZA, ZB))))

// Maploader bounds indices
#define MAP_MINX 1
#define MAP_MINY 2
#define MAP_MINZ 3
#define MAP_MAXX 4
#define MAP_MAXY 5
#define MAP_MAXZ 6

// This utilizes an explicitly given type X instead of using src's type
//  in order for subtypes of src's type to detect each other
#define DELETE_IF_DUPLICATE_OF(X) \
var/other_init = FALSE; \
for(var/existing in get_turf(src)) { \
	if(existing == src) { \
		continue; \
	} \
	if(!istype(existing, X)) { \
		continue; \
	} \
	var/atom/A = existing; \
	if(A.atom_flags & ATOM_FLAG_INITIALIZED) {\
		other_init = TRUE; \
		break; \
	} \
} \
if(other_init) { \
	PRINT_STACK_TRACE("Deleting duplicate of [log_info_line(src)]"); \
	return INITIALIZE_HINT_QDEL; \
}

#define ADJUST_TAG_VAR(variable, map_hash) (istext(variable) && (variable += map_hash))

/// Map template categories for mass retrieval.
#define MAP_TEMPLATE_CATEGORY_EXOPLANET       "exoplanet_template"
#define MAP_TEMPLATE_CATEGORY_EXOPLANET_SITE  "exoplanet_site_template"
#define MAP_TEMPLATE_CATEGORY_PLANET          "planet_template"
#define MAP_TEMPLATE_CATEGORY_PLANET_SITE     "planet_site_template"
#define MAP_TEMPLATE_CATEGORY_SPACE           "space_template"
#define MAP_TEMPLATE_CATEGORY_AWAYSITE        "awaysite_template"
#define MAP_TEMPLATE_CATEGORY_LANDMARK_LOADED "landmark_template"

/// Used to filter out some crafting recipes.
#define MAP_TECH_LEVEL_ANY       0
#define MAP_TECH_LEVEL_MEDIEVAL 50
#define MAP_TECH_LEVEL_SPACE   100
