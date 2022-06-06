/proc/wash_mob(var/mob/living/washing)

	if(!istype(washing))
		return

	var/mob/living/L = washing

	if(L.on_fire)
		L.visible_message("<span class='danger'>A cloud of steam rises up as the water hits \the [L]!</span>")
		L.ExtinguishMob()

	L.fire_stacks = -20 //Douse ourselves with water to avoid fire more easily

	if(!iscarbon(washing))
		washing.clean_blood()
		return

	var/mob/living/carbon/M = washing
	for(var/obj/item/thing in M.get_held_items())
		thing.clean_blood()

	var/obj/item/back = M.get_equipped_item(slot_back_str)
	if(back)
		back.clean_blood()

	//flush away reagents on the skin
	var/datum/reagents/touching_reagents = M.get_contact_reagents()
	if(touching_reagents)
		var/remove_amount = touching_reagents.maximum_volume * M.reagent_permeability() //take off your suit first
		touching_reagents.remove_any(remove_amount)

	if(!ishuman(M))
		var/obj/item/mask = M.get_equipped_item(slot_wear_mask_str)
		if(mask)
			mask.clean_blood()
		M.clean_blood()
		return

	var/mob/living/carbon/human/H = M
	var/washgloves = 1
	var/washshoes = 1
	var/washmask = 1
	var/washears = 1
	var/washglasses = 1

	var/obj/item/suit = H.get_equipped_item(slot_wear_suit_str)
	if(suit)
		washgloves = !(suit.flags_inv & HIDEGLOVES)
		washshoes = !(suit.flags_inv & HIDESHOES)

	var/obj/item/head = H.get_equipped_item(slot_head_str)
	if(head)
		washmask = !(head.flags_inv & HIDEMASK)
		washglasses = !(head.flags_inv & HIDEEYES)
		washears = !(head.flags_inv & HIDEEARS)

	var/obj/item/mask = M.get_equipped_item(slot_wear_mask_str)
	if(mask)
		if (washears)
			washears = !(mask.flags_inv & HIDEEARS)
		if (washglasses)
			washglasses = !(mask.flags_inv & HIDEEYES)

	if(head)
		head.clean_blood()

	if(suit)
		suit.clean_blood()
	else
		var/obj/item/uniform = H.get_equipped_item(slot_w_uniform_str)
		if(uniform)
			uniform.clean_blood()

	if(washgloves)
		var/obj/item/gloves = H.get_equipped_item(slot_gloves_str)
		if(gloves)
			gloves.clean_blood()

	var/obj/item/shoes = H.get_equipped_item(slot_shoes_str)
	if(shoes && washshoes)
		shoes.clean_blood()
	if(mask && washmask)
		mask.clean_blood()
	if(washglasses)
		var/obj/item/glasses = H.get_equipped_item(slot_glasses_str)
		if(glasses)
			glasses.clean_blood()

	if(washears)
		var/obj/item/ear = H.get_equipped_item(slot_l_ear_str)
		if(ear)
			ear.clean_blood()
		ear = H.get_equipped_item(slot_r_ear_str)
		if(ear)
			ear.clean_blood()

	var/obj/item/belt = H.get_equipped_item(slot_belt_str)
	if(belt)
		belt.clean_blood()
	H.clean_blood(washshoes)
