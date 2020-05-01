/datum/controller/subsystem/ticker/pregame_tick()
	start_now()

/datum/controller/subsystem/ticker/choose_gamemode()
	master_mode = "persistent"
	bypass_gamemode_vote = TRUE
	. = ..()