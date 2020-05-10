/obj/machinery/atmospherics/omni/before_save()
	. = ..()
	for(var/datum/omni_port/port in ports)
		switch(port.direction)
			if(NORTH)
				tag_north = port.mode
			if(EAST)
				tag_east = port.mode
			if(WEST)
				tag_west = port.mode
			if(SOUTH)
				tag_south = port.mode

/obj/machinery/atmospherics/omni/after_save()
	. = ..()
	tag_north = null
	tag_east = null
	tag_west = null
	tag_south = null