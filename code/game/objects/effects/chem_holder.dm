/obj/effect/chem_holder
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

/obj/effect/chem_holder/Initialize(mapload, _vol)
	chem_volume = _vol
	. = ..()
