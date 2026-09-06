/decl/configuration_category/modes
	name = "Modes"
	desc = "Configuration options relating to game modes."
	associated_configuration = list(
		/decl/config/lists/mode_names,
		/decl/config/lists/mode_allowed,
		/decl/config/lists/mode_votable,
		/decl/config/lists/mode_probabilities,
		/decl/config/toggle/traitor_scaling,
		/decl/config/toggle/protect_roles_from_antagonist,
		/decl/config/toggle/continuous_rounds,
		/decl/config/toggle/allow_extra_antags
	)

/decl/config/lists/mode_names
	uid = "mode_names"
	desc = "Mode names."
	default_value = list()

/decl/config/lists/mode_names/Initialize()
	var/list/all_modes = decls_repository.get_decls_of_subtype(/decl/game_mode)
	for(var/mode_type in all_modes)
		var/decl/game_mode/game_mode = all_modes[mode_type]
		default_value[game_mode.uid] = game_mode.name
	return ..()

/decl/config/lists/mode_allowed
	uid = "modes"
	desc = "Allowed modes."
	default_value = list()

/decl/config/lists/mode_allowed/Initialize()
	var/list/all_modes = decls_repository.get_decls_of_subtype(/decl/game_mode)
	for(var/mode_type in all_modes)
		var/decl/game_mode/game_mode = all_modes[mode_type]
		if(game_mode.available_by_default)
			default_value += game_mode.uid
	default_value = sortTim(default_value, /proc/cmp_text_asc)
	return ..()

/decl/config/lists/mode_votable
	uid = "votable_modes"
	desc = "A list of modes that should be votable."
	default_value = list()

/decl/config/lists/mode_votable/Initialize()
	default_value = list("secret")
	var/list/all_modes = decls_repository.get_decls_of_subtype(/decl/game_mode)
	for(var/mode_type in all_modes)
		var/decl/game_mode/game_mode = all_modes[mode_type]
		if(game_mode.votable)
			default_value += game_mode.uid
	default_value = sortTim(default_value, /proc/cmp_text_asc)
	return ..()

/decl/config/lists/mode_votable/set_value(new_value)
	. = ..()
	LAZYDISTINCTADD(value, "secret")
	value = sortTim(value, /proc/cmp_text_asc)

/decl/config/lists/mode_probabilities
	uid = "probabilities"
	desc = "Relative probability of each mode."
	default_value = list()

/decl/config/lists/mode_probabilities/Initialize()
	var/list/all_modes = decls_repository.get_decls_of_subtype(/decl/game_mode)
	for(var/mode_type in all_modes)
		var/decl/game_mode/game_mode = all_modes[mode_type]
		default_value[game_mode.uid] = initial(game_mode.probability)
	return ..()

/decl/config/lists/mode_probabilities/update_post_value_set()
	. = ..()
	var/list/all_modes = decls_repository.get_decls_of_subtype(/decl/game_mode)
	for(var/mode_type in all_modes)
		var/decl/game_mode/game_mode = all_modes[mode_type]
		game_mode.probability = max(0, value[game_mode.uid])

/decl/config/toggle/traitor_scaling
	uid = "traitor_scaling"
	desc = "If amount of traitors scales or not."

/decl/config/toggle/protect_roles_from_antagonist
	uid = "protect_roles_from_antagonist"
	desc = "If security is prohibited from being most antagonists."

/decl/config/toggle/continuous_rounds
	uid = "continuous_rounds"
	desc = list(
		"Remove the # to make rounds which end instantly continue until the shuttle is called or the station is nuked.",
		"Malf and Rev will let the shuttle be called when the antags/protags are dead."
	)

/decl/config/toggle/antag_hud_allowed
	uid = "antag_hud_allowed"
	desc = "Allow ghosts to see antagonist through AntagHUD."

/decl/config/toggle/antag_hud_allowed/update_post_value_set()
	. = ..()
	if(value)
		for(var/mob/observer/ghost/g in get_ghosts())
			if(!g.client.holder)						// Add the verb back for all non-admin ghosts
				g.verbs += /mob/observer/ghost/verb/toggle_antagHUD
				to_chat(g, SPAN_NOTICE("<B>AntagHUD has been enabled!</B>"))// Notify all observers they can now use AntagHUD
	else
		for(var/mob/observer/ghost/g in get_ghosts())
			if(!g.client.holder)						//Remove the verb from non-admin ghosts
				g.verbs -= /mob/observer/ghost/verb/toggle_antagHUD
			if(g.antagHUD)
				g.antagHUD = 0						// Disable it on those that have it enabled
				g.has_enabled_antagHUD = 2				// We'll allow them to respawn
				to_chat(g, SPAN_DANGER("AntagHUD has been disabled."))

/decl/config/toggle/antag_hud_restricted
	uid = "antag_hud_restricted"
	desc = "If ghosts use antagHUD they are no longer allowed to join the round."

/decl/config/toggle/secret_hide_possibilities
	uid = "secret_hide_possibilities"
	desc = "If possible round types will be hidden from players for secret rounds."

/decl/config/toggle/allow_extra_antags
	uid = "allow_extra_antags"
	desc = "If uncommented, votes can be called to add extra antags to the round."
