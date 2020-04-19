/obj/machinery/get_base_monetary_worth()
	. = ..()
	if(stat & BROKEN)
		. = round(. * 0.5)
