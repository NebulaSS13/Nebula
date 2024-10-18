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
	update_marker_icon()
	marker.alpha = 0 // Marker fades in on detection.
	marker.appearance_flags |= RESET_TRANSFORM

	images += marker

	radar = image(loc = effect, icon = 'icons/obj/overmap.dmi', icon_state = "sensor_range")
	radar.color = source.color
	radar.tag = "radar"
	radar.add_filter("blur", 1, list(type = "blur", size = 1))
	radar.appearance_flags |= RESET_TRANSFORM | KEEP_APART
	radar.appearance_flags &= ~PIXEL_SCALE

/datum/overmap_contact/proc/update_marker_icon()

	marker.appearance = effect
	marker.appearance_flags |= RESET_TRANSFORM
	// Pixel offsets are included in appearance but since this marker's loc
	// is the effect, it's already offset and we don't want to double it.
	marker.pixel_x = 0
	marker.pixel_y = 0

	marker.transform = effect.transform
	marker.overlays.Cut()
	if(check_effect_shield())
		var/image/shield_image = image(icon = 'icons/obj/overmap.dmi', icon_state = "shield")
		shield_image.pixel_x = 8
		marker.overlays += shield_image

/datum/overmap_contact/proc/ping_radar(var/range = 0)

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
	if(!owner)
		return
	var/list/showing = owner.linked?.navigation_viewers || owner.viewers
	if(length(showing))
		for(var/weakref/W in showing)
			var/mob/M = W.resolve()
			if(istype(M) && M.client)
				M.client.images |= images

/datum/overmap_contact/proc/hide()
	if(!owner)
		return
	var/list/showing = owner.linked?.navigation_viewers || owner.viewers
	if(length(showing))
		for(var/weakref/W in showing)
			var/mob/M = W.resolve()
			if(istype(M) && M.client)
				M.client.images -= images

/datum/overmap_contact/proc/check_effect_shield()
	var/obj/effect/overmap/visitable/visitable_effect = effect
	if(!visitable_effect || !istype(visitable_effect))
		return FALSE
	for(var/thing in visitable_effect.get_linked_machines_of_type(/obj/machinery/shield_generator))
		var/obj/machinery/shield_generator/S = thing
		if(S.running == SHIELD_RUNNING)
			return TRUE
	return FALSE

/datum/overmap_contact/proc/ping()
	if(pinged)
		return
	pinged = TRUE
	show()
	animate(marker, alpha=255, 0.5 SECOND, 1, LINEAR_EASING)
	addtimer(CALLBACK(src, PROC_REF(unping)), 1 SECOND)

/datum/overmap_contact/proc/unping()
	animate(marker, alpha=75, 2 SECOND, 1, LINEAR_EASING)
	pinged = FALSE

/datum/overmap_contact/Destroy()
	if(owner)
		hide()
		if(effect)
			owner.contact_datums -= effect
		owner = null
	effect = null
	QDEL_NULL_LIST(images)
	. = ..()
