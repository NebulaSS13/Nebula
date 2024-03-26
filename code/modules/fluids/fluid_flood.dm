// Permaflood overlay.
var/global/list/flood_type_overlay_cache = list()
/proc/get_flood_overlay(fluid_type)
	if(!ispath(fluid_type, /decl/material))
		return null
	if(!global.flood_type_overlay_cache[fluid_type])
		var/decl/material/fluid_decl = GET_DECL(fluid_type)
		var/obj/effect/flood/new_flood = new
		new_flood.color = fluid_decl.color
		new_flood.alpha = round(fluid_decl.min_fluid_opacity + ((fluid_decl.max_fluid_opacity - fluid_decl.min_fluid_opacity) * 0.5))
		global.flood_type_overlay_cache[fluid_type] = new_flood
		return new_flood
	return global.flood_type_overlay_cache[fluid_type]

/obj/effect/flood
	name              = ""
	icon              = 'icons/effects/liquids.dmi'
	icon_state        = "ocean"
	layer             = DEEP_FLUID_LAYER
	color             = COLOR_LIQUID_WATER
	alpha             = 140
	invisibility      = 0
	simulated         = FALSE
	density           = FALSE
	anchored          = TRUE
	mouse_opacity     = MOUSE_OPACITY_UNCLICKABLE
	is_spawnable_type = FALSE
