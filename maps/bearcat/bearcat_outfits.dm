// OUTFITS
#define BEARCAT_OUTFIT_JOB_NAME(job_name) ("Bearcat - Job - " + job_name)

/decl/hierarchy/outfit/job/bearcat
	hierarchy_type = /decl/hierarchy/outfit/job/bearcat
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store
	l_ear = null
	r_ear = null

/decl/hierarchy/outfit/job/bearcat/captain
	name = BEARCAT_OUTFIT_JOB_NAME("Captain")
	uniform = /obj/item/clothing/under/casual_pants/classicjeans
	shoes = /obj/item/clothing/shoes/color/black
	pda_type = /obj/item/modular_computer/pda/captain
	r_pocket = /obj/item/radio
	id_type = /obj/item/card/id/gold/bearcat_captain

/obj/item/card/id/gold/bearcat_captain
	job_access_type = /datum/job/bearcat_captain

/decl/hierarchy/outfit/job/bearcat/captain/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/toggleable/hawaii/random/eyegore = new()
		if(uniform.can_attach_accessory(eyegore))
			uniform.attach_accessory(null, eyegore)
		else
			qdel(eyegore)

/decl/hierarchy/outfit/job/bearcat/chief_engineer
	name = BEARCAT_OUTFIT_JOB_NAME("Chief Engineer")
	uniform = /obj/item/clothing/under/rank/chief_engineer
	glasses = /obj/item/clothing/glasses/welding/superior
	suit = /obj/item/clothing/suit/storage/hazardvest
	gloves = /obj/item/clothing/gloves/thick
	shoes = /obj/item/clothing/shoes/workboots
	pda_type = /obj/item/modular_computer/pda/heads/ce
	l_hand = /obj/item/wrench
	belt = /obj/item/storage/belt/utility/full
	id_type = /obj/item/card/id/bearcat_engineering
	r_pocket = /obj/item/radio
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/obj/item/card/id/bearcat_engineering
	name = "identification card"
	desc = "A card which represents creativity and ingenuity."
	job_access_type = /datum/job/bearcat_chief_engineer
	extra_details = list("goldstripe")
	detail_color = COLOR_SUN

/decl/hierarchy/outfit/job/bearcat/doc
	name = BEARCAT_OUTFIT_JOB_NAME("Ship's Doc")
	uniform = /obj/item/clothing/under/det/black
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	pda_type = /obj/item/modular_computer/pda/medical

/decl/hierarchy/outfit/job/bearcat/mate
	name = BEARCAT_OUTFIT_JOB_NAME("First Mate")
	uniform = /obj/item/clothing/under/suit_jacket/checkered
	shoes = /obj/item/clothing/shoes/laceup
	glasses = /obj/item/clothing/glasses/sunglasses/big
	pda_type = /obj/item/modular_computer/pda/cargo
	l_hand = /obj/item/material/clipboard

/decl/hierarchy/outfit/job/bearcat/hand
	name = BEARCAT_OUTFIT_JOB_NAME("Deck Hand")

/decl/hierarchy/outfit/job/bearcat/hand/pre_equip(mob/living/carbon/human/H)
	..()
	uniform = pick(list(/obj/item/clothing/under/overalls,/obj/item/clothing/under/rank/corp/focal,/obj/item/clothing/under/hazard,/obj/item/clothing/under/rank/cargotech,/obj/item/clothing/under/color/black,/obj/item/clothing/under/color/grey,/obj/item/clothing/under/casual_pants/track))

/decl/hierarchy/outfit/job/bearcat/hand/cook
	name = BEARCAT_OUTFIT_JOB_NAME("Cook")
	head = /obj/item/clothing/head/chefhat
	suit = /obj/item/clothing/suit/chef/classic

/decl/hierarchy/outfit/job/bearcat/hand/engine
	name = BEARCAT_OUTFIT_JOB_NAME("Junior Engineer")
	head = /obj/item/clothing/head/hardhat
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/bearcat/hand/engine/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(50))
		suit = /obj/item/clothing/suit/storage/hazardvest