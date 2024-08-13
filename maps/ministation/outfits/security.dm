/obj/item/modular_computer/pda/security
	color = COLOR_DARK_RED
	decals = list("stripe" = COLOR_RED_LIGHT)

/decl/outfit/job/ministation/security
	l_ear = /obj/item/radio/headset/headset_sec
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/jackboots
	backpack_contents = list(/obj/item/handcuffs = 1)
	name = "Ministation - Job - Security Officer"
	uniform = /obj/item/clothing/jumpsuit/security
	l_pocket = /obj/item/flash
	r_pocket = /obj/item/handcuffs
	id_type = /obj/item/card/id/ministation/security
	pda_type = /obj/item/modular_computer/pda/security

/decl/outfit/job/ministation/security/head
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	l_ear = /obj/item/radio/headset/heads/hos
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/jackboots
	backpack_contents = list(/obj/item/handcuffs = 1)
	name = "Ministation - Job - Head of Security"
	uniform = /obj/item/clothing/jumpsuit/security
	l_pocket = /obj/item/flash
	r_pocket = /obj/item/handcuffs
	id_type = /obj/item/card/id/ministation/security
	pda_type = /obj/item/modular_computer/pda/security

/decl/outfit/job/ministation/security/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_SECURITY

/decl/outfit/job/ministation/security/head/Initialize()
	. = ..()
	BACKPACK_OVERRIDE_SECURITY

/obj/item/modular_computer/pda/forensics
	color = COLOR_DARK_RED
	decals = list("stripe" = COLOR_SKY_BLUE)

/obj/item/modular_computer/pda/forensics/install_default_hardware()
	default_hardware |= /obj/item/stock_parts/computer/scanner/reagent
	. = ..()

/decl/outfit/job/ministation/detective
	name = "Ministation - Job - Detective"
	head = /obj/item/clothing/head/det
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	l_ear = /obj/item/radio/headset/headset_sec
	uniform = /obj/item/clothing/pants/slacks/outfit/detective
	suit = /obj/item/clothing/suit/det_trench
	l_pocket = /obj/item/flame/fuelled/lighter/zippo
	shoes = /obj/item/clothing/shoes/dress
	hands = list(/obj/item/briefcase/crimekit)
	id_type = /obj/item/card/id/ministation/security
	pda_type = /obj/item/modular_computer/pda/forensics
	backpack_contents = list(/obj/item/box/evidence = 1)
	gloves = /obj/item/clothing/gloves/thick

/decl/outfit/job/ministation/detective/Initialize()
	. = ..()
	backpack_overrides.Cut()

/obj/item/card/id/ministation/security
	name = "identification card"
	desc = "A card issued to security staff."
	color = COLOR_OFF_WHITE
	detail_color = COLOR_MAROON
