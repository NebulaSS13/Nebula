///////////////////////////////////////////////////////////////////////////////
// Data Disk
///////////////////////////////////////////////////////////////////////////////
/obj/item/disk
	name                   = "data disk"
	desc                   = "A standard 3.5 inches floppy disk for storing computer files... What's even an inch?"
	icon                   = 'icons/obj/items/device/diskette.dmi'
	icon_state             = ICON_STATE_WORLD
	w_class                = ITEM_SIZE_TINY
	material               = /decl/material/solid/plastic
	matter                 = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE)
	throw_range            = 10
	throw_speed            = 6
	var/label
	var/free_blocks        = 14400 //Blocks
	var/tmp/block_capacity = 14400 //Blocks
	var/list/stored_files          //Associative list of file name to computer_file.

/obj/item/disk/proc/can_write_file(var/datum/computer_file/data/F)
	return F?.block_size <= free_blocks

/**Writes a file to the disk. Fails if the file is bigger than the amount of free blocks left. */
/obj/item/disk/proc/write_file(var/datum/computer_file/data/F, var/new_name = null)
	if(F.block_size > free_blocks)
		return FALSE
	F = F.Clone()
	if(length(new_name))
		F.filename = new_name

	var/datum/computer_file/existing = LAZYACCESS(stored_files, F.filename)
	if(existing && existing != F)
		delete_file(F.filename)

	LAZYSET(stored_files, F.filename, F)
	free_blocks = clamp(round(free_blocks - F.block_size), 0, block_capacity)
	return TRUE

/**Read and returns a file by filename. */
/obj/item/disk/proc/read_file(var/name)
	return LAZYACCESS(stored_files, name)

/**Clone the file. */
/obj/item/disk/proc/copy_file(var/name)
	var/datum/computer_file/F = LAZYACCESS(stored_files, name)
	return F?.Clone()

/**Delete a specific file. Fails if file is write protected, and force is FALSE. */
/obj/item/disk/proc/delete_file(var/name, var/force = FALSE)
	var/datum/computer_file/data/F = LAZYACCESS(stored_files, name)
	if(!F || (F.read_only && !force))
		return FALSE
	free_blocks = clamp(round(free_blocks + F.block_size), 0, block_capacity)
	qdel(LAZYACCESS(stored_files, name))
	LAZYREMOVE(stored_files, name)
	return TRUE

/**Like a full disk format. Erase all files, even if write protected! */
/obj/item/disk/proc/delete_all()
	LAZYCLEARLIST(stored_files)
	free_blocks = block_capacity

/**Returns the first file with the matching file_extension, or null if it can't find one */
/obj/item/disk/proc/contains_file_type(var/file_extension)
	for(var/key in stored_files)
		var/datum/computer_file/data/F = stored_files[key]
		if(!istype(F))
			continue
		if(F.filetype == file_extension)
			return F

/**Offers a simple input box to pick and return the name of a file currently on disk. */
/obj/item/disk/proc/simple_pick_file(var/mob/user)
	return input(user, "Choose a file.", "File") as anything  in src.stored_files

/obj/item/disk/proc/get_free_blocks()
	return free_blocks

/obj/item/disk/proc/get_blocks_capacity()
	return block_capacity

/obj/item/disk/on_update_icon()
	. = ..()
	var/list/details = list(mutable_appearance(icon, "slider", flags = RESET_COLOR))
	if(label)
		details += mutable_appearance(icon, label, flags = RESET_COLOR)
	add_overlay(details)

///////////////////////////////////////////////////////////////////////////////
// Random Data Disk
///////////////////////////////////////////////////////////////////////////////
/obj/item/disk/random/Initialize(ml, material_key)
	color = get_random_colour()
	. = ..()

///////////////////////////////////////////////////////////////////////////////
// Fabricator Data Disk
///////////////////////////////////////////////////////////////////////////////
/obj/item/disk/tech_disk
	name = "fabricator data disk"
	desc = "A disk for storing fabricator learning data for backup."
	color = COLOR_BOTTLE_GREEN
	var/list/stored_tech

///////////////////////////////////////////////////////////////////////////////
// Component Design Data Disk
///////////////////////////////////////////////////////////////////////////////
/obj/item/disk/design_disk
	name = "component design disk"
	desc = "A disk for storing device design data for construction in lathes."
	color = COLOR_BLUE_GRAY
	var/datum/fabricator_recipe/blueprint

/obj/item/disk/design_disk/attack_hand(mob/user)
	if(user.a_intent != I_HURT || !blueprint || !user.has_dexterity(DEXTERITY_KEYBOARDS))
		return ..()
	blueprint = null
	SetName(initial(name))
	to_chat(user, SPAN_DANGER("You flick the erase switch and wipe \the [src]."))
	return TRUE
