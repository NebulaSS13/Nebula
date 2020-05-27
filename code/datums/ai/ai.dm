/datum/ai
	var/name
	var/mob/living/body		// The parent mob we control.
	var/waiting	= 	0		// The number of process ticks we've been waiting.
	var/wait_for = 	1		// How many process ticks to wait before processing.
	
/datum/ai/New(var/mob/living/body)
	src.body = body

/datum/ai/proc/can_process()
	waiting++
	if(waiting >= wait_for)
		waiting = 0
		return TRUE
	return FALSE

/datum/ai/proc/do_process()

/datum/ai/Destroy()
	qdel(body)
	. = ..()