#define SENSOR_TIME_DELAY 0.2 SECONDS
/datum/overmap_contact

	var/name  = "Unknown"	 // Contact name.
	var/image/marker		 // Image overlay attached to the contact.
	var/pinged = FALSE		 // Used to animate overmap effects.
	var/list/images = list() // Our list of images to cast to users.
	var/image/radar			 // Radar image for sonar esque effect

	// The sensor console holding this data.
	var/obj/machinery/computer/ship/sensors/owner

	// The actual overmap effect associated with this.
	var/obj/effect/overmap/effect

/datum/overmap_contact/New(var/obj/machinery/computer/ship/sensors/creator, var/obj/effect/overmap/source)
	// Update local tracking information.
	owner =  creator
	effect = source
	name =   effect.name
	owner.contact_datums[effect] = src

	marker = new(loc = effect)
	marker.appearance = effect
	marker.alpha = 0 // Marker fades in on detection.	

	images += marker
	
	radar = image(loc = effect, icon = 'icons/obj/overmap.dmi', icon_state = "sensor_range")
	radar.tag = "radar"
	radar.filters = filter(type="blur", size = 1)

/datum/overmap_contact/proc/update_marker_icon(var/range = 0)
	marker.icon_state = effect.icon_state
	marker.dir = effect.dir
	marker.overlays.Cut()

	if(check_effect_shield())
		var/image/shield_image = image(icon = 'icons/obj/overmap.dmi', icon_state = "shield")
		shield_image.pixel_x = 8
		marker.overlays += shield_image

	radar.transform = null
	radar.alpha = 255

	if(range > 1)
		images |= radar

		var/matrix/M = matrix()
		M.Scale(range*2.6)
		animate(radar, transform = M, alpha = 0, time = (SENSOR_TIME_DELAY*range), 1, SINE_EASING)
	else
		images -= radar

/datum/overmap_contact/proc/show()
	for(var/weakref/W in owner?.viewers)
		var/mob/M = W.resolve()
		if(istype(M))
			M.client?.images |= images

/datum/overmap_contact/proc/check_effect_shield()
	var/obj/effect/overmap/visitable/visitable_effect = effect
	if(!visitable_effect || !istype(visitable_effect))
		return FALSE
	for(var/thing in visitable_effect.get_linked_machines_of_type(/obj/machinery/power/shield_generator))
		var/obj/machinery/power/shield_generator/S = thing 
		if(S.running == SHIELD_RUNNING)
			return TRUE
	return FALSE

/datum/overmap_contact/proc/ping()
	if(pinged)
		return
	pinged = TRUE
	show()
	animate(marker, alpha=255, 0.5 SECOND, 1, LINEAR_EASING)
	addtimer(CALLBACK(src, .proc/unping), 1 SECOND)

/datum/overmap_contact/proc/unping()
	animate(marker, alpha=75, 2 SECOND, 1, LINEAR_EASING)
	pinged = FALSE

/datum/overmap_contact/Destroy()
	if(owner)
		for(var/weakref/W in owner?.viewers)
			var/mob/M = W.resolve()
			if(istype(M))
				M.client?.images -= images

		if(effect) owner.contact_datums -= effect
	owner = null
	effect = null
	QDEL_NULL_LIST(images)
	. = ..()