/decl/outfit/nanotrasen
	abstract_type = /decl/outfit/nanotrasen
	uniform = /obj/item/clothing/costume/centcom
	shoes = /obj/item/clothing/shoes/dress
	gloves = /obj/item/clothing/gloves
	l_ear = /obj/item/radio/headset/heads/hop
	glasses = /obj/item/clothing/glasses/sunglasses
	id_slot = slot_wear_id_str
	id_type = /obj/item/card/id/centcom/station
	pda_slot = slot_r_store_str
	pda_type = /obj/item/modular_computer/pda/heads

/decl/outfit/nanotrasen/representative
	name = "Corporate Representative"
	belt = /obj/item/clipboard
	id_pda_assignment = "Corporate Representative"

/decl/outfit/nanotrasen/officer
	name = "Corporate Officer"
	head = /obj/item/clothing/head/beret/corp/centcom/officer
	l_ear = /obj/item/radio/headset/heads/captain
	belt = /obj/item/gun/energy
	id_pda_assignment = "Corporate Officer"

/decl/outfit/nanotrasen/captain
	name = "Corporate Captain"
	uniform = /obj/item/clothing/costume/centcom_captain
	l_ear = /obj/item/radio/headset/heads/captain
	head = /obj/item/clothing/head/beret/corp/centcom/captain
	belt = /obj/item/gun/energy
	id_pda_assignment = "Corporate Captain"

/decl/outfit/nanotrasen/commander
	name = "Corporate Commander"
	head = /obj/item/clothing/head/centhat
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	shoes = /obj/item/clothing/shoes/jackboots/swat
	uniform = /obj/item/clothing/costume/centcom_captain
	suit = /obj/item/clothing/suit/armor/bulletproof
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear =  /obj/item/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/eyepatch
	l_pocket = /obj/item/flame/fuelled/lighter/zippo
	id_pda_assignment = "Corporate Commander"

/decl/outfit/death_command
	name = "Spec Ops - Death commando"

/decl/outfit/death_command/equip_outfit(mob/living/human/H, assignment, equip_adjustments, datum/job/job, datum/mil_rank/rank)
	var/decl/special_role/deathsquad = GET_DECL(/decl/special_role/deathsquad)
	deathsquad.equip_role(H)
	return 1

/decl/outfit/syndicate_command
	name = "Spec Ops - Syndicate commando"

/decl/outfit/syndicate_command/equip_outfit(mob/living/human/H, assignment, equip_adjustments, datum/job/job, datum/mil_rank/rank)
	var/decl/special_role/commandos = GET_DECL(/decl/special_role/deathsquad/mercenary)
	commandos.equip_role(H)
	return 1
