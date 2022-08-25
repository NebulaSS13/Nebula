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
	encryption_keys = list(/obj/item/encryptionkey)
	encryption_key_capacity = 1
	peer_to_peer_range = 25

/obj/item/radio/headset/on_update_icon()
	icon_state = get_world_inventory_state()
	cut_overlays()
	if(on)
		if(peer_to_peer)
			add_overlay(icon, "[icon_state]-local")
		else
			var/datum/extension/network_device/network_device = get_extension(src, /datum/extension/network_device)
			var/datum/computer_network/network = network_device?.get_network()
			if(network)
				add_overlay(icon, "[icon_state]-online")
			else
				add_overlay(icon, "[icon_state]-offline")

/obj/item/radio/headset/receive_range(freq, level, aiOverride = 0)
	if (aiOverride)
		return ..(freq, level)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		for(var/slot in global.ear_slots)
			if(H.get_equipped_item(slot) == src)
				return ..(freq, level)
	return -1
