/obj/machinery/atmospherics/omni/mixer/before_save()
	. = ..()
	for(var/datum/omni_port/port in ports)
		switch(port.direction)
			if(NORTH)
				tag_north_con = port.concentration
			if(EAST)
				tag_east_con = port.concentration
			if(WEST)
				tag_west_con = port.concentration
			if(SOUTH)
				tag_south_con = port.concentration

/obj/machinery/atmospherics/omni/mixer/after_save()
	. = ..()
	tag_north_con = null
	tag_east_con = null
	tag_west_con = null
	tag_south_con = null