#define LANDING_VIEW 12

/mob/observer/eye/landing
	name = "Landing Eye"
	desc = "A visual projection used to assist in the landing of a shuttle."
	name_sufix = "Landing Eye"
	var/datum/shuttle/autodock/shuttle
	var/list/landing_images = list()

/mob/observer/eye/landing/Initialize(var/mapload, var/shuttle_tag)
	shuttle = SSshuttle.shuttles[shuttle_tag]
	// Generates the overlay of the shuttle on turfs.
	var/turf/origin = get_turf(src)
	for(var/area/A in shuttle.shuttle_area)
		for(var/turf/T in A)
			var/image/I = image('icons/effects/alphacolors.dmi', origin, "red")
			// Record the offset of the turfs from the eye. The eye is where the shuttle landmark will be placed, so the resultant images will reflect actual landing.
			var/x_off = T.x - origin.x
			var/y_off = T.y - origin.y

			I.loc = locate(origin.x + x_off, origin.y + y_off, origin.z)
			I.plane = OBSERVER_PLANE
			landing_images[I] = list(x_off, y_off)

	. = ..(mapload)

/mob/observer/eye/landing/Destroy()
	. = ..()
	shuttle = null
	landing_images.Cut()

/mob/observer/eye/landing/setLoc(var/turf/T)
	T = get_turf(T)
	if(T.x < TRANSITIONEDGE || T.x > world.maxx - TRANSITIONEDGE || T.y < TRANSITIONEDGE ||  T.y > world.maxy - TRANSITIONEDGE)
		return FALSE

	. = ..()

	check_landing()

//This is a subset of the actual checks in place for moving the shuttle.
/mob/observer/eye/landing/proc/check_landing()
	for(var/i = 1 to landing_images.len)
		var/image/img = landing_images[i]
		var/list/coords = landing_images[img]

		var/turf/origin = get_turf(src)
		var/turf/T = locate(origin.x + coords[1], origin.y + coords[2], origin.z)
		var/area/A = T?.loc
		img.loc = T

		img.icon_state = "green"
		. = TRUE

		if(!T || !T.loc || !origin || !origin.loc)
			img.icon_state = "red"
			. = FALSE
			continue
		if((T.x < TRANSITIONEDGE || T.x > world.maxx - TRANSITIONEDGE) || (T.y < TRANSITIONEDGE || T.y > world.maxy - TRANSITIONEDGE))
			img.icon_state = "red"
			. = FALSE // Cannot land past the normal world boundaries.
			continue
		if(!istype(T, origin))
			img.icon_state = "red"
			. = FALSE // Cannot land on two different types of turfs.
			continue
		if(check_collision(origin.loc, list(T))) // Checking for density or multi-area overlap.
			img.icon_state = "red"
			. = FALSE
			continue
		if(!istype(A, /area/space) && !istype(A, /area/exoplanet)) // Can only land in space or outside.
			img.icon_state = "red"
			. = FALSE
			continue

/mob/observer/eye/landing/possess(var/mob/user)
	..()
	if(owner && owner.client)
		owner.client.view = LANDING_VIEW
		owner.client.images += landing_images

/mob/observer/eye/landing/release(var/mob/user)
	if(owner && owner.client)
		owner.client.view = world.view
		// Removing images is inconsistent if the image is not rendered on the screen at the time of removal, so it's safer to reset the client's images altogether.
		owner.client.images.Cut()
	..()

// The eye can see turfs for landing, but is unable to see anything else.
/mob/observer/eye/landing/additional_sight_flags()
	return SEE_TURFS|BLIND

#undef LANDING_VIEW