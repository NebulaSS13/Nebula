/datum/mob_controller
	/// What world.time did our stance change at?
	var/stance_changed_time
	/// What is our current general attitude and demeanor?
	var/decl/mob_controller_stance/stance
	/// How close can someone be before we leave our alert state and attack?
	var/alert_threat_range = 4
	/// String to show when we enter an alert state.
	var/alert_started_str = "$USER$ stares alertly at $TARGET$."
	/// Strings to show to our potential target during an alert state.
	var/alert_threatened_str = list(
		"$USER$ growls at $TARGET$...",
		"$USER$ stares angrily at $TARGET$...",
		"$USER$ prepares to attack $TARGET$...",
		"$USER$ closely watches $TARGET$..."
	)
	/// Aggressive AI var; defined here for reference without casting.
	var/try_destroy_surroundings = FALSE
	// What chance is there of destroying our surroundings during an attack move?
	var/break_stuff_probability = 0
	/// What chance do we have of lying down while we are idle?
	var/rest_chance = 0.5

/datum/mob_controller/proc/set_stance(decl/mob_controller_stance/new_stance)
	new_stance = RESOLVE_TO_DECL(new_stance) || GET_DECL(/decl/mob_controller_stance/idle)
	if(stance == new_stance)
		return FALSE
	stance?.on_stance_unset(body, src)
	stance = new_stance
	stance_changed_time = world.time
	stance?.on_stance_set(body, src)
	return TRUE

/datum/mob_controller/proc/get_stance()
	RETURN_TYPE(/decl/mob_controller_stance)
	return stance

/datum/mob_controller/proc/startle()
	if(QDELETED(body) || body.stat != UNCONSCIOUS)
		return
	body.set_stat(CONSCIOUS)
	if(body.current_posture?.prone)
		body.set_posture(/decl/posture/standing)

/datum/mob_controller/proc/get_alert_time()
	return 5 SECONDS
