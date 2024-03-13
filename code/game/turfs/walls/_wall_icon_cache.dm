#define CACHE_BASE_MARKER   1
#define CACHE_PAINT_MARKER  2
#define CACHE_STRIPE_MARKER 3
#define CACHE_EDGE_MARKER   4
#define CACHE_SHINE_MARKER  5

var/global/const/WALL_PAINT_STATE =  "paint"
var/global/const/WALL_STRIPE_STATE = "stripe"
var/global/const/WALL_OTHER_STATE =  "other"
var/global/const/WALL_SHINE_STATE =  "shine"

var/global/list/cached_wall_icons = list()
/proc/_get_wall_subicon(var/material_icon_base, var/connections, var/color, var/state, var/alpha, var/cache_marker)
	var/cache_key = jointext(list(cache_marker, material_icon_base, json_encode(connections), color), "-")
	if(!global.cached_wall_icons[cache_key])
		var/icon/subicon = icon('icons/turf/wall_texture.dmi', "blank")
		for(var/i = 1 to 4)
			var/check_state = "[state][length(connections) >= i ? connections[i] : null]"
			if(check_state_in_icon(check_state, material_icon_base))
				subicon.Blend(icon(material_icon_base, check_state, dir = BITFLAG(i-1)), ICON_OVERLAY)
		if(color && color != COLOR_WHITE)
			subicon.Blend(color, ICON_MULTIPLY)
		if(!isnull(alpha))
			subicon += rgb(null, null, null, alpha)
		global.cached_wall_icons[cache_key] = subicon
	return global.cached_wall_icons[cache_key]

/proc/get_combined_wall_icon(var/list/wall_connections, var/list/other_connections, var/material_icon_base, var/base_color, var/paint_color, var/stripe_color, var/edge_color, var/shine_value)

	var/cache_key = list(material_icon_base, json_encode(wall_connections), json_encode(other_connections))
	if(base_color)
		cache_key += CACHE_BASE_MARKER
		cache_key += base_color
	if(paint_color)
		cache_key += CACHE_PAINT_MARKER
		cache_key += paint_color
	if(stripe_color)
		cache_key += CACHE_STRIPE_MARKER
		cache_key += stripe_color
	if(edge_color)
		cache_key += CACHE_EDGE_MARKER
		cache_key += edge_color
	if(shine_value)
		cache_key += CACHE_SHINE_MARKER
		cache_key += shine_value
	cache_key = jointext(cache_key, "-")

	if(!global.cached_wall_icons[cache_key])
		var/icon/wall_icon =        icon(_get_wall_subicon(material_icon_base, wall_connections, base_color,                      cache_marker = CACHE_BASE_MARKER))
		if(paint_color)  wall_icon.Blend(_get_wall_subicon(material_icon_base, wall_connections, paint_color,  WALL_PAINT_STATE,  cache_marker = CACHE_PAINT_MARKER),                      ICON_OVERLAY)
		if(stripe_color) wall_icon.Blend(_get_wall_subicon(material_icon_base, wall_connections, stripe_color, WALL_STRIPE_STATE, cache_marker = CACHE_STRIPE_MARKER),                     ICON_OVERLAY)
		if(edge_color)   wall_icon.Blend(_get_wall_subicon(material_icon_base, other_connections, edge_color,  WALL_OTHER_STATE,  cache_marker = CACHE_EDGE_MARKER),                       ICON_OVERLAY)
		if(shine_value)  wall_icon.Blend(_get_wall_subicon(material_icon_base, other_connections, null,        WALL_SHINE_STATE,  cache_marker = CACHE_SHINE_MARKER, alpha = shine_value), ICON_OVERLAY)
		global.cached_wall_icons[cache_key] = wall_icon
	return global.cached_wall_icons[cache_key]

#undef CACHE_BASE_MARKER
#undef CACHE_PAINT_MARKER
#undef CACHE_STRIPE_MARKER
#undef CACHE_EDGE_MARKER
#undef CACHE_SHINE_MARKER