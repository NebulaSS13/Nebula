// TODO make this a network device.
/obj/item/camera/tvcamera
	name = "press camera drone"
	desc = "An EyeBuddy livestreaming press camera drone. Weapon of choice for war correspondents and reality show cameramen. It does not appear to have any internal memory storage."
	icon = 'icons/clothing/belt/camcorder.dmi'
	icon_state = ICON_STATE_WORLD
	item_state = null
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_LOWER_BODY
	material = /decl/material/solid/plastic
	matter = list(
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_REINFORCEMENT, 
		/decl/material/solid/silicon         = MATTER_AMOUNT_REINFORCEMENT, 
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/glass           = MATTER_AMOUNT_TRACE,
	)
	var/channel = "General News Feed"
	var/video_enabled = FALSE
	var/obj/item/radio/radio

/obj/item/camera/tvcamera/Destroy()
	global.listening_objects -= src
	QDEL_NULL(radio)
	. = ..()

/obj/item/camera/tvcamera/Initialize()
	set_extension(src, /datum/extension/network_device/camera/television, null, null, null, TRUE, list(CAMERA_CHANNEL_TELEVISION), channel, FALSE)
	radio = new(src)
	radio.listening = FALSE
	radio.power_usage = 0
	global.listening_objects += src
	. = ..()

/obj/item/camera/tvcamera/examine(mob/user)
	. = ..()
	to_chat(user, "Video feed is currently: [video_enabled ? "Online" : "Offline"]")
	to_chat(user, "Audio feed is currently: [radio.broadcasting ? "Online" : "Offline"]")
	to_chat(user, "Photography setting is currently: [turned_on ? "On" : "Off"]")

/obj/item/camera/tvcamera/attack_self(mob/user)
	add_fingerprint(user)
	user.set_machine(src)
	var/dat = list()
	dat += "Photography mode is currently: <a href='?src=\ref[src];photo=1'>[turned_on ? "On" : "Off"]</a><br>"
	dat += "Photography focus is currently: <a href='?src=\ref[src];focus=1'>[field_of_view]</a><br>"
	dat += "Channel name is: <a href='?src=\ref[src];channel=1'>[channel ? channel : "unidentified broadcast"]</a><br>"
	dat += "Video streaming is: <a href='?src=\ref[src];video=1'>[video_enabled ? "Online" : "Offline"]</a><br>"
	dat += "Microphone is: <a href='?src=\ref[src];sound=1'>[radio.broadcasting ? "Online" : "Offline"]</a><br>"
	dat += "Sound is being broadcasted on frequency: [format_frequency(radio.frequency)]<br>"
	dat += "<a href='?src=\ref[src];net_options=1'>Network Options</a>"
	var/datum/browser/written_digital/popup = new(user, "Press Camera Drone", "EyeBuddy", 300, 390, src)
	popup.set_content(jointext(dat,null))
	popup.open()

/obj/item/camera/tvcamera/Topic(bred, href_list, state = global.physical_topic_state)
	if(..())
		return 1
	if (href_list["photo"])
		turned_on = !turned_on
	if (href_list["focus"])
		change_size()
	if(href_list["channel"])
		var/nc = sanitize(input(usr, "Channel name", "Select new channel name", channel) as text|null)
		if(nc)
			channel = nc
			var/datum/extension/network_device/camera/television/D = get_extension(src, /datum/extension/network_device)
			D.display_name = channel
			to_chat(usr, "<span class='notice'>New channel name: '[channel]' has been set.</span>")
	if(href_list["video"])
		video_enabled = !video_enabled
		if(video_enabled)
			to_chat(usr,"<span class='notice'>Video streaming: Activated. Broadcasting on channel: '[channel]'</span>")
		else
			to_chat(usr,"<span class='notice'>Video streaming: Deactivated.</span>")
		update_icon()
	if(href_list["sound"])
		radio.toggle_broadcast()
		if(radio.broadcasting)
			to_chat(usr,"<span class='notice'>Audio streaming: Activated. Broadcasting on frequency: [format_frequency(radio.frequency)].</span>")
		else
			to_chat(usr,"<span class='notice'>Audio streaming: Deactivated.</span>")
	if(href_list["net_options"])
		var/datum/extension/network_device/camera/television/D = get_extension(src, /datum/extension/network_device)
		D.ui_interact(usr)
	if(!href_list["close"])
		attack_self(usr)

/obj/item/camera/tvcamera/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && video_enabled && check_state_in_icon("[overlay.icon_state]-on", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]-on"
	. = ..()

/obj/item/camera/tvcamera/on_update_icon()
	. = ..()
	if(video_enabled)
		add_overlay("[icon_state]-on")
	update_held_icon()

/* Assembly by a roboticist */
/obj/item/robot_parts/head/attackby(var/obj/item/assembly/S, mob/user)
	if ((!istype(S, /obj/item/assembly/infra)))
		..()
		return
	var/obj/item/TVAssembly/A = new(user)
	qdel(S)
	user.put_in_hands(A)
	to_chat(user, "<span class='notice'>You add the infrared sensor to the robot head.</span>")
	qdel(src)

/* Using camcorder icon as I can't sprite.
Using robohead because of restricting to roboticist */
/obj/item/TVAssembly
	name = "TV Camera assembly"
	desc = "A robotic head with an infrared sensor inside"
	icon = 'icons/obj/robot_parts.dmi'
	icon_state = "head"
	item_state = "head"
	var/buildstep = 0
	w_class = ITEM_SIZE_LARGE
	material = /decl/material/solid/metal/steel

/obj/item/TVAssembly/attackby(var/obj/item/W, var/mob/user)
	switch(buildstep)
		if(0)
			if(istype(W, /obj/item/robot_parts/robot_component/camera))
				to_chat(user, "<span class='notice'>You add the camera module to [src]</span>")
				qdel(W)
				desc = "This TV camera assembly has a camera module."
				buildstep++
		if(1)
			if(istype(W, /obj/item/taperecorder))
				qdel(W)
				buildstep++
				to_chat(user, "<span class='notice'>You add the tape recorder to [src]</span>")
				desc = "This TV camera assembly has a camera and audio module."
				return
		if(2)
			if(IS_COIL(W))
				var/obj/item/stack/cable_coil/C = W
				if(!C.use(3))
					to_chat(user, "<span class='notice'>You need three cable coils to wire the devices.</span>")
					..()
					return
				buildstep++
				to_chat(user, "<span class='notice'>You wire the assembly</span>")
				desc = "This TV camera assembly has wires sticking out"
				return
		if(3)
			if(IS_WIRECUTTER(W))
				to_chat(user, "<span class='notice'> You trim the wires.</span>")
				buildstep++
				desc = "This TV camera assembly needs casing."
				return
		if(4)
			if(istype(W, /obj/item/stack/material))
				var/obj/item/stack/material/S = W
				if(S.material?.type == /decl/material/solid/metal/steel && S.use(1))
					buildstep++
					to_chat(user, "<span class='notice'>You encase the assembly.</span>")
					var/turf/T = get_turf(src)
					new /obj/item/camera/tvcamera(T)
					qdel(src)
					return
	..()

/datum/extension/network_device/camera/television
	expected_type = /obj/item/camera/tvcamera
	requires_connection = FALSE

/datum/extension/network_device/camera/television/is_functional()
	var/obj/item/camera/tvcamera/tv = holder
	return tv.video_enabled