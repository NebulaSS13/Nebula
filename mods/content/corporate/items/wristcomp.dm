/obj/item/modular_computer/pda/wrist
	name = "wrist computer"
	desc = "A wrist-mounted modular personal computer. Very stylish."
	icon = 'mods/content/corporate/icons/obj/wristcomp.dmi'
	screen_icon = 'mods/content/corporate/icons/obj/wristcomp_screens.dmi'

	slot_flags = SLOT_ID | SLOT_LOWER_BODY
	color = COLOR_GUNMETAL
	light_color = LIGHT_COLOR_GREEN

/obj/item/modular_computer/pda/wrist/get_mob_overlay(var/mob/user_mob, var/slot, var/bodypart)
	var/image/ret = ..()
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly)
	if(slot == slot_wear_id_str)
		if(assembly?.enabled)
			var/image/I = image(screen_icon, icon_state = "[ret.icon_state]-screen")
			I.appearance_flags |= RESET_COLOR
			I.color = (assembly.bsod || os?.updating) ? "#0000ff" : "#00ff00"
			ret.overlays.Add(I)
		else
			ret.overlays.Add(image(screen_icon, icon_state = "[ret.icon_state]-screen_off"))
		for(var/decal in decals)
			var/image/I = image(icon = ret.icon, icon_state = "[ret.icon_state]-[decal]")
			I.appearance_flags |= RESET_COLOR
			I.color = decals[decal]
			ret.overlays.Add(I)
	return ret

/obj/item/modular_computer/pda/wrist/AltClick(var/mob/user)
	if(!CanPhysicallyInteract(user))
		return
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	var/obj/item/stock_parts/computer/card_slot/card_slot = assembly.get_component(PART_CARD)
	if(card_slot?.stored_card)
		card_slot.eject_id(user)
	else
		..()

/obj/item/modular_computer/pda/wrist/attack_hand(var/mob/user)
	if(loc == user)
		if(user.incapacitated() || user.restrained())
			return
		var/mob/living/carbon/human/H = user
		if(istype(H) && src == H.wear_id)
			return attack_self(user)
	return ..()

/obj/item/modular_computer/pda/wrist/handle_mouse_drop(atom/over, mob/user)
	if(ishuman(user) && loc == user && user.unEquip(src))
		user.put_in_hands(src)
		add_fingerprint(usr)
		return TRUE
	. = ..()

// wrist box //

/obj/item/storage/box/wrist
	name = "box of spare wrist computers"
	desc = "A box of spare wrist microcomputers."
	icon_state = "pda"
	startswith = list(/obj/item/modular_computer/pda/wrist = 5)
