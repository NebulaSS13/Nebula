/decl/loadout_category/utility
	name = "Utility"

// "Useful" items - I'm guessing things that might be used at work?
/decl/loadout_option/utility
	category = /decl/loadout_category/utility
	abstract_type = /decl/loadout_option/utility

/decl/loadout_option/utility/briefcase
	name = "briefcase"
	path = /obj/item/briefcase
	uid = "gear_utility_briefcase"

/decl/loadout_option/utility/clipboard
	name = "clipboard"
	path = /obj/item/clipboard
	uid = "gear_utility_clipboard"

/decl/loadout_option/utility/folder
	name = "folders"
	path = /obj/item/folder
	uid = "gear_utility_folders"

/decl/loadout_option/utility/taperecorder
	name = "tape recorder"
	path = /obj/item/taperecorder
	uid = "gear_utility_taperecorder"

/decl/loadout_option/utility/folder/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"blue folder" =   /obj/item/folder/blue,
		"grey folder" =   /obj/item/folder,
		"red folder" =    /obj/item/folder/red,
		"cyan folder" =  /obj/item/folder/cyan,
		"yellow folder" = /obj/item/folder/yellow
	)

/decl/loadout_option/utility/paicard
	name = "personal AI device"
	path = /obj/item/paicard
	uid = "gear_utility_pai"

/decl/loadout_option/utility/camera
	name = "camera"
	path = /obj/item/camera
	uid = "gear_utility_camera"

/decl/loadout_option/utility/photo_album
	name = "photo album"
	path = /obj/item/photo_album
	uid = "gear_utility_album"

/decl/loadout_option/utility/film_roll
	name = "film roll"
	path = /obj/item/camera_film
	uid = "gear_utility_film"

/decl/loadout_option/utility/pen
	name = "multicolored pen"
	path = /obj/item/pen/multi
	cost = 2
	uid = "gear_utility_pen"

/decl/loadout_option/utility/fancy
	name = "fancy pen"
	path = /obj/item/pen/fancy
	cost = 2
	uid = "gear_utility_pen_fancy"

/decl/loadout_option/utility/umbrella
	name = "umbrella"
	path = /obj/item/umbrella
	loadout_flags = GEAR_HAS_COLOR_SELECTION
	uid = "gear_utility_umbrella"

/decl/loadout_option/utility/knives
	name = "utility knife selection"
	description = "A selection of knives."
	path = /obj/item/knife
	uid = "gear_utility_knives"

/decl/loadout_option/utility/knives/get_gear_tweak_options()
	. = ..()
	LAZYINITLIST(.[/datum/gear_tweak/path])
	.[/datum/gear_tweak/path] |= list(
		"folding knife" =             /obj/item/knife/folding,
		"peasant folding knife" =     /obj/item/knife/folding/wood,
		"tactical folding knife" =    /obj/item/knife/folding/tacticool,
		"utility knife" =             /obj/item/knife/utility,
		"lightweight utility knife" = /obj/item/knife/utility/lightweight
	)
