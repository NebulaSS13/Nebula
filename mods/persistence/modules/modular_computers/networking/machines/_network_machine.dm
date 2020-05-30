/obj/machinery/network
	var/saved_address
	var/saved_network_tag

/obj/machinery/network/before_save()
	. = ..()
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	saved_address = D.address
	saved_network_tag = D.network_tag
	initial_network_id = D.network_id
	initial_network_key = D.key

/obj/machinery/network/after_save()
	. = ..()
	saved_address = null
	saved_network_tag = null
	initial_network_id = null
	initial_network_key = null

/obj/machinery/network/Initialize()
	. = ..()
	
	var/datum/extension/network_device/D = get_extension(src, /datum/extension/network_device)
	if(saved_address)
		D.address = saved_address
	if(saved_network_tag)
		D.network_tag = saved_network_tag
	saved_address = null
	saved_network_tag = null
	
	