/datum/denomination
	var/name
	var/state
	var/mark
	var/list/faces
	var/marked_value
	var/image/overlay
	var/rotate_icon = TRUE
	var/decl/currency/currency

/datum/denomination/New(var/decl/currency/_currency, var/value, var/value_name, var/colour = COLOR_PALE_BTL_GREEN)
	..()
	currency = _currency
	name = "[value_name] [currency.name_singular] [name || "piece"]"
	state = state || "cash"
	marked_value = value
	overlay = image(currency, state)
	overlay.color = colour
	overlay.appearance_flags |= RESET_COLOR | PIXEL_SCALE
	overlay.plane = FLOAT_PLANE
	overlay.layer = FLOAT_LAYER
	if(mark)
		var/image/use_mark = image(currency.icon, mark)
		use_mark.appearance_flags |= RESET_COLOR
		overlay.overlays |= use_mark

/datum/denomination/coin
	name = "coin"
	state = "coin"
	faces = list("heads", "tails")
	rotate_icon = FALSE

/datum/denomination/note
	name = "note"
	mark = "mark"

/datum/denomination/bundle
	name = "bundle"
	state = "cash_x_5"
	mark =  "mark_x_5"

/decl/currency
	var/name
	var/name_singular
	var/name_prefix
	var/name_suffix
	var/icon = 'icons/obj/items/money.dmi'
	var/material = /decl/material/solid/plastic
	var/absolute_value = 1 // Divisor for cash pile worth. Should never be <1 or non-integer (think of it like cents).
	var/list/denominations = list()
	var/list/denominations_by_value = list()

/decl/currency/New()
	if(!name_singular)
		name_singular = name
	if(!name_prefix && !name_suffix)
		name_suffix = uppertext(copytext(name, 1, 1))
	build_denominations()
	..()

/decl/currency/proc/format_value(var/amt)
	. = "[name_prefix][FLOOR(amt / absolute_value)][name_suffix]"

/decl/currency/proc/build_denominations()
	for(var/datum/denomination/denomination in denominations)
		denominations_by_value["[denomination.marked_value]"] = denomination
	sortTim(denominations, /proc/cmp_currency_denomination_des)

/decl/currency/credits
	name =          "credits"
	name_singular = "credit"
	name_suffix =   "cr"

/decl/currency/credits/build_denominations()
	denominations = list(
		new /datum/denomination/bundle(src, 1000, "one thousand"),
		new /datum/denomination/bundle(src, 500,  "five hundred"),
		new /datum/denomination/note(src,   100,  "one hundred"),
		new /datum/denomination/note(src,   50,   "fifty",  COLOR_PALE_YELLOW),
		new /datum/denomination/note(src,   20,   "twenty", COLOR_ORANGE),
		new /datum/denomination/note(src,   10,   "ten",    COLOR_PALE_BLUE_GRAY),
		new /datum/denomination/note(src,   5,    "five",   COLOR_PALE_PURPLE_GRAY),
		new /datum/denomination/coin(src,   2,    "two",    COLOR_GOLD),
		new /datum/denomination/coin(src,   1,    "one",    COLOR_GOLD)
	)
	..()

/datum/denomination/coin/mid
	state = "coin_medium"

/datum/denomination/coin/large
	state = "coin_large"

/decl/currency/trader
	name = "scrip"
	name_prefix = "$"
	material = /decl/material/solid/metal/copper

/decl/currency/trader/build_denominations()
	denominations = list(
		new /datum/denomination/coin/large(src, 10, "ten",  COLOR_GOLD),
		new /datum/denomination/coin/mid(src,   5,  "five", COLOR_SILVER),
		new /datum/denomination/coin(src,       1,  "one",  COLOR_BRONZE)
	)
	..()

/decl/currency/scav
	name = "scavbucks"
	name_singular = "scavbuck"
	name_suffix = "sb"
	material = /decl/material/solid/slag

/datum/denomination/trash
	name = "wiggly string"
	state = "string"
/datum/denomination/trash/bone
	name = "pointy bone"
	state = "bone"
/datum/denomination/trash/rock
	name = "neat rock"
	state = "rock"
/datum/denomination/trash/shell
	name = "tasty shell"
	state = "shell"

/decl/currency/scav/build_denominations()
	denominations = list(
		new /datum/denomination/trash(src,       1, "one",   COLOR_RED_GRAY),
		new /datum/denomination/trash/bone(src,  2, "two",   COLOR_OFF_WHITE),
		new /datum/denomination/trash/rock(src,  3, "three", COLOR_SILVER),
		new /datum/denomination/trash/shell(src, 4, "four",  COLOR_BLUE_GRAY)
	)
	..()
