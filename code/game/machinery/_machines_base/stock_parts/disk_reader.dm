/obj/item/stock_parts/disk_reader
	name       = "disk drive"
	desc       = "A floppy disk drive for installation in most machines. Able to read most floppy disks."
	icon       = 'icons/obj/items/stock_parts/modular_components.dmi'
	icon_state = "floppy_drive"
	material   = /decl/material/solid/plastic
	matter     = list(
		/decl/material/solid/metal/steel  = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/fiberglass   = MATTER_AMOUNT_REINFORCEMENT,
	)
	max_health = 56
	var/obj/item/disk/disk              //Disk currently inserted
	var/datum/callback/on_insert_target //Callback to call when a disk is inserted
	var/datum/callback/on_eject_target  //Callback to call when a disk is ejected

/obj/item/stock_parts/disk_reader/buildable
	part_flags = PART_FLAG_HAND_REMOVE

/obj/item/stock_parts/disk_reader/Destroy()
	QDEL_NULL(disk)
	unregister_on_insert()
	unregister_on_eject()
	. = ..()

/obj/item/stock_parts/disk_reader/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/disk))
		insert_disk(W, user)
		return TRUE
	. = ..()

/obj/item/stock_parts/disk_reader/attack_hand(mob/user)
	if(disk && istype(loc, /obj/machinery))
		eject_disk(user)
		return TRUE
	. = ..()

/obj/item/stock_parts/disk_reader/attack_self(mob/user)
	if(disk)
		eject_disk(user)
		return TRUE
	. = ..()

/obj/item/stock_parts/disk_reader/proc/insert_disk(var/obj/item/disk/D, var/mob/user)
	if(disk)
		if(user)
			to_chat(user, SPAN_WARNING("There is already \a [disk] in \the [src]."))
		return FALSE
	
	if(user)
		if(user.unEquip(D, src))
			to_chat(user, SPAN_NOTICE("You insert \the [D] into \the [src]."))
		else
			return FALSE
	else
		D.forceMove(src)
	disk = D
	if(on_insert_target)
		on_insert_target.InvokeAsync(D, user)
	return TRUE

/obj/item/stock_parts/disk_reader/proc/eject_disk(var/mob/user)
	if(!disk)
		if(user)
			to_chat(user, SPAN_WARNING("There's no disk in \the [src]."))
		return
	if(user)
		user.put_in_hands(disk)
		to_chat(user, SPAN_NOTICE("You remove \the [disk] from \the [src]."))
	else
		disk.forceMove(get_turf(src))
	. = disk
	if(on_eject_target)
		on_eject_target.InvokeAsync(disk, user)
	disk = null

/obj/item/stock_parts/disk_reader/proc/get_disk()
	return disk

//
// Callback Handling
//

/obj/item/stock_parts/disk_reader/on_install(obj/machinery/machine)
	unregister_on_insert()
	unregister_on_eject()
	. = ..()

/obj/item/stock_parts/disk_reader/on_uninstall(obj/machinery/machine, temporary)
	unregister_on_insert()
	unregister_on_eject()
	. = ..()

/obj/item/stock_parts/disk_reader/proc/register_on_insert(var/datum/callback/cback)
	on_insert_target = cback

/obj/item/stock_parts/disk_reader/proc/register_on_eject(var/datum/callback/cback)
	on_eject_target = cback

/obj/item/stock_parts/disk_reader/proc/unregister_on_insert()
	QDEL_NULL(on_insert_target)

/obj/item/stock_parts/disk_reader/proc/unregister_on_eject()
	QDEL_NULL(on_eject_target)