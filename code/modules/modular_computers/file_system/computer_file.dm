var/global/file_uid = 0

#define OS_READ_ACCESS  BITFLAG(0)
#define OS_WRITE_ACCESS BITFLAG(1)
#define OS_MOD_ACCESS   BITFLAG(2)

/datum/computer_file
	var/filename = "NewFile" 								// Placeholder. No spacebars
	var/filetype = "XXX" 									// File full names are [filename].[filetype] so like NewFile.XXX in this case
	var/size = 1											// File size in GQ. Integers only!
	var/weakref/holder										// Holder that contains this file. Refers to a obj/item/stock_parts/computer/hard_drive.
	var/unsendable = 0										// Whether the file may be sent to someone via file transfer or other means.
	var/undeletable = 0										// Whether the file may be deleted. Setting to 1 prevents deletion/renaming/etc.
	var/unrenamable = 0										// Whether the file may be renamed. Setting to 1 prevents renaming.
	var/uid													// UID of this file
	var/list/metadata										// Any metadata the file uses.
	var/papertype = /obj/item/paper
	var/copy_string = "(Copy)"

	var/list/read_access
	var/list/write_access
	var/list/mod_access

/datum/computer_file/New(var/list/md = null)
	..()
	uid = file_uid
	file_uid++
	if(islist(md))
		metadata = md.Copy()

/datum/computer_file/Destroy()
	var/obj/item/stock_parts/computer/hard_drive/hard_drive = holder?.resolve()
	if(hard_drive)
		hard_drive.remove_file(src, forced = TRUE)
	. = ..()

/datum/computer_file/PopulateClone(datum/computer_file/clone)
	clone = ..()
	clone.unsendable  = unsendable
	clone.undeletable = undeletable
	clone.size        = size
	if(metadata)
		clone.metadata = listDeepClone(metadata, TRUE)
	clone.filetype     = filetype
	clone.read_access  = deepCopyList(read_access)
	clone.write_access = deepCopyList(write_access)
	clone.mod_access   = deepCopyList(mod_access)
	return clone

/**
 * Returns independent copy of this file.
 * rename: Whether the clone shold be auto-renamed.
 */
/datum/computer_file/Clone(var/rename = FALSE)
	var/datum/computer_file/clone = ..(null) //Don't propagate our rename param
	if(clone)
		if(rename)
			clone.filename = filename + copy_string
		else
			clone.filename = filename
	return clone

/datum/computer_file/proc/get_file_perms(var/list/accesses, var/mob/user)
	. = 0
	if(!accesses || (isghost(user) && check_rights(R_ADMIN, 0, user))) // No access list past means internal usage, so grant full access. Also override for use by admin ghosts.
		return (OS_READ_ACCESS | OS_WRITE_ACCESS | OS_MOD_ACCESS)
	if(!LAZYLEN(read_access) || has_access(read_access, accesses))
		. |= OS_READ_ACCESS
	if(!LAZYLEN(write_access) || has_access(write_access, accesses))
		. |= OS_WRITE_ACCESS
	if(!LAZYLEN(mod_access) || has_access(mod_access, accesses))
		. |= OS_MOD_ACCESS

/datum/computer_file/proc/get_perms_readable()
	var/list/msg = list()
	msg += "Permissions for file [filename]:"
	var/read_perms
	if(LAZYLEN(read_access))
		read_perms = english_list(read_access[1])
	else
		read_perms = "No access required."
	msg += "Read access: [read_perms]"
	var/write_perms
	if(LAZYLEN(write_access))
		write_perms = english_list(write_access[1])
	else
		write_perms = "No access required."
	msg += "Write access: [write_perms]"
	var/mod_perms
	if(LAZYLEN(mod_access))
		mod_perms = english_list(mod_access[1])
	else
		mod_perms = "No access required."
	msg += "Permission modification access: [mod_perms]"
	return msg

/datum/computer_file/proc/change_perms(var/change, var/perm, var/access_key, var/changer_accesses)

	if(!has_access(mod_access, changer_accesses))
		return FALSE

	if(perm == (OS_READ_ACCESS || OS_WRITE_ACCESS))
		var/list/modded_list = (perm == OS_READ_ACCESS ? read_access : write_access)
		if(change == "+")
			if(!LAZYLEN(modded_list))
				modded_list = list()
				modded_list += list(list())
			modded_list[1] += access_key
			return TRUE
		else if(change == "-")
			if(!LAZYLEN(modded_list)) // There weren't any access requirements to begin with.
				return TRUE
			modded_list[1] -= access_key
			if(!length(modded_list[1]))
				modded_list[1] = null
				modded_list = null
			return TRUE
		else
			return FALSE // Something unexpected was passed into the change argument.

	else if(perm == OS_MOD_ACCESS)
		var/list/test_list // You can't modify access such that you can't access the file any longer, so we test changes first.
		if(change == "+")
			if(!LAZYLEN(mod_access))
				test_list = list(list(access_key))
				if(!has_access(test_list, changer_accesses))
					return FALSE
				mod_access = list()
				mod_access += list(list())
				mod_access[1] += access_key
				return TRUE
			test_list = list(mod_access[1] + access_key)
			if(!has_access(test_list, changer_accesses))
				return FALSE
			mod_access[1] += access_key
			return TRUE
		else if(change == "-")
			if(!LAZYLEN(mod_access))
				return TRUE
			test_list = list(mod_access[1] - access_key)
			if(!has_access(test_list, changer_accesses))
				return FALSE
			mod_access[1] -= access_key
			if(!length(mod_access[1]))
				mod_access[1] = null
				mod_access = null
			return TRUE
		else
			return FALSE

/datum/computer_file/proc/get_directory()
	var/obj/item/stock_parts/computer/hard_drive/hard_drive = holder?.resolve()
	if(hard_drive)
		return hard_drive.stored_files[src]

/datum/computer_file/proc/get_file_path()
	var/datum/computer_file/parent = get_directory()
	var/list/dir_names = list()
	while(istype(parent))
		dir_names.Insert(1, parent.filename)
		parent = parent.get_directory()

	return jointext(dir_names, "/")