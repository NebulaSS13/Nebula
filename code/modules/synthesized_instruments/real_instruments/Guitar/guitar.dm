/obj/item/synthesized_instrument/guitar
	name = "guitar"
	desc = "A wooden musical instrument with six strings. This one looks like it may actually work."
	icon = 'icons/obj/items/guitar.dmi'
	icon_state = ICON_STATE_WORLD
	sound_player = /datum/sound_player/synthesizer
	path = /datum/instrument/guitar/clean_crisis
	material = /decl/material/solid/organic/wood
	matter = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_TRACE)
	slot_flags = SLOT_BACK

/obj/item/synthesized_instrument/guitar/multi
	name = "Polyguitar"
	desc = "An instrument for a more ass-kicking era."
	icon = 'icons/obj/musician.dmi'
	icon_state = "eguitar"
	sound_player = /datum/sound_player/synthesizer
	path = /datum/instrument/guitar
	material = /decl/material/solid/organic/wood
	matter = list(
		/decl/material/solid/metal/steel  = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_TRACE,
		/decl/material/solid/silicon      = MATTER_AMOUNT_TRACE,
		)
	slot_flags = 0