/decl/loadout_category/utility
	name = "Utility"

// "Useful" items - I'm guessing things that might be used at work?
/decl/loadout_option/utility
	category = /decl/loadout_category/utility

/decl/loadout_option/utility/briefcase
	display_name = "briefcase"
	path = /obj/item/storage/briefcase

/decl/loadout_option/utility/clipboard
	display_name = "clipboard"
	path = /obj/item/clipboard

/decl/loadout_option/utility/folder
	display_name = "folders"
	path = /obj/item/folder

/decl/loadout_option/utility/taperecorder
	display_name = "tape recorder"
	path = /obj/item/taperecorder

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
	display_name = "personal AI device"
	path = /obj/item/paicard

/decl/loadout_option/utility/camera
	display_name = "camera"
	path = /obj/item/camera

/decl/loadout_option/utility/photo_album
	display_name = "photo album"
	path = /obj/item/storage/photo_album

/decl/loadout_option/utility/film_roll
	display_name = "film roll"
	path = /obj/item/camera_film

/decl/loadout_option/accessory/stethoscope
	display_name = "stethoscope (medical)"
	path = /obj/item/clothing/accessory/stethoscope
	cost = 2

/decl/loadout_option/utility/pen
	display_name = "Multicolored Pen"
	path = /obj/item/pen/multi
	cost = 2

/decl/loadout_option/utility/fancy
	display_name = "Fancy Pen"
	path = /obj/item/pen/fancy
	cost = 2

/decl/loadout_option/utility/hand_labeler
	display_name = "hand labeler"
	path = /obj/item/hand_labeler
	cost = 3

/****************
modular computers
****************/

/decl/loadout_option/utility/cheaptablet
	display_name = "tablet computer, cheap"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/cheap
	cost = 3

/decl/loadout_option/utility/normaltablet
	display_name = "tablet computer, advanced"
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/advanced
	cost = 4

/decl/loadout_option/utility/customtablet
	display_name = "tablet computer, custom"
	path = /obj/item/modular_computer/tablet
	cost = 4

/decl/loadout_option/utility/customtablet/get_gear_tweak_options()
	. = ..() | /datum/gear_tweak/tablet

/decl/loadout_option/utility/cheaplaptop
	display_name = "laptop computer, cheap"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/cheap
	cost = 5

/decl/loadout_option/utility/normallaptop
	display_name = "laptop computer, advanced"
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/advanced
	cost = 6
