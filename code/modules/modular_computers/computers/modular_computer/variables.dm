// This is the base type that handles everything. Subtypes can be easily created by tweaking variables in this file to your liking.

/obj/item/modular_computer
	name = "modular computer"
	desc = "A modular computer. You shouldn't see this."
	icon_state = ICON_STATE_WORLD
	center_of_mass = null
	randpixel = 0

	var/screen_icon
	var/list/decals
	var/computer_emagged = FALSE
	var/ambience_last_played
	var/light_strength = 0	// Intensity of light this computer emits. Comparable to numbers light fixtures use.
	var/list/terminals // List of open terminal datums.
	var/stores_pen = FALSE
	var/obj/item/pen/stored_pen
	var/interact_sounds
	var/interact_sound_volume = 40
	var/list/default_hardware = list()
	var/list/default_programs = list()
	var/initial_hardware_flag = 0
	var/computer_type = /datum/extension/assembly/modular_computer
