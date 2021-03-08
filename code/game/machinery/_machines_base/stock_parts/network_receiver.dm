// A reciever that allows for non-network machines to have public vars and methods interacted with by networks

/obj/item/stock_parts/network_receiver
	name = "network receiver"
	desc = "A network receiver designed for use with machinery otherwise disconnected from a network."
	icon_state = "net_lock"
	part_flags = PART_FLAG_QDEL

/obj/item/stock_parts/network_receiver/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/network_device/stock_part)

/obj/item/stock_parts/network_receiver/on_install(obj/machinery/machine)
	. = ..()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	D.sanitize_commands()

/obj/item/stock_parts/network_receiver/attack_self(mob/user)
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	D.ui_interact(user)

/obj/item/stock_parts/network_receiver/attackby(obj/item/I, mob/user)
	. = ..()
	if(isMultitool(I))
		var/candidates = list()
		for(var/obj/machinery/new_machine in view(2, user))
			candidates += new_machine
		if(!length(candidates))
			to_chat(user, SPAN_WARNING("You fail to import configuration settings from anything. Try standing near a machine."))
			return
		var/obj/machinery/input = input(user, "Which machine would you like to configure \the [src] for?", "Machine Selection") as null|anything in candidates
		if(!istype(input) || !CanPhysicallyInteractWith(usr, src))
			return
		var/datum/extension/network_device/stock_part/D = get_extension(src, /datum/extension/network_device/)
		D.machine = weakref(input)
		D.sanitize_commands()
		to_chat(user, SPAN_NOTICE("You import configuration settings from \the [input]."))

/obj/item/stock_parts/network_receiver/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	material = /decl/material/solid/metal/steel