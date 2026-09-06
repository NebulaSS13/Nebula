/decl/game_mode/possible_ert_disabled_reasons()
	var/static/sm_injected = FALSE
	if(sm_injected)
		return ..()
	sm_injected = TRUE
	. = ..()
	. += "supermatter dust" // this intentionally mutates the static list in the parent call