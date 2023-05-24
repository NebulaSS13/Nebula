/decl/hierarchy/outfit/job/tradeship/hand/engine
	name = "Tradeship - Job - Junior Engineer"
	head = /obj/item/clothing/head/hardhat
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
	id_type = /obj/item/card/id/tradeship/engineering
	shoes = /obj/item/clothing/shoes/workboots
	hands = list(/obj/item/wrench)
	belt = /obj/item/storage/belt/utility/full
	r_pocket = /obj/item/radio
	l_ear = /obj/item/radio/headset/headset_eng

/obj/item/card/id/tradeship/engineering
	name = "identification card"
	desc = "A card issued to engineering staff."
	detail_color = COLOR_SUN

/decl/hierarchy/outfit/job/tradeship/chief_engineer
	name = "Tradeship - Job - Head Engineer"
	uniform = /obj/item/clothing/under/chief_engineer
	glasses = /obj/item/clothing/glasses/welding/superior
	suit = /obj/item/clothing/suit/storage/hazardvest
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/workboots
	pda_type = /obj/item/modular_computer/pda/heads/ce
	hands = list(/obj/item/wrench)
	belt = /obj/item/storage/belt/utility/full
	id_type = /obj/item/card/id/tradeship/engineering/head
	r_pocket = /obj/item/radio
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
	l_ear = /obj/item/radio/headset/heads/ce

/obj/item/card/id/tradeship/engineering/head
	name = "identification card"
	desc = "A card which represents creativity and ingenuity."
	extra_details = list("goldstripe")
