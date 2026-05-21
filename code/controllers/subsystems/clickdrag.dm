SUBSYSTEM_DEF(clickdrag)
	name = "Clickdrag"
	wait = 1
	flags = SS_TICKER | SS_NO_INIT

	var/tmp/list/active_wielders = list()
	var/tmp/active_wielders_copied_yet = FALSE
	var/tmp/list/processing_wielders

/datum/controller/subsystem/clickdrag/stat_entry()
	..("W:[active_wielders.len]")

/datum/controller/subsystem/clickdrag/fire(resumed = 0)

	if(!resumed)
		active_wielders_copied_yet = FALSE

	if(!active_wielders_copied_yet)
		active_wielders_copied_yet = TRUE
		processing_wielders = active_wielders.Copy()

	var/mob/wielder
	var/i = 0
	while(i < processing_wielders.len)
		i++
		wielder = processing_wielders[i]
		if(!wielder.on_mouse_held())
			wielder.on_mouse_up(remove_from_processing = FALSE) // we will do this via our list iteration anyway
		if (MC_TICK_CHECK)
			processing_wielders.Cut(1, i+1)
			return
	processing_wielders.Cut()

/client
	// (BOOL) Flag for whether or not the next Click() should be blocked - Click() is called immediately after MouseUp() which isn't desirable.
	VAR_PRIVATE/tmp/_block_next_click = FALSE

/mob
	// (DATUM) Tracker for clickdrag subsystem,
	VAR_PRIVATE/tmp/weakref/_last_mouse_over_atom
	// (BOOL) Flag for keeping track of if we're already processing or not.
	VAR_PRIVATE/tmp/_is_holding_mouse = FALSE
	// (INT) Time that we started holding the mouse down.
	VAR_PRIVATE/tmp/_started_mouse_down = 0
	// (FLOAT) Delay before a hold is considered a hold rather than a single click.
	VAR_PRIVATE/const/MOUSE_DRAG_DELAY = 0.25 SECONDS

/client/MouseEntered(object,location,control,params)
	UNLINT(mob?._last_mouse_over_atom = weakref(object))
	. = ..()

/client/MouseDrag(src_object, over_object, src_location, over_location, src_control, over_control, params)
	UNLINT(mob?._last_mouse_over_atom = weakref(over_object))
	. = ..()
