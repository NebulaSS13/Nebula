#define SKYBOX_MAX_BOUND 736

/obj/skybox
	name = "skybox"
	mouse_opacity = 0
	anchored = TRUE
	simulated = FALSE
	plane = SKYBOX_PLANE
	blend_mode = BLEND_MULTIPLY
	var/base_x_dim = 7
	var/base_y_dim = 7
	var/base_offset_x = -224 // -(world.view x dimension * world.icon_size)
	var/base_offset_y = -224 // -(world.view y dimension * world.icon_size)

/obj/skybox/Initialize()
	screen_loc = "CENTER:[base_offset_x],CENTER:[base_offset_y]"
	. = ..()

/client
	var/obj/skybox/skybox

/client/proc/set_skybox_offsets(var/x_dim, var/y_dim)
	if(!skybox)
		update_skybox()
	if(skybox)
		skybox.base_x_dim = x_dim
		skybox.base_y_dim = y_dim
		skybox.base_offset_x = -((world.icon_size * skybox.base_x_dim)/2)
		skybox.base_offset_y = -((world.icon_size * skybox.base_y_dim)/2)
		
		// Check if the skybox needs to be scaled to fit large displays.
		var/new_max_tile_bound = max(skybox.base_x_dim, skybox.base_y_dim)
		var/old_max_tile_bound = SKYBOX_MAX_BOUND/world.icon_size
		if(new_max_tile_bound > old_max_tile_bound)
			var/matrix/M = matrix()
			M.Scale(1 + (new_max_tile_bound/old_max_tile_bound))
			skybox.transform = M
		else
			skybox.transform = null
		update_skybox()

/client/proc/update_skybox(rebuild)
	if(!skybox)
		skybox = new()
		screen += skybox
		rebuild = 1
	var/turf/T = get_turf(eye)
	if(T)
		if(rebuild)
			skybox.overlays.Cut()
			skybox.overlays += SSskybox.get_skybox(T.z)
			screen |= skybox
		skybox.screen_loc = "CENTER:[skybox.base_offset_x - T.x],CENTER:[skybox.base_offset_y - T.y]"

/mob/Login()
	..()
	client.update_skybox(1)

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

#undef SKYBOX_MAX_BOUND