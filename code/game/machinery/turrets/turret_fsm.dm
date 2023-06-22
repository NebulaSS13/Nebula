/datum/state_machine/turret
	current_state = /decl/state/turret/idle
	expected_type = /obj/machinery/turret

/decl/state/turret
	var/ray_color = "#ffffffff" // Turrets have a visual indicator of their current state.
	var/switched_to_sound = null

	var/timer_proc = null
	var/timer_wait = TURRET_WAIT

/decl/state/turret/entered_state(obj/machinery/turret/turret)
	turret.ray_color = src.ray_color
	turret.update_icon()
	if(switched_to_sound)
		playsound(turret, switched_to_sound, 40, TRUE)
	if(timer_proc)
		turret.timer_id = addtimer(CALLBACK(turret, timer_proc), timer_wait, TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_LOOP|TIMER_OVERRIDE)

/decl/state/turret/exited_state(obj/machinery/turret/turret)
	if(timer_proc && turret.timer_id)
		deltimer(turret.timer_id)
		turret.timer_id = null
/decl/state/turret/idle
	ray_color = "#00ff00ff"
	switched_to_sound = 'sound/machines/triple_beep.ogg'
	// Timer for returning to default bearing.
	timer_proc = /obj/machinery/turret/proc/process_idle
	timer_wait = 5 SECONDS

	transitions = list(
		/decl/state_transition/turret/lost_power,
		/decl/state_transition/turret/reload,
		/decl/state_transition/turret/shoot,
		/decl/state_transition/turret/turn_to_bearing
		)

/decl/state/turret/turning
	ray_color = "#ffff00ff"
	switched_to_sound = 'sound/machines/quiet_beep.ogg'
	timer_proc = /obj/machinery/turret/proc/process_turning
	transitions = list(
		/decl/state_transition/turret/lost_power,
		/decl/state_transition/turret/reload,
		/decl/state_transition/turret/shoot,
		/decl/state_transition/turret/no_enemies
		)

/decl/state/turret/engaging
	ray_color = "#ff0000ff"
	switched_to_sound = 'sound/machines/buttonbeep.ogg'
	timer_proc = /obj/machinery/turret/proc/process_shooting
	transitions = list(
		/decl/state_transition/turret/lost_power,
		/decl/state_transition/turret/reload,
		/decl/state_transition/turret/turn_to_bearing,
		/decl/state_transition/turret/no_enemies
		)

/decl/state/turret/reloading
	ray_color = "#ffa600ff"
	switched_to_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'
	timer_proc = /obj/machinery/turret/proc/process_reloading
	transitions = list(
		/decl/state_transition/turret/lost_power,
		/decl/state_transition/turret/shoot,
		/decl/state_transition/turret/turn_to_bearing,
		/decl/state_transition/turret/no_enemies
	)

/decl/state/turret/reloading/entered_state(obj/machinery/turret/turret)
	. = ..()
	turret.reloading_progress = 0

/decl/state/turret/no_power
	ray_color = "#00000000" // Makes the beam invisible with #RRGGBBAA, not black.
	transitions = list(
		/decl/state_transition/turret/reload,
		/decl/state_transition/turret/shoot,
		/decl/state_transition/turret/turn_to_bearing,
		/decl/state_transition/turret/no_enemies
		)

/decl/state_transition/turret/is_open(obj/machinery/turret/turret)
	return turret.operable() && turret.enabled
/decl/state_transition/turret/turn_to_bearing
	target = /decl/state/turret/turning

/decl/state_transition/turret/turn_to_bearing/is_open(obj/machinery/turret/turret)
	. = ..()
	return . && !turret.within_bearing()

/decl/state_transition/turret/shoot
	target = /decl/state/turret/engaging

/decl/state_transition/turret/shoot/is_open(obj/machinery/turret/turret)
	. = ..()
	return . && turret.find_target() && turret.within_bearing()

/decl/state_transition/turret/reload
	target = /decl/state/turret/reloading

/decl/state_transition/turret/reload/is_open(obj/machinery/turret/turret)
	. = ..()
	return . && turret.should_reload()

/decl/state_transition/turret/no_enemies
	target = /decl/state/turret/idle

/decl/state_transition/turret/no_enemies/is_open(obj/machinery/turret/turret)
	. = ..()
	return . && turret.within_bearing() && !turret.find_target()

/decl/state_transition/turret/lost_power
	target = /decl/state/turret/no_power

/decl/state_transition/turret/lost_power/is_open(obj/machinery/turret/turret)
	return !turret.enabled || turret.inoperable()