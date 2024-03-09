/obj/screen/global_hud
	screen_loc = ui_entire_screen
	icon = 'icons/effects/hud_full.dmi'
	plane = FULLSCREEN_PLANE
	layer = FULLSCREEN_LAYER
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	alpha = 125
	blend_mode = BLEND_MULTIPLY
	requires_owner = FALSE
	requires_ui_style = FALSE
	is_global_screen = TRUE
	user_incapacitation_flags = null

/obj/screen/global_holomap
	name = "holomap"
	icon = null
	plane = HUD_PLANE
	layer = HUD_BASE_LAYER
	screen_loc = UI_HOLOMAP
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	requires_owner = FALSE
	requires_ui_style = FALSE
	is_global_screen = TRUE
