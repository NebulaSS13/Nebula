#define PIPE_STRAIGHT 2
#define PIPE_BENT     5

/datum/fabricator_recipe/pipe
	name = "pipe fitting"
	rotate_class = PIPE_ROTATE_TWODIR

/datum/fabricator_recipe/pipe/bent
	name = "bent pipe fitting"
	dir = PIPE_BENT
	rotate_class = PIPE_ROTATE_TWODIR

/datum/fabricator_recipe/pipe/manifold
	name = "pipe manifold fitting"
	build_icon_state = "manifold"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold/hidden
	pipe_class = PIPE_CLASS_TRINARY
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/manifold4w
	name = "four-way pipe manifold fitting"
	build_icon_state = "manifold4w"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold4w/hidden
	pipe_class = PIPE_CLASS_QUATERNARY
	rotate_class = PIPE_ROTATE_ONEDIR

/datum/fabricator_recipe/pipe/cap
	name = "pipe cap fitting"
	build_icon_state = "cap"
	constructed_path = /obj/machinery/atmospherics/pipe/cap/hidden
	pipe_class = PIPE_CLASS_UNARY
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/up
	name = "upward pipe fitting"
	build_icon_state = "up"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/up
	rotate_class = PIPE_ROTATE_STANDARD


/datum/fabricator_recipe/pipe/down
	name = "downward pipe fitting"
	build_icon_state = "down"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/down
	rotate_class = PIPE_ROTATE_STANDARD


/datum/fabricator_recipe/pipe/supply
	category = "Supply Pipes"
	colorable = FALSE
	connect_types = CONNECT_TYPE_SUPPLY
	pipe_color = PIPE_COLOR_BLUE
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/supply
	pipe_class = PIPE_CLASS_BINARY

	name = "supply pipe fitting"
	rotate_class = PIPE_ROTATE_TWODIR

/datum/fabricator_recipe/pipe/supply/bent
	name = "bent supply pipe fitting"
	dir = PIPE_BENT
	rotate_class = PIPE_ROTATE_TWODIR

/datum/fabricator_recipe/pipe/supply/manifold
	name = "supply pipe manifold fitting"
	build_icon_state = "manifold"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold/hidden/supply
	pipe_class = PIPE_CLASS_TRINARY
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/supply/manifold4w
	name = "four-way supply pipe manifold fitting"
	build_icon_state = "manifold4w"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold4w/hidden/supply
	pipe_class = PIPE_CLASS_QUATERNARY
	rotate_class = PIPE_ROTATE_ONEDIR

/datum/fabricator_recipe/pipe/supply/cap
	name = "supply pipe cap fitting"
	build_icon_state = "cap"
	constructed_path = /obj/machinery/atmospherics/pipe/cap/hidden/supply
	pipe_class = PIPE_CLASS_UNARY
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/supply/up
	name = "upward supply pipe fitting"
	build_icon_state = "up"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/up/supply
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/supply/down
	name = "downward supply pipe fitting"
	build_icon_state = "down"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/down/supply
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/scrubber
	category = "Scrubber Pipes"
	colorable = FALSE
	connect_types = CONNECT_TYPE_SCRUBBER
	pipe_color = PIPE_COLOR_RED
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/scrubbers
	pipe_class = PIPE_CLASS_BINARY

	name = "scrubber pipe fitting"
	rotate_class = PIPE_ROTATE_TWODIR

/datum/fabricator_recipe/pipe/scrubber/bent
	name = "bent scrubber pipe fitting"
	rotate_class = PIPE_ROTATE_TWODIR
	dir = PIPE_BENT

/datum/fabricator_recipe/pipe/scrubber/manifold
	name = "scrubber pipe manifold fitting"
	build_icon_state = "manifold"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers
	pipe_class = PIPE_CLASS_TRINARY
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/scrubber/manifold4w
	name = "four-way scrubber pipe manifold fitting"
	build_icon_state = "manifold4w"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers
	pipe_class = PIPE_CLASS_QUATERNARY
	rotate_class = PIPE_ROTATE_ONEDIR

/datum/fabricator_recipe/pipe/scrubber/cap
	name = "scrubber pipe cap fitting"
	build_icon_state = "cap"
	constructed_path = /obj/machinery/atmospherics/pipe/cap/hidden/scrubbers
	pipe_class = PIPE_CLASS_UNARY
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/scrubber/up
	name = "upward scrubber pipe fitting"
	build_icon_state = "up"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/up/scrubbers
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/scrubber/down
	name = "downward scrubber pipe fitting"
	build_icon_state = "down"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/down/scrubbers
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/fuel
	category = "Fuel Pipes"
	colorable = FALSE
	pipe_color = PIPE_COLOR_ORANGE
	connect_types = CONNECT_TYPE_FUEL
	constructed_path = /obj/machinery/atmospherics/pipe/simple/hidden/fuel
	pipe_class = PIPE_CLASS_BINARY

	name = "fuel pipe fitting"
	rotate_class = PIPE_ROTATE_TWODIR

/datum/fabricator_recipe/pipe/fuel/bent
	name = "bent fuel pipe fitting"
	rotate_class = PIPE_ROTATE_TWODIR
	dir = PIPE_BENT

/datum/fabricator_recipe/pipe/fuel/manifold
	name = "fuel pipe manifold fitting"
	build_icon_state = "manifold"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold/hidden/fuel
	pipe_class = PIPE_CLASS_TRINARY
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/fuel/manifold4w
	name = "four-way supply pipe manifold fitting"
	build_icon_state = "manifold4w"
	constructed_path = /obj/machinery/atmospherics/pipe/manifold4w/hidden/fuel
	pipe_class = PIPE_CLASS_QUATERNARY
	rotate_class = PIPE_ROTATE_ONEDIR

/datum/fabricator_recipe/pipe/fuel/cap
	name = "fuel pipe cap fitting"
	build_icon_state = "cap"
	constructed_path = /obj/machinery/atmospherics/pipe/cap/hidden/fuel
	pipe_class = PIPE_CLASS_UNARY
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/fuel/up
	name = "upward fuel pipe fitting"
	build_icon_state = "up"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/up/fuel
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/fuel/down
	name = "downward fuel pipe fitting"
	build_icon_state = "down"
	constructed_path = /obj/machinery/atmospherics/pipe/zpipe/down/fuel
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/he
	category = "Heat Exchange Pipes"
	colorable = FALSE
	pipe_color = null
	connect_types = CONNECT_TYPE_HE
	constructed_path = /obj/machinery/atmospherics/pipe/simple/heat_exchanging
	pipe_class = PIPE_CLASS_BINARY

	name = "heat exchanger pipe fitting"
	build_icon_state = "he"
	rotate_class = PIPE_ROTATE_TWODIR

/datum/fabricator_recipe/pipe/he/bent
	name = "bent heat exchanger pipe fitting"
	connect_types = CONNECT_TYPE_HE
	rotate_class = PIPE_ROTATE_TWODIR
	build_icon_state = "he"
	dir = PIPE_BENT

/datum/fabricator_recipe/pipe/he/junction
	name = "heat exchanger junction"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_HE|CONNECT_TYPE_FUEL
	build_icon_state = "junction"
	constructed_path = /obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction
	rotate_class = PIPE_ROTATE_STANDARD

/datum/fabricator_recipe/pipe/he/exchanger
	name = "heat exchanger"
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL
	build_icon_state = "heunary"
	constructed_path = /obj/machinery/atmospherics/unary/heat_exchanger
	pipe_class = PIPE_CLASS_UNARY
	rotate_class = PIPE_ROTATE_STANDARD

//Cleanup
#undef PIPE_STRAIGHT
#undef PIPE_BENT