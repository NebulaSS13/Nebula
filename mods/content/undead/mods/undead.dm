/mob/living/human/get_movement_delay(var/travel_dir)
	. = ..()
	if(has_trait(/decl/trait/undead))
		set_moving_slowly()
		if(istype(default_walk_intent))
			. = max(., default_walk_intent.move_delay) // no runner zombies yet

// Overridden by fantasy modpack.
/mob/living/human/proc/grant_basic_undead_equipment()
	return
