/decl/currency/imperial
	name = "\improper Imperial crowns"
	name_prefix = "¢"

/decl/currency/imperial/build_denominations()
	denominations = list(
		new /datum/denomination/coin/crown/regalis(src, 125, null, COLOR_GOLD),
		new /datum/denomination/coin/crown/quin(src,    5, null,  COLOR_SILVER),
		new /datum/denomination/coin/crown(src,         1, null,  COLOR_BRONZE)
	)
	..()

/datum/denomination/coin/crown
	name = "\improper Imperial crown"
	faces = list("obverse", "reverse")

/datum/denomination/coin/crown/New(decl/currency/_currency, value, value_name, colour)
	. = ..()
	name = initial(name) // Awful, evil, terrible.

/datum/denomination/coin/crown/quin
	name = "\improper Imperial quincrown"

/datum/denomination/coin/crown/regalis
	name = "\improper Imperial crown regalis"

/decl/stack_recipe/coin/imperial
	currency = /decl/currency/imperial
	name = "\improper Imperial crown"

/decl/stack_recipe/coin/imperial/quin
	name = "\improper Imperial quincrown"

/decl/stack_recipe/coin/imperial/huge
	name = "\improper Imperial crown regalis"
