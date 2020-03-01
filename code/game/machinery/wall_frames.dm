/obj/item/frame
	name = "frame"
	desc = "Used for building machines."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarm_bitem"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	var/build_machine_type
	var/refund_amt = 2
	var/refund_type = /obj/item/stack/material/steel
	var/reverse = 0 //if resulting object faces opposite its dir (like light fixtures)

/obj/item/frame/attackby(obj/item/W, mob/user)
	if(isWrench(W))
		new refund_type( get_turf(src.loc), refund_amt)
		qdel(src)
		return
	..()

/obj/item/frame/proc/try_build(turf/on_wall)
	if(!build_machine_type)
		return

	if (get_dist(on_wall,usr)>1)
		return

	var/ndir
	if(reverse)
		ndir = get_dir(usr,on_wall)
	else
		ndir = get_dir(on_wall,usr)

	if (!(ndir in GLOB.cardinal))
		return

	var/turf/loc = get_turf(usr)
	if (!istype(loc, /turf/simulated/floor))
		to_chat(usr, "<span class='danger'>\The [src] cannot be placed on this spot.</span>")
		return

	if(gotwallitem(loc, ndir))
		to_chat(usr, "<span class='danger'>There's already an item on this wall!</span>")
		return

	var/obj/machinery/machine = new build_machine_type(loc, ndir, FALSE)
	transfer_fingerprints_to(machine)
	qdel(src)

/obj/item/frame/fire_alarm
	name = "fire alarm frame"
	desc = "Used for building fire alarms."
	icon = 'icons/obj/firealarm.dmi'
	icon_state = "casing"
	build_machine_type = /obj/machinery/firealarm

/obj/item/frame/air_alarm
	name = "air alarm frame"
	desc = "Used for building air alarms."
	build_machine_type = /obj/machinery/alarm

/obj/item/frame/light
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	build_machine_type = /obj/machinery/light_construct
	reverse = 1

/obj/item/frame/light/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-item"
	refund_amt = 1
	build_machine_type = /obj/machinery/light_construct/small
