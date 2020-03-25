/obj/effect/overmap/radio
	name = "radio signal"
	icon_state = "radio"
	scannable = TRUE
	color = COLOR_AMBER
	var/message
	var/obj/effect/overmap/source

/obj/effect/overmap/radio/get_scan_data(mob/user)
	return "A radio signal originating at \the [source].<br><br> \
	---BEGINNING OF TRANSMISSION---<br><br> \
	[message] \
	<br><br>---END OF TRANSMISSION---"

/obj/effect/overmap/radio/proc/set_origin(obj/effect/overmap/origin)
	GLOB.moved_event.register(origin, src, /obj/effect/overmap/radio/proc/follow)
	GLOB.destroyed_event.register(origin, src, /datum/proc/qdel_self)
	forceMove(origin.loc)
	source = origin
	pixel_x = -(origin.bound_width - 6)
	pixel_y = origin.bound_height - 6

/obj/effect/overmap/radio/proc/follow(var/atom/movable/am, var/old_loc, var/new_loc)
	forceMove(new_loc)

/obj/effect/overmap/radio/Destroy()
	GLOB.destroyed_event.unregister(source, src)
	GLOB.moved_event.unregister(source, src)
	source = null
	. = ..()

/obj/item/radio_beacon
	name = "radio beacon"
	desc = "Device capable of continuously broadcasting a signal that can be picked up by ship sensors."
	icon = 'icons/obj/radio.dmi'
	icon_state = "walkietalkie"
	var/obj/effect/overmap/radio/signal

/obj/item/radio_beacon/attack_self(mob/user)
	var/obj/effect/overmap/visitable/O = map_sectors["[get_z(src)]"]
	if(!O)
		to_chat(user, SPAN_WARNING("You cannot deploy [src] here."))
		return
	var/message = sanitize(input("What should it broadcast?") as message|null)
	
	if(!signal)
		signal = new()
	
	signal.message = message
	signal.set_origin(O)

	