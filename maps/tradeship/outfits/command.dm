/decl/hierarchy/outfit/job/tradeship/captain
	name = "Tradeship - Job - Tradehouse Captain"
	uniform = /obj/item/clothing/pants/baggy/casual/classicjeans
	shoes = /obj/item/clothing/shoes/color/black
	pda_type = /obj/item/modular_computer/pda/heads/captain
	r_pocket = /obj/item/radio
	id_type = /obj/item/card/id/gold
	l_ear = /obj/item/radio/headset/heads/captain

/decl/hierarchy/outfit/job/tradeship/captain/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/clothing/uniform = H.get_equipped_item(slot_w_uniform_str)
	if(uniform)
		var/obj/item/clothing/accessory/toggleable/hawaii/random/eyegore = new()
		if(uniform.can_attach_accessory(eyegore))
			uniform.attach_accessory(null, eyegore)
		else
			qdel(eyegore)

/decl/hierarchy/outfit/job/tradeship/mate
	name = "Tradeship - Job - Tradehouse First Mate"
	uniform = /obj/item/clothing/under/suit_jacket/checkered
	shoes = /obj/item/clothing/shoes/dress
	glasses = /obj/item/clothing/glasses/sunglasses/big
	pda_type = /obj/item/modular_computer/pda/cargo
	hands = list(/obj/item/clipboard)
	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/modular_computer/pda/heads/hop
	l_ear = /obj/item/radio/headset/heads/hop
