/obj/machinery/network/stellar_anchor
	name = "stellar anchor"

/obj/machinery/network/stellar_anchor/proc/is_paid()
	return TRUE

/obj/machinery/network/stellar_anchor/proc/mark_persisted()
	SSpersistence.saved_levels |= get_turf(src).z

/obj/machinery/network/stellar_anchor/before_save()
	. = ..()
	if(is_paid())
		mark_persisted()
	
/obj/machinery/network/stellar_anchor/ship_core
	name = "ship core"

/obj/machinery/network/stellar_anchor/ship_core/mark_persisted()
	