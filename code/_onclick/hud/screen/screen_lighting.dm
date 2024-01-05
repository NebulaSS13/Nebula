/obj/screen/lighting_plane_master
	screen_loc       = "CENTER"
	appearance_flags = PLANE_MASTER
	mouse_opacity    = MOUSE_OPACITY_UNCLICKABLE
	plane            = LIGHTING_PLANE
	blend_mode       = BLEND_MULTIPLY
	alpha            = 255

/obj/screen/lighting_plane_master/proc/set_alpha(var/newalpha)
	if(alpha != newalpha)
		animate(src, alpha = newalpha, time = SSmobs.wait)
