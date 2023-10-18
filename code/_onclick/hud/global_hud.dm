/*
	The global hud:
	Uses the same visual objects for all players.
*/

var/global/datum/global_hud/hud
/proc/get_global_hud()
	if(!global.hud)
		global.hud = new
	return global.hud

/datum/global_hud
	var/obj/screen/global_hud/nvg
	var/obj/screen/global_hud/thermal
	var/obj/screen/global_hud/meson
	var/obj/screen/global_hud/science
	var/obj/screen/global_holomap/holomap

// makes custom colored overlay, can also generate scanline
/datum/global_hud/proc/setup_overlay(icon_state, color)
	var/obj/screen/global_hud/screen = new(null)
	screen.icon_state = icon_state
	screen.color = color
	return screen

/datum/global_hud/New()
	nvg     = setup_overlay("scanline", "#06ff00")
	thermal = setup_overlay("scanline", "#ff0000")
	meson   = setup_overlay("scanline", "#9fd800")
	science = setup_overlay("scanline", "#d600d6")
	holomap = new(null)
