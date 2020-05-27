/datum/ai
	var/name
	var/mob/living/body		// The parent mob we control.
	var/wait_for = 	0 		// The next time we can process.
	var/run_interval = 1 	// How long to wait between processes.
	
/datum/ai/New(var/mob/living/target_body)
	body = target_body
	START_PROCESSING(SSai, src)

/datum/ai/proc/can_process()
	if((body.client || body.mind) && !(body.status_flags & ENABLE_AI))
		return FALSE
	if(wait_for > world.time)
		return FALSE
	if(body.stat == DEAD)
		return FALSE
	return TRUE

/datum/ai/Process()
	if(!can_process())
		return

	var/time_elapsed = wait_for - world.time
	wait_for = world.time + run_interval
	do_process(time_elapsed)

// This is the place to actually do work in the AI.
/datum/ai/proc/do_process(var/time_elapsed)
	
/datum/ai/Destroy()
	STOP_PROCESSING(SSai, src)
	if(body.ai == src) body.ai = null
	body = null
	. = ..()