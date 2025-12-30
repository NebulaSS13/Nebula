/*
 * Adds pointer entries to clients to allow for multiple sources wanting to modify the cursor at once.
 * - add_mouse_pointer(pointer_type, pointer_priority, icon_index) will add or replace a pointer of the specified /decl/mouse_pointer type.
 * - remove_mouse_pointer(pointer_type) will clear that entry.
 * - Updates are handled automatically by adding/removing, other procs should not be used without a good reason.
 */

/client
	VAR_PRIVATE/list/_mouse_pointers

/client/proc/clear_mouse_pointers()
	if(LAZYLEN(_mouse_pointers))
		LAZYCLEARLIST(_mouse_pointers)
		update_mouse_pointer()
		return TRUE
	return FALSE

/client/proc/set_mouse_pointer_icon(new_cursor)
	if(isnull(new_cursor))
		new_cursor = initial(mouse_pointer_icon)
	if(mouse_pointer_icon != new_cursor)
		mouse_pointer_icon = new_cursor
		return TRUE
	return FALSE

/client/proc/add_mouse_pointer(pointer_type, pointer_priority = 1, icon_index = 1)

	// Is an identical pointer already being tracked?
	var/decl/mouse_pointer/pointer_decl = ispath(pointer_type) ? GET_DECL(pointer_type) : pointer_type
	if(!isnum(icon_index) || icon_index < 1 || icon_index > length(pointer_decl.icons))
		CRASH("Invalid icon_index passed to add_mouse_pointer() for [pointer_type].")

	var/pointer_icon = pointer_decl.icons[icon_index]
	var/list/comparing = _mouse_pointers?[pointer_type]
	if(islist(comparing) && comparing["icon"] == pointer_icon && comparing["priority"] == pointer_priority)
		return FALSE

	// Update our list entry. If we have multiple pointers, sort by priority.
	var/need_update = !(pointer_type in _mouse_pointers)
	LAZYSET(_mouse_pointers, pointer_type, list("icon" = pointer_icon, "priority" = pointer_priority))
	if(LAZYLEN(_mouse_pointers) > 1)
		_mouse_pointers = sortTim(_mouse_pointers, /proc/cmp_priority_list, TRUE)
		need_update = TRUE

	// Refresh if needed.
	if(need_update)
		update_mouse_pointer()

/client/proc/remove_mouse_pointer(pointer_type)
	if(!_mouse_pointers?[pointer_type])
		return FALSE
	var/current_pointer = _mouse_pointers[1]
	LAZYREMOVE(_mouse_pointers, pointer_type)
	if(pointer_type == current_pointer)
		update_mouse_pointer()
	return TRUE

/client/proc/update_mouse_pointer()
	if(!LAZYLEN(_mouse_pointers))
		return set_mouse_pointer_icon()
	var/list/pointer = _mouse_pointers[_mouse_pointers[1]]
	if(!islist(pointer))
		return set_mouse_pointer_icon()
	var/set_pointer = pointer["icon"]
	if(isicon(set_pointer))
		return set_mouse_pointer_icon(set_pointer)
	return set_mouse_pointer_icon()
