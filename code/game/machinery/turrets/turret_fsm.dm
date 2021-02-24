/datum/state_machine/turret
	current_state = /decl/state/turret/idle
	expected_holder_type = /obj/machinery/turret


/decl/state/turret
	var/ray_color = "#ffffffff" // Turrets have a visual indicator of their current state.
	var/switched_to_sound = null
	var/timer_proc = null

/decl/state/turret/entered_state(obj/machinery/turret/turret)
	turret.ray_color = src.ray_color
	turret.update_icon()
	if(switched_to_sound)
		playsound(turret, switched_to_sound, 40, TRUE)
	if(timer_proc)
		// TODO: Remove TIMER_CLIENT_TIME and the sleep(0) when #1464 is merged.
		turret.timer_id = addtimer(CALLBACK(turret, timer_proc), 2, TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_LOOP|TIMER_OVERRIDE|TIMER_CLIENT_TIME)

/decl/state/turret/exited_state(obj/machinery/turret/turret)
	if(timer_proc && turret.timer_id)
		sleep(0) // `deltimer()` may fail without this.
		deltimer(turret.timer_id)
		turret.timer_id = null


/decl/state/turret/idle
	ray_color = "#00ff00ff"
	switched_to_sound = 'sound/machines/triple_beep.ogg'
	transitions = list(
		/decl/state_transition/turret/lost_power,
		/decl/state_transition/turret/shoot,
		/decl/state_transition/turret/turn_to_bearing
		)

/decl/state/turret/turning
	ray_color = "#ffff00ff"
	switched_to_sound = 'sound/machines/quiet_beep.ogg'
	timer_proc = /obj/machinery/turret/proc/process_turning
	transitions = list(
		/decl/state_transition/turret/lost_power,
		/decl/state_transition/turret/shoot,
		/decl/state_transition/turret/no_enemies
		)


/decl/state/turret/engaging
	ray_color = "#ff0000ff"
	switched_to_sound = 'sound/machines/buttonbeep.ogg'
	timer_proc = /obj/machinery/turret/proc/process_shooting
	transitions = list(
		/decl/state_transition/turret/lost_power,
		/decl/state_transition/turret/turn_to_bearing,
		/decl/state_transition/turret/no_enemies
		)

/decl/state/turret/no_power
	ray_color = "#00000000" // Makes the beam invisible with #RRGGBBAA, not black.
	transitions = list(
		/decl/state_transition/turret/shoot,
		/decl/state_transition/turret/turn_to_bearing,
		/decl/state_transition/turret/no_enemies
		)

/decl/state_transition/turret/turn_to_bearing
	target = /decl/state/turret/turning

/decl/state_transition/turret/turn_to_bearing/is_open(obj/machinery/turret/turret)
	return !turret.within_bearing()


/decl/state_transition/turret/shoot
	target = /decl/state/turret/engaging

/decl/state_transition/turret/shoot/is_open(obj/machinery/turret/turret)
//	return turret.target && turret.within_bearing() && turret.is_valid_target(turret.target.resolve())
	return turret.within_bearing() && turret.find_target()


/decl/state_transition/turret/no_enemies
	target = /decl/state/turret/idle 

/decl/state_transition/turret/no_enemies/is_open(obj/machinery/turret/turret)
	return turret.within_bearing() && !turret.find_target() // TODO

/decl/state_transition/turret/yes_power
	target = /decl/state/turret/idle 


/decl/state_transition/turret/lost_power
	target = /decl/state/turret/no_power

/decl/state_transition/turret/lost_power/is_open(obj/machinery/turret/turret)
	return !turret.is_powered()