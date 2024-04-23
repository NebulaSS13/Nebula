/obj/structure/closet/secure_closet/hydroponics
	name = "botanist's locker"
	req_access = list(access_hydroponics)
	closet_appearance = /decl/closet_appearance/secure_closet/hydroponics

/obj/structure/closet/secure_closet/hydroponics/WillContain()
	return list(
		new /datum/atom_creator/weighted(list(/obj/item/clothing/suit/apron, /obj/item/clothing/suit/apron/overalls)),
		/obj/item/plants,
		/obj/item/clothing/jumpsuit/hydroponics,
		/obj/item/scanner/plant,
		/obj/item/radio/headset/headset_service,
		/obj/item/clothing/mask/bandana/botany,
		/obj/item/clothing/head/bandana/green,
		/obj/item/tool/hoe/mini,
		/obj/item/tool/axe/hatchet,
		/obj/item/wirecutters/clippers,
		/obj/item/chems/spray/plantbgone,
	)


/obj/structure/closet/secure_closet/hydroponics/sci
	name = "xenoflorist's locker"
	req_access = list(access_xenobiology)
	closet_appearance = /decl/closet_appearance/secure_closet/hydroponics/xenoflora

/obj/structure/closet/secure_closet/hydroponics/sci/WillContain()
	. = ..()
	. += /obj/item/clothing/head/bio_hood/scientist
	. += /obj/item/clothing/suit/bio_suit/scientist
	. += /obj/item/clothing/mask/
