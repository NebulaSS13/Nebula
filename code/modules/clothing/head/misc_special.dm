/*
 * Contents:
 *		Welding mask
 *		Cakehat
 *		Ushanka
 *		Pumpkin head
 *		Kitty ears
 *
 */

/*
 * Welding mask
 */
/obj/item/clothing/head/welding
	name = "welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/head/welding/default.dmi'
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	armor = list(
		melee = ARMOR_MELEE_SMALL
	)
	flags_inv = (HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	action_button_name = "Flip Welding Mask"
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_NORMAL
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY
	var/up = 0
	var/base_state

/obj/item/clothing/head/welding/attack_self()
	if(!base_state)
		base_state = icon_state
	toggle()

/obj/item/clothing/head/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding mask"
	set src in usr

	if(CanPhysicallyInteract(usr))
		if(src.up)
			src.up = !src.up
			body_parts_covered |= (SLOT_EYES|SLOT_FACE)
			flags_inv |= (HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			to_chat(usr, "You flip the [src] down to protect your eyes.")
		else
			src.up = !src.up
			body_parts_covered &= ~(SLOT_EYES|SLOT_FACE)
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			flags_inv &= ~(HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE)
			to_chat(usr, "You push the [src] up out of your face.")
		update_icon()
		update_vision()
		usr.update_action_buttons()

/obj/item/clothing/head/welding/on_update_icon()
	..()
	icon_state = get_world_inventory_state()
	if(up && check_state_in_icon("[icon_state]_up", icon))
		icon_state = "[icon_state]_up"
	update_clothing_icon()	//so our mob-overlays

/obj/item/clothing/head/welding/experimental_mob_overlay()
	var/image/ret = ..()
	if(up && check_state_in_icon("[ret.icon_state]_up", icon))
		ret.icon_state = "[ret.icon_state]_up"
	return ret

/obj/item/clothing/head/welding/demon
	name = "demonic welding helmet"
	desc = "A painted welding helmet, this one has a demonic face on it."
	icon = 'icons/clothing/head/welding/demon.dmi'

/obj/item/clothing/head/welding/knight
	name = "knightly welding helmet"
	desc = "A painted welding helmet, this one looks like a knights helmet."
	icon = 'icons/clothing/head/welding/knight.dmi'

/obj/item/clothing/head/welding/fancy
	name = "fancy welding helmet"
	desc = "A painted welding helmet, the black and gold make this one look very fancy."
	icon = 'icons/clothing/head/welding/fancy.dmi'

/obj/item/clothing/head/welding/engie
	name = "engineering welding helmet"
	desc = "A painted welding helmet, this one has been painted the engineering colours."
	icon = 'icons/clothing/head/welding/engie.dmi'

/obj/item/clothing/head/welding/carp
	name = "carp welding helmet"
	desc = "A painted welding helmet, this one has a carp face on it."
	icon = 'icons/clothing/head/welding/carp.dmi'

/*
 * Ushanka
 */
/obj/item/clothing/head/ushanka
	name = "ushanka"
	desc = "Perfect for winter in Siberia, da?"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/head/ushanka.dmi'
	flags_inv = HIDEEARS|BLOCKHEADHAIR
	cold_protection = SLOT_HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	var/up = FALSE

/obj/item/clothing/head/ushanka/attack_self(mob/user)
	..()
	up = !up
	to_chat(user, "You [up ? "raise" : "lower"] the ear flaps on the ushanka.")
	update_icon()

/obj/item/clothing/head/ushanka/on_update_icon()
	..()
	icon_state = get_world_inventory_state()
	if(up && check_state_in_icon("[icon_state]_up", icon))
		icon_state = "[icon_state]_up"
	update_clothing_icon()

/obj/item/clothing/head/ushanka/experimental_mob_overlay()
	var/image/ret = ..()
	if(up && check_state_in_icon("[ret.icon_state]_up", icon))
		ret.icon_state = "[ret.icon_state]_up"
	return ret

/*
 * Pumpkin head
 */
/obj/item/clothing/head/pumpkinhead
	name = "carved pumpkin"
	desc = "A jack o' lantern! Believed to ward off evil spirits."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/head/pumpkin.dmi'
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	brightness_on = 0.2
	light_overlay = "helmet_light"
	w_class = ITEM_SIZE_NORMAL

/*
 * Kitty ears
 */
/obj/item/clothing/head/kitty
	name = "kitty ears"
	desc = "A pair of kitty ears. Meow!"
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/head/cat.dmi'
	body_parts_covered = 0
	siemens_coefficient = 1.5

/obj/item/clothing/head/richard
	name = "chicken mask"
	desc = "You can hear the distant sounds of rhythmic electronica."
	icon_state = ICON_STATE_WORLD
	icon = 'icons/clothing/head/richard.dmi'
	body_parts_covered = SLOT_HEAD|SLOT_FACE
	flags_inv = BLOCKHAIR
