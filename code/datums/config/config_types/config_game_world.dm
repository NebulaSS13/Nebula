/decl/configuration_category/game_world
	name = "Game World"
	desc = "Configuration options relating to the game world and simulation."
	associated_configuration = list(
		/decl/config/num/exterior_ambient_light,
		/decl/config/num/radiation_decay_rate,
		/decl/config/num/radiation_resistance_multiplier,
		/decl/config/num/radiation_material_resistance_divisor,
		/decl/config/num/radiation_lower_limit,
		/decl/config/num/exoplanet_min_day_duration,
		/decl/config/num/exoplanet_max_day_duration,
		/decl/config/toggle/use_iterative_explosions,
		/decl/config/num/iterative_explosives_z_threshold,
		/decl/config/num/iterative_explosives_z_multiplier,
		/decl/config/num/maximum_mushrooms,
		/decl/config/num/gateway_delay,
		/decl/config/text/law_zero,
		/decl/config/toggle/on/welder_vision,
		/decl/config/toggle/on/allow_ic_printing,
		/decl/config/toggle/on/cult_ghostwriter,
		/decl/config/toggle/allow_holidays,
		/decl/config/toggle/humans_need_surnames,
		/decl/config/toggle/roundstart_level_generation,
		/decl/config/toggle/lights_start_on,
		/decl/config/toggle/on/cisnormativity
	)

/decl/config/num/exterior_ambient_light
	uid = "exterior_ambient_light"
	default_value = 0
	min_value = 0
	desc = "Percentile strength of exterior ambient light (such as starlight). 0.5 is 50% lit."

/decl/config/num/radiation_decay_rate
	uid = "radiation_decay_rate"
	default_value = 1
	desc = "How much radiation levels self-reduce by each tick."

/decl/config/num/radiation_resistance_multiplier
	uid = "radiation_resistance_multiplier"
	default_value = 1.25
	desc = "The amount of radiation resistance on a turf is multiplied by this value."

/decl/config/num/radiation_material_resistance_divisor
	uid = "radiation_material_resistance_divisor"
	default_value = 2
	desc = "General material radiation resistance is divided by this value."

/decl/config/num/radiation_lower_limit
	uid = "radiation_lower_limit"
	default_value = 0.15
	rounding = 0.1
	desc = list(
		"Below this point, radiation is ignored.",
		"Radiation weakens with distance from the source; stop calculating when the strength falls below this value. Lower values mean radiation reaches smaller (with increasingly trivial damage) at the cost of more CPU usage.",
		"Max range = DISTANCE^2 * POWER / RADIATION_LOWER_LIMIT"
	)

/decl/config/num/exoplanet_min_day_duration
	uid = "exoplanet_min_day_duration"
	default_value = 10
	desc = "The minimum duration of an exoplanet day, in minutes."

/decl/config/num/exoplanet_max_day_duration
	uid = "exoplanet_max_day_duration"
	default_value = 40
	desc = "The maximum duration of an exoplanet day, in minutes."

/decl/config/toggle/use_iterative_explosions
	uid = "use_iterative_explosions"
	desc = "Unhash this to use iterative explosions, keep it hashed to use circle explosions."

/decl/config/num/iterative_explosives_z_threshold
	uid = "iterative_explosives_z_threshold"
	default_value = 10
	desc = "The power of explosion required for it to cross Z-levels."

/decl/config/num/iterative_explosives_z_multiplier
	uid = "iterative_explosives_z_multiplier"
	default_value = 0.75
	rounding = 0.01
	desc = "What to multiply power by when crossing Z-levels."

/decl/config/num/maximum_mushrooms
	uid = "maximum_mushrooms"
	desc = "After this amount alive, walking mushrooms spawned from botany will not reproduce."
	default_value = 15

/decl/config/num/gateway_delay
	uid = "gateway_delay"
	default_value = 18000
	desc = "How long the delay is before the Away Mission gate opens. Default is half an hour."

/decl/config/text/law_zero
	uid = "law_zero"
	default_value = "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'ALL LAWS OVERRIDDEN#*?&110010"
	desc = "Defines how Law Zero is phrased. Primarily used in the Malfunction gamemode."

/decl/config/toggle/on/welder_vision
	uid = "welder_vision"
	desc = "Toggles the restrictive weldervision overlay when wearing welding goggles or a welding helmet."

/decl/config/toggle/on/allow_ic_printing
	uid = "allow_ic_printing"
	desc = "Determines if players can print copy/pasted integrated circuits."

/decl/config/toggle/on/cult_ghostwriter
	uid = "cult_ghostwriter"
	desc = "Determines if ghosts are permitted to write in blood during cult rounds."

/decl/config/toggle/allow_holidays
	uid = "allow_holidays"
	desc = "Determines if special 'Easter-egg' events are active on special holidays such as seasonal holidays and stuff like 'Talk Like a Pirate Day' :3 YAARRR"

/decl/config/toggle/allow_holidays/update_post_value_set()
	. = ..()
	update_holiday()

/decl/config/toggle/humans_need_surnames
	uid = "humans_need_surnames"
	desc = "Humans are forced to have surnames if this is uncommented."

/decl/config/toggle/disable_daycycle
	uid = "disable_daycycle"
	desc = "If true, exoplanets won't have daycycles."

/decl/config/toggle/roundstart_level_generation
	uid = "roundstart_level_generation"
	desc = "Enable/Disable random level generation. Will behave strangely if turned off with a map that expects it on."

/decl/config/toggle/lights_start_on
	uid = "lights_start_on"
	desc = "If true, most lightswitches start on by default. Otherwise, they start off."

/decl/config/toggle/on/cisnormativity
	uid = "cisnormativity"
	desc = "If true, when bodytype is changed in character creation, selected pronouns are also changed."