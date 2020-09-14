/obj/item/modular_computer/pda/security
	color = COLOR_DARK_RED
	decals = list("stripe" = COLOR_RED_LIGHT)

/decl/hierarchy/outfit/job/ministation/security
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	l_ear = /obj/item/radio/headset/ministation_headset_sec
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/jackboots
	backpack_contents = list(/obj/item/handcuffs = 1)
	name = "Ministation - Job - Security Officer"
	uniform = /obj/item/clothing/under/security
	l_pocket = /obj/item/flash
	r_pocket = /obj/item/handcuffs
	id_type = /obj/item/card/id/ministation/security
	pda_type = /obj/item/modular_computer/pda/security

/obj/item/encryptionkey/ministation_headset_sec
	name = "security radio encryption key"
	icon_state = "srv_cypherkey"
	can_decrypt = list(access_security)

/obj/item/radio/headset/ministation_headset_sec
	name = "security radio headset"
	desc = "This is used by your elite security force."
	icon = 'maps/ministation/icons/headset_security.dmi'
	encryption_keys = list(/obj/item/encryptionkey/ministation_headset_sec)

/decl/hierarchy/outfit/job/ministation/security/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_SECURITY

/obj/item/modular_computer/pda/forensics
	color = COLOR_DARK_RED
	decals = list("stripe" = COLOR_SKY_BLUE)

/obj/item/modular_computer/pda/forensics/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/reagent
	. = ..()

/decl/hierarchy/outfit/job/ministation/detective
	name = "Ministation - Job - Detective"
	head = /obj/item/clothing/head/det
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	l_ear = /obj/item/radio/headset/ministation_headset_sec
	uniform = /obj/item/clothing/under/det
	suit = /obj/item/clothing/suit/storage/det_trench
	l_pocket = /obj/item/flame/lighter/zippo
	shoes = /obj/item/clothing/shoes/dress
	hands = list(/obj/item/storage/briefcase/crimekit)
	id_type = /obj/item/card/id/ministation/security
	pda_type = /obj/item/modular_computer/pda/forensics
	backpack_contents = list(/obj/item/storage/box/evidence = 1)
	gloves = /obj/item/clothing/gloves/thick

/decl/hierarchy/outfit/job/ministation/detective/Initialize()
	. = ..()
	backpack_overrides.Cut()

/obj/item/card/id/ministation/security
	name = "identification card"
	desc = "A card issued to security staff."
	color = COLOR_OFF_WHITE
	detail_color = COLOR_MAROON
