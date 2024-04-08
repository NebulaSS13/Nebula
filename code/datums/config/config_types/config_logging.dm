/decl/configuration_category/logging
	name = "Logging"
	desc = "Configuration options relating to logging."
	associated_configuration = list(
		/decl/config/toggle/log_ooc,
		/decl/config/toggle/log_access,
		/decl/config/toggle/log_say,
		/decl/config/toggle/log_admin,
		/decl/config/toggle/log_debug,
		/decl/config/toggle/log_game,
		/decl/config/toggle/log_vote,
		/decl/config/toggle/log_whisper,
		/decl/config/toggle/log_emotes,
		/decl/config/toggle/log_attack,
		/decl/config/toggle/log_adminchat,
		/decl/config/toggle/log_adminwarn,
		/decl/config/toggle/log_hrefs,
		/decl/config/toggle/log_runtime,
		/decl/config/toggle/log_world_output
	)

/decl/config/toggle/log_ooc
	uid = "log_ooc"
	desc = "log OOC channel"

/decl/config/toggle/log_access
	uid = "log_access"
	desc = "log client access (logon/logoff)"

/decl/config/toggle/log_say
	uid = "log_say"
	desc = "log client Say"

/decl/config/toggle/log_admin
	uid = "log_admin"
	desc = "log admin actions"

/decl/config/toggle/log_debug
	uid = "log_debug"
	desc = "log debug output"

/decl/config/toggle/log_game
	uid = "log_game"
	desc = "log game actions (start of round, results, etc.)"

/decl/config/toggle/log_vote
	uid = "log_vote"
	desc = "log player votes"

/decl/config/toggle/log_whisper
	uid = "log_whisper"
	desc = "log client Whisper"

/decl/config/toggle/log_emotes
	uid = "log_emote"
	desc = "log emotes"

/decl/config/toggle/log_attack
	uid = "log_attack"
	desc = "log attack messages"

/decl/config/toggle/log_adminchat
	uid = "log_adminchat"
	desc = "log admin chat"

/decl/config/toggle/log_adminwarn
	uid = "log_adminwarn"
	desc = "Log admin warning messages. Also duplicates a bunch of other messages."

/decl/config/toggle/log_hrefs
	uid = "log_hrefs"
	desc = "Log all Topic() calls (for use by coders in tracking down Topic issues)."

/decl/config/toggle/log_runtime
	uid = "log_runtime"
	desc = "Log world.log and runtime errors to a file."

/decl/config/toggle/log_world_output
	uid = "log_world_output"
	desc = "Log world.log messages."
