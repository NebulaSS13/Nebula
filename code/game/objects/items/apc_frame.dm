// APC HULL

/obj/item/frame/apc
	name = "\improper APC frame"
	desc = "Used for repairing or building APCs."
	icon = 'icons/obj/apc_repair.dmi'
	icon_state = "apc_frame"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	build_machine_type = /obj/machinery/power/apc/buildable
	reverse = TRUE

/obj/item/frame/apc/try_build(turf/on_wall)
	var/area/A = get_area(src)
	if (A.requires_power == 0 || istype(A, /area/space))
		to_chat(usr, "<span class='warning'>APC cannot be placed in this area.</span>")
		return
	if (A.get_apc())
		to_chat(usr, "<span class='warning'>This area already has an APC.</span>")
		return //only one APC per area
	for(var/obj/machinery/power/terminal/T in loc)
		if (T.master)
			to_chat(usr, "<span class='warning'>There is another network terminal here.</span>")
			return
	return ..()

/obj/item/frame/apc/kit
	fully_construct = TRUE
	name = "APC kit"
	desc = "An all-in-one APC kit, comes preassembled."
	build_machine_type = /obj/machinery/power/apc