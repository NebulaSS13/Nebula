/obj/effect/portal_visuals
	appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
	mouse_opacity = 0
	vis_flags = VIS_INHERIT_ID
	layer = BELOW_OBJ_LAYER
	no_z_overlay = TRUE
	
	var/alpha_icon = 'icons/obj/machines/teleporter.dmi'
	var/alpha_icon_state = "portal_visuals"

	var/atom/our_destination

	var/portal_alpha_x = 0
	var/portal_alpha_y = 0

	var/portal_ripple_x = 0
	var/portal_ripple_y = 0

/obj/effect/portal_visuals/proc/setup_visuals(atom/A)
	our_destination = A
	update_portal_filters()

/obj/effect/portal_visuals/proc/reset_visuals()
	our_destination = null
	update_portal_filters()

/obj/effect/portal_visuals/proc/update_portal_filters()
	filters = null
	vis_contents.Cut()

	if(!our_destination)
		return

	filters += filter("type" = "alpha", "icon" = icon(alpha_icon, alpha_icon_state), "x" = portal_alpha_x, "y" = portal_alpha_y)
	filters += filter("type" = "blur", "size" = 0.5)
	filters += filter("type" = "ripple", "size" = 2, "radius" = 1, "falloff" = 1, "x" = portal_ripple_x, "y" = portal_ripple_y)

	animate(filters[3], time = 1.3 SECONDS, loop = -1, easing = LINEAR_EASING, radius = 16)

	var/turf/center_turf = get_turf(our_destination)

	vis_contents += center_turf
