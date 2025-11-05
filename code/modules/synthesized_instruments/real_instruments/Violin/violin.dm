/datum/sound_player/violin
	play_volume = 25
	range = 10 //Kinda don't want this horrible thing to be heard from far away

/obj/item/synthesized_instrument/violin
	name = "violin"
	desc = "A wooden musical instrument with four strings and a bow. \"The devil went down to space, he was looking for an assistant to grief.\"."
	icon_state = "violin"
	sound_player = /datum/sound_player/violin
	path = /datum/instrument/obsolete/violin
	material = /decl/material/solid/organic/wood/oak
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE)
