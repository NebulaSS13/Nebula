//Jackets with buttons, used for labcoats, IA jackets, First Responder jackets, and brown jackets.
/obj/item/clothing/suit/storage/toggle
	var/buttons // null means no toggle, TRUE means unbuttoned, FALSE means buttoned closed. Set during Initialize() based on icon
	var/obj/item/clothing/head/hood

/obj/item/clothing/suit/storage/toggle/Initialize()
	if(check_state_in_icon("[icon_state]_open", icon))
		buttons = TRUE
	if(ispath(hood))
		hood = new hood(src)
	. = ..()

/obj/item/clothing/suit/storage/toggle/Destroy()
	if(istype(hood))
		QDEL_NULL(hood)
	return ..()

/obj/item/clothing/suit/storage/toggle/examine(mob/user)
	. = ..()
	if(hood || !isnull(buttons))
		var/alt_interaction_string = "buttons"
		if(hood && !isnull(buttons))
			alt_interaction_string = "hood or buttons"
		else if(hood)
			alt_interaction_string = "hood"
		to_chat(user, SPAN_SUBTLE("Use alt-click to toggle this coat's [alt_interaction_string]."))

/obj/item/clothing/suit/storage/toggle/equipped(mob/user, slot)
	if(slot != slot_wear_suit_str)
		remove_hood()
	. = ..()

/obj/item/clothing/suit/storage/toggle/dropped()
	. = ..()
	remove_hood()

/obj/item/clothing/suit/storage/toggle/proc/remove_hood()
	if(!hood || hood.loc == src)
		return
	if(ismob(hood.loc))
		var/mob/M = hood.loc
		M.drop_from_inventory(hood)
	hood.forceMove(src)
	update_clothing_icon()

/obj/item/clothing/suit/storage/toggle/proc/toggle_buttons(var/mob/user)
	if(!CanPhysicallyInteract(usr) || isnull(buttons))
		return FALSE
	buttons = !buttons
	if(user)
		to_chat(user, SPAN_NOTICE("You [buttons ? "unbutton" : "button up"] \the [src]."))
	update_icon()
	update_clothing_icon()	//so our overlays update

/obj/item/clothing/suit/storage/toggle/on_update_icon()
	. = ..()
	if(buttons)
		icon_state = "[get_world_inventory_state()]_open"
	else
		icon_state = get_world_inventory_state()

/obj/item/clothing/suit/storage/toggle/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_offset = FALSE)
	if(buttons && overlay && check_state_in_icon("[overlay.icon_state]_open", overlay.icon))
		overlay.icon_state = "[overlay.icon_state]_open"
	. = ..()

/obj/item/clothing/suit/storage/toggle/proc/toggle_hood(var/mob/user)
	if(!ismob(loc) || !hood)
		remove_hood()
		return FALSE
	var/mob/M = loc
	if(M.get_equipped_item(slot_wear_suit_str) != src)
		if(user)
			to_chat(user, SPAN_WARNING("You must be wearing \the [src] to put up the hood!"))
		return FALSE
	var/wearing_head = M.get_equipped_item(slot_head_str)
	if(wearing_head && wearing_head != hood)
		if(user)
			to_chat(user, SPAN_WARNING("You're already wearing something on your head!"))
		return FALSE
	if(wearing_head)
		remove_hood()
	else
		M.equip_to_slot_if_possible(hood, slot_head_str, 0, 0, 1)
	update_clothing_icon()
	return TRUE

// Short-circuit this for quick interaction when worn.
/obj/item/clothing/suit/storage/toggle/AltClick(var/mob/user)
	if(user.get_equipped_item(slot_wear_suit_str) == src)
		if(isnull(buttons) && hood)
			toggle_hood(user)
			return TRUE
		if(!hood && !isnull(buttons))
			toggle_buttons(user)
			return TRUE
	return ..()

/obj/item/clothing/suit/storage/toggle/get_alt_interactions(var/mob/user)
	. = ..()
	if(!isnull(buttons))
		LAZYADD(., /decl/interaction_handler/toggle_buttons)
	if(hood)
		LAZYADD(., /decl/interaction_handler/toggle_hood)

/decl/interaction_handler/toggle_buttons
	name = "Toggle Coat Buttons"
	expected_target_type = /obj/item/clothing/suit/storage/toggle

/decl/interaction_handler/toggle_buttons/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/item/clothing/suit/storage/toggle/coat = target
	coat.toggle_buttons(user)

/decl/interaction_handler/toggle_hood
	name = "Toggle Coat Hood"
	expected_target_type = /obj/item/clothing/suit/storage/toggle

/decl/interaction_handler/toggle_hood/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/item/clothing/suit/storage/toggle/coat = target
	coat.toggle_hood(user)

/obj/item/clothing/suit/storage/toggle/wintercoat
	name = "winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs."
	icon = 'icons/clothing/suit/wintercoat/coat.dmi'
	body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	armor = list(
		ARMOR_BIO = ARMOR_BIO_MINOR
		)
	hood = /obj/item/clothing/head/winterhood
	allowed = list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight,/obj/item/storage/box/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/chems/drinks/flask)
	siemens_coefficient = 0.6
	protects_against_weather = TRUE

/obj/item/clothing/head/winterhood
	name = "winter hood"
	desc = "A hood attached to a heavy winter jacket."
	icon = 'icons/clothing/head/hood_winter.dmi'
	body_parts_covered = SLOT_HEAD
	cold_protection = SLOT_HEAD
	flags_inv = HIDEEARS | BLOCK_HEAD_HAIR
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	protects_against_weather = TRUE

/obj/item/clothing/suit/storage/toggle/wintercoat/captain
	name = "captain's winter coat"
	icon = 'icons/clothing/suit/wintercoat/captain.dmi'
	hood = /obj/item/clothing/head/winterhood/captain
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_MINOR,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_MINOR
	)

/obj/item/clothing/head/winterhood/captain
	icon = 'icons/clothing/head/hood_winter_captain.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/security
	name = "security winter coat"
	icon = 'icons/clothing/suit/wintercoat/sec.dmi'
	hood = /obj/item/clothing/head/winterhood/security
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_KNIVES,
		ARMOR_BULLET = ARMOR_BALLISTIC_SMALL,
		ARMOR_LASER = ARMOR_LASER_SMALL,
		ARMOR_ENERGY = ARMOR_ENERGY_MINOR,
		ARMOR_BOMB = ARMOR_BOMB_MINOR
	)

/obj/item/clothing/head/winterhood/security
	icon = 'icons/clothing/head/hood_winter_sec.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/medical
	name = "medical winter coat"
	icon = 'icons/clothing/suit/wintercoat/med.dmi'
	hood = /obj/item/clothing/head/winterhood/medical
	armor = list(
		ARMOR_BIO = ARMOR_BIO_RESISTANT
	)

/obj/item/clothing/head/winterhood/medical
	icon = 'icons/clothing/head/hood_winter_med.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/science
	name = "science winter coat"
	icon = 'icons/clothing/suit/wintercoat/sci.dmi'
	hood = /obj/item/clothing/head/winterhood/science
	armor = list(
		ARMOR_BOMB = ARMOR_BOMB_MINOR
	)

/obj/item/clothing/head/winterhood/science
	icon = 'icons/clothing/head/hood_winter_sci.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/engineering
	name = "engineering winter coat"
	icon = 'icons/clothing/suit/wintercoat/eng.dmi'
	hood = /obj/item/clothing/head/winterhood/engineering
	armor = list(
		ARMOR_RAD = ARMOR_RAD_MINOR
	)

/obj/item/clothing/head/winterhood/engineering
	icon = 'icons/clothing/head/hood_winter_eng.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/engineering/atmos
	name = "atmospherics winter coat"
	hood = /obj/item/clothing/head/winterhood/atmos
	icon = 'icons/clothing/suit/wintercoat/atmos.dmi'

/obj/item/clothing/head/winterhood/atmos
	icon = 'icons/clothing/head/hood_winter_atmos.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/hydro
	name = "hydroponics winter coat"
	hood = /obj/item/clothing/head/winterhood/hydroponics
	icon = 'icons/clothing/suit/wintercoat/hydro.dmi'

/obj/item/clothing/head/winterhood/hydroponics
	icon = 'icons/clothing/head/hood_winter_hydro.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/cargo
	name = "cargo winter coat"
	hood = /obj/item/clothing/head/winterhood/cargo
	icon = 'icons/clothing/suit/wintercoat/cargo.dmi'

/obj/item/clothing/head/winterhood/cargo
	icon = 'icons/clothing/head/hood_winter_cargo.dmi'

/obj/item/clothing/suit/storage/toggle/wintercoat/miner
	name = "mining winter coat"
	hood = /obj/item/clothing/head/winterhood/mining
	icon = 'icons/clothing/suit/wintercoat/mining.dmi'
	armor = list(
		ARMOR_MELEE = ARMOR_MELEE_SMALL
	)

/obj/item/clothing/head/winterhood/mining
	icon = 'icons/clothing/head/hood_winter_mining.dmi'

/obj/item/clothing/suit/storage/toggle/hoodie
	name = "hoodie"
	desc = "A warm sweatshirt."
	icon = 'icons/clothing/suit/hoodie.dmi'
	min_cold_protection_temperature = T0C - 20
	cold_protection = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_ARMS
	action_button_name = "Toggle Hood"
	hood = /obj/item/clothing/head/hoodiehood

/obj/item/clothing/head/hoodiehood
	name = "hoodie hood"
	desc = "A hood attached to a warm sweatshirt."
	icon = 'icons/clothing/head/hood.dmi'
	body_parts_covered = SLOT_HEAD
	min_cold_protection_temperature = T0C - 20
	cold_protection = SLOT_HEAD
	flags_inv = HIDEEARS | BLOCK_HEAD_HAIR
