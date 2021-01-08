/*
(VOX) HEIST ROUNDTYPE
*/

/datum/game_mode/heist
	name = "Heist"
	config_tag = "heist"
	required_players = 12
	required_enemies = 3
	round_description = "An unidentified drive signature has slipped into close sensor range and is approaching!"
	extended_round_description = "Piratical raiders are on their way to steal the station goods, and possibly the crew!"
	end_on_antag_death = FALSE
	associated_antags = list(/decl/special_role/raider)
