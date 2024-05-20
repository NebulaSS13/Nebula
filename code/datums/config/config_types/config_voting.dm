/decl/configuration_category/voting
	name = "Voting"
	desc = "Configuration options relating to votes at runtime."
	associated_configuration = list(
		/decl/config/num/vote_delay,
		/decl/config/num/vote_period,
		/decl/config/num/vote_autotransfer_initial,
		/decl/config/num/vote_autotransfer_interval,
		/decl/config/num/vote_autogamemode_timeleft,
		/decl/config/num/vote_no_default,
		/decl/config/num/vote_no_dead,
		/decl/config/num/vote_no_dead_crew_transfer,
		/decl/config/toggle/vote_restart,
		/decl/config/toggle/vote_mode,
		/decl/config/toggle/allow_map_switching,
		/decl/config/toggle/auto_map_vote
	)

/decl/config/num/vote_delay
	uid = "vote_delay"
	default_value = 6000
	desc = "Min delay (deciseconds) between voting sessions (default 10 minutes)."

/decl/config/num/vote_period
	uid = "vote_period"
	default_value = 600
	desc = "Time period (deciseconds) which voting session will last (default 1 minute)."

/decl/config/num/vote_autotransfer_initial
	uid = "vote_autotransfer_initial"
	default_value = 108000
	desc = "Autovote initial delay (deciseconds) before first automatic transfer vote call (default 180 minutes)."

/decl/config/num/vote_autotransfer_interval
	uid = "vote_autotransfer_interval"
	default_value = 18000
	desc = "Autovote delay (deciseconds) before sequential automatic transfer votes are called (default 30 minutes)."

/decl/config/num/vote_autogamemode_timeleft
	uid = "vote_autogamemode_timeleft"
	default_value = 100
	desc = "Time left (seconds) before round start when automatic gamemote vote is called (default 160)."

/decl/config/num/vote_no_default
	uid = "vote_no_default"
	default_value = FALSE
	config_flags = CONFIG_FLAG_BOOL | CONFIG_FLAG_HAS_VALUE
	desc = "Players' votes default to 'No vote' (otherwise,  default to 'No change')."

/decl/config/num/vote_no_dead
	uid = "vote_no_dead"
	default_value = FALSE
	config_flags = CONFIG_FLAG_BOOL | CONFIG_FLAG_HAS_VALUE
	desc = "Prevents dead players from voting or starting votes."

/decl/config/num/vote_no_dead_crew_transfer
	uid = "vote_no_dead_crew_transfer"
	default_value = FALSE
	config_flags = CONFIG_FLAG_BOOL | CONFIG_FLAG_HAS_VALUE
	desc = "Prevents players not in-round from voting on crew transfer votes."

/decl/config/toggle/vote_restart
	uid = "allow_vote_restart"
	desc = "Allow players to initiate a restart vote."

/decl/config/toggle/vote_mode
	uid = "allow_vote_mode"
	desc = "Allow players to initate a mode-change start."

/decl/config/toggle/allow_map_switching
	uid = "allow_map_switching"
	desc = list(
		"Uncomment to enable map voting; you'll need to use the script at tools/server.sh or an equivalent for it to take effect.",
		"You'll also likely need to enable WAIT_FOR_SIGUSR1 below."
	)

/decl/config/toggle/auto_map_vote
	uid = "auto_map_vote"
	desc = "Determines if the automatic map vote and switch are called at end of round. MAP_SWITCHING must also be enabled."
