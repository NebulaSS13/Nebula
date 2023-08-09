/obj/item/stock_parts/computer/data_disk_drive
	name = "data disk slot"
	desc = "Slot that allows this computer to accept data disks."
	power_usage = 10 //W
	critical = 0
	icon_state = "cardreader"
	hardware_size = 1
	origin_tech = "{'programming':2}"
	usage_flags = PROGRAM_ALL
	external_slot = TRUE
	material = /decl/material/solid/metal/steel

	var/obj/item/disk/stored_disk = null
	var/mount_name

/obj/item/stock_parts/computer/data_disk_drive/diagnostics()
	. = ..()
	. += "[name] status: [stored_disk ? "Disk Inserted" : "Disk Not Present"]\n"

/obj/item/stock_parts/computer/data_disk_drive/proc/verb_eject_disk()
	set name = "Remove Disk"
	set category = "Object"
	set src in view(1)

	if(!CanPhysicallyInteract(usr))
		to_chat(usr, SPAN_WARNING("You can't reach it."))
		return

	var/obj/item/stock_parts/computer/data_disk_drive/device = src
	if (!istype(device))
		device = locate() in src

	if(!istype(device))
		return

	if(!device.stored_disk)
		if(usr)
			to_chat(usr, "There is no drive in \the [src].")
		return

	device.eject_disk(usr)

/obj/item/stock_parts/computer/data_disk_drive/proc/eject_disk(mob/user)
	if(!stored_disk)
		return FALSE

	if(user)
		to_chat(user, "You remove [stored_disk] from [src].")
		user.put_in_hands(stored_disk)
	else
		dropInto(loc)
	stored_disk = null

	loc.verbs -= /obj/item/stock_parts/computer/data_disk_drive/proc/verb_eject_disk
	return TRUE

/obj/item/stock_parts/computer/data_disk_drive/proc/insert_disk(obj/item/disk/new_disk, mob/user)
	if(!istype(new_disk))
		return FALSE

	if(stored_disk)
		to_chat(user, "You try to insert [new_disk] into [src], but its data disk slot is occupied.")
		return FALSE

	if(user && !user.try_unequip(new_disk, src))
		return FALSE

	stored_disk = new_disk
	to_chat(user, "You insert [new_disk] into [src].")
	if(isobj(loc))
		loc.verbs |= /obj/item/stock_parts/computer/data_disk_drive/proc/verb_eject_disk
	return TRUE

/obj/item/stock_parts/computer/data_disk_drive/proc/mount_filesystem(datum/extension/interactive/os/os)
	return os?.mount_storage(/datum/file_storage/disk/datadisk, "data", FALSE)

/obj/item/stock_parts/computer/data_disk_drive/do_after_install(atom/device, loud)
	var/datum/extension/interactive/os/os = get_extension(device, /datum/extension/interactive/os)
	if(!os?.on)
		return FALSE

	var/datum/file_storage/new_storage = mount_filesystem(os)
	if(new_storage)
		mount_name = new_storage.root_name
		if(loud)
			os.visible_notification("Mounted data disk as filesystem with root directory '[new_storage.root_name]'.")
		return TRUE
	else
		if(loud)
			os.visible_error("Failed to mount data disk. Disk may be non-functional.")
		return FALSE

/obj/item/stock_parts/computer/data_disk_drive/do_before_uninstall(atom/device, loud)
	var/datum/extension/interactive/os/os = get_extension(device, /datum/extension/interactive/os)
	if(!os)
		return FALSE

	os.unmount_storage(mount_name)

/obj/item/stock_parts/computer/data_disk_drive/attackby(obj/item/disk/new_disk, mob/user)
	if(!istype(new_disk))
		return
	insert_disk(new_disk, user)
	return TRUE

/obj/item/stock_parts/computer/data_disk_drive/Destroy()
	if(loc)
		loc.verbs -= /obj/item/stock_parts/computer/data_disk_drive/proc/verb_eject_disk
	if(stored_disk)
		QDEL_NULL(stored_disk)
	return ..()