/decl/background_detail/citizenship/other
	name = "Other Polity"
	uid = "stateless_citizenship"
	description = "You are from one of the many small, relatively unknown powers scattered across the galaxy."
	language = /decl/language/human/common
	secondary_langs = list(
		/decl/language/human/common,
		/decl/language/sign
	)

/decl/background_detail/citizenship/stateless
	name = "Stateless"
	uid = "stateless"
	description = "You do not possess any kind of official citizenship."
	economic_power = 0

/decl/background_detail/citizenship/synthetic
	name = "Stateless Drone"
	uid = "stateless_drone"
	description = "Drones are considered property in most systems. Thus, statelessness is ubiqtuous for them."
	secondary_langs = list(
		/decl/language/machine,
		/decl/language/human/common,
		/decl/language/sign
	)

/decl/background_detail/citizenship/synthetic/sanitize_background_name(new_name)
	return sanitize_name(new_name, allow_numbers = TRUE)
