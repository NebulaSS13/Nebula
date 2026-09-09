/datum/mob_controller/aggressive
	target_scan_distance    = 10
	ai_flags                = AI_FLAG_WANDERS | AI_FLAG_AGGRESSIVE | AI_FLAG_ALERTS | AI_FLAG_CAUTIOUS
	break_stuff_probability = 10

/datum/mob_controller/passive
	speak_chance            = 0.25
	turns_per_wander        = 10
	ai_flags                = AI_FLAG_NO_PULLED_WANDER | AI_FLAG_WANDERS | AI_FLAG_COWARD

/datum/mob_controller/hunter
	target_scan_distance    = 10
	speak_chance            = 0.25
	turns_per_wander        = 10
	ai_flags                = AI_FLAG_WANDERS | AI_FLAG_AGGRESSIVE | AI_FLAG_CAUTIOUS | AI_FLAG_COWARD | AI_FLAG_HUNTER
