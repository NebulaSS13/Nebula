/decl/hierarchy/outfit/job/engineering
	hierarchy_type = /decl/hierarchy/outfit/job/engineering
	belt = /obj/item/storage/belt/utility/full
	l_ear = /obj/item/radio/headset/headset_eng
	shoes = /obj/item/clothing/shoes/workboots
	pda_slot = slot_l_store_str
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/engineering/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/engineering/chief_engineer
	name = OUTFIT_JOB_NAME("Chief Engineer")
	head = /obj/item/clothing/head/hardhat/white
	uniform = /obj/item/clothing/under/chief_engineer
	l_ear = /obj/item/radio/headset/heads/ce
	gloves = /obj/item/clothing/gloves/thick
	id_type = /obj/item/card/id/engineering/head
	pda_type = /obj/item/modular_computer/pda/heads/ce

/decl/hierarchy/outfit/job/engineering/engineer
	name = OUTFIT_JOB_NAME("Engineer")
	head = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/under/engineer
	r_pocket = /obj/item/t_scanner
	id_type = /obj/item/card/id/engineering
	pda_type = /obj/item/modular_computer/pda/engineering

/decl/hierarchy/outfit/job/engineering/atmos
	name = OUTFIT_JOB_NAME("Atmospheric technician")
	uniform = /obj/item/clothing/under/atmospheric_technician
	belt = /obj/item/storage/belt/utility/atmostech
	pda_type = /obj/item/modular_computer/pda/engineering
