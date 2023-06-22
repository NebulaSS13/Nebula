/obj/item/stock_parts/computer/charge_stick_slot
	name = "charge-stick slot"
	desc = "Slot that allows this computer to pay for transactions using an inserted charge-stick."
	power_usage = 10 //W
	critical = 0
	icon_state = "cardreader"
	hardware_size = 1
	origin_tech = "{'programming':2}"
	usage_flags = PROGRAM_ALL & ~PROGRAM_PDA
	external_slot = TRUE
	material = /decl/material/solid/metal/steel

	var/can_broadcast = FALSE
	// TODO: reimplment charge stick write access and can_write
	var/obj/item/charge_stick/stored_stick = null

/obj/item/stock_parts/computer/charge_stick_slot/proc/get_currency_name()
	var/decl/currency/cur = GET_DECL(global.using_map.default_currency)
	return cur.name

/obj/item/stock_parts/computer/charge_stick_slot/diagnostics()
	. = ..()
	. += "[name] status: [stored_stick ? "[get_currency_name()]-stick Inserted" : "[get_currency_name()]-stick Not Present"]"
	if(!stored_stick)
		. += "\nStick status: Missing"
	else
		. += "\nStick status: [stored_stick.is_locked() ? "Locked" : "Unlocked"]"
	if(!stored_stick.is_locked())
		. += "\nStick balance: [stored_stick.loaded_worth]"

/obj/item/stock_parts/computer/charge_stick_slot/proc/verb_eject_stick()
	set name = "Remove Charge-stick"
	set category = "Object"
	set src in view(1)

	if(!CanPhysicallyInteract(usr))
		to_chat(usr, SPAN_WARNING("You can't reach it."))
		return

	var/obj/item/stock_parts/computer/charge_stick_slot/device = src
	if (!istype(device))
		device = locate() in src

	if(!device.stored_stick)
		if(usr)
			to_chat(usr, "There is no [get_currency_name()]-stick in \the [src].")
		return

	device.eject_stick(usr)

/obj/item/stock_parts/computer/charge_stick_slot/proc/eject_stick(mob/user)
	if(!stored_stick)
		return FALSE

	if(user)
		to_chat(user, "You remove [stored_stick] from [src].")
		user.put_in_hands(stored_stick)
	else
		dropInto(loc)
	stored_stick = null

	var/datum/extension/interactive/os/os = get_extension(loc, /datum/extension/interactive/os)
	if(os)
		os.event_idremoved()
	loc.verbs -= /obj/item/stock_parts/computer/charge_stick_slot/proc/verb_eject_stick
	return TRUE

/obj/item/stock_parts/computer/charge_stick_slot/proc/insert_stick(var/obj/item/charge_stick/I, mob/user)
	if(!istype(I))
		return FALSE

	if(stored_stick)
		to_chat(user, "You try to insert [I] into [src], but its [get_currency_name()]-stick slot is occupied.")
		return FALSE

	if(user && !user.try_unequip(I, src))
		return FALSE

	stored_stick = I
	to_chat(user, "You insert [I] into [src].")
	if(isobj(loc))
		loc.verbs |= /obj/item/stock_parts/computer/charge_stick_slot/proc/verb_eject_stick
	return TRUE

/obj/item/stock_parts/computer/charge_stick_slot/attackby(obj/item/card/id/I, mob/user)
	if(!istype(I))
		return
	insert_stick(I, user)
	return TRUE

/obj/item/stock_parts/computer/charge_stick_slot/broadcaster // read only
	name = "NFC charge-stick broadcaster"
	desc = "Reads and broadcasts the NFC signal of an inserted charge-stick."
	can_broadcast = TRUE

	usage_flags = PROGRAM_PDA

/obj/item/stock_parts/computer/charge_stick_slot/Destroy()
	if(loc)
		loc.verbs -= /obj/item/stock_parts/computer/charge_stick_slot/proc/verb_eject_stick
	if(stored_stick)
		stored_stick.dropInto(get_turf(loc))
		stored_stick = null
	return ..()