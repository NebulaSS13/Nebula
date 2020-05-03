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

	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()
	var/error

/obj/machinery/cloning_pod/Initialize()
	. = ..()
	set_extension(src, /datum/extension/network_device/cloning_pod, initial_network_id, initial_network_key, NETWORK_CONNECTION_WIRED)
	if(occupant)
		eject()

/obj/machinery/cloning_pod/attackby(var/obj/item/G, var/mob/user)
	var/datum/extension/network_device/cloning_pod/computer = get_extension(src, /datum/extension/network_device)
	if(istype(G, /obj/item/grab))
		var/obj/item/grab/grab = G
		if(computer.occupied)
			to_chat(user, SPAN_NOTICE("\The [src] is in use."))
			return

		if(!ismob(grab.affecting))
			return

		if(!check_occupant_allowed(grab.affecting))
			return

		attempt_enter(grab.affecting, user)

	if(istype(G, /obj/item/organ/internal/stack))
		if(computer.occupied)
			to_chat(user, SPAN_NOTICE("\The [src] is in use."))
			return

		attempt_enter(G, user)
	return ..()

/obj/machinery/cloning_pod/proc/attempt_enter(var/datum/target, var/mob/user)
	visible_message("[user] starts putting [target] into \the [src].", range = 3)
	if(!do_after(user, 20, src) || QDELETED(target))
		return
	var/datum/extension/network_device/cloning_pod/computer = get_extension(src, /datum/extension/network_device)
	computer.set_occupant(target)

	src.add_fingerprint(user)

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
	if(!occupant)
		return

	//Eject any items that aren't meant to be in the pod.
	var/list/items = contents - component_parts
	if(occupant) items -= occupant

	for(var/obj/item/W in items)
		W.dropInto(loc)

	var/datum/extension/network_device/cloning_pod/D = get_extension(src, /datum/extension/network_device)
	D.eject_occupant()
	add_fingerprint(usr)