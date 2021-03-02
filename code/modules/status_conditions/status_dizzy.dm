/decl/status_condition/dizzy
	name = "dizzy"

/decl/status_condition/dizzy/handle_changed_amount(var/mob/living/victim, var/new_amount, var/last_amount)
	. = ..()
	if(new_amount <= 100)
		return
	var/victim_ref = weakref(victim)
	if(LAZYACCESS(victim_data, victim_ref))
		return
	LAZYSET(victim_data, victim_ref, TRUE)
	var/dizziness = new_amount
	while(dizziness > 100 && !QDELETED(victim) && victim.stat != DEAD && victim.client)
		var/amplitude = dizziness*(sin(dizziness * 0.044 * world.time) + 1) / 70
		victim.client.pixel_x = amplitude * sin(0.008 * dizziness * world.time)
		victim.client.pixel_y = amplitude * cos(0.008 * dizziness * world.time)
		sleep(1)
		dizziness = GET_STATUS(victim, type)
	LAZYREMOVE(victim_data, victim_ref)
	if(!QDELETED(victim) && victim.client)
		victim.client.pixel_x = 0
		victim.client.pixel_y = 0
