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
	D.reload_commands()

/obj/item/stock_parts/network_receiver/attack_self(mob/user)
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	D.ui_interact(user)

/obj/item/stock_parts/network_receiver/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	material = /decl/material/solid/metal/steel