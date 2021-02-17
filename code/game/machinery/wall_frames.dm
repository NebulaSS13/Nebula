/obj/item/frame
	name = "frame"
	desc = "Used for building machines."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarm_bitem"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	material = /decl/material/solid/metal/steel
	var/build_machine_type
	var/reverse = 0 //if resulting object faces opposite its dir (like light fixtures)
	var/fully_construct = FALSE // Results in a machine with all parts auto-installed and ready to go if TRUE; if FALSE, the machine will spawn without removable expected parts

/obj/item/frame/building_cost()
	. = ..()
	if(fully_construct)
		var/list/cost = atom_info_repository.get_matter_for(build_machine_type)
		for(var/key in cost)
			.[key] += cost[key]

/obj/item/frame/attackby(obj/item/W, mob/user)
	if(isWrench(W))
		for(var/key in matter)
			var/decl/material/material = GET_DECL(key)
			material.place_sheet(get_turf(src), matter[key]/SHEET_MATERIAL_AMOUNT)
		qdel(src)
		return TRUE
	. = ..()

/obj/item/frame/proc/try_build(turf/on_wall, click_params)
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

	if(gotwallitem(loc, get_dir(usr,on_wall))) // Use actual dir, not the new machine's dir
		to_chat(usr, "<span class='danger'>There's already an item on this wall!</span>")
		return

	var/obj/machinery/machine = new build_machine_type(loc, ndir, fully_construct)
	modify_positioning(machine, ndir, click_params)
	if(istype(machine) && machine.construct_state && !fully_construct)
		machine.construct_state.post_construct(machine)
	transfer_fingerprints_to(machine)
	qdel(src)

/obj/item/frame/proc/modify_positioning(var/obj/machinery/product, _dir, click_params)

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
	material = /decl/material/solid/metal/steel
	build_machine_type = /obj/machinery/light/small/buildable

/obj/item/frame/light/spot
	name = "spotlight fixture frame"
	icon_state = "tube-construct-item"
	material = /decl/material/solid/metal/steel
	build_machine_type = /obj/machinery/light/spot/buildable

/obj/item/frame/light/nav
	name = "navigation light fixture frame"
	icon_state = "tube-construct-item"
	material = /decl/material/solid/metal/steel
	build_machine_type = /obj/machinery/light/navigation/buildable

/obj/item/frame/button
	name = "button frame"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	material = /decl/material/solid/metal/steel
	build_machine_type = /obj/machinery/button/buildable

/obj/item/frame/button/modify_positioning(var/obj/machinery/button/product, _dir, click_params)
	var/list/params = params2list(click_params)
	var/_pixel_x = text2num(params["icon-x"]) - WORLD_ICON_SIZE/2 //Make it relative to center instead of bottom left
	var/_pixel_y = text2num(params["icon-y"]) - WORLD_ICON_SIZE/2
	switch(_dir)
		if(NORTH)
			_pixel_y = max(_pixel_y, WORLD_ICON_SIZE/4)
			_pixel_y -= WORLD_ICON_SIZE
		if(SOUTH)
			_pixel_y = min(_pixel_y, WORLD_ICON_SIZE/4)
			_pixel_y += WORLD_ICON_SIZE
		if(EAST)
			_pixel_x = max(_pixel_x, 0)
			_pixel_x -= WORLD_ICON_SIZE
		if(WEST)
			_pixel_x = min(_pixel_x, 0)
			_pixel_x += WORLD_ICON_SIZE
	product.pixel_x = _pixel_x
	product.pixel_y = _pixel_y

/obj/item/frame/button/wall_charger
	name = "wall charger frame"
	icon = 'icons/obj/machines/recharger_wall.dmi'
	icon_state = "wrecharger0"
	material = /decl/material/solid/metal/steel
	build_machine_type = /obj/machinery/recharger/wallcharger

/obj/item/frame/button/wall_charger/kit
	fully_construct = TRUE
	name = "wall charger kit"

/obj/item/frame/button/sparker
	name = "mounted igniter"
	desc = "A wall-mounted ignition device."
	icon = 'icons/obj/machines/igniter_mounted.dmi'
	icon_state = "migniter"
	material = /decl/material/solid/metal/steel
	build_machine_type = /obj/machinery/sparker/buildable

// Shifts it dead center of the turf you are looking at. Useful for items with antiquated icons.
/obj/item/frame/stock_offset
	reverse = TRUE

/obj/item/frame/stock_offset/modify_positioning(var/obj/machinery/product, _dir, click_params)
	switch(_dir)
		if(NORTH)
			product.pixel_y = WORLD_ICON_SIZE
		if(SOUTH)
			product.pixel_y = - WORLD_ICON_SIZE
		if(EAST)
			product.pixel_x = WORLD_ICON_SIZE
		if(WEST)
			product.pixel_x = - WORLD_ICON_SIZE

/obj/item/frame/stock_offset/request_console
	name = "request console frame"
	desc = "Used for building request consoles."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "req_comp0"
	build_machine_type = /obj/machinery/network/requests_console

/obj/item/frame/stock_offset/request_console/kit
	fully_construct = TRUE
	name = "request console kit"
	desc = "An all-in-one request console kit, comes preassembled."

/obj/item/frame/stock_offset/atm
	name = "automatic teller machine frame"
	desc = "Used to build an ATM terminal on a wall."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "atm"
	build_machine_type = /obj/machinery/atm

/obj/item/frame/stock_offset/atm/kit
	name = "automatic teller machine kit"
	fully_construct = TRUE

/obj/item/frame/stock_offset/newscaster
	name = "newscaster frame"
	desc = "Used to build a newscaster on a wall."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "newscaster_off"
	build_machine_type = /obj/machinery/newscaster

/obj/item/frame/stock_offset/newscaster/kit
	name = "newscaster kit"
	fully_construct = TRUE

/obj/item/frame/button/airlock_sensor
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	name = "airlock sensor"
	desc = "An airlock sensor frame."
	build_machine_type = /obj/machinery/airlock_sensor/buildable

/obj/item/frame/button/airlock_controller
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_off"
	name = "airlock controller frame"
	desc = "Used to build airlock controllers. Use a multitool on the circuit to determine which type you want, and then hit this with the the circuit."
	build_machine_type = null

/obj/item/frame/button/airlock_controller/try_build(turf/on_wall, click_params)
	if(!build_machine_type)
		to_chat(usr, SPAN_WARNING("First hit this with a circuitboard to configure it!"))
		return
	return ..()

/obj/item/frame/button/airlock_controller/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stock_parts/circuitboard))
		var/obj/item/stock_parts/circuitboard/board = W
		if(ispath(board.build_path, /obj/machinery/embedded_controller/radio))
			build_machine_type = board.build_path
			to_chat(user, SPAN_NOTICE("You configure \the [src] using \the [W]."))
			return TRUE
	. = ..()
