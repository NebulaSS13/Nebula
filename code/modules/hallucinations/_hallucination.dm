//////////////////////////////////////////////////////////////////////////////////////////////////////
//Hallucination effects datums
//////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/hallucination
	var/mob/living/holder
	var/allow_duplicates = 1
	var/duration = 0
	var/min_power = 0 //at what levels of hallucination power mobs should get it
	var/max_power = INFINITY
	var/activated = FALSE

/datum/hallucination/proc/start()
	SHOULD_CALL_PARENT(TRUE)
	activated = TRUE

/datum/hallucination/proc/end()
	SHOULD_CALL_PARENT(TRUE)
	activated = FALSE

/datum/hallucination/proc/can_affect(var/mob/living/victim)
	if(!victim.client)
		return FALSE
	if(min_power > victim.hallucination_power)
		return FALSE
	if(max_power < victim.hallucination_power)
		return FALSE
	if(!allow_duplicates && (locate(type) in victim._hallucinations))
		return FALSE
	return TRUE

/datum/hallucination/Destroy()
	if(holder)
		LAZYREMOVE(holder._hallucinations, src)
		holder = null
	if(activated)
		end()
	return ..()

/datum/hallucination/proc/activate_hallucination()
	set waitfor = FALSE
	if(!holder || !holder.client || activated)
		return
	LAZYADD(holder._hallucinations, src)
	start()
	sleep(duration)
	if(!QDELETED(src))
		qdel(src)
