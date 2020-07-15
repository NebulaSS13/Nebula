/obj/item/modular_computer/tablet
	name = "tablet computer"
	desc = "A small, portable microcomputer."
	icon = 'icons/obj/modular_computers/modular_tablet.dmi'
	icon_state = "tablet"

	w_class = ITEM_SIZE_SMALL
	light_strength = 5 // same as PDAs

	interact_sounds = list('sound/machines/pda_click.ogg')
	interact_sound_volume = 20
	computer_type = /datum/extension/assembly/modular_computer/tablet

/obj/item/modular_computer/tablet/lease
	desc = "A small, portable microcomputer. This one has a gold and blue stripe, and a serial number stamped into the case."
	icon_state = "tabletsol"
