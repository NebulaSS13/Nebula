// APC HULL

/obj/item/frame/apc
	name = "\improper APC frame"
	desc = "Used for repairing or building APCs."
	icon = 'icons/obj/apc_repair.dmi'
	icon_state = "apc_frame"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	build_machine_type = /obj/machinery/apc/buildable
	reverse = TRUE

/obj/item/frame/apc/try_build(turf/on_wall)
	var/area/A = get_area(src)
	if (A.requires_power == 0 || A.always_unpowered)
		to_chat(usr, SPAN_WARNING("An APC cannot be placed in this area."))
		return
	if (A.get_apc())
		to_chat(usr, SPAN_WARNING("This area already has an APC."))
		return //only one APC per area
	for(var/obj/machinery/power/terminal/T in loc)
		if (T.master)
			to_chat(usr, SPAN_WARNING("There is another network terminal here."))
			return
	return ..()

/obj/item/frame/apc/kit
	fully_construct = TRUE
	name = "APC kit"
	desc = "An all-in-one APC kit, comes preassembled."
	build_machine_type = /obj/machinery/apc