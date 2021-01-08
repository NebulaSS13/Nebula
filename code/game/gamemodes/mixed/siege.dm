/datum/game_mode/siege
	name = "Mercenary & Revolution"
	config_tag = "siege"
	round_description = "Getting stuck between a rock and a hard place, maybe the nice visitors can help with your internal security problem?"
	extended_round_description = "GENERAL QUARTERS! OH GOD WE GAVE THE REVOLUTIONARIES GUNS!"
	required_players = 20
	required_enemies = 5
	end_on_antag_death = FALSE
	auto_recall_shuttle = FALSE
	shuttle_delay = 2
	associated_antags = list(
		/decl/special_role/revolutionary,
		/decl/special_role/loyalist,
		/decl/special_role/mercenary
	)
	require_all_templates = TRUE
