/decl/hierarchy/outfit/spec_op_officer
	name = "Spec Ops - Officer"
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/officer
	l_ear = /obj/item/radio/headset/ert
	glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
	head = /obj/item/clothing/head/beret
	belt = /obj/item/gun/energy/pulse_pistol
	back = /obj/item/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/jackboots/swat/combat
	gloves = /obj/item/clothing/gloves/thick/combat

	id_slot = slot_wear_id_str
	id_type = /obj/item/card/id/centcom/ERT
	id_desc = "Special operations ID."
	id_pda_assignment = "Special Operations Officer"

/decl/hierarchy/outfit/spec_op_officer/space
	name = "Spec Ops - Officer in space"
	suit = /obj/item/clothing/suit/space/void/swat
	back = /obj/item/tank/jetpack/oxygen
	mask = /obj/item/clothing/mask/gas/swat

	flags = OUTFIT_HAS_JETPACK|OUTFIT_RESET_EQUIPMENT

/decl/hierarchy/outfit/ert
	name = "Spec Ops - Emergency response team"
	uniform = /obj/item/clothing/under/syndicate/combat
	shoes = /obj/item/clothing/shoes/jackboots/swat
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/radio/headset/ert
	belt = /obj/item/gun/energy/gun
	glasses = /obj/item/clothing/glasses/sunglasses
	back = /obj/item/storage/backpack/satchel
	pda_type = /obj/item/modular_computer/pda/ert

	id_slot = slot_wear_id_str
	id_type = /obj/item/card/id/centcom/ERT

/decl/hierarchy/outfit/mercenary
	name = "Spec Ops - Mercenary"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/jackboots/swat/combat
	l_ear = /obj/item/radio/headset/mercenary
	belt = /obj/item/storage/belt/holster/security
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/thick/swat
	l_pocket = /obj/item/chems/pill/cyanide
	pda_type = /obj/item/modular_computer/pda/mercenary
	id_slot = slot_wear_id_str
	id_type = /obj/item/card/id/syndicate
	id_pda_assignment = "Mercenary"

	backpack_contents = list(/obj/item/clothing/suit/space/void/merc/prepared = 1, /obj/item/clothing/mask/gas/syndicate = 1)

	flags = OUTFIT_HAS_BACKPACK|OUTFIT_RESET_EQUIPMENT

/decl/hierarchy/outfit/mercenary/syndicate
	name = "Spec Ops - Syndicate"
	suit = /obj/item/clothing/suit/armor/vest
	mask = /obj/item/clothing/mask/gas
	head = /obj/item/clothing/head/helmet/swat
	shoes = /obj/item/clothing/shoes/jackboots/swat
	id_desc = "Syndicate Operative"

/decl/hierarchy/outfit/mercenary/syndicate/commando
	name = "Spec Ops - Syndicate Commando"
	suit = /obj/item/clothing/suit/space/void/merc
	mask = /obj/item/clothing/mask/gas/syndicate
	head = /obj/item/clothing/head/helmet/space/void/merc
	back = /obj/item/tank/jetpack/oxygen
	l_pocket = /obj/item/tank/emergency/oxygen
