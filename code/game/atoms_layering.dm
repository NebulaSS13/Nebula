/atom
	plane = DEFAULT_PLANE

/atom/proc/hud_layerise()
	plane = HUD_PLANE
	layer = HUD_ITEM_LAYER

/atom/proc/reset_plane_and_layer()
	reset_plane()
	reset_layer()

/atom/proc/reset_plane()
	plane = initial(plane)

/atom/proc/reset_layer()
	layer = initial(layer)

/atom/proc/reset_offsets(var/anim_time = 2)
	pixel_w = default_pixel_w
	pixel_x = default_pixel_x
	pixel_y = default_pixel_y
	pixel_z = default_pixel_z
