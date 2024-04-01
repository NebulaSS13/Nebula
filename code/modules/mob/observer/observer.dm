var/global/const/GHOST_IMAGE_NONE = 0
var/global/const/GHOST_IMAGE_DARKNESS = 1
var/global/const/GHOST_IMAGE_SIGHTLESS = 2
var/global/const/GHOST_IMAGE_ALL = ~GHOST_IMAGE_NONE

/mob/observer
	density = FALSE
	alpha = 127
	layer = OBSERVER_LAYER
	plane = OBSERVER_PLANE
	invisibility = INVISIBILITY_OBSERVER
	see_invisible = SEE_INVISIBLE_OBSERVER
	sight = SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_SELF
	simulated = FALSE
	stat = DEAD
	status_flags = GODMODE
	shift_to_open_context_menu = FALSE
	var/ghost_image_flag = GHOST_IMAGE_DARKNESS
	var/image/ghost_image = null //this mobs ghost image, for deleting and stuff

/mob/observer/Initialize()
	. = ..()
	glide_size = 0 // Set in Initialize() because the compiler doesn't like it set in the definition.
	ghost_image = image(src.icon,src)
	ghost_image.plane = plane
	ghost_image.layer = layer
	ghost_image.appearance = src
	ghost_image.appearance_flags = RESET_ALPHA
	if(ghost_image_flag & GHOST_IMAGE_DARKNESS)
		ghost_darkness_images |= ghost_image //so ghosts can see the eye when they disable darkness
	if(ghost_image_flag & GHOST_IMAGE_SIGHTLESS)
		ghost_sightless_images |= ghost_image //so ghosts can see the eye when they disable ghost sight
	SSghost_images.queue_global_image_update()

/mob/observer/Destroy()
	if (ghost_image)
		ghost_darkness_images -= ghost_image
		ghost_sightless_images -= ghost_image
		qdel(ghost_image)
		ghost_image = null
		SSghost_images.queue_global_image_update()
	. = ..()

/mob/observer/get_movement_delay(travel_dir)
	return 1

/mob/observer/check_airflow_movable()
	return FALSE

/mob/observer/CanPass()
	return TRUE

/mob/observer/physically_destroyed()
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/mob/observer/handle_existence_failure(dusted)
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/mob/observer/dust()	//observers can't be vaporised.
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/mob/observer/gib()		//observers can't be gibbed.
	SHOULD_CALL_PARENT(FALSE)
	return FALSE

/mob/observer/is_blind()	//Not blind either.
	return

/mob/observer/is_deaf() 	//Nor deaf.
	return

/mob/observer/set_stat()
	stat = DEAD // They are also always dead

/mob/observer/touch_map_edge(var/overmap_id = OVERMAP_ID_SPACE)
	if(isSealedLevel(z))
		return

	var/new_x = x
	var/new_y = y

	if(x <= TRANSITIONEDGE)
		new_x = TRANSITIONEDGE + 1
	else if (x >= (world.maxx - TRANSITIONEDGE + 1))
		new_x = world.maxx - TRANSITIONEDGE
	else if (y <= TRANSITIONEDGE)
		new_y = TRANSITIONEDGE + 1
	else if (y >= (world.maxy - TRANSITIONEDGE + 1))
		new_y = world.maxy - TRANSITIONEDGE

	var/turf/T = locate(new_x, new_y, z)
	if(T)
		forceMove(T)
		end_throw()
		to_chat(src, "<span class='notice'>You cannot move further in this direction.</span>")

/mob/observer/handle_reading_literacy(var/mob/user, var/text_content, var/skip_delays, var/digital = FALSE)
	. = text_content

/mob/observer/handle_writing_literacy(var/mob/user, var/text_content, var/skip_delays)
	. = text_content

/mob/observer/get_admin_job_string()
	return "Ghost"

/mob/observer/set_glide_size(var/delay)
	glide_size = 0

/mob/observer/get_speech_bubble_state_modifier()
	return "ghost"

/mob/observer/refresh_lighting_master()
	..()
	lighting_master.alpha = 255 // don't bother animating it
