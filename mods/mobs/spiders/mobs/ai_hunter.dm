/datum/mob_controller/aggressive/giant_spider/hunter
	hunt_chance = 12
	break_stuff_probability = 30
	can_escape_buckles = TRUE

/datum/mob_controller/aggressive/giant_spider/hunter/move_to_target(var/move_only = FALSE)
	if(!body.can_act() || body.perform_maneuver(/decl/maneuver/leap/spider, get_target()))
		return
	..()
