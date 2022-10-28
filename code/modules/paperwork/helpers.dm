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
