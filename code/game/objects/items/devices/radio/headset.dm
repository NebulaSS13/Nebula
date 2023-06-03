/obj/item/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys."
	icon = 'icons/obj/items/device/radio/headsets/headset.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/metal/aluminium
	canhear_range = 0 // can't hear headsets from very far away
	slot_flags = SLOT_EARS
	cell = null
	power_usage = 0
	can_use_analog = FALSE
	encryption_keys = list(/obj/item/encryptionkey)
	encryption_key_capacity = 2

/obj/item/radio/headset/on_update_icon()
	icon_state = get_world_inventory_state()
	cut_overlays()
	if(on)
		if(analog)
			add_overlay("[icon_state]-local")
		else
			var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
			var/datum/computer_network/network = network_device?.get_network()
			if(network)
				add_overlay("[icon_state]-online")
			else
				add_overlay("[icon_state]-offline")
