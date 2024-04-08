/obj/machinery/fabricator/textile
	name = "textile fabricator"
	desc = "A complex and flexible nanofabrication system for producing textiles and composite wearable equipment."
	icon = 'icons/obj/machines/fabricators/robotics.dmi'
	icon_state = "robotics"
	base_icon_state = "robotics"
	idle_power_usage = 20
	active_power_usage = 5000
	base_type = /obj/machinery/fabricator/textile
	fabricator_class = FABRICATOR_CLASS_TEXTILE
	base_storage_capacity_mult = 100

/obj/machinery/fabricator/textile/can_ingest(var/obj/item/thing)
	if(thing.has_textile_fibers()) // only raw cotton plants currently
		return TRUE
	return ..()
