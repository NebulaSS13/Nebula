// These colour substitutions are taken from Wikipedia and are very rough;
// someone with better knowledge of how colour blindness manifests, pls update.

/datum/client_color/deuteranopia
	priority = 100
	client_color = list(
		0.47,0.38,0.15,
		0.54,0.31,0.15,
		0,0.3,0.7
	)
	wire_colour_substitutions = list(
		"red" =     "black",
		"darkred" = "black",
		"purple" =  "blue",
		"orange" =  "yellow",
		"brown" =   "yellow",
		"green" =   "yellow"
	)

/datum/client_color/protanopia
	priority = 100
	client_color = list(
		0.51,0.4,0.12,
		0.49,0.41,0.12,
		0,0.2,0.76
	)
	wire_colour_substitutions = list(
		"red" =     "black",
		"darkred" = "black",
		"purple" =  "blue",
		"orange" =  "yellow",
		"brown" =   "yellow",
		"green" =   "yellow"
	)

/datum/client_color/tritanopia
	priority = 100
	client_color = list(
		0.95,0.07,0,
		0,0.44,0.52,
		0.05,0.49,0.48
	)
	wire_colour_substitutions = list(
		"blue" =    "green",
		"orange" =  "pink",
		"brown" =   "pink",
		"gold" =    "pink",
		"yellow" =  "pink",
		"cyan" =    "green",
		"navy" =    "green",
		"purple" =  "darkred"
	)

/datum/client_color/achromatopsia
	priority = 100
	client_color = list(
		0.33,0.33,0.33,
		0.33,0.33,0.33,
		0.33,0.33,0.33
	)
	wire_colour_substitutions = list(
		"red" =     "gray",
		"blue" =    "black",
		"green" =   "gray",
		"darkred" = "black",
		"orange" =  "gray",
		"brown" =   "gray",
		"gold" =    "gray",
		"cyan" =    "gray",
		"navy" =    "gray",
		"purple" =  "black",
		"pink" =    "gray",
		"yellow" =  "gray"
	)

//Similar to monochrome but shouldn't look as flat, same priority
/datum/client_color/noir
	client_color = list(0.299,0.299,0.299, 0.587,0.587,0.587, 0.114,0.114,0.114)
	priority = 200

// Defining this twice so a detective dosing on Gleam doesn't lose the overlay.
/datum/client_color/noir/thirdeye
	priority = 300

/datum/client_color/berserk
	client_color = "#af111c"
	priority = INFINITY //This effect sort of exists on its own you /have/ to be seeing RED
	override = TRUE //Because multiplying this will inevitably fail
	wire_colour_substitutions = list(
		"red" =     "red",
		"blue" =    "red",
		"green" =   "red",
		"darkred" = "red",
		"orange" =  "red",
		"brown" =   "red",
		"gold" =    "red",
		"cyan" =    "red",
		"navy" =    "red",
		"purple" =  "red",
		"pink" =    "red",
		"yellow" =  "red",
		"gray" =    "red"
	)

/datum/client_color/oversaturated/New()
	client_color = legacy_color_saturation(40)
