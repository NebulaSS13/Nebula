/decl/closet_appearance/secure_closet/corporate
	color = COLOR_GREEN_GRAY
	decals = list(
		"lower_holes"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_GRAY80,
		"research" = COLOR_OFF_WHITE
	)

/obj/structure/closet/wardrobe/red/Initialize()
	. = ..()
	new /obj/item/clothing/head/beret/sec/corporate/officer(src)
	new /obj/item/clothing/head/beret/sec/corporate/officer(src)
	new /obj/item/clothing/head/beret/sec/corporate/officer(src)

/obj/structure/closet/secure_closet/hos/WillContain()
	. = ..() + /obj/item/clothing/head/beret/sec/corporate/hos

/obj/structure/closet/secure_closet/warden/WillContain()
	. = ..() + /obj/item/clothing/head/beret/sec/corporate/warden

/obj/structure/closet/secure_closet/xenoarchaeologist/Initialize()
	. = ..()
	if(!(locate(/obj/item/storage/backpack/toxins) in contents))
		new /obj/item/storage/backpack/satchel/tox(src)

/obj/structure/closet/secure_closet/security/WillContain()
	. = ..()
	. += /obj/item/clothing/suit/armor/vest/nt
	. += /obj/item/clothing/head/soft/sec/corp
	. += /obj/item/clothing/under/rank/security/corp

/obj/structure/closet/wardrobe/red/Initialize()
	. = ..()
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)
	new /obj/item/clothing/head/beret/sec(src)

/obj/structure/closet/wardrobe/atmospherics_yellow/Initialize()
	. = ..()
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)

/obj/structure/closet/wardrobe/engineering_yellow/Initialize()
	. = ..()
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)
	new /obj/item/clothing/head/beret/engineering(src)

/obj/structure/closet/secure_closet/scientist/WillContain()
	. = ..() + new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/messenger/tox, /obj/item/storage/backpack/satchel/tox))

/obj/structure/closet/secure_closet/xenobio/WillContain()
	. = ..() + new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/messenger/tox, /obj/item/storage/backpack/satchel/tox))

/obj/structure/closet/secure_closet/captains/WillContain()
	. = ..()
	. += /obj/item/clothing/suit/armor/captain
	. += /obj/item/clothing/suit/armor/vest/nt

/obj/structure/closet/secure_closet/warden/WillContain()
	. = ..()
	. += /obj/item/clothing/head/helmet/nt
	. += /obj/item/clothing/suit/armor/vest/nt
	. += /obj/item/clothing/under/rank/warden/corp

/obj/structure/closet/secure_closet/hos/WillContain()
	. = ..()
	. += /obj/item/clothing/head/helmet/nt
	. += /obj/item/clothing/suit/armor/vest/nt
	. += /obj/item/clothing/under/rank/head_of_security/corp

/obj/structure/closet/secure_closet/hop/WillContain()
	. = ..() + /obj/item/clothing/suit/armor/vest/nt
