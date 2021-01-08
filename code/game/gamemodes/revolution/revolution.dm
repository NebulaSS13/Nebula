/datum/game_mode/revolution
	name = "Revolution"
	config_tag = "revolution"
	round_description = "Some crewmembers are attempting to start a revolution!"
	extended_round_description = "Revolutionaries - Remove the heads of staff from power. Convert other crewmembers to your cause using the 'Convert Bourgeoise' verb. Protect your leaders."
	required_players = 4
	required_enemies = 3
	auto_recall_shuttle = FALSE
	end_on_antag_death = FALSE
	shuttle_delay = 2
	associated_antags = list(
		/decl/special_role/revolutionary,
		/decl/special_role/loyalist
	)
	require_all_templates = TRUE
