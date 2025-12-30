/obj/screen/scan_radius
	name = null
	plane = HUD_PLANE
	layer = UNDER_HUD_LAYER
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	screen_loc = "CENTER,CENTER"
	icon = 'icons/screen/scanner.dmi'
	icon_state = "blank"
	alpha = 180
	requires_owner = FALSE
	requires_ui_style = FALSE
	var/scan_range
	var/image/holder_image

/obj/screen/scan_radius/proc/set_radius(var/new_range)
	if(new_range != scan_range)
		scan_range = max(1, new_range)
		update_icon()

/obj/screen/scan_radius/proc/fade_out(var/mob/user, var/fade_time)
	set waitfor = FALSE
	animate(src, alpha = 0, time = fade_time)
	if(fade_time > 0)
		sleep(fade_time)
	if(user?.client && holder_image)
		user.client.images -= holder_image

/obj/screen/scan_radius/Destroy()
	if(holder_image)
		holder_image.vis_contents.Cut()
		QDEL_NULL(holder_image)
	return ..()

/obj/screen/scan_radius/rebuild_screen_overlays()
	..()
	if(scan_range <= 1)
		add_overlay("single")
	else
		var/pixel_bound = (world.icon_size * scan_range)

		var/image/I = image(icon, "bottomleft")
		I.pixel_x = -(pixel_bound)
		I.pixel_y = -(pixel_bound)
		add_overlay(I)

		I = image(icon, "bottomright")
		I.pixel_x = pixel_bound
		I.pixel_y = -(pixel_bound)
		add_overlay(I)

		I = image(icon, "topleft")
		I.pixel_x = -(pixel_bound)
		I.pixel_y = pixel_bound
		add_overlay(I)

		I = image(icon, "topright")
		I.pixel_x = pixel_bound
		I.pixel_y = pixel_bound
		add_overlay(I)

		var/offset_scan_range = scan_range-1
		for(var/i = -(offset_scan_range) to offset_scan_range)
			I = image(icon, "left")
			I.pixel_x = -(pixel_bound)
			I.pixel_y = world.icon_size * i
			add_overlay(I)

			I = image(icon, "right")
			I.pixel_x = pixel_bound
			I.pixel_y = world.icon_size * i
			add_overlay(I)

			I = image(icon, "bottom")
			I.pixel_x = world.icon_size * i
			I.pixel_y = -(pixel_bound)
			add_overlay(I)

			I = image(icon, "top")
			I.pixel_x = world.icon_size * i
			I.pixel_y = pixel_bound
			add_overlay(I)
