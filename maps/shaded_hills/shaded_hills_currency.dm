/datum/map/shaded_hills
	starting_cash_choices = list(
		/decl/starting_cash_choice/none,
		/decl/starting_cash_choice/cash
	)
	default_currency = /decl/currency/imperial
	salary_modifier = 0.05 // turn the 300-400 base into 15-20 base

/// Functionally identical to its parent type, but with a different name since it's not defined until later.
/decl/starting_cash_choice/none
	name = "none"
	uid = "starting_cash_none"
