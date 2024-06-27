/datum/keybinding/human
	category = CATEGORY_HUMAN

/datum/keybinding/human/can_use(client/user)
	return ishuman(user.mob)

/datum/keybinding/human/quick_equip
	hotkey_keys = list("E")
	name = "quick_equip"
	full_name = "Quick Equip"
	description = "Quickly puts an item in the best slot available"

/datum/keybinding/human/quick_equip/down(client/user)
	var/mob/living/human/H = user.mob
	H.quick_equip()
	return TRUE

/datum/keybinding/human/holster
	hotkey_keys = list("H")
	name = "holster"
	full_name = "Holster"
	description = "Draw or holster weapon"

/datum/keybinding/human/holster/down(client/user)
	var/mob/living/human/H = user.mob
	if(H.incapacitated())
		return

	var/obj/item/clothing/U = H.get_equipped_item(slot_w_uniform_str)
	if(istype(U))
		for(var/obj/S in U.accessories)
			if(istype(S, /obj/item/clothing/webbing/holster))
				var/datum/extension/holster/E = get_extension(S, /datum/extension/holster)
				if(!E.holstered)
					if(!H.get_active_held_item())
						to_chat(H, SPAN_WARNING("You're not holding anything to holster."))
						return
					E.holster(H.get_active_held_item(), H)
				else
					E.unholster(H, TRUE)
				return

	var/obj/item/belt/holster/B = H.get_equipped_item(slot_belt_str)
	if(istype(B))
		var/datum/extension/holster/E = get_extension(B, /datum/extension/holster)
		if(!E.holstered)
			if(!H.get_active_held_item())
				to_chat(H, SPAN_WARNING("You're not holding anything to holster."))
				return
			E.holster(H.get_active_held_item(), H)
		else
			E.unholster(H, TRUE)
		return

	return TRUE

/datum/keybinding/human/give
	hotkey_keys = list("G")
	name = "give_item"
	full_name = "Give Item"
	description = "Give the item you're currently holding"

/datum/keybinding/human/give/down(client/user)
	var/mob/living/human/H = user.mob
	H.give()
	return TRUE
