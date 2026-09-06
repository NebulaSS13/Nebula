//#TODO: disk reader should have its own includable tmpl, and override ui_data so machines don't have to reimplemnt the disk stuff a million time in their ui.
/**
 * Stock part for reading/writing to an inserted data disk.
 */
/obj/item/stock_parts/item_holder/disk_reader
	name       = "disk drive"
	desc       = "A floppy disk drive for installation in most machines. Able to read most floppy disks."
	icon       = 'icons/obj/items/stock_parts/modular_components.dmi'
	icon_state = "floppy_drive"
	material   = /decl/material/solid/organic/plastic
	matter     = list(
		/decl/material/solid/metal/steel  = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/fiberglass   = MATTER_AMOUNT_REINFORCEMENT,
	)
	max_health = ITEM_HEALTH_NO_DAMAGE
	eject_handler = /decl/interaction_handler/remove_held_item/disk
	var/obj/item/disk/disk //Disk currently inserted

/obj/item/stock_parts/item_holder/disk_reader/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	max_health = 56

/obj/item/stock_parts/item_holder/disk_reader/Destroy()
	QDEL_NULL(disk)
	. = ..()

/obj/item/stock_parts/item_holder/disk_reader/is_item_inserted()
	return !isnull(disk)

/obj/item/stock_parts/item_holder/disk_reader/is_accepted_type(obj/O)
	return istype(O, /obj/item/disk)

/obj/item/stock_parts/item_holder/disk_reader/get_inserted()
	return disk

/obj/item/stock_parts/item_holder/disk_reader/set_inserted(obj/O)
	disk = O

/obj/item/stock_parts/item_holder/disk_reader/get_description_insertable()
	return "disk"

/decl/interaction_handler/remove_held_item/disk
	name = "Eject Disk"
	expected_component_type = /obj/item/stock_parts/item_holder/disk_reader
	examine_desc = "remove a disk"
