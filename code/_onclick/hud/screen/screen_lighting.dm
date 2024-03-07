/obj/screen/lighting_plane_master
	screen_loc        = "CENTER"
	appearance_flags  = PLANE_MASTER
	mouse_opacity     = MOUSE_OPACITY_UNCLICKABLE
	plane             = LIGHTING_PLANE
	blend_mode        = BLEND_MULTIPLY
	alpha             = 255
	requires_ui_style = FALSE

/obj/screen/lighting_plane_master/set_alpha(var/new_alpha)
	if(alpha != new_alpha)
		animate(src, alpha = new_alpha, time = SSmobs.wait)