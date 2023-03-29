/obj/item/stock_parts/computer/drive_slot
	name = "removable drive slot"
	desc = "Slot that allows this computer to accept removable drives."
	power_usage = 10 //W
	critical = 0
	icon_state = "cardreader"
	hardware_size = 1
	origin_tech = "{'programming':2}"
	usage_flags = PROGRAM_ALL
	external_slot = TRUE
	material = /decl/material/solid/metal/steel

	var/obj/item/stock_parts/computer/hard_drive/portable/stored_drive = null
	var/mount_name

/obj/item/stock_parts/computer/drive_slot/diagnostics()
	. = ..()
	. += "[name] status: [stored_drive ? "Drive Inserted" : "Drive Not Present"]\n"

/obj/item/stock_parts/computer/drive_slot/proc/verb_eject_drive()
	set name = "Remove Drive"
	set category = "Object"
	set src in view(1)

	if(!CanPhysicallyInteract(usr))
		to_chat(usr, "<span class='warning'>You can't reach it.</span>")
		return

	var/obj/item/stock_parts/computer/drive_slot/device = src
	if (!istype(device))
		device = locate() in src

	if(!device.stored_drive)
		if(usr)
			to_chat(usr, "There is no drive in \the [src].")
		return

	device.eject_drive(usr)

/obj/item/stock_parts/computer/drive_slot/proc/eject_drive(mob/user)
	if(!stored_drive)
		return FALSE

	if(user)
		to_chat(user, "You remove [stored_drive] from [src].")
		user.put_in_hands(stored_drive)
	else
		dropInto(loc)
	stored_drive = null

	loc.verbs -= /obj/item/stock_parts/computer/drive_slot/proc/verb_eject_drive
	return TRUE

/obj/item/stock_parts/computer/drive_slot/proc/insert_drive(var/obj/item/stock_parts/computer/hard_drive/portable/I, mob/user)
	if(!istype(I))
		return FALSE

	if(stored_drive)
		to_chat(user, "You try to insert [I] into [src], but its portable drive slot is occupied.")
		return FALSE

	if(user && !user.try_unequip(I, src))
		return FALSE

	stored_drive = I
	to_chat(user, "You insert [I] into [src].")
	if(isobj(loc))
		loc.verbs |= /obj/item/stock_parts/computer/drive_slot/proc/verb_eject_drive
	return TRUE

/obj/item/stock_parts/computer/drive_slot/do_after_install(atom/device, loud)
	var/datum/extension/interactive/os/os = get_extension(device, /datum/extension/interactive/os)
	if(!os)
		return FALSE

	var/datum/file_storage/new_storage = os.mount_storage(/datum/file_storage/disk/removable, "media", FALSE)
	if(new_storage)
		mount_name = new_storage.root_name
		if(loud)
			device.visible_message(SPAN_NOTICE("\The [device] pings: Mounted removable hard drive as file system with root directory '[new_storage.root_name]'."))
		return TRUE
	else
		if(loud)
			device.visible_message(SPAN_WARNING("\The [device] flashes an error: Failed to mount removable harddrive. Hard drive may be non-functional."))
		return FALSE

/obj/item/stock_parts/computer/drive_slot/do_before_uninstall(atom/device, loud)
	var/datum/extension/interactive/os/os = get_extension(device, /datum/extension/interactive/os)
	if(!os)
		return FALSE

	os.unmount_storage(mount_name)

/obj/item/stock_parts/computer/drive_slot/attackby(obj/item/stock_parts/computer/hard_drive/portable/I, mob/user)
	if(!istype(I))
		return
	insert_drive(I, user)
	return TRUE

/obj/item/stock_parts/computer/drive_slot/Destroy()
	if(loc)
		loc.verbs -= /obj/item/stock_parts/computer/drive_slot/proc/verb_eject_drive
	if(stored_drive)
		QDEL_NULL(stored_drive)
	return ..()