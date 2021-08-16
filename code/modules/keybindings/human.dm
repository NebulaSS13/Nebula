/decl/keybinding/human
	name = "Human"
	abstract_type = /decl/keybinding/human

/decl/keybinding/human/can_use(client/user)
	return ishuman(user.mob)

/decl/keybinding/human/quick_equip
	hotkey_keys = list("E")
	uid = "keybind_quick_equip"
	name = "Quick Equip"
	description = "Quickly puts an item in the best slot available"

/decl/keybinding/human/quick_equip/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	H.quick_equip()
	return TRUE

/decl/keybinding/human/holster
	hotkey_keys = list("H")
	uid = "keybind_holster"
	name = "Holster"
	description = "Draw or holster weapon"

/decl/keybinding/human/holster/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	if(H.incapacitated())
		return

	var/obj/item/clothing/under/U = H.w_uniform
	for(var/obj/S in U.accessories)
		if(istype(S, /obj/item/clothing/accessory/storage/holster))
			var/datum/extension/holster/E = get_extension(S, /datum/extension/holster)
			if(!E.holstered)
				if(!H.get_active_hand())
					to_chat(H, SPAN_WARNING("You're not holding anything to holster."))
					return
				E.holster(H.get_active_hand(), src)
				return
			else
				E.unholster(H, TRUE)
				return

	if(istype(H.belt, /obj/item/storage/belt/holster))
		var/obj/item/storage/belt/holster/B = H.belt
		var/datum/extension/holster/E = get_extension(B, /datum/extension/holster)
		if(!E.holstered)
			if(!H.get_active_hand())
				to_chat(H, SPAN_WARNING("You're not holding anything to holster."))
				return
			E.holster(H.get_active_hand(), src)
			return
		else
			E.unholster(H, TRUE)
			return

	return TRUE

/decl/keybinding/human/give
	hotkey_keys = list(KEYSTROKE_NONE)
	uid = "keybind_give_item"
	name = "Give Item"
	description = "Give the item you're currently holding"

/decl/keybinding/human/give/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	H.give()
	return TRUE
