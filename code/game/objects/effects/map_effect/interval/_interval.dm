// Base type for effects that run on variable intervals.
/obj/abstract/map_effect/interval
	var/interval_lower_bound = 5 SECONDS // Lower number for how often the map_effect will trigger.
	var/interval_upper_bound = 5 SECONDS // Higher number for above.

/obj/abstract/map_effect/interval/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/abstract/map_effect/interval/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

// Override this for the specific thing to do.
/obj/abstract/map_effect/interval/proc/trigger_map_effect()
	return

// Handles the delay and making sure it doesn't run when it would be bad.
/obj/abstract/map_effect/interval/Process()

	//Not yet!
	if(world.time < next_attempt)
		return

	// Check to see if we're useful first.
	if(!always_run && !check_for_player_proximity(proximity_needed, ignore_ghosts, ignore_afk))
		next_attempt = world.time + retry_delay
		return

	// Hey there's someone nearby.
	next_attempt = world.time + rand(interval_lower_bound, interval_upper_bound)
	trigger_map_effect()
