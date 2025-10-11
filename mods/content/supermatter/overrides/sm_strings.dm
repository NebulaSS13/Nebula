/decl/game_mode/possible_ert_disabled_reasons()
	var/static/sm_injected = FALSE
	if(sm_injected)
		return ..()
	sm_injected = TRUE
	. = ..()
	. += "supermatter dust"

/obj/item/disk/secret_project/get_secret_project_nouns()
	var/static/sm_injected = FALSE
	if(sm_injected)
		return ..()
	sm_injected = TRUE
	. = ..()
	. += "a supermatter engine"
	return .
