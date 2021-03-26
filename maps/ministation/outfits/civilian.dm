/decl/hierarchy/outfit/job/ministation/cargo
	l_ear = /obj/item/radio/headset/headset_cargo
	name = MINISTATION_OUTFIT_JOB_NAME("Cargo technician")
	uniform = /obj/item/clothing/under/cargotech
	id_type = /obj/item/card/id/ministation/cargo
	pda_type = /obj/item/modular_computer/pda/cargo
	backpack_contents = list(/obj/item/crowbar = 1, /obj/item/storage/ore = 1)
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/ministation/cargo/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/ministation/bartender
	l_ear = /obj/item/radio/headset/headset_service
	name = MINISTATION_OUTFIT_JOB_NAME("Bartender")
	uniform = /obj/item/clothing/under/bartender
	id_type = /obj/item/card/id/ministation/bartender
	pda_type = /obj/item/modular_computer/pda
	head = /obj/item/clothing/head/chefhat

/decl/hierarchy/outfit/job/ministation/janitor
	l_ear = /obj/item/radio/headset/headset_service
	name = MINISTATION_OUTFIT_JOB_NAME("Janitor")
	uniform = /obj/item/clothing/under/janitor
	id_type = /obj/item/card/id/ministation/janitor
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/ministation/librarian
	l_ear = /obj/item/radio/headset/headset_service
	name = MINISTATION_OUTFIT_JOB_NAME("Librarian")
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
