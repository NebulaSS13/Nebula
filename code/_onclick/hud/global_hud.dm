/*
	The global hud:
	Uses the same visual objects for all players.
*/

GLOBAL_DATUM_INIT(global_hud, /datum/global_hud, new())

/datum/global_hud
	var/obj/screen/nvg
	var/obj/screen/thermal
	var/obj/screen/meson
	var/obj/screen/science

// makes custom colored overlay, can also generate scanline
/datum/global_hud/proc/setup_overlay(icon_state, color)
	var/obj/screen/screen = new /obj/screen()
	screen.screen_loc = ui_entire_screen
	screen.icon = 'icons/obj/hud_full.dmi'
	screen.icon_state = icon_state
	screen.plane = FULLSCREEN_PLANE
	screen.layer = FULLSCREEN_LAYER
	screen.mouse_opacity = 0
	screen.alpha = 125

	screen.blend_mode = BLEND_MULTIPLY
	screen.color = color

	return screen

/datum/global_hud/New()
	nvg = setup_overlay("scanline", "#06ff00")
	thermal = setup_overlay("scanline", "#ff0000")
	meson = setup_overlay("scanline", "#9fd800")
	science = setup_overlay("scanline", "#d600d6")
