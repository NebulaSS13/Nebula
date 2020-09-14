/obj/item/radio/headset/headset_med
	name = "medical radio headset"
	desc = "A headset for the trained staff of the medbay."
	icon = 'icons/obj/items/device/radio/headsets/headset_medical.dmi'
	encryption_keys = list(/obj/item/encryptionkey/headset_med)

/obj/item/encryptionkey/headset_med
	name = "medical radio encryption key"
	icon_state = "med_cypherkey"
	can_decrypt = list(access_medical)

/obj/item/radio/headset/headset_service
	name = "service radio headset"
	desc = "Headset used by the service staff, tasked with keeping everyone full, happy and clean."
	icon = 'icons/obj/items/device/radio/headsets/headset_service.dmi'
	encryption_keys = list(/obj/item/encryptionkey/headset_service)
	
/obj/item/encryptionkey/headset_service
	name = "service radio encryption key"
	icon_state = "srv_cypherkey"
	can_decrypt = list(access_bar)

/obj/item/radio/headset/headset_sci
	name = "science radio headset"
	desc = "A sciency headset. Like usual."
	icon = 'icons/obj/items/device/radio/headsets/headset_science.dmi'
	encryption_keys = list(/obj/item/encryptionkey/headset_sci)
	
/obj/item/encryptionkey/headset_sci
	name = "science radio encryption key"
	icon_state = "sci_cypherkey"
	can_decrypt = list(access_research)

/obj/item/radio/headset/headset_eng
	name = "engineering radio headset"
	desc = "When the engineers wish to gossip like highschoolers."
	icon = 'icons/obj/items/device/radio/headsets/headset_engineering.dmi'
	encryption_keys = list(/obj/item/encryptionkey/headset_eng)

/obj/item/encryptionkey/headset_eng
	name = "engineering radio encryption key"
	icon_state = "eng_cypherkey"
	can_decrypt = list(access_engine)

/obj/item/radio/headset/heads
	icon_state = "com_headset"
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'

/obj/item/radio/headset/heads/ce
	name = "chief engineer's headset"
	desc = "The headset of the boss engineer."
	encryption_keys = list(/obj/item/encryptionkey/heads/ce)

/obj/item/encryptionkey/heads/ce
	name = "chief engineer's encryption key"
	icon_state = "cap_cypherkey"
	can_decrypt = list(
		access_bridge,
		access_engine
	)

/obj/item/radio/headset/heads/cmo
	name = "chief medical officer's headset"
	desc = "The headset of the boss medic."
	encryption_keys = list(/obj/item/encryptionkey/heads/cmo)

/obj/item/encryptionkey/heads/cmo
	name = "chief medical officer's encryption key"
	icon_state = "cap_cypherkey"
	can_decrypt = list(
		access_bridge,
		access_medical
	)

/obj/item/radio/headset/heads/rd
	name = "research director's headset"
	desc = "The headset of the boss egghead."
	encryption_keys = list(/obj/item/encryptionkey/heads/rd)

/obj/item/encryptionkey/heads/rd
	name = "research director's encryption key"
	icon_state = "cap_cypherkey"
	can_decrypt = list(
		access_bridge,
		access_research
	)

/obj/item/radio/headset/heads/captain
	name = "captain's headset"
	desc = "The headset of the boss."
	encryption_keys = list(/obj/item/encryptionkey/heads/captain)

/obj/item/encryptionkey/heads/captain
	name = "captain's encryption key"
	icon_state = "cap_cypherkey"
	can_decrypt = list(
		access_bridge,
		access_security,
		access_engine,
		access_research,
		access_medical,
		access_cargo,
		access_bar
	)

/obj/item/radio/headset/heads/hop
	name = "head of personnel's headset"
	desc = "The headset of the guy who will one day be captain."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	encryption_keys = list(/obj/item/encryptionkey/heads/hop)

/obj/item/encryptionkey/heads/hop
	name = "head of personnel's encryption key"
	icon_state = "hop_cypherkey"
	can_decrypt = list(
		access_bar,
		access_cargo,
		access_bridge,
		access_security
	)


/obj/item/encryptionkey/ert
	name = "\improper ERT radio encryption key"
	can_decrypt = list(access_cent_specops)

/obj/item/radio/headset/ert
	name = "emergency response team radio headset"
	desc = "The headset of the boss's boss."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	encryption_keys = list(/obj/item/encryptionkey/ert)

/obj/item/encryptionkey/mercenary
	icon_state = "cypherkey"
	origin_tech = "{'esoteric':2}"
	can_decrypt = list(access_mercenary)

/obj/item/radio/headset/mercenary
	origin_tech = "{'esoteric':2}"
	encryption_keys = list(/obj/item/encryptionkey/mercenary)
	peer_to_peer = TRUE
	peer_to_peer_range = 100

/obj/item/radio/headset/mercenary/Initialize()
	peer_to_peer_password = get_initial_peer_to_peer_password(/decl/special_role/mercenary)
	. = ..()

/obj/item/encryptionkey/entertainment
	name = "entertainment radio key"

/obj/item/radio/headset/entertainment
	name = "actor's radio headset"
	desc = "Specially made to make you sound less cheesy."
	icon = 'icons/obj/items/device/radio/headsets/headset_command.dmi'
	encryption_keys = list(/obj/item/encryptionkey/entertainment)

/obj/item/encryptionkey/raider
	icon_state = "cypherkey"
	origin_tech = "{'esoteric':2}"
	can_decrypt = list(access_raider)

/obj/item/radio/headset/raider
	origin_tech = "{'esoteric':2}"
	encryption_keys = list(/obj/item/encryptionkey/raider)
	peer_to_peer = TRUE
	peer_to_peer_range = 100

/obj/item/radio/headset/raider/Initialize()
	peer_to_peer_password = get_initial_peer_to_peer_password(/decl/special_role/raider)
	. = ..()
