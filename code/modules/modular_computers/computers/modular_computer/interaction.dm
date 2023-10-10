/obj/item/modular_computer/proc/update_verbs()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	if(stores_pen && istype(stored_pen))
		verbs |= /obj/item/modular_computer/proc/remove_pen
	else
		verbs -= /obj/item/modular_computer/proc/remove_pen

	if(assembly.get_component(PART_CARD))
		verbs |= /obj/item/stock_parts/computer/card_slot/proc/verb_eject_id
	else
		verbs -= /obj/item/stock_parts/computer/card_slot/proc/verb_eject_id

// Forcibly shut down the device. To be used when something bugs out and the UI is nonfunctional.
/obj/item/modular_computer/verb/emergency_shutdown()
	set name = "Forced Shutdown"
	set category = "Object"
	set src in view(1)

	if(usr.incapacitated() || !istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(!Adjacent(usr))
		to_chat(usr, "<span class='warning'>You can't reach it.</span>")
		return
	var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly.enabled)
		assembly.bsod = 1
		update_icon()
		to_chat(usr, "You press a hard-reset button on \the [src]. It displays a brief debug screen before shutting down.")
		shutdown_computer(FALSE)
		spawn(2 SECONDS)
			assembly.bsod = 0
			update_icon()

/obj/item/modular_computer/proc/remove_pen()
	set name = "Remove Pen"
	set category = "Object"
	set src in view(1)

	if(usr.incapacitated() || !istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(!Adjacent(usr))
		to_chat(usr, "<span class='warning'>You can't reach it.</span>")
		return

	if(IS_PEN(stored_pen))
		to_chat(usr, "<span class='notice'>You remove [stored_pen] from [src].</span>")
		usr.put_in_hands(stored_pen) // Silicons will drop it anyway.
		stored_pen = null
		update_verbs()

/obj/item/modular_computer/attack_ghost(var/mob/observer/ghost/user)
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly.enabled)
		ui_interact(user)
	else if(check_rights(R_ADMIN, 0, user))
		var/response = alert(user, "This computer is turned off. Would you like to turn it on?", "Admin Override", "Yes", "No")
		if(response == "Yes")
			assembly.turn_on(user)

/obj/item/modular_computer/attack_ai(var/mob/user)
	return attack_self(user)

/obj/item/modular_computer/attack_hand(var/mob/user)
	if(anchored)
		return attack_self(user)
	return ..()

// On-click handling. Turns on the computer if it's off and opens the GUI.
/obj/item/modular_computer/attack_self(var/mob/user)
	var/datum/extension/assembly/modular_computer/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly.enabled && assembly.screen_on)
		ui_interact(user)
		return TRUE
	else if(!assembly.enabled && assembly.screen_on)
		assembly.turn_on(user)
		return TRUE
	. = ..()

/obj/item/modular_computer/attackby(var/obj/item/W, var/mob/user)
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly.attackby(W, user))
		update_verbs()
		return

	if(IS_PEN(W) && (W.w_class <= ITEM_SIZE_TINY) && stores_pen)
		if(istype(stored_pen))
			to_chat(user, "<span class='notice'>There is already a pen in [src].</span>")
			return
		if(!user.try_unequip(W, src))
			return
		stored_pen = W
		update_verbs()
		to_chat(user, "<span class='notice'>You insert [W] into [src].</span>")
		return
	return ..()

/obj/item/modular_computer/examine(mob/user)
	. = ..()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	if(assembly.enabled)
		to_chat(user, "The time [stationtime2text()] is displayed in the corner of the screen.")

	var/obj/item/stock_parts/computer/card_slot/card_slot = assembly.get_component(PART_CARD)
	if(card_slot && card_slot.stored_card)
		to_chat(user, "\The [card_slot.stored_card] is inserted into it.")
	assembly.examine(user)

/obj/item/modular_computer/handle_mouse_drop(atom/over, mob/user)
	. = (!istype(over, /obj/screen) && attack_self(user)) || ..()

/obj/item/modular_computer/afterattack(atom/target, mob/user, proximity)
	. = ..()
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	var/obj/item/stock_parts/computer/scanner/scanner = assembly.get_component(PART_SCANNER)
	if(scanner)
		scanner.do_on_afterattack(user, target, proximity)

/obj/item/modular_computer/CtrlAltClick(mob/user)
	if(!CanPhysicallyInteract(user))
		return
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		os.open_terminal(user)

/obj/item/modular_computer/CouldUseTopic(var/mob/user)
	..()
	if(LAZYLEN(interact_sounds) && CanPhysicallyInteract(user))
		playsound(src, pick(interact_sounds), interact_sound_volume)

/obj/item/modular_computer/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/remove_id/modular_computer)
	LAZYADD(., /decl/interaction_handler/remove_pen/modular_computer)
	LAZYADD(., /decl/interaction_handler/emergency_shutdown)

//
// Remove ID
//
/decl/interaction_handler/remove_id/modular_computer
	expected_target_type = /obj/item/modular_computer

/decl/interaction_handler/remove_id/modular_computer/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..()
	if(.)
		var/datum/extension/assembly/assembly = get_extension(target, /datum/extension/assembly)
		. = !!(assembly?.get_component(PART_CARD))

/decl/interaction_handler/remove_id/modular_computer/invoked(atom/target, mob/user, obj/item/prop)
	var/datum/extension/assembly/assembly = get_extension(target, /datum/extension/assembly)
	var/obj/item/stock_parts/computer/card_slot/card_slot = assembly.get_component(PART_CARD)
	if(card_slot.stored_card)
		card_slot.eject_id(user)

//
// Remove Pen
//
/decl/interaction_handler/remove_pen/modular_computer
	expected_target_type = /obj/item/modular_computer

/decl/interaction_handler/remove_pen/modular_computer/is_possible(obj/item/modular_computer/target, mob/user, obj/item/prop)
	return ..() && target.stores_pen && target.stored_pen

/decl/interaction_handler/remove_pen/modular_computer/invoked(obj/item/modular_computer/target, mob/user, obj/item/prop)
	target.remove_pen()

//
// Emergency Shutdown
//
/decl/interaction_handler/emergency_shutdown
	name = "Emergency Shutdown"
	icon = 'icons/screen/radial.dmi'
	icon_state = "radial_power_off"
	expected_target_type = /obj/item/modular_computer

/decl/interaction_handler/emergency_shutdown/is_possible(atom/target, mob/user, obj/item/prop)
	. = ..()
	if(!.)
		return
	var/datum/extension/assembly/modular_computer/assembly = get_extension(target, /datum/extension/assembly)
	return !isnull(assembly) && assembly.enabled

/decl/interaction_handler/emergency_shutdown/invoked(obj/item/modular_computer/target, mob/user, obj/item/prop)
	target.emergency_shutdown()