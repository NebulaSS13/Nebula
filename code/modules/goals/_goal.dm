/datum/goal
	var/description
	var/owner
	var/completion_message
	var/failure_message
	var/can_reroll = TRUE
	var/can_abandon = TRUE

/datum/goal/New(var/_owner)
	owner = _owner
	events_repository.register(/decl/observ/destroyed, owner, src, TYPE_PROC_REF(/datum, qdel_self))
	if(istype(owner, /datum/mind))
		var/datum/mind/mind = owner
		LAZYADD(mind.goals, src)
	update_strings()

/datum/goal/Destroy()
	events_repository.unregister(/decl/observ/destroyed, owner, src)
	if(owner)
		if(istype(owner, /datum/mind))
			var/datum/mind/mind = owner
			LAZYREMOVE(mind.goals, src)
		owner = null
	. = ..()

/datum/goal/proc/summarize(var/show_success = FALSE, var/allow_modification = FALSE, var/mob/caller ,var/position = 1)
	. = "[description][get_summary_value()]"
	if(show_success)
		. += get_success_string()
	if(allow_modification)
		if(can_abandon) . += " (<a href='byond://?src=\ref[owner];abandon_goal=[position];abandon_goal_caller=\ref[caller]'>Abandon</a>)"
		if(can_reroll)  . += " (<a href='byond://?src=\ref[owner];reroll_goal=[position];reroll_goal_caller=\ref[caller]'>Reroll</a>)"

/datum/goal/proc/get_success_string()
	return check_success() ? " <b><font color='green'>Success!</font></b>" : " <b><font color='red'>Failure.</font></b>"

/datum/goal/proc/get_summary_value()
	return

/datum/goal/proc/update_strings()
	return

/datum/goal/proc/update_progress(var/progress)
	return

/datum/goal/proc/check_success()
	return TRUE

/datum/goal/proc/try_initialize()
	return TRUE

/datum/goal/proc/on_completion()
	if(completion_message && check_success())
		if(istype(owner, /datum/mind))
			var/datum/mind/mind = owner
			to_chat(mind.current, SPAN_GOOD("<b>[completion_message]</b>"))

/datum/goal/proc/on_failure()
	if(failure_message && !check_success())
		if(istype(owner, /datum/mind))
			var/datum/mind/mind = owner
			to_chat(mind.current, SPAN_BAD("<b>[failure_message]</b>"))

/datum/goal/proc/is_valid()
	return TRUE
