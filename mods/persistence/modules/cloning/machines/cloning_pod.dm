/obj/machinery/cloning_pod
	name = "Cloning Pod"
	desc = "Clones a backup of a deceased crew member."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "pod_0"
	density = TRUE
	anchored = TRUE

	idle_power_usage = 250
	active_power_usage = 5 KILOWATTS

	base_type = /obj/machinery/cloning_pod
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null

	var/initial_network_id
	var/initial_network_key

	var/atom/movable/occupant = null

	var/allow_occupant_types = list(
		/mob/living/carbon/human,
		/obj/item/organ/internal/stack
	)
	var/disallow_occupant_types = list()
	var/error

/obj/machinery/cloning_pod/Initialize()
	. = ..()
	set_extension(src, /datum/extension/network_device/cloning_pod, initial_network_id, initial_network_key, NETWORK_CONNECTION_WIRED)
	if(occupant)
		eject()

/obj/machinery/cloning_pod/MouseDrop_T(atom/dropping, mob/user)
	if(dropping != user)
		return
	attempt_enter(dropping, user, "[user] starts putting [dropping] into \the [src].")

/obj/machinery/cloning_pod/attackby(var/obj/item/G, var/mob/user)
	if(istype(G, /obj/item/grab))
		var/obj/item/grab/grab = G
		attempt_enter(grab.affecting, user, "[user] starts putting [grab.affecting] into \the [src].")

	if(istype(G, /obj/item/organ/internal/stack))
		attempt_enter(G, user, "[user] starts putting [G] into \the [src].")
	return ..()

/obj/machinery/cloning_pod/proc/check_occupant_allowed(mob/M)
	var/correct_type = 0
	for(var/type in allow_occupant_types)
		if(istype(M, type))
			correct_type = 1
			break

	if(!correct_type) return 0

	for(var/type in disallow_occupant_types)
		if(istype(M, type))
			return 0

	return 1

/obj/machinery/cloning_pod/interface_interact(user)
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	D.ui_interact(user)
	return TRUE

/obj/machinery/cloning_pod/ui_data(mob/user, ui_key)
	var/list/data[0]
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(!istype(D))
		error = "HARDWARE FAILURE: NETWORK DEVICE NOT FOUND"
		data["error"] = error
		return data
	data["error"] = error
	data += D.ui_data(user, ui_key)
	return data

/obj/machinery/cloning_pod/power_change()
	. = ..()
	if(.)
		update_network_status()

/obj/machinery/cloning_pod/set_broken(new_state, cause = MACHINE_BROKEN_GENERIC)
	. = ..()
	if(.)
		update_network_status()

/obj/machinery/cloning_pod/proc/update_network_status()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(!D)
		return
	if(operable())
		D.connect()
	else
		D.disconnect()

/obj/machinery/cloning_pod/verb/eject()
	set name = "Eject Pod"
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return
	var/datum/extension/network_device/cloning_pod/D = get_extension(src, /datum/extension/network_device)
	if(D.eject_occupant())
		add_fingerprint(usr)

/obj/machinery/cloning_pod/verb/move_inside()
	set name = "Enter Pod"
	set category = "Object"
	set src in oview(1)

	attempt_enter(usr, usr, "\The [usr] starts climbing into \the [src].")

/obj/machinery/cloning_pod/proc/attempt_enter(var/atom/movable/target, var/mob/user, var/message)
	if(user.stat != 0 || !check_occupant_allowed(target))
		return

	if(occupant)
		to_chat(user, SPAN_NOTICE("<B>\The [src] is in use.</B>"))
		return

	for(var/mob/living/carbon/slime/M in range(1,user))
		if(M.Victim == user)
			to_chat(user, "You're too busy getting your life sucked out of you.")
			return

	visible_message(message, range = 3)
	if(do_after(user, 20, src))
		var/datum/extension/network_device/cloning_pod/computer = get_extension(src, /datum/extension/network_device)
		computer.set_occupant(target, user)
		src.add_fingerprint(user)
