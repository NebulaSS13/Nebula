/obj/screen/fullscreen
	icon = 'icons/mob/screen/full.dmi'
	icon_state = "default"
	screen_loc = ui_center_fullscreen
	plane = FULLSCREEN_PLANE
	layer = FULLSCREEN_LAYER
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	requires_ui_style = FALSE
	var/severity = 0
	var/allstate = 0 //shows if it should show up for dead people too

/obj/screen/fullscreen/Destroy()
	severity = 0
	return ..()

/obj/screen/fullscreen/brute
	icon_state = "brutedamageoverlay"
	layer = DAMAGE_LAYER

/obj/screen/fullscreen/oxy
	icon_state = "oxydamageoverlay"
	layer = DAMAGE_LAYER

/obj/screen/fullscreen/crit
	icon_state = "passage"
	layer = CRIT_LAYER

/obj/screen/fullscreen/blind
	icon_state = "blackimageoverlay"
	layer = BLIND_LAYER

/obj/screen/fullscreen/blackout
	icon = 'icons/mob/screen/effects.dmi'
	icon_state = "black"
	screen_loc = ui_entire_screen
	layer = BLIND_LAYER

/obj/screen/fullscreen/impaired
	icon_state = "impairedoverlay"
	layer = IMPAIRED_LAYER

/obj/screen/fullscreen/blurry
	icon = 'icons/mob/screen/effects.dmi'
	screen_loc = ui_entire_screen
	icon_state = "blurry"
	alpha = 100

/obj/screen/fullscreen/flash
	icon = 'icons/mob/screen/effects.dmi'
	screen_loc = ui_entire_screen
	icon_state = "flash"

/obj/screen/fullscreen/flash/noise
	icon_state = "noise"

/obj/screen/fullscreen/high
	icon = 'icons/mob/screen/effects.dmi'
	screen_loc = ui_entire_screen
	icon_state = "druggy"
	alpha = 180
	blend_mode = BLEND_MULTIPLY

/obj/screen/fullscreen/noise
	icon = 'icons/effects/static.dmi'
	icon_state = "1 light"
	screen_loc = ui_entire_screen
	alpha = 127

/obj/screen/fullscreen/fadeout
	icon = 'icons/mob/screen/effects.dmi'
	icon_state = "black"
	screen_loc = ui_entire_screen
	alpha = 0
	allstate = 1

/obj/screen/fullscreen/fadeout/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha)
	. = ..()
	animate(src, alpha = 255, time = 10)

/obj/screen/fullscreen/scanline
	icon = 'icons/effects/static.dmi'
	icon_state = "scanlines"
	screen_loc = ui_entire_screen
	alpha = 50

/obj/screen/fullscreen/fishbed
	icon_state = "fishbed"
	allstate = 1

/obj/screen/fullscreen/pain
	icon_state = "brutedamageoverlay6"
	alpha = 0

/obj/screen/fullscreen/blueprints
	icon = 'icons/effects/blueprints.dmi'
	icon_state = "base"
	screen_loc = ui_entire_screen
	alpha = 100

/obj/screen/fullscreen/jump_overlay
	icon = 'icons/effects/effects.dmi'
	icon_state = "mfoam"
	screen_loc = ui_entire_screen
	color = "#ff9900"
	blend_mode = BLEND_SUBTRACT

/obj/screen/fullscreen/wormhole_overlay
	icon = 'icons/effects/effects.dmi'
	icon_state = "mfoam"
	screen_loc = ui_entire_screen
	color = "#ff9900"
	alpha = 100
	blend_mode = BLEND_SUBTRACT
