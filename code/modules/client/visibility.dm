
/client
	var/obj/screen/visibility/backdrop/vis_backdrop = new
	var/obj/screen/visibility/overlay/vis_overlay =   new

/mob/Login()
	. = ..()
	client.screen |= list(client.vis_backdrop, client.vis_overlay)

/client/New()
	..()
	vis_overlay.render_target =  "*vis_render_[ckey]"
	vis_backdrop.filters = filter(type="alpha", render_source="*vis_render_[ckey]", flags=MASK_INVERSE)
	set_visibility_radius()

/mob/proc/set_visibility_radius(var/sight_radius, var/sight_quality)
	if(client)
		client.set_visibility_radius(sight_radius, sight_quality)

/mob/observer/Login()
	. = ..()
	client.screen -= list(client.vis_overlay, client.vis_backdrop)

/client/proc/set_visibility_radius(var/sight_radius = INFINITY, var/sight_quality = INFINITY)

	vis_overlay.alpha = (sight_radius <= 0) ? 0 : 255
	if(sight_quality == INFINITY)
		sight_quality = 0
	else if(sight_quality <= 0)
		sight_quality = 255
		sight_radius = 0
	else
		sight_quality = Clamp(255 - round(sight_quality * 255), 0, 255)
	sight_radius = max(1, sight_radius)

	var/matrix/target_transform
	if(vis_backdrop.transform.a != sight_radius)
		target_transform = matrix()
		target_transform.Scale(sight_radius)
	if(target_transform)
		animate(vis_backdrop, transform = target_transform, time = 5)
	else if(vis_backdrop.alpha != sight_quality)
		animate(vis_backdrop, alpha = sight_quality, time = 5)

/obj/screen/visibility
	plane = BLINDNESS_PLANE
	screen_loc = "CENTER,CENTER"
	blend_mode = BLEND_OVERLAY
	appearance_flags = RESET_TRANSFORM | RESET_COLOR | KEEP_TOGETHER
	simulated = 0
	mouse_opacity = 0

/obj/screen/visibility/backdrop
	alpha = 0
	color = "#000000"
	layer = BLIND_LAYER
	var/scale_x
	var/scale_y

/obj/screen/visibility/backdrop/proc/set_backdrop_scale(var/s_x, var/s_y)
	if(s_x != scale_x || s_y != scale_y)
		scale_x = s_x
		scale_y = s_y
		update_icon()

/obj/screen/visibility/backdrop/Initialize()
	. = ..()
	set_backdrop_scale(1, 1)

/obj/screen/visibility/backdrop/on_update_icon()
	cut_overlays()
	var/image/I = image('icons/planes/over_dark.dmi', "")
	var/matrix/M = matrix()
	M.Scale(scale_x, scale_y)
	I.transform = M
	I.appearance_flags |= RESET_TRANSFORM
	add_overlay(I)

/obj/screen/visibility/overlay
	icon = 'icons/planes/visibility_overlays.dmi'
	icon_state = "soft"
	layer = VISIBILITY_LAYER
