var/global/const/SKYBOX_DIMENSION = 736 // Largest measurement for icon sides, used for offsets/scaling
/obj/skybox
	name = "skybox"
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	anchored = TRUE
	simulated = FALSE
	plane = SKYBOX_PLANE
	blend_mode = BLEND_MULTIPLY
	screen_loc = "CENTER,CENTER"
	transform_animate_time = 0
	var/static/max_view_dim
	var/static/const/parallax_bleed_percent = 0.2 // 20% parallax offset when going from x=1 to x=max

/obj/skybox/Initialize()
	if(!max_view_dim)
		max_view_dim = ceil(SKYBOX_DIMENSION / world.icon_size)
	. = ..()

/client
	var/obj/skybox/skybox

/client/proc/set_skybox_offsets(var/x_dim, var/y_dim)
	if(!skybox)
		update_skybox(TRUE)
		return
	var/scale_value = 1
	if(isnum(view))
		var/target_icon_size = (view * 2 + 1) * world.icon_size
		scale_value = skybox.parallax_bleed_percent + max((target_icon_size / SKYBOX_DIMENSION), 1)
		skybox.screen_loc = "CENTER:-[view * world.icon_size],CENTER:-[view * world.icon_size]"
	else
		var/target_icon_size = max(x_dim, y_dim) * world.icon_size
		scale_value = skybox.parallax_bleed_percent + max((target_icon_size / SKYBOX_DIMENSION), 1)
		skybox.screen_loc = "CENTER:-[round(SKYBOX_DIMENSION * scale_value / 2)],CENTER:-[round(SKYBOX_DIMENSION * scale_value / 2)]"
	skybox.set_scale(scale_value)
	update_skybox()

/client/proc/update_skybox(rebuild)

	var/turf/T = get_turf(eye)
	if(!T)
		return

	if(!skybox)
		skybox = new()
		screen += skybox
		rebuild = TRUE

	if(rebuild)
		skybox.overlays.Cut()
		var/image/I = SSskybox.get_skybox(T.z)
		skybox.overlays += I
		screen |= skybox
		set_skybox_offsets(last_view_x_dim, last_view_y_dim)
		return

	if(skybox.parallax_bleed_percent > 0)
		var/matrix/M = skybox.update_transform() || matrix()
		var/x_translate = -((T.x/world.maxx)-0.5) * skybox.parallax_bleed_percent * SKYBOX_DIMENSION
		var/y_translate = -((T.y/world.maxy)-0.5) * skybox.parallax_bleed_percent * SKYBOX_DIMENSION
		M.Translate(x_translate, y_translate)
		skybox.transform = M

/mob/Move()
	var/old_z = get_z(src)
	. = ..()
	if(. && client)
		client.update_skybox(old_z != get_z(src))

/mob/forceMove()
	var/old_z = get_z(src)
	. = ..()
	if(. && client)
		client.update_skybox(old_z != get_z(src))
