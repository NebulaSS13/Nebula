/client
	var/obj/screen/visibility/backdrop/vis_backdrop
	var/obj/screen/visibility/overlay/vis_overlay

/client/verb/refresh_vis_overlays()
	set name = "Refresh Vis Overlays"
	set category = "Debug"
	set src = usr
	screen |= list(vis_overlay, vis_backdrop)

/client/New()
	..()
	vis_overlay = new
	vis_overlay.render_target = "*visibility_[ckey]"
	vis_overlay.set_scale(3)
	vis_backdrop = new
	vis_backdrop.filters = filter(type="alpha", render_source="*visibility_[ckey]", flags=MASK_INVERSE)
	screen += list(vis_overlay, vis_backdrop)
	set_visibility_radius()

/mob/proc/set_visibility_radius(var/sight_radius, var/sight_quality)
	if(client)
		client.set_visibility_radius(sight_radius, sight_quality)

/mob/observer/Login()
	. = ..()
	client.screen -= list(client.vis_overlay, client.vis_backdrop)

/client/proc/set_visibility_radius(var/sight_radius = INFINITY, var/sight_quality = INFINITY)

	var/backdrop_alpha = 255
	var/spotlight_alpha = 255

	if(sight_quality == INFINITY)
		backdrop_alpha = 0
		spotlight_alpha = 255

	var/matrix/target_transform = matrix()
	target_transform.Scale(max(1, sight_radius))
	//animate(vis_overlay, alpha = spotlight_alpha, transform = target_transform, time = 5)
	animate(vis_backdrop, alpha = backdrop_alpha, time = 5)

/obj/screen/visibility
	plane = HUD_PLANE
	layer = UNDER_HUD_LAYER
	blend_mode = BLEND_OVERLAY
	appearance_flags = RESET_TRANSFORM | RESET_COLOR
	simulated = 0
	mouse_opacity = 0
	screen_loc = "CENTER,CENTER"

/obj/screen/visibility/backdrop
	alpha = 0
	color = "#000000"
	icon = 'icons/planes/over_dark.dmi'
	icon_state = "blank"

/obj/screen/visibility/backdrop/proc/set_underlay_scale(var/scale_x, var/scale_y)
	var/image/I = image(icon, "square")
	var/matrix/M = matrix()
	M.Scale(scale_x, scale_y)
	I.transform = M
	underlays = list(I)

/obj/screen/visibility/overlay
	icon = 'icons/planes/visibility_overlays.dmi'
	icon_state = "soft"
	layer = HUD_BACKDROP_LAYER
