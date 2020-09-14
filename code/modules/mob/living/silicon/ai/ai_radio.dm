/obj/item/radio/headset/heads/ai_integrated
	name = "\improper AI subspace transceiver"
	desc = "Integrated AI radio transceiver."
	encryption_keys = list(/obj/item/encryptionkey/heads/ai_integrated)
	var/myAi = null    // Atlantis: Reference back to the AI which has this radio.
	var/disabledAi = 0 // Atlantis: Used to manually disable AI's integrated radio via inteliCard menu.

/obj/item/radio/headset/heads/ai_integrated/Destroy()
	myAi = null
	. = ..()

/obj/item/radio/headset/heads/ai_integrated/receive_range(freq, level)
	if (disabledAi)
		return -1 //Transciever Disabled.
	return ..(freq, level, 1)

/obj/item/encryptionkey/heads/ai_integrated
	name = "ai integrated encryption key"
	desc = "Integrated encryption key."
	icon_state = "cap_cypherkey"
	can_decrypt = list(
		access_bridge,
		access_security,
		access_engine,
		access_research,
		access_medical,
		access_cargo,
		access_bar,
		access_ai_upload
	)
