/obj/machinery/network/router
	var/datum/computer_network/saved_network

/obj/machinery/network/router/before_save()
	. = ..()
	if(initial_network_id)
		saved_network = SSnetworking.networks[initial_network_id]

/obj/machinery/network/router/after_save()
	saved_network = null

/obj/machinery/network/router/after_deserialize()
	. = ..()
	if(initial_network_id && saved_network)
		// adds to GLOB &* updates override from New()
		saved_network.change_id(initial_network_id)
		SSnetworking.networks[initial_network_id] = saved_network

