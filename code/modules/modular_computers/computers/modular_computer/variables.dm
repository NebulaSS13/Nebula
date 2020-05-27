// This is the base type that handles everything. Subtypes can be easily created by tweaking variables in this file to your liking.

/obj/item/modular_computer
	name = "Modular Computer"
	desc = "A modular computer. You shouldn't see this."

	var/computer_emagged = FALSE							// Whether the computer is emagged.
	var/ambience_last_played								// Last time sound was played

	// Modular computers can run on various devices. Each DEVICE (Laptop, Console, Tablet,..)
	// must have it's own DMI file. Icon states must be called exactly the same in all files, but may look differently
	// If you create a program which is limited to Laptops and Consoles you don't have to add it's icon_state overlay for Tablets too, for example.

	icon = null												// This thing isn't meant to be used on it's own. Subtypes should supply their own icon.
	icon_state = null
	center_of_mass = null									// No pixelshifting by placing on tables, etc.
	randpixel = 0											// And no random pixelshifting on-creation either.
	var/icon_state_unpowered = null							// Icon state when the computer is turned off
	var/light_strength = 0									// Intensity of light this computer emits. Comparable to numbers light fixtures use.

	var/list/terminals          // List of open terminal datums.

	var/stores_pen = FALSE
	var/obj/item/pen/stored_pen

	var/interact_sounds
	var/interact_sound_volume = 40

	var/list/default_hardware = list()
	var/list/default_programs = list()

	// setup stuff
	var/initial_hardware_flag = 0
	var/computer_type = /datum/extension/assembly/modular_computer // Determines assembly extension.