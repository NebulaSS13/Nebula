/datum/game_mode/traitor
	name = "traitor"
	round_description = "There is a foreign agent or traitor onboard. Do not let the traitor succeed!"
	extended_round_description = "Some members of the crew have been suborned, and are acting to meet a secret and traitorous goals of their own."
	config_tag = "traitor"
	required_players = 0
	required_enemies = 1
	associated_antags = list(/decl/special_role/traitor)
	antag_scaling_coeff = 5
	end_on_antag_death = FALSE
	latejoin_antags = list(/decl/special_role/traitor)
