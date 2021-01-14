/decl/hierarchy/outfit/job/tradeship/captain
	name = TRADESHIP_OUTFIT_JOB_NAME("Tradehouse Captain")
	uniform = /obj/item/clothing/pants/baggy/casual/classicjeans
	shoes = /obj/item/clothing/shoes/color/black
	pda_type = /obj/item/modular_computer/pda/heads/captain
	r_pocket = /obj/item/radio
	id_type = /obj/item/card/id/gold/tradeship_captain

/decl/hierarchy/outfit/job/tradeship/captain/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.w_uniform
	if(uniform)
		var/obj/item/clothing/accessory/toggleable/hawaii/random/eyegore = new()
		if(uniform.can_attach_accessory(eyegore))
			uniform.attach_accessory(null, eyegore)
		else
			qdel(eyegore)

/decl/hierarchy/outfit/job/tradeship/mate
	name = TRADESHIP_OUTFIT_JOB_NAME("Tradehouse First Mate")
	uniform = /obj/item/clothing/under/suit_jacket/checkered
	shoes = /obj/item/clothing/shoes/dress
	glasses = /obj/item/clothing/glasses/sunglasses/big
	pda_type = /obj/item/modular_computer/pda/cargo
	hands = list(/obj/item/clipboard)
	id_type = /obj/item/card/id/silver/tradeship_first_mate
	pda_type = /obj/item/modular_computer/pda/heads/hop

//id cards
/obj/item/card/id/gold/tradeship_captain
	job_access_type = /datum/job/tradeship_captain

/obj/item/card/id/silver/tradeship_first_mate
	job_access_type = /datum/job/tradeship_first_mate