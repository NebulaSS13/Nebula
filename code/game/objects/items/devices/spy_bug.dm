/obj/item/spy_bug
	name = "bug"
	desc = ""	// Nothing to see here
	icon = 'icons/obj/items/shield/e_shield.dmi'
	icon_state = "eshield0"
	item_state = "nothing"
	layer = BELOW_TABLE_LAYER
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	throw_range = 15
	throw_speed = 3
	origin_tech = @'{"programming":1,"engineering":1,"esoteric":3}'
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon         = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/glass           = MATTER_AMOUNT_TRACE,
	)
	var/obj/item/radio/spy/radio

/obj/item/spy_bug/Initialize()
	. = ..()
	name = "bug #[random_id(/obj/item/spy_bug, 1000,9999)]"
	radio = new(src)
	global.listening_objects += src

/obj/item/spy_bug/Destroy()
	QDEL_NULL(radio)
	return ..()

/obj/item/spy_bug/examine(mob/user, distance)
	. = ..()
	if(distance <= 0)
		to_chat(user, "It's a tiny camera, microphone, and transmission device in a happy union.")
		to_chat(user, "Needs to be both configured and brought in contact with monitor device to be fully functional.")

/obj/item/spy_bug/attack_self(mob/user)
	radio.attack_self(user)

/obj/item/spy_bug/attackby(obj/W, mob/user)
	if(istype(W, /obj/item/spy_monitor))
		var/obj/item/spy_monitor/SM = W
		SM.pair(src, user)
	else
		..()

/obj/item/spy_bug/hear_talk(mob/M, var/msg, verb, decl/language/speaking)
	radio.hear_talk(M, msg, speaking)


/obj/item/spy_monitor
	name = "\improper PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	icon = 'icons/obj/modular_computers/pda/pda.dmi'
	icon_state = ICON_STATE_WORLD
	color = COLOR_GRAY80
	w_class = ITEM_SIZE_SMALL
	origin_tech = @'{"programming":1,"engineering":1,"esoteric":3}'
	material = /decl/material/solid/organic/plastic
	matter = list(
		/decl/material/solid/metal/copper = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/silicon = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/glass = MATTER_AMOUNT_TRACE,
	)

	var/obj/item/radio/spy/radio
	var/obj/item/spy_bug/selected_camera
	var/list/obj/item/spy_bug/cameras = list()

/obj/item/spy_monitor/Initialize()
	. = ..()
	radio = new(src)
	global.listening_objects += src

/obj/item/spy_monitor/Destroy()
	selected_camera = null
	cameras.Cut()
	return ..()

/obj/item/spy_monitor/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "The time '12:00' is blinking in the corner of the screen and \the [src] looks very cheaply made.")

/obj/item/spy_monitor/attack_self(mob/user)
	radio.attack_self(user)
	view_cameras(user)

/obj/item/spy_monitor/attackby(obj/W, mob/user)
	if(istype(W, /obj/item/spy_bug))
		pair(W, user)
	else
		return ..()

/obj/item/spy_monitor/proc/pair(var/obj/item/spy_bug/SB, var/mob/living/user)
	to_chat(user, SPAN_NOTICE("\The [SB] has been paired with \the [src]."))
	events_repository.register(/decl/observ/destroyed, SB, src, PROC_REF(unpair))
	cameras += SB

/obj/item/spy_monitor/proc/unpair(var/obj/item/spy_bug/SB, var/mob/living/user)
	to_chat(user, SPAN_NOTICE("\The [SB] has been unpaired from \the [src]."))
	events_repository.unregister(/decl/observ/destroyed, SB, src, PROC_REF(unpair))
	if(selected_camera == SB)
		selected_camera = null
	cameras -= SB

/obj/item/spy_monitor/proc/view_cameras(mob/user)
	if(!cameras.len)
		to_chat(user, SPAN_WARNING("No paired cameras detected!"))
		to_chat(user, SPAN_WARNING("Bring a bug in contact with this device to pair the camera."))
		return

	if(selected_camera)
		selected_camera = null
		user.reset_view()
		user.unset_machine()
		return

	selected_camera = input("Select camera bug to view.") as null|anything in cameras
	view_camera(user)

/obj/item/spy_monitor/proc/view_camera(mob/user)
	user.machine = src
	user.reset_view(selected_camera)

/obj/item/spy_monitor/check_eye(mob/user)
	if(!selected_camera || QDELETED(selected_camera))
		user.unset_machine()
		return -1
	if(!CanUseTopicPhysical(user))
		user.unset_machine()
		return -1
	var/turf/T = get_turf(selected_camera)
	if(!T || !is_on_same_plane_or_station(T.z, user.z))
		user.unset_machine()
		selected_camera = null
		return -1
	return 0

/obj/item/spy_monitor/hear_talk(mob/M, var/msg, verb, decl/language/speaking)
	return radio.hear_talk(M, msg, speaking)

/obj/item/radio/spy
	listening = 0
	frequency = 1473
	broadcasting = 0
	canhear_range = 1
	name = "spy device"
	icon = 'icons/obj/items/device/radio/spybug.dmi'
	icon_state = ICON_STATE_WORLD
