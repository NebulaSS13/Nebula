/datum/game_mode/changeling
	name = "Changeling"
	round_description = "There are alien changelings onboard. Do not let the changelings succeed!"
	extended_round_description = "One or more of the crew have secretly been replaced by an alien shapeshifter called a changeling. It could be anyone!"
	config_tag = "changeling"
	required_players = 2
	required_enemies = 1
	end_on_antag_death = FALSE
	antag_scaling_coeff = 10
	associated_antags = list(/decl/special_role/changeling)