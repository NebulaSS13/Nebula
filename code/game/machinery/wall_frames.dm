/obj/item/frame
	name = "frame"
	desc = "Used for building machines."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarm_bitem"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	matter = list(MAT_STEEL = 4000)
	var/build_machine_type
	var/reverse = 0 //if resulting object faces opposite its dir (like light fixtures)
	var/fully_construct = FALSE // Results in a machine with all parts auto-installed and ready to go if TRUE; if FALSE, the machine will spawn without removable expected parts

/obj/item/frame/building_cost()
	. = ..()
	if(fully_construct)
		var/obj/machinery/machine = new build_machine_type
		var/list/cost = machine.building_cost()
		qdel(machine) // It's likely queued for processing; it won't delete automatically.
		for(var/key in cost)
			.[key] += cost[key]

/obj/item/frame/attackby(obj/item/W, mob/user)
	if(isWrench(W))
		for(var/key in matter)
			var/material/material = SSmaterials.get_material_datum(key)
			material.place_sheet(get_turf(src), matter[key]/SHEET_MATERIAL_AMOUNT)
		qdel(src)
		return TRUE
	. = ..()

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

	var/obj/machinery/machine = new build_machine_type(loc, ndir, fully_construct)
	if(istype(machine) && machine.construct_state && !fully_construct)
		machine.construct_state.post_construct(machine)
	transfer_fingerprints_to(machine)
	qdel(src)

/obj/item/frame/fire_alarm
	name = "fire alarm frame"
	desc = "Used for building fire alarms."
	icon = 'icons/obj/firealarm.dmi'
	icon_state = "casing"
	build_machine_type = /obj/machinery/firealarm

/obj/item/frame/fire_alarm/kit
	fully_construct = TRUE
	name = "fire alarm kit"
	desc = "An all-in-one fire alarm kit, comes preassembled."

/obj/item/frame/air_alarm
	name = "air alarm frame"
	desc = "Used for building air alarms."
	build_machine_type = /obj/machinery/alarm

/obj/item/frame/air_alarm/kit
	fully_construct = TRUE
	name = "air alarm kit"
	desc = "An all-in-one air alarm kit, comes preassembled."

/obj/item/frame/light
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	build_machine_type = /obj/machinery/light/buildable
	reverse = 1

/obj/item/frame/light/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-item"
	matter = list(MAT_STEEL = 2000)
	build_machine_type = /obj/machinery/light/small/buildable

/obj/item/frame/light/spot
	name = "spotlight fixture frame"
	icon_state = "tube-construct-item"
	matter = list(MAT_STEEL = 4000, MAT_PLASTIC = 2000)
	build_machine_type = /obj/machinery/light/spot/buildable

/obj/item/frame/light/nav
	name = "navigation light fixture frame"
	icon_state = "tube-construct-item"
	matter = list(MAT_STEEL = 4000, MAT_PLASTIC = 2000)
	build_machine_type = /obj/machinery/light/navigation/buildable