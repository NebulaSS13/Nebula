
/decl/hierarchy/outfit/job/generic
	hierarchy_type = /decl/hierarchy/outfit/job/generic
	id_type = /obj/item/card/id/civilian

/decl/hierarchy/outfit/job/generic/scientist
	name = OUTFIT_JOB_NAME("Default Scientist")
	l_ear = /obj/item/radio/headset/headset_sci
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	shoes = /obj/item/clothing/shoes/color/white
	pda_type = /obj/item/modular_computer/pda/science
	uniform = /obj/item/clothing/under/color/white

/decl/hierarchy/outfit/job/generic/engineer
	name = OUTFIT_JOB_NAME("Default Engineer")
	head = /obj/item/clothing/head/hardhat
	uniform = /obj/item/clothing/under/engineer
	r_pocket = /obj/item/t_scanner
	belt = /obj/item/storage/belt/utility/full
	l_ear = /obj/item/radio/headset/headset_eng
	shoes = /obj/item/clothing/shoes/workboots
	pda_type = /obj/item/modular_computer/pda/engineering
	pda_slot = slot_l_store_str
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/generic/engineer/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/generic/doctor
	name = OUTFIT_JOB_NAME("Default Doctor")
	uniform = /obj/item/clothing/under/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	hands = list(/obj/item/storage/firstaid/adv)
	r_pocket = /obj/item/flashlight/pen
	l_ear = /obj/item/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/color/white
	pda_type = /obj/item/modular_computer/pda/medical
	pda_slot = slot_l_store_str

/decl/hierarchy/outfit/job/generic/doctor/New()
	..()
	BACKPACK_OVERRIDE_MEDICAL

/decl/hierarchy/outfit/job/generic/chef
	name = OUTFIT_JOB_NAME("Default Chef")
	l_ear = /obj/item/radio/headset/headset_service
	uniform = /obj/item/clothing/under/chef
	suit = /obj/item/clothing/suit/chef
	head = /obj/item/clothing/head/chefhat
	pda_type = /obj/item/modular_computer/pda
