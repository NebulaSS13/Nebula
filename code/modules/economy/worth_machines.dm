/obj/machinery/get_base_value()
	. = ..()
	if(stat & BROKEN)
		. = round(. * 0.5)
