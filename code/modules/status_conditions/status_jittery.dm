/decl/status_condition/jittery
	name = "jittery"

/decl/status_condition/jittery/handle_changed_amount(var/mob/living/victim, var/new_amount, var/last_amount)
	. = ..()
	if(new_amount <= 100)
		return
	var/weakref/victim_ref = weakref(victim)
	if(LAZYACCESS(victim_data, victim_ref))
		return
	LAZYSET(victim_data, victim_ref, TRUE)
	var/jitteriness = new_amount
	while(jitteriness > 100 && istype(victim) && !QDELETED(victim) && victim.stat != DEAD)
		var/amplitude = min(4, jitteriness / 100)
		victim.do_jitter(amplitude)
		sleep(1)
		jitteriness = GET_STATUS(victim, type)
	if(victim_ref)
		LAZYREMOVE(victim_data, victim_ref)
		if(!QDELETED(victim))
			victim.do_jitter(0)

/decl/status_condition/jittery/handle_status(var/mob/living/victim, var/amount)
	. = ..()
	var/jitteriness = amount
	if(jitteriness >= 400)
		var/obj/item/organ/internal/heart/L = victim.get_organ(BP_HEART)
		if(!istype(L))
			return 
		if(BP_IS_PROSTHETIC(L))
			return
		if(prob(5))
			if(prob(1))
				L.take_internal_damage(L.max_damage / 2, 0)
				to_chat(victim, SPAN_DANGER("Something bursts in your heart."))
				admin_victim_log(victim, "has taken <b>lethal heart damage</b> at jitteriness level [jitteriness].")
			else
				L.take_internal_damage(1, 0)
				to_chat(victim, SPAN_DANGER("The jitters are killing you! You feel your heart beating out of your chest."))
				admin_victim_log(victim, "has taken <i>minor heart damage</i> at jitteriness level [jitteriness].")
