/decl/hierarchy/outfit/job/ministation/cargo
	l_ear = /obj/item/radio/headset/ministation_headset_cargo
	name = "Ministation - Job - Cargo technician"
	uniform = /obj/item/clothing/under/cargotech
	id_type = /obj/item/card/id/ministation/cargo
	pda_type = /obj/item/modular_computer/pda/cargo
	backpack_contents = list(/obj/item/crowbar = 1, /obj/item/storage/ore = 1)
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/obj/item/encryptionkey/ministation_headset_cargo
	name = "cargo radio encryption key"
	icon_state = "srv_cypherkey"
	can_decrypt = list(access_cargo)

/obj/item/radio/headset/ministation_headset_cargo
	name = "supply radio headset"
	desc = "A headset used by the box-pushers."
	icon = 'maps/ministation/icons/headset_cargo.dmi'
	encryption_keys = list(/obj/item/encryptionkey/ministation_headset_cargo)

/decl/hierarchy/outfit/job/ministation/cargo/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/ministation/bartender
	l_ear = /obj/item/radio/headset/headset_service
	name = "Ministation - Job - Bartender"
	uniform = /obj/item/clothing/under/bartender
	id_type = /obj/item/card/id/ministation/bartender
	pda_type = /obj/item/modular_computer/pda
	head = /obj/item/clothing/head/chefhat

/decl/hierarchy/outfit/job/ministation/janitor
	l_ear = /obj/item/radio/headset/headset_service
	name = "Ministation - Job - Janitor"
	uniform = /obj/item/clothing/under/janitor
	id_type = /obj/item/card/id/ministation/janitor
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/ministation/librarian
	l_ear = /obj/item/radio/headset/headset_service
	name = "Ministation - Job - Librarian"
	uniform = /obj/item/clothing/under/librarian
	id_type = /obj/item/card/id/ministation/librarian
	pda_type = /obj/item/modular_computer/pda

//cards
/obj/item/card/id/ministation/cargo
	name = "identification card"
	desc = "A card issued to cargo staff."
	detail_color = COLOR_BROWN

/obj/item/card/id/ministation/bartender
	desc = "A card issued to kitchen staff."

/obj/item/card/id/ministation/janitor
	desc = "A card issued to custodial staff."

/obj/item/card/id/ministation/librarian
	desc = "A card issued to the station librarian."
