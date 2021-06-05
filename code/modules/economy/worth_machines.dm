/obj/machinery/get_base_value()
	. = ..()
	if(stat & BROKEN)
		. = round(. * 0.5)

/obj/machinery/get_single_monetary_worth()
	. = ..()
	for(var/atom/movable/component in component_parts)
		. += component.get_combined_monetary_worth()
