/decl/outfit/mercenary
	name = "Spec Ops - Mercenary"
	uniform = /obj/item/clothing/pants/casual/camo/outfit
	shoes = /obj/item/clothing/shoes/jackboots/swat/combat
	l_ear = /obj/item/radio/headset/mercenary
	belt = /obj/item/belt/holster/security
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/thick/swat
	l_pocket = /obj/item/chems/pill/cyanide
	pda_type = /obj/item/modular_computer/pda/mercenary
	id_slot = slot_wear_id_str
	id_type = /obj/item/card/id/syndicate
	id_pda_assignment = "Mercenary"

	backpack_contents = list(/obj/item/clothing/suit/space/void/merc/prepared = 1, /obj/item/clothing/mask/gas/syndicate = 1)

	outfit_flags = OUTFIT_HAS_BACKPACK|OUTFIT_RESET_EQUIPMENT

/decl/outfit/mercenary/syndicate
	name = "Spec Ops - Syndicate"
	suit = /obj/item/clothing/suit/armor/vest
	mask = /obj/item/clothing/mask/gas
	head = /obj/item/clothing/head/helmet/swat
	shoes = /obj/item/clothing/shoes/jackboots/swat
	id_desc = "Syndicate Operative"

/decl/outfit/mercenary/syndicate/commando
	name = "Spec Ops - Syndicate Commando"
	suit = /obj/item/clothing/suit/space/void/merc
	mask = /obj/item/clothing/mask/gas/syndicate
	head = /obj/item/clothing/head/helmet/space/void/merc
	back = /obj/item/tank/jetpack/oxygen
	l_pocket = /obj/item/tank/emergency/oxygen
