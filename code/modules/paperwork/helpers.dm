/**Tries to find a readily accessible pen in the user's held items, and in some of its inventory. */
/proc/get_accessible_pen(var/mob/user)
	//We might save a few loop iterations by just looking in the active hand first
	var/obj/item/I = user.get_active_hand()
	if(IS_PEN(I))
		return I

	//Look if we're holding a pen elsewhere
	for(I in user.get_held_items()) 
		if(IS_PEN(I))
			return I

	//Try looking if we got a rig module with integrated pen
	var/obj/item/rig/r = usr.get_equipped_item(slot_back_str)
	if(istype(r))
		var/obj/item/rig_module/device/pen/m = locate(/obj/item/rig_module/device/pen) in r.installed_modules
		if(!r.offline && m)
			return m.device

	//Look for other slots
	var/static/list/PEN_CHECK_SLOTS = list(slot_l_ear_str, slot_r_ear_str, slot_l_store_str, slot_r_store_str, slot_s_store_str)
	for(var/slot in PEN_CHECK_SLOTS)
		I = usr.get_equipped_item(slot)
		if(IS_PEN(I))
			return I

/**Handles topic interactions shared by folders and clipboard.*/
/proc/handle_paper_stack_shared_topics(var/mob/user, var/list/href_list)
	if(href_list["rename"])
		var/obj/item/O = locate(href_list["rename"])
		if(istype(O, /obj/item/paper))
			var/obj/item/paper/to_rename = O
			to_rename.rename()
			. = TOPIC_REFRESH

		else if(istype(O, /obj/item/photo))
			var/obj/item/photo/to_rename = O
			to_rename.rename()
			. = TOPIC_REFRESH

		else if(istype(O, /obj/item/paper_bundle))
			var/obj/item/paper_bundle/to_rename = O
			to_rename.rename()
			. = TOPIC_REFRESH

	else if(href_list["examine"])
		var/obj/item/P = locate(href_list["examine"])
		if(istype(P, /obj/item/paper))
			var/obj/item/paper/PP = P
			PP.attack_self(user)
			. = TOPIC_HANDLED
			
		else if(istype(P, /obj/item/photo))
			var/obj/item/photo/PP = P
			PP.attack_self(user)
			. = TOPIC_HANDLED

		else if(istype(P, /obj/item/paper_bundle))
			var/obj/item/paper_bundle/PP = P
			PP.attack_self(user)
			. = TOPIC_HANDLED
