#define LANDING_VIEW 25

/mob/observer/eye/landing
	name = "Landing Eye"
	desc = "A visual projection used to assist in the landing of a shuttle."
	name_sufix = "Landing Eye"
	var/datum/shuttle/autodock/shuttle
	var/obj/effect/overmap/visitable/target_sector
	var/list/landing_images = list()
	var/list/docking_images = list()
	var/list/docking_turfs = list()	// Turfs where it is okay to land, even if its within a restricted area.

/mob/observer/eye/landing/Initialize(var/mapload, var/shuttle_tag, var/obj/effect/overmap/visitable/sector)
	shuttle = SSshuttle.shuttles[shuttle_tag]
	target_sector = sector
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
	
	// Find the docking beacons in the z-level(s) we're landing in.
	var/list/docking_beacons = SSshuttle.docking_beacons_by_z(target_sector.map_z)
	for(var/obj/machinery/docking_beacon/beacon in docking_beacons)
		// If the beacon permits us, we'll generate the images for the area where we can land.
		if(beacon.check_permission(shuttle.name, shuttle.docking_codes))
			docking_turfs += beacon.get_area()
		
	for(var/turf/T in docking_turfs)
		var/image/I = image('icons/effects/alphacolors.dmi', T, "blue")

		I.plane = OBSERVER_PLANE
		docking_images += I
	
	. = ..(mapload)

/mob/observer/eye/landing/Destroy()
	. = ..()
	shuttle = null
	target_sector = null
	landing_images.Cut()
	docking_images.Cut()
	docking_turfs.Cut()

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

		var/ra = target_sector.restricted_area

		img.loc = T

		img.icon_state = "green"
		. = TRUE

		if(!T || !T.loc || !origin || !origin.loc)
			. = FALSE
		else if((T.x < TRANSITIONEDGE || T.x > world.maxx - TRANSITIONEDGE) || (T.y < TRANSITIONEDGE || T.y > world.maxy - TRANSITIONEDGE))
			. = FALSE // Cannot land past the normal world boundaries.
		else if(check_collision(origin.loc, list(T))) // Checking for density or multi-area overlap.
			. = FALSE
		else if((T.x > (world.maxx - ra)/2 && T.x < (world.maxx + ra)/2) && (T.y > (world.maxy - ra)/2 && T.y < (world.maxy + ra)/2))
			if(!(T in docking_turfs)) 
				. = FALSE // Cannot land within the restricted area *unless* there is a valid docking beacon in the same location.
		if(!.)
			img.icon_state = "red" // Visual indicator the spot is invalid.

// Checks if the landing location is secure, and therefore the shuttle will move with whatever sector its landed in.
/mob/observer/eye/landing/proc/check_secure_landing()
	return ((target_sector.sector_flags & (~OVERMAP_SECTOR_IN_SPACE)) || (get_turf(src) in docking_turfs)) 

/mob/observer/eye/landing/possess(var/mob/user)
	. = ..()
	if(owner && owner.client)
		owner.client.view = LANDING_VIEW
		owner.client.images += landing_images
		owner.client.images += docking_images

/mob/observer/eye/landing/release(var/mob/user)
	if(owner && owner.client && owner == user)
		owner.client.view = world.view
		// Removing images is inconsistent if the image is not rendered on the screen at the time of removal, so it's safer to reset the client's images altogether.
		owner.client.images.Cut()
	. = ..()

// The eye can see turfs for landing, but is unable to see anything else.
/mob/observer/eye/landing/additional_sight_flags()
	return SEE_TURFS|BLIND

#undef LANDING_VIEW
