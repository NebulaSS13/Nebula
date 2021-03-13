GLOBAL_DATUM_INIT(dview_mob, /mob/dview, new)

//Version of view() which ignores darkness, because BYOND doesn't have it.
/proc/dview(var/range = world.view, var/center, var/invis_flags = 0)
	if(!center)
		return

	GLOB.dview_mob.loc = center
	GLOB.dview_mob.see_invisible = invis_flags
	. = view(range, GLOB.dview_mob)
	GLOB.dview_mob.loc = null

/mob/dview
	invisibility = 101
	density = 0

	anchored = 1
	simulated = 0

	see_in_dark = 1e6

	virtual_mob = null

/mob/dview/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	PRINT_STACK_TRACE("Prevented attempt to delete dview mob: [log_info_line(src)]")
	return QDEL_HINT_LETMELIVE // Prevents destruction

/mob/dview/Initialize()
	. = ..()
	// We don't want to be in any mob lists; we're a dummy not a mob.
	STOP_PROCESSING(SSmobs, src)