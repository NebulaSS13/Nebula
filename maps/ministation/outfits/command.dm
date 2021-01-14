/decl/hierarchy/outfit/job/ministation/captain
	name = MINISTATION_OUTFIT_JOB_NAME("Captain")
	head = /obj/item/clothing/head/caphat
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/captain
	l_ear = /obj/item/radio/headset/heads/captain
	shoes = /obj/item/clothing/shoes/color/brown
	id_type = /obj/item/card/id/gold/ministation
	pda_type = /obj/item/modular_computer/pda/heads/captain

/decl/hierarchy/outfit/job/ministation/captain/New()
	..()
	backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/storage/backpack/captain
	backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/storage/backpack/satchel/cap
	backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/storage/backpack/messenger/com

/decl/hierarchy/outfit/job/captain/post_equip(var/mob/living/carbon/human/H)
	..()
	if(H.age>49)
		// Since we can have something other than the default uniform at this
		// point, check if we can actually attach the medal
		var/obj/item/clothing/uniform = H.w_uniform
		if(uniform)
			var/obj/item/clothing/accessory/medal/gold/medal = new()
			if(uniform.can_attach_accessory(medal))
				uniform.attach_accessory(null, medal)
			else
				qdel(medal)

/obj/item/card/id/gold/ministation
	job_access_type = /datum/job/ministation/captain

/decl/hierarchy/outfit/job/ministation/hop
	name = MINISTATION_OUTFIT_JOB_NAME("Lieutenant")
	uniform = /obj/item/clothing/under/head_of_personnel
	l_ear = /obj/item/radio/headset/heads/hop
	shoes = /obj/item/clothing/shoes/color/brown
	id_type = /obj/item/card/id/silver/ministation
	pda_type = /obj/item/modular_computer/pda/heads/hop
	backpack_contents = list(/obj/item/storage/box/ids = 1)

/obj/item/card/id/silver/ministation
	job_access_type = /datum/job/ministation/hop