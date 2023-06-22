/obj/item/modular_computer/pda/wrist
	name = "wrist computer"
	desc = "A wrist-mounted modular personal computer. Very stylish."
	icon = 'mods/content/corporate/icons/obj/wristcomp.dmi'
	screen_icon = 'mods/content/corporate/icons/obj/wristcomp_screens.dmi'

	slot_flags = SLOT_ID | SLOT_LOWER_BODY
	color = COLOR_GUNMETAL
	light_color = LIGHT_COLOR_GREEN

/obj/item/modular_computer/pda/wrist/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay)
		var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
		var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly)
		if(slot == slot_wear_id_str)
			if(assembly?.enabled)
				var/image/I = image(screen_icon, icon_state = "[overlay.icon_state]-screen")
				I.appearance_flags |= RESET_COLOR
				I.color = (assembly.bsod || os?.updating) ? "#0000ff" : "#00ff00"
				overlay.overlays += I
			else
				overlay.overlays += image(screen_icon, icon_state = "[overlay.icon_state]-screen_off")
			for(var/decal in decals)
				var/image/I = image(icon = overlay.icon, icon_state = "[overlay.icon_state]-[decal]")
				I.appearance_flags |= RESET_COLOR
				I.color = decals[decal]
				overlay.overlays += I
	. = ..()

/obj/item/modular_computer/pda/wrist/attack_hand(var/mob/user)
	if(user.check_dexterity(DEXTERITY_KEYBOARDS, TRUE) && loc == user && !user.restrained() && src == user.get_equipped_item(slot_wear_id_str))
		return attack_self(user)
	return ..()

/obj/item/modular_computer/pda/wrist/handle_mouse_drop(atom/over, mob/user)
	if(ishuman(user) && loc == user && user.try_unequip(src))
		user.put_in_hands(src)
		add_fingerprint(usr)
		return TRUE
	. = ..()

// wrist box //

/obj/item/storage/box/wrist
	name = "box of spare wrist computers"
	desc = "A box of spare wrist microcomputers."
	icon_state = "pda"

/obj/item/storage/box/wrist/WillContain()
	return list(/obj/item/modular_computer/pda/wrist = 5)
