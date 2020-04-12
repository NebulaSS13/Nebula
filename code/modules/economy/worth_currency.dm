/decl/currency
	var/name =           "credits"
	var/name_singular =  "credit"
	var/name_short =     "cr"
	var/icon =           'icons/obj/items/money.dmi'
	var/material =       MAT_PLASTIC
	var/absolute_value = 1 // Divisor for cash pile worth. Should never be <1 or non-integer (think of it like cents).

	// Sort denominations by highest to lowest for the purposes of money
	// icon generation not producing a pile of 2000 $1 coin overlays.
	var/list/denominations = list(
		1000,
		500,
		100,
		50,
		20,
		10,
		5,
		2,
		1
	)

	var/list/denomination_has_mark = list(
		"500" =  "mark_x_5",
		"100" =  "mark", 
		"50" =   "mark",
		"20" =   "mark",
		"10" =   "mark",
		"5" =    "mark"
	)
	var/list/denomination_has_colour = list(
		"1" =    COLOR_GOLD,
		"2" =    COLOR_GOLD,
		"5" =    COLOR_PALE_PURPLE_GRAY,
		"10" =   COLOR_PALE_BLUE_GRAY,
		"20" =   COLOR_ORANGE,
		"50" =   COLOR_PALE_YELLOW
	)
	var/list/denomination_has_state = list(
		"1" =    "coin",
		"2" =    "coin",
		"500" =  "cash_x_5"
	)

/decl/currency/supply
	name =               "supply credits"
	name_singular =      "supply credit"
	name_short =         "supply"
