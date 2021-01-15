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
	new /obj/item/clothing/head/beret/corp/sec/corporate/officer(src)
	new /obj/item/clothing/head/beret/corp/sec/corporate/officer(src)
	new /obj/item/clothing/head/beret/corp/sec/corporate/officer(src)

/obj/structure/closet/secure_closet/hos/WillContain()
	. = ..() + /obj/item/clothing/head/beret/corp/sec/corporate/hos

/obj/structure/closet/secure_closet/warden/WillContain()
	. = ..() + /obj/item/clothing/head/beret/corp/sec/corporate/warden

/obj/structure/closet/secure_closet/security/WillContain()
	. = ..()
	. += /obj/item/clothing/suit/armor/vest/nt
	. += /obj/item/clothing/head/soft/sec/corp
	. += /obj/item/clothing/under/security/corp

/obj/structure/closet/wardrobe/red/Initialize()
	. = ..()
	new /obj/item/clothing/head/beret/corp/sec(src)
	new /obj/item/clothing/head/beret/corp/sec(src)
	new /obj/item/clothing/head/beret/corp/sec(src)

/obj/structure/closet/secure_closet/captains/WillContain()
	. = ..()
	. += /obj/item/clothing/suit/armor/captain
	. += /obj/item/clothing/suit/armor/vest/nt

/obj/structure/closet/secure_closet/warden/WillContain()
	. = ..()
	. += /obj/item/clothing/head/helmet/corp
	. += /obj/item/clothing/suit/armor/vest/nt
	. += /obj/item/clothing/under/warden/corp

/obj/structure/closet/secure_closet/hos/WillContain()
	. = ..()
	. += /obj/item/clothing/head/helmet/corp
	. += /obj/item/clothing/suit/armor/vest/nt
	. += /obj/item/clothing/under/head_of_security/corp

/obj/structure/closet/secure_closet/hop/WillContain()
	. = ..() + /obj/item/clothing/suit/armor/vest/nt
