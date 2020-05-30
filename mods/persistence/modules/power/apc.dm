/obj/machinery/power/apc/Initialize(mapload, var/ndir, var/populate_parts = TRUE)
	var/cur_operating = operating
	. = ..()
	operating = cur_operating
	queue_icon_update()

	if(operating)
		force_update_channels()
	power_change()