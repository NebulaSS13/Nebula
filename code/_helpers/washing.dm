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
	
	var/obj/item/back = M.get_equipped_item(BP_SHOULDERS)
	if(back && back.clean_blood())
		M.update_inv_back(0)

	//flush away reagents on the skin
	if(M.touching)
		var/remove_amount = M.touching.maximum_volume * M.reagent_permeability() //take off your suit first
		M.touching.remove_any(remove_amount)

	if(!ishuman(M))
		var/obj/item/mask = M.get_equipped_item(BP_MOUTH)
		if(mask && mask.clean_blood())
			M.update_inv_wear_mask(0)
		M.clean_blood()
		return

	var/mob/living/carbon/human/H = M
	var/washgloves = 1
	var/washshoes = 1
	var/washmask = 1
	var/washears = 1
	var/washglasses = 1

	var/obj/item/suit = H.get_equipped_item(BP_BODY)
	if(suit)
		washgloves = !(suit.flags_inv & HIDEGLOVES)
		washshoes = !(suit.flags_inv & HIDESHOES)
		if(suit.clean_blood())
			H.update_inv_wear_suit(0)

	var/obj/item/head = H.get_equipped_item(BP_HEAD)
	if(head)
		washmask = !(head.flags_inv & HIDEMASK)
		washglasses = !(head.flags_inv & HIDEEYES)
		washears = !(head.flags_inv & HIDEEARS)
		if(head.clean_blood())
			H.update_inv_head(0)

	var/obj/item/mask = washing.get_equipped_item(BP_MOUTH)
	if(mask)
		if (washears)
			washears = !(mask.flags_inv & HIDEEARS)
		if (washglasses)
			washglasses = !(mask.flags_inv & HIDEEYES)
		if(washmask && mask.clean_blood())
			H.update_inv_wear_mask(0)

	var/obj/item/uniform = washing.get_equipped_item(BP_CHEST)
	if(!suit && uniform && uniform.clean_blood())
		H.update_inv_w_uniform(0)
	if(H.gloves && washgloves)
		if(H.gloves.clean_blood())
			H.update_inv_gloves(0)
	if(H.shoes && washshoes)
		if(H.shoes.clean_blood())
			H.update_inv_shoes(0)

	var/obj/item/glasses = H.get_equipped_item(BP_EYES)
	if(glasses && washglasses)
		if(glasses.clean_blood())
			H.update_inv_glasses(0)

	if(washears)
		var/update_icon
		var/obj/item/l_ear = H.get_equipped_item(BP_L_EAR)
		if(l_ear && l_ear.clean_blood())
			update_icon = TRUE
		var/obj/item/r_ear = H.get_equipped_item(BP_R_EAR)
		if(r_ear && r_ear.clean_blood())
			update_icon = TRUE
		if(update_icon)
			H.update_inv_ears(FALSE)

	var/obj/item/belt = H.get_equipped_item(BP_GROIN)
	if(belt && belt.clean_blood())
		H.update_inv_belt(0)

	H.clean_blood(washshoes)