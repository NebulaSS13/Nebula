/*
How it works:
AI clicks on holopad in camera view. View centers on holopad.
AI clicks again on the holopad to display a hologram. Hologram stays as long as AI is looking at the pad and it (the hologram) is in range of the pad.
AI can use the directional keys to move the hologram around, provided the above conditions are met and the AI in question is the holopad's master.
Only one AI may project from a holopad at any given time.
AI may cancel the hologram at any time by clicking on the holopad once more.

Possible to do for anyone motivated enough:
	Give an AI variable for different hologram icons.
	Itegrate EMP effect to disable the unit.
*/

var/global/list/holopads = list()

/obj/machinery/holopad
	name               = "\improper holopad"
	desc               = "It's a floor-mounted device for projecting holographic images."
	icon               = 'icons/obj/machines/holopad.dmi'
	icon_state         = "holopad-B0"
	layer              = ABOVE_TILE_LAYER
	anchored           = TRUE
	idle_power_usage   = 5
	active_power_usage = 100

	/// per usage per hologram
	var/power_per_hologram = 500
	/// List of AIs that use the holopad
	var/list/mob/living/silicon/ai/masters = new()
	/// Timer to prevent request spam.
	var/last_request = 0
	/// Change to change how far the AI can move away from the holopad before deactivating.
	var/holo_range = 5
	var/incoming_connection = 0
	var/mob/living/caller_id
	var/obj/machinery/holopad/sourcepad
	var/obj/machinery/holopad/targetpad
	var/last_message
	/// Whether the holopad is short-range or long-range.
	var/holopadType = HOLOPAD_SHORT_RANGE
	var/base_icon = "holopad-B"
	var/allow_ai = TRUE
	var/static/list/reachable_overmaps = list(OVERMAP_ID_SPACE)
	var/static/list/used_holopad_ids = list()
	var/holopad_id
	var/const/HOLOPAD_MODE                = RANGE_BASED
	var/const/HOLOPAD_PASSIVE_POWER_USAGE = 1
	var/const/HOLOGRAM_POWER_USAGE        = 2
	var/const/RANGE_BASED                 = 4
	var/const/AREA_BASED                  = 6

/obj/machinery/holopad/Initialize()
	. = ..()

	global.holopads += src
	global.listening_objects += src
	// Null ID means we want to use our area name.
	if(isnull(holopad_id))
		var/area/A = get_area(src)
		var/holopad_index = 1
		var/holopad_base = A?.proper_name || "Unknown"
		holopad_id = "[holopad_base] #[holopad_index]"
		while(holopad_id in used_holopad_ids)
			holopad_index++
			holopad_id = "[holopad_base] #[holopad_index]"
	used_holopad_ids |= holopad_id

	// For overmap sites, always tag the sector name so we have a unique discriminator for long range calls.
	var/obj/effect/overmap/visitable/sector = global.overmap_sectors[z]
	if(sector)
		holopad_id = "[sector.name] - [holopad_id]"

	// Update our desc.
	desc = "It's a floor-mounted device for projecting holographic images. Its ID is '[holopad_id]'"

/obj/machinery/holopad/Destroy()
	global.listening_objects -= src
	global.holopads -= src
	for (var/mob/living/master in masters)
		clear_holo(master)
	return ..()

/obj/machinery/holopad/interface_interact(var/mob/living/human/user) //Carn: Hologram requests.
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	if(incoming_connection && caller_id)
		if(QDELETED(sourcepad)) // If the sourcepad was deleted, most likely.
			incoming_connection = 0
			clear_holo()
			return TRUE
		visible_message("The pad hums quietly as it establishes a connection.", source = src)
		if(caller_id.loc!=sourcepad.loc)
			visible_message("The pad flashes an error message. The caller has left their holopad.", source = src)
			return TRUE
		take_call(user)
		return TRUE
	else if(caller_id && !incoming_connection)
		audible_message("<b>\The [src]</b> announces, \"Severing connection to distant holopad.\"", source = src)
		end_call(user)
		return TRUE

	. = TRUE
	var/handle_type = "Holocomms"
	if(allow_ai)
		handle_type = alert(user,"Would you like to request an AI's presence or establish communications with another pad?", "Holopad","AI","Holocomms","Cancel")

	switch(handle_type)
		if("AI")
			if(last_request + 200 < world.time) //don't spam the AI with requests you jerk!
				last_request = world.time
				to_chat(user, "<span class='notice'>You request an AI's presence.</span>")
				for(var/mob/living/silicon/ai/AI in global.living_mob_list_)
					if(!AI.client)	continue
					if (holopadType != HOLOPAD_LONG_RANGE && !SSmapping.are_connected_levels(AI.z, src.z))
						continue
					to_chat(AI, "<span class='info'>Your presence is requested at <a href='byond://?src=\ref[AI];jumptoholopad=\ref[src]'>\the [holopad_id]</a>.</span>")
			else
				to_chat(user, "<span class='notice'>A request for AI presence was already sent recently.</span>")
		if("Holocomms")

			if(user.loc != src.loc)
				to_chat(user, "<span class='info'>Please step onto the holopad.</span>")
				return

			if(last_request + 200 < world.time) //don't spam other people with requests either, you jerk!

				last_request = world.time
				var/list/holopadlist = list()
				var/zlevels = SSmapping.get_connected_levels(z)
				var/list/zlevels_long = list()

				if(holopadType == HOLOPAD_LONG_RANGE && length(reachable_overmaps))
					for(var/zlevel, sector in global.overmap_sectors)
						var/obj/effect/overmap/visitable/O = sector
						if(!isnull(O) && (O.overmap_id in reachable_overmaps) && LAZYLEN(O.map_z))
							zlevels_long |= O.map_z

				for(var/obj/machinery/holopad/H in SSmachines.machinery)
					if (H.operable())
						if(H.z in zlevels)
							holopadlist["[H.holopad_id]"] = H	//Define a list and fill it with the area of every holopad in the world
						if (H.holopadType == HOLOPAD_LONG_RANGE && (H.z in zlevels_long))
							holopadlist["[H.holopad_id]"] = H

				holopadlist = sortTim(holopadlist, /proc/cmp_text_asc)
				var/temppad = input(user, "Which holopad would you like to contact?", "holopad list") as null|anything in holopadlist
				targetpad = holopadlist["[temppad]"]
				if(targetpad==src)
					to_chat(user, "<span class='info'>Using such sophisticated technology, just to talk to yourself seems a bit silly.</span>")
					return
				if(targetpad && targetpad.caller_id)
					to_chat(user, "<span class='info'>The pad flashes a busy sign. Maybe you should try again later.</span>")
					return
				if(targetpad)
					make_call(targetpad, user)
			else
				to_chat(user, "<span class='notice'>A request for holographic communication was already sent recently.</span>")


/obj/machinery/holopad/proc/make_call(var/obj/machinery/holopad/targetpad, var/mob/living/user)
	targetpad.last_request = world.time
	targetpad.sourcepad = src //This marks the holopad you are making the call from
	targetpad.caller_id = user //This marks you as the caller
	targetpad.incoming_connection = 1
	playsound(targetpad.loc, 'sound/machines/chime.ogg', 25, 5)
	targetpad.icon_state = "[targetpad.base_icon]1"
	targetpad.audible_message("<b>\The [src]</b> announces, \"Incoming communications request from [holopad_id].\"", source = src)
	to_chat(user, SPAN_NOTICE("Trying to establish a connection to the holopad in [targetpad.holopad_id]... Please await confirmation from recipient."))

/obj/machinery/holopad/proc/take_call(mob/living/user)
	incoming_connection = 0
	caller_id.machine = sourcepad
	caller_id.reset_view(src)
	if(!masters[caller_id])//If there is no hologram, possibly make one.
		activate_holocall(caller_id)
	log_admin("[key_name(caller_id)] just established a holopad connection from [sourcepad.holopad_id] to [holopad_id]")

/obj/machinery/holopad/proc/end_call(mob/user)
	if(!caller_id)
		return
	caller_id.unset_machine()
	caller_id.reset_view() //Send the caller back to his body
	clear_holo(0, caller_id) // destroy the hologram
	caller_id = null

/obj/machinery/holopad/check_eye(mob/user)
	return 0

/obj/machinery/holopad/attack_ai(mob/living/silicon/ai/user)
	if(!istype(user))
		return
	/*There are pretty much only three ways to interact here.
	I don't need to check for client since they're clicking on an object.
	This may change in the future but for now will suffice.*/
	if(user.eyeobj && (user.eyeobj.loc != src.loc))//Set client eye on the object if it's not already.
		user.eyeobj.setLoc(get_turf(src))
	else if (!allow_ai)
		to_chat(user, SPAN_WARNING("Access denied."))
	else if (holopadType != HOLOPAD_LONG_RANGE && !SSmapping.are_connected_levels(user.z, src.z))
		to_chat(user, SPAN_WARNING("Out of range."))
	else if(!masters[user])//If there is no hologram, possibly make one.
		activate_holo(user)
	else//If there is a hologram, remove it.
		clear_holo(user)
	return

/obj/machinery/holopad/proc/activate_holo(mob/living/silicon/ai/user)
	if(!(stat & NOPOWER) && user.eyeobj && user.eyeobj.loc == src.loc)//If the projector has power and client eye is on it
		if (user.holo)
			to_chat(user, "<span class='danger'>ERROR:</span> Image feed in progress.")
			return
		audible_message("<b>\The [src]</b> announces, \"A holographic image of [user] flickers to life right before your eyes!\"", source = src)
		create_holo(user)//Create one.
	else
		to_chat(user, "<span class='danger'>ERROR:</span> Unable to project hologram.")
	return

/obj/machinery/holopad/proc/activate_holocall(mob/living/caller_id)
	if(caller_id)
		visible_message("A holographic image of [caller_id] flickers to life right before your eyes!", source = src)
		create_holo(0, caller_id)//Create one.
	else
		to_chat(caller_id, "<span class='danger'>ERROR:</span> Unable to project hologram.")
	return

/obj/machinery/holopad/proc/create_holo(mob/living/silicon/ai/A, mob/living/caller_id, turf/T = loc)
	var/obj/effect/overlay/hologram = new(T)//Spawn a blank effect at the location.
	if(caller_id)
		hologram.overlays += getHologramIcon(getFlatIcon(caller_id), hologram_color = holopadType) // Add the callers image as an overlay to keep coloration!
	else if(A)
		if(holopadType == HOLOPAD_LONG_RANGE)
			hologram.overlays += A.holo_icon_longrange
		else
			hologram.overlays += A.holo_icon // Add the AI's configured holo Icon
	if(A)
		if(A.holo_icon_malf == TRUE)
			hologram.overlays += icon("icons/effects/effects.dmi", "malf-scanline")
	hologram.mouse_opacity = MOUSE_OPACITY_UNCLICKABLE//So you can't click on it.
	hologram.layer = ABOVE_HUMAN_LAYER //Above all the other objects/mobs. Or the vast majority of them.
	hologram.anchored = TRUE//So space wind cannot drag it.
	if(caller_id)
		hologram.SetName("[caller_id.name] (Hologram)")
		hologram.forceMove(get_step(src,1))
		masters[caller_id] = hologram
	else
		hologram.SetName("[A.name] (Hologram)") //If someone decides to right click.
		A.holo = src
		masters[A] = hologram
	hologram.set_light(2, 0.1) //hologram lighting
	hologram.color = color //painted holopad gives coloured holograms
	set_light(2, 0.1) //pad lighting
	icon_state = "[base_icon]1"
	return 1

/obj/machinery/holopad/proc/clear_holo(mob/living/silicon/ai/user, mob/living/caller_id)
	if(user)
		qdel(masters[user])//Get rid of user's hologram
		user.holo = null
		masters -= user //Discard AI from the list of those who use holopad
	if(caller_id)
		qdel(masters[caller_id])//Get rid of user's hologram
		masters -= caller_id //Discard the caller from the list of those who use holopad
	if (!masters.len)//If no users left
		set_light(0)			//pad lighting (hologram lighting will be handled automatically since its owner was deleted)
		icon_state = "[base_icon]0"
		if(sourcepad)
			sourcepad.targetpad = null
			sourcepad = null
			caller_id = null
	return TRUE

/obj/machinery/holopad/Process()

	for(var/mob/living/silicon/ai/master in masters)
		var/active_ai = (master && !master.incapacitated() && master.client && master.eyeobj)//If there is an AI with an eye attached, it's not incapacitated, and it has a client
		if((stat & NOPOWER) || !active_ai)
			clear_holo(master)
			continue
		if(!(masters[master] in view(src)))
			clear_holo(master)
			continue
		use_power_oneoff(power_per_hologram)

	if(last_request + 200 < world.time&&incoming_connection==1)
		if(sourcepad)
			sourcepad.audible_message("<b>\The [src]</b> announces, \"The holopad connection timed out.\"", source = src)
		incoming_connection = 0
		end_call()

	if(caller_id&&sourcepad)
		if(caller_id.loc!=sourcepad.loc)
			to_chat(sourcepad.caller_id, "Severing connection to distant holopad.")
			end_call()
			audible_message("<b>\The [src]</b> announces, \"The connection has been terminated by the caller.\"", source = src)

/obj/machinery/holopad/proc/move_hologram(mob/living/silicon/ai/user)
	if(masters[user])
		step_to(masters[user], user.eyeobj) // So it turns.
		var/obj/effect/overlay/H = masters[user]
		H.dropInto(user.eyeobj)
		masters[user] = H

		if(!(H in view(src)))
			clear_holo(user)
			return 0

		if((HOLOPAD_MODE == RANGE_BASED && (get_dist(user.eyeobj, src) > holo_range)))
			clear_holo(user)

		if(HOLOPAD_MODE == AREA_BASED)
			var/area/holo_area = get_area(src)
			var/area/hologram_area = get_area(H)
			if(hologram_area != holo_area)
				clear_holo(user)
	return TRUE


/obj/machinery/holopad/proc/set_dir_hologram(new_dir, mob/living/silicon/ai/user)
	if(masters[user])
		var/obj/effect/overlay/hologram = masters[user]
		hologram.set_dir(new_dir)

/obj/machinery/holopad/longrange
	name = "long range holopad"
	desc = "It's a floor-mounted device for projecting holographic images. This one utilizes micro-width wormholes to communicate with far away locations."
	icon_state = "holopad-Y0"
	power_per_hologram = 1000 //per usage per hologram
	holopadType = HOLOPAD_LONG_RANGE
	base_icon = "holopad-Y"

// Used for overmap capable ships that should have communications, but not be AI accessible
/obj/machinery/holopad/longrange/remoteship
	allow_ai = FALSE
