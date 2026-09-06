/atom/proc/relayed_mouse_down(mob/user, object, location, control, params)
	return null

/atom/proc/relayed_mouse_held(mob/user, atom/target)
	return null

/atom/proc/relayed_mouse_up(mob/user, atom/target)
	return null

/mob/proc/on_mouse_down(object, location, control, params)

	// We are mouse down outside the map or on a screen element, assume it is not relevant.
	if(!isatom(object) || istype(object, /obj/screen))
		return FALSE

	// Do not do this for things that are not in the world.
	var/atom/atom = object
	if(!isturf(atom) && !isturf(atom.loc))
		return FALSE

	// Debounce, we might already be holding.
	if(_is_holding_mouse)
		return FALSE

	// Ignore right click and middle click currently.
	// Might be worth handling these in the future.
	var/list/modifiers = params2list(params)
	if(modifiers["middle"] || modifiers["right"])
		return FALSE

	// Keep track of when we started holding the mouse down so that we can check if we hold it long enough to start the drag behavior.
	_started_mouse_down = world.time

	// Might be inside an exosuit or such that has its own handling for these inputs.
	. = loc?.relayed_mouse_down(src, object, location, control, params)
	if(isnull(.))

		// Handle our actual 'drag beginning' logic.
		var/obj/item/held = get_active_held_item()
		. = istype(held) && held.wielder_mouse_drag_down(src, object, location, control, params)

	if(.)
		update_mouse_pointer()
		SSclickdrag.active_wielders[src] = TRUE
		_is_holding_mouse = TRUE

/mob/proc/on_mouse_held()

	if(!_is_holding_mouse)
		return FALSE

	// Grace period before we start holding (rather than a single click)
	if(world.time < _started_mouse_down + MOUSE_DRAG_DELAY)
		return TRUE

	var/atom/mouse_over = _last_mouse_over_atom?.resolve()
	if(QDELETED(mouse_over) || !istype(mouse_over))
		mouse_over = null

	// Might be inside an exosuit or such that has its own handling for these inputs.
	. = loc?.relayed_mouse_held(src, mouse_over)
	if(isnull(.))
		var/obj/item/held = get_active_held_item()
		. = istype(held) && held.wielder_mouse_drag_held(src, mouse_over)

	if(.)
		update_mouse_pointer()
		set_dir(get_dir(src, mouse_over))
	else
		on_mouse_up()

/mob/proc/on_mouse_up(remove_from_processing = TRUE)

	if(!_is_holding_mouse)
		return FALSE

	// Don't block the follow-up Click() if this wasn't an 'official' drag.
	if(world.time >= _started_mouse_down + MOUSE_DRAG_DELAY)
		var/atom/mouse_over = _last_mouse_over_atom?.resolve()
		if(QDELETED(mouse_over) || !istype(mouse_over))
			mouse_over = null
		. = loc?.relayed_mouse_up(src, mouse_over)
		if(isnull(.))
			var/obj/item/held = get_active_held_item()
			. = istype(held) && held.wielder_mouse_drag_up(src, mouse_over)

	update_mouse_pointer()
	_is_holding_mouse = FALSE
	SSclickdrag.active_wielders -= src
	if(remove_from_processing && length(SSclickdrag.processing_wielders))
		SSclickdrag.processing_wielders -= src
