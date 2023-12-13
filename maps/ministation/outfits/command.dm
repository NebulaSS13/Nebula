/decl/hierarchy/outfit/job/ministation/captain
	name = "Ministation - Job - Captain"
	head = /obj/item/clothing/head/caphat
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/captain
	l_ear = /obj/item/radio/headset/heads/captain
	shoes = /obj/item/clothing/shoes/color/brown
	id_type = /obj/item/card/id/gold
	pda_type = /obj/item/modular_computer/pda/heads/captain

/decl/hierarchy/outfit/job/ministation/captain/Initialize()
	. = ..()
	backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/storage/backpack/captain
	backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/storage/backpack/satchel/cap
	backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/storage/backpack/messenger/com

/decl/hierarchy/outfit/job/ministation/captain/post_equip(var/mob/living/carbon/human/H)
	..()
	if(H.get_age() > 20)
		// Since we can have something other than the default uniform at this
		// point, check if we can actually attach the medal
		var/obj/item/clothing/uniform = H.get_equipped_item(slot_w_uniform_str)
		if(istype(uniform))
			var/obj/item/clothing/accessory/medal/gold/medal = new()
			if(uniform.can_attach_accessory(medal))
				uniform.attach_accessory(null, medal)
			else
				qdel(medal)

/decl/hierarchy/outfit/job/ministation/hop
	name = "Ministation - Job - Lieutenant"
	uniform = /obj/item/clothing/under/head_of_personnel
	l_ear = /obj/item/radio/headset/heads/hop
	shoes = /obj/item/clothing/shoes/color/brown
	r_pocket = /obj/item/gun/energy/taser
	hands = list(/obj/item/clothing/suit/armor/bulletproof)
	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/modular_computer/pda/heads/hop
	backpack_contents = list(/obj/item/storage/box/ids = 1)
