/obj/item/radio/headset/heads/ai_integrated
	name = "\improper AI subspace transceiver"
	desc = "Integrated AI radio transceiver."
	encryption_keys = list(/obj/item/encryptionkey/heads/ai_integrated)
	var/disabledAi = 0 // Atlantis: Used to manually disable AI's integrated radio via intelliCard menu.

/obj/item/radio/headset/heads/ai_integrated/get_accessible_channel_descriptions(mob/user)
	. = ..()
	if(user)
		LAZYADD(., "<b>- Holopad Transmission:</b> [user.get_department_radio_prefix()]h")

/obj/item/encryptionkey/heads/ai_integrated
	name = "ai integrated encryption key"
	desc = "Integrated encryption key."
	color = COLOR_GOLD
	fill_color = COLOR_PALE_GOLD
	inlay_color = COLOR_ROYAL_BLUE
	can_decrypt = list(
		access_bridge,
		access_security,
		access_engine,
		access_research,
		access_medical,
		access_cargo,
		access_bar,
		access_ai_upload,
		access_explorer
	)
