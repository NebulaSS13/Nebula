/obj/map_debug_holder
	icon       = 'icons/effects/landmarks.dmi'
	icon_state = "x"
	simulated  = FALSE
	var/datum/mm_cell/cell

/obj/map_debug_holder/Initialize(mapload, datum/mm_cell/_cell)
	. = ..()
	cell = _cell

/obj/map_debug_holder/Destroy()
	. = ..()
	cell = null
