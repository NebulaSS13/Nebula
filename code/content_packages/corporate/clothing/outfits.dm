/decl/hierarchy/outfit/nanotrasen
	hierarchy_type = /decl/hierarchy/outfit/nanotrasen
	uniform = /obj/item/clothing/under/rank/centcom
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/white
	l_ear = /obj/item/radio/headset/heads/hop
	glasses = /obj/item/clothing/glasses/sunglasses

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/centcom/station
	pda_slot = slot_r_store
	pda_type = /obj/item/modular_computer/pda/heads

/decl/hierarchy/outfit/nanotrasen/representative
	name = "Corporate Representative"
	belt = /obj/item/material/clipboard
	id_pda_assignment = "Corporate Representative"

/decl/hierarchy/outfit/nanotrasen/officer
	name = "Corporate Officer"
	head = /obj/item/clothing/head/beret/centcom/officer
	l_ear = /obj/item/radio/headset/heads/captain
	belt = /obj/item/gun/energy
	id_pda_assignment = "Corporate Officer"

/decl/hierarchy/outfit/nanotrasen/captain
	name = "Corporate Captain"
	uniform = /obj/item/clothing/under/rank/centcom_captain
	l_ear = /obj/item/radio/headset/heads/captain
	head = /obj/item/clothing/head/beret/centcom/captain
	belt = /obj/item/gun/energy
	id_pda_assignment = "Corporate Captain"

/decl/hierarchy/outfit/nanotrasen/commander
	name = "Corporate Commander"
	head = /obj/item/clothing/head/centhat
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	shoes = /obj/item/clothing/shoes/swat
	uniform = /obj/item/clothing/under/rank/centcom_captain
	suit = /obj/item/clothing/suit/armor/bulletproof
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear =  /obj/item/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/eyepatch
	l_pocket = /obj/item/flame/lighter/zippo
	id_pda_assignment = "Corporate Commander"

/decl/hierarchy/outfit/death_command
	name = "Spec Ops - Death commando"

/decl/hierarchy/outfit/death_command/equip(mob/living/carbon/human/H, rank, assignment, equip_adjustments)
	GLOB.deathsquad.equip(H)
	return 1

/decl/hierarchy/outfit/syndicate_command
	name = "Spec Ops - Syndicate commando"

/decl/hierarchy/outfit/syndicate_command/equip(mob/living/carbon/human/H, rank, assignment, equip_adjustments)
	GLOB.commandos.equip(H)
	return 1
