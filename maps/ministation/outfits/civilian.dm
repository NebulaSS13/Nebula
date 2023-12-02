/decl/hierarchy/outfit/job/ministation/cargo
	name              = "Ministation - Job - Cargo technician"
	l_ear             = /obj/item/radio/headset/ministation_headset_cargo
	pants             = /obj/item/clothing/jumpsuit/cargotech
	id_type           = /obj/item/card/id/ministation/cargo
	pda_type          = /obj/item/modular_computer/pda/cargo
	backpack_contents = list(/obj/item/crowbar = 1, /obj/item/storage/ore = 1)
	outfit_flags      = OUTFIT_HAS_BACKPACK | OUTFIT_EXTENDED_SURVIVAL | OUTFIT_HAS_VITALS_SENSOR

/decl/hierarchy/outfit/job/ministation/cargo/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/ministation/bartender
	name     = "Ministation - Job - Bartender"
	l_ear    = /obj/item/radio/headset/headset_service
	uniform  = /obj/item/clothing/under/bartender
	id_type  = /obj/item/card/id/ministation/bartender
	pda_type = /obj/item/modular_computer/pda
	head     = /obj/item/clothing/head/chefhat

/decl/hierarchy/outfit/job/ministation/janitor
	name     = "Ministation - Job - Janitor"
	l_ear    = /obj/item/radio/headset/headset_service
	pants    = /obj/item/clothing/jumpsuit/janitor
	id_type  = /obj/item/card/id/ministation/janitor
	pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/job/ministation/librarian
	name     = "Ministation - Job - Librarian"
	l_ear    = /obj/item/radio/headset/headset_service
	uniform  = /obj/item/clothing/under/librarian
	id_type  = /obj/item/card/id/ministation/librarian
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
