/obj/machinery/computer/ship/ftl
	name = "shunt drive control console"
	var/obj/machinery/ftl_shunt/core/linked_core

/obj/machinery/computer/ship/ftl/Initialize()
	. = ..()
	find_core()

/obj/machinery/computer/ship/ftl/proc/find_core()
	if(!linked)
		return

	for(var/obj/machinery/ftl_shunt/core/C in world)
		if(C.z in linked.map_z)
			linked_core = C
			C.ftl_computer = src