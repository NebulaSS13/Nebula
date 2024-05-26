/decl/configuration_category/debug
	name = "Debug"
	desc = "Configuration options relating to error reporting."
	associated_configuration = list(
		/decl/config/num/debug_error_cooldown,
		/decl/config/num/debug_error_limit,
		/decl/config/num/debug_error_silence_time,
		/decl/config/num/debug_error_msg_delay,
		/decl/config/toggle/paranoid
	)

/decl/config/num/debug_error_cooldown
	uid = "error_cooldown"
	desc = "The \"cooldown\" time for each occurrence of a unique error."
	default_value = 600

/decl/config/num/debug_error_limit
	uid = "error_limit"
	desc = "How many occurrences before the next will silence them."
	default_value = 50

/decl/config/num/debug_error_silence_time
	uid = "error_silence_time"
	desc = "How long a unique error will be silenced for."
	default_value = 6000

/decl/config/num/debug_error_msg_delay
	uid = "error_msg_delay"
	desc = "How long to wait between messaging admins about occurrences of a unique error."
	default_value = 50

/decl/config/toggle/paranoid
	uid = "debug_paranoid"
	desc = list(
		"Uncomment to make proccall require R_ADMIN instead of R_DEBUG",
		"designed for environments where you have testers but don't want them",
		"able to use the more powerful debug options."
	)
