/obj/machinery/get_single_monetary_worth()
	. = ..()
	if(stat & BROKEN)
		. = round(. * 0.5)
