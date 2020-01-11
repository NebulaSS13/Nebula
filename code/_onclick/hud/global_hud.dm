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

/datum/global_hud/proc/setup_overlay(var/icon_state)
	var/obj/screen/screen = new /obj/screen()
	screen.screen_loc = "CENTER,CENTER"
	screen.icon = 'icons/obj/hud_full.dmi'
	screen.icon_state = icon_state
	screen.mouse_opacity = 0
	var/matrix/M = matrix()
	M.Scale(30) // Arbitrary value (30 tiles) to cover most possible resolutions. 
				// HUDs will need to be altered to be per-client to fix this more generally.
	screen.transform = M
	return screen

/datum/global_hud/New()
	nvg = setup_overlay("nvg_hud")
	thermal = setup_overlay("thermal_hud")
	meson = setup_overlay("meson_hud")
	science = setup_overlay("science_hud")