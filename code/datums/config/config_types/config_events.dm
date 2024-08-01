/decl/configuration_category/events
	name = "Events"
	desc = "Configuration options relating to event timers and probabilities."
	associated_configuration = list(
		/decl/config/enum/objectives_disabled,
		/decl/config/lists/event_first_run,
		/decl/config/lists/event_delay_lower,
		/decl/config/lists/event_delay_upper,
		/decl/config/toggle/on/allow_random_events
	)

//if objectives are disabled or not
/decl/config/enum/objectives_disabled
	uid = "objectives_disabled"
	default_value = CONFIG_OBJECTIVE_NONE
	desc = "Determines if objectives are disabled."
	enum_map = list(
		"none" = CONFIG_OBJECTIVE_NONE,
		"verb" = CONFIG_OBJECTIVE_VERB,
		"all"  = CONFIG_OBJECTIVE_ALL
	)

// No custom time, no custom time, between 80 to 100 minutes respectively.
/decl/config/lists/event_first_run
	uid = "event_first_run"
	desc = "If the first delay has a custom start time. Defined in minutes."
	default_value = list(null, null, list("lower" = 80, "upper" = 100))

/decl/config/lists/event_delay_lower
	uid = "event_delay_lower"
	default_value = list(10, 30, 50)
	desc = list(
		"The lower delay between events in minutes.",
		"Affect mundane, moderate, and major events respectively."
	)

/decl/config/lists/event_delay_upper
	uid = "event_delay_upper"
	default_value = list(15, 45, 70)
	desc = list(
		"The upper delay between events in minutes.",
		"Affect mundane, moderate, and major events respectively."
	)

/decl/config/toggle/on/allow_random_events
	uid = "allow_random_events"
	desc = "Hash out to disable random events during the round."
