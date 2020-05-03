/obj/machinery/atmospherics/pipe/Initialize()
	. = ..()
	if(leaking)
		leaking = 0
		set_leaking(TRUE)
