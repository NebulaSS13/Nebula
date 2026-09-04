/obj/abstract/map_effect
	icon = 'icons/effects/map_effects.dmi'

	// Below vars concern check_for_player_proximity() and is used to not waste effort if nobody is around to appreciate the effects.
	/// If true, the game will not try to suppress this from firing if nobody is around to see it.
	var/always_run = FALSE
	/// How many tiles a mob with a client must be for this to run.
	var/proximity_needed = 12
	/// If true, ghosts won't satisfy the above requirement.
	var/ignore_ghosts = FALSE
	/// If true, AFK people (5 minutes) won't satisfy it as well.
	var/ignore_afk = TRUE
	/// How long until we check for players again.
	var/retry_delay = 5 SECONDS
	/// Next time we're going to do ACTUAL WORK
	var/next_attempt = 0

// Helper proc to optimize the use of effects by making sure they do not run if nobody is around to perceive it.
/obj/abstract/map_effect/proc/check_for_player_proximity(radius = 12, ignore_ghosts = FALSE, ignore_afk = TRUE)
	if(!z)
		return FALSE
	for(var/mob/player as anything in player_list)
		if(player.z != z)
			continue
		if(ignore_ghosts && isobserver(player))
			continue
		if(ignore_afk && player.client && player.client.is_afk(5 MINUTES))
			continue
		if(get_dist(player, src) <= radius)
			return TRUE
	return FALSE
