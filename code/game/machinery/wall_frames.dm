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

/obj/item/frame/get_contained_matter()
	. = ..()
	if(fully_construct)
		var/list/cost = atom_info_repository.get_matter_for(build_machine_type)
		for(var/key in cost)
			.[key] += cost[key]

/obj/item/frame/attackby(obj/item/W, mob/user)
	if(IS_WRENCH(W))
		for(var/key in matter)
			SSmaterials.create_object(key, get_turf(src), round(matter[key]/SHEET_MATERIAL_AMOUNT))
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

	if (!(ndir in global.cardinal))
		return

	var/turf/my_turf = get_turf(usr)
	if (!istype(my_turf) || !my_turf.simulated || !my_turf.is_floor())
		to_chat(usr, "<span class='danger'>\The [src] cannot be placed on this spot.</span>")
		return

	if(gotwallitem(my_turf, get_dir(usr,on_wall))) // Use actual dir, not the new machine's dir
		to_chat(usr, "<span class='danger'>There's already an item on this wall!</span>")
		return

	var/obj/machinery/machine = new build_machine_type(my_turf, ndir, fully_construct)
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

/obj/item/frame/wall_router
	name = "wall-mounted router frame"
	desc = "Used for building wall-mounted network routers."
	icon = 'icons/obj/machines/wall_router.dmi'
	icon_state = "wall_router_o_off"
	build_machine_type = /obj/machinery/network/router/wall_mounted

/obj/item/frame/wall_router/kit
	fully_construct = TRUE
	name = "wall-mounted router kit"
	desc = "An all-in-one wall-mounted router kit, comes preassembled."

/obj/item/frame/wall_relay
	name = "wall-mounted relay frame"
	desc = "Used for building wall-mounted network relays."
	icon = 'icons/obj/machines/wall_router.dmi'
	icon_state = "wall_router_o_off"
	build_machine_type = /obj/machinery/network/relay/wall_mounted

/obj/item/frame/wall_relay/kit
	fully_construct = TRUE
	name = "wall-mounted relay kit"
	desc = "An all-in-one wall-mounted relay kit, comes preassembled."

/obj/item/frame/light
	name = "light fixture frame"
	desc = "Used for building lights."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-item"
	build_machine_type = /obj/machinery/light
	reverse = 1

/obj/item/frame/light/small
	name = "small light fixture frame"
	icon_state = "bulb-construct-item"
	material = /decl/material/solid/metal/steel
	build_machine_type = /obj/machinery/light/small

/obj/item/frame/light/spot
	name = "spotlight fixture frame"
	icon_state = "tube-construct-item"
	material = /decl/material/solid/metal/steel
	build_machine_type = /obj/machinery/light/spot

/obj/item/frame/light/nav
	name = "navigation light fixture frame"
	icon_state = "tube-construct-item"
	material = /decl/material/solid/metal/steel
	build_machine_type = /obj/machinery/light/navigation

/obj/item/frame/button
	name = "button frame"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	material = /decl/material/solid/metal/steel
	build_machine_type = /obj/machinery/button/buildable

/obj/item/frame/button/kit
	fully_construct = TRUE
	name = "radio button kit"
	desc = "An all-in-one wall-mounted button kit, comes preassembled and equipped with a radio transmitter."
	build_machine_type = /obj/machinery/button

/obj/item/frame/button/alternate
	name = "button frame (door)"
	icon = 'icons/obj/machines/button_door.dmi'
	icon_state = "doorctrl"
	build_machine_type = /obj/machinery/button/alternate/buildable

/obj/item/frame/button/alternate/kit
	fully_construct = TRUE
	name = "button kit (door)"
	desc = "An all-in-one wall-mounted button kit, comes preassembled and equipped with a radio transmitter."
	build_machine_type = /obj/machinery/button/alternate

/obj/item/frame/button/blastdoor
	name = "button frame (blast doors)"
	icon = 'icons/obj/machines/button_blastdoor.dmi'
	icon_state = "blastctrl"
	build_machine_type = /obj/machinery/button/blast_door/buildable

/obj/item/frame/button/blastdoor/kit
	fully_construct = TRUE
	name = "button kit (blast doors)"
	desc = "An all-in-one wall-mounted button kit, comes preassembled and equipped with a radio transmitter."
	build_machine_type = /obj/machinery/button/blast_door

/obj/item/frame/camera
	name = "security camera frame"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "cameracase"
	material = /decl/material/solid/metal/aluminium
	build_machine_type = /obj/machinery/camera

/obj/item/frame/camera/kit
	fully_construct = TRUE
	name = "security camera kit"
	desc = "An all-in-one wall-mounted security camera kit, comes preassembled."

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
	product.update_directional_offset()

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

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Airlock Controller Frame
////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/item/frame/button/airlock_controller
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_off"
	name = "airlock controller frame"
	desc = "Used to build airlock controllers. Use a multitool on the circuit to determine which type you want, and then hit this with the the circuit."
	build_machine_type = null
	///Used when configuring a dummy controller
	var/master_controller_id_tag

/obj/item/frame/button/airlock_controller/modify_positioning(obj/machinery/product, _dir, click_params)
	if(length(master_controller_id_tag))
		product.set_id_tag(master_controller_id_tag)
	. = ..()

/obj/item/frame/button/airlock_controller/proc/warn_not_setup(var/mob/user)
	to_chat(user, SPAN_WARNING("First hit this with a circuitboard to properly setup the controller's software!"))

/obj/item/frame/button/airlock_controller/try_build(turf/on_wall, click_params)
	if(!build_machine_type)
		warn_not_setup(usr)
		return
	return ..()

/obj/item/frame/button/airlock_controller/afterattack(obj/machinery/embedded_controller/radio/target, mob/user, proximity_flag, click_parameters)
	if((. = ..()) || !ispath(build_machine_type, /obj/machinery/dummy_airlock_controller))
		return .
	if(istype(target, /obj/machinery/dummy_airlock_controller))
		var/obj/machinery/dummy_airlock_controller/D = target
		target = D.master_controller
		. = TRUE
	if(istype(target))
		master_controller_id_tag = target.id_tag
		to_chat(user, SPAN_NOTICE("You successfully link \the [src]'s master ID tag with \the [target]'s ID tag. \The [src] should now work with \the [target] with the default settings."))
		return TRUE
	master_controller_id_tag = null

/obj/item/frame/button/airlock_controller/attackby(obj/item/W, mob/user)
	if(!istype(W, /obj/item/stock_parts/circuitboard))
		return ..()
	var/obj/item/stock_parts/circuitboard/board = W
	var/obj/machinery/M
	if(ispath(board.build_path, /obj/machinery/embedded_controller/radio))
		build_machine_type = board.build_path
		. = TRUE
	if(ispath(board.build_path, /obj/machinery/dummy_airlock_controller))
		build_machine_type = board.build_path
		. = TRUE
	if(.)
		M = build_machine_type
		to_chat(user, SPAN_NOTICE("You setup \the [src]'s software to work as a '[initial(M.name)]', using \the [W]."))
		return .

/obj/item/frame/button/airlock_controller/kit
	fully_construct = TRUE
	name = "airlock controller kit"
	desc = "An all-in-one airlock controller kit, comes preassembled with a radio transmitter. Use a multitool on the kit to select what type of controller to build."
	build_machine_type = /obj/machinery/embedded_controller/radio/airlock/airlock_controller  //Must set a default one, otherwise building_cost calcs will fail

/obj/item/frame/button/airlock_controller/kit/warn_not_setup(mob/user)
	to_chat(user, SPAN_WARNING("First, use a multitool on the kit to properly setup the controller's software!"))

//Let them also hit it with a circuitboard if they so wish. But multitool is better when you don't want to print one for nothing.
/obj/item/frame/button/airlock_controller/kit/attackby(obj/item/W, mob/user)
	if(!IS_MULTITOOL(W))
		return ..()
	//Handle kit configuration
	var/obj/machinery/M = /obj/machinery/dummy_airlock_controller
	var/list/possible_kit_type_names = list(initial(M.name) = /obj/machinery/dummy_airlock_controller)
	var/static/list/AirlockControllerSubtypes = subtypesof(/obj/machinery/embedded_controller/radio) | subtypesof(/obj/machinery/embedded_controller/radio/airlock)

	for(var/path in AirlockControllerSubtypes)
		var/obj/machinery/embedded_controller/radio/controller = path
		var/base_type = initial(controller.base_type) || path
		M = base_type
		possible_kit_type_names[initial(M.name)] = base_type

	var/choice = input(user, "Chose the type of controller to build:", "Select Controller Type") as null|anything in possible_kit_type_names
	if(!choice || !CanPhysicallyInteract(user))
		build_machine_type = initial(build_machine_type)
		return
	build_machine_type = possible_kit_type_names[choice]
	M = build_machine_type
	to_chat(user, SPAN_NOTICE("You set the kit type to '[initial(M.name)]'!"))
	return TRUE

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Airlock controller setup abstract
////////////////////////////////////////////////////////////////////////////////////////////////////////
///Base class for handling configurable airlock devices frames that want to get configuration info from an airlock controller
/obj/item/frame/button/airlock_controller_config
	abstract_type = /obj/item/frame/button/airlock_controller_config
	///Stores the id tag of the controller we hit this with, to make setup easier
	var/preferred_id_tag

/obj/item/frame/button/airlock_controller_config/modify_positioning(obj/machinery/product, _dir, click_params)
	if(length(preferred_id_tag))
		product.set_id_tag(preferred_id_tag)
	. = ..()

///Returns the list of types of device options we can configure this as
/obj/item/frame/button/airlock_controller_config/proc/get_setup_option_choices()
	return

///Actually applies the changes to the thing based on the setup option picked
/obj/item/frame/button/airlock_controller_config/proc/setup_for_chosen_type(obj/machinery/embedded_controller/radio/target, var/choice)
	return

///Returns the master controller from the target machine whether its a dummy controller or an actual controller
/obj/item/frame/button/airlock_controller_config/proc/get_master_controller(obj/machinery/embedded_controller/radio/target, mob/user)
	if(istype(target))
		return target
	//If we hit a dummy controller just try to grab the master controller
	if(istype(target, /obj/machinery/dummy_airlock_controller))
		var/obj/machinery/dummy_airlock_controller/dummy_controller = target
		if(dummy_controller.master_controller)
			return dummy_controller.master_controller
		else
			to_chat(user, SPAN_WARNING("\The [target] isn't connected to a master controller. Please use \the [src] on the master controller of this airlock system, or connect \the [target] to a master controller."))
			return

/obj/item/frame/button/airlock_controller_config/afterattack(obj/machinery/embedded_controller/radio/target, mob/user, proximity_flag, click_parameters)
	if((. = ..()))
		return .
	var/obj/machinery/dummy_airlock_controller/dummy_controller = istype(target, /obj/machinery/dummy_airlock_controller)? target : null
	target = get_master_controller(target, user)
	if(!istype(target))
		return

	if(!length(target.id_tag))
		to_chat(user, SPAN_WARNING("\The [target] doesn't have its ID tag set! Please set a valid ID tag on it first! [dummy_controller? "** Note that this is a remote controller. You must set the ID tag on the master controller. **" : ""]"))
		return

	var/choice = input(user, "Configure as what?", "Connection Setup") as null|anything in get_setup_option_choices()
	if(!choice || (dummy_controller && !CanPhysicallyInteractWith(user, dummy_controller)) || (!dummy_controller && !CanPhysicallyInteract(user)))
		build_machine_type = initial(build_machine_type)
		preferred_id_tag = null
		return //Cancelled or can't use either the dummy controller or the actual controller
	setup_for_chosen_type(target, choice)
	to_chat(user, SPAN_NOTICE("You successfully link \the [src]'s ID tag with \the [target]'s ID tag. \The [src] should now work with \the [target] with the default settings."))
	return TRUE

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Airlock Sensor Frame
////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/item/frame/button/airlock_controller_config/airlock_sensor
	icon = 'icons/obj/machines/airlock_sensor.dmi'
	icon_state = ICON_STATE_WORLD
	name = "airlock sensor"
	desc = "An airlock sensor frame. Use on an airlock controller to pre-configure it."
	build_machine_type = /obj/machinery/airlock_sensor/buildable

#define CHOICE_INTERIOR_SENSOR "interior sensor"
#define CHOICE_EXTERIOR_SENSOR "exterior sensor"
#define CHOICE_CHAMBER_SENSOR  "airlock chamber sensor"

/obj/item/frame/button/airlock_controller_config/airlock_sensor/get_setup_option_choices()
	return list(
		CHOICE_INTERIOR_SENSOR,
		CHOICE_CHAMBER_SENSOR,
		CHOICE_EXTERIOR_SENSOR,
	)

/obj/item/frame/button/airlock_controller_config/airlock_sensor/setup_for_chosen_type(obj/machinery/embedded_controller/radio/target, var/choice)
	switch(choice)
		if(CHOICE_INTERIOR_SENSOR)
			preferred_id_tag = "[target.id_tag]_interior_sensor"
			return TRUE
		if(CHOICE_EXTERIOR_SENSOR)
			preferred_id_tag = "[target.id_tag]_exterior_sensor"
			return TRUE
		if(CHOICE_CHAMBER_SENSOR)
			preferred_id_tag = "[target.id_tag]_sensor"
			return TRUE
		else
			preferred_id_tag = null

/obj/item/frame/button/airlock_controller_config/airlock_sensor/kit
	fully_construct = TRUE
	name = "airlock sensor kit"
	desc = "An all-in-one airlock sensor kit, comes preassembled with a radio transmitter. Use on an airlock controller to pre-configure it."
	build_machine_type = /obj/machinery/airlock_sensor

#undef CHOICE_INTERIOR_SENSOR
#undef CHOICE_EXTERIOR_SENSOR
#undef CHOICE_CHAMBER_SENSOR

////////////////////////////////////////////////////////////////////////////////////////////////////////
// Airlock Access Button Frame
////////////////////////////////////////////////////////////////////////////////////////////////////////
#define CHOICE_INTERIOR_BUTTON "interior button"
#define CHOICE_EXTERIOR_BUTTON "exterior button"
/obj/item/frame/button/airlock_controller_config/access
	name = "button frame (airlock)"
	desc  = "Use on an airlock controller to pre-configure it."
	icon = 'icons/obj/machines/button_airlock.dmi'
	icon_state = ICON_STATE_WORLD
	build_machine_type = /obj/machinery/button/access/buildable
	///The type of the interior button to build for this frame
	var/interior_button_type = /obj/machinery/button/access/interior/buildable
	///The type of the exterior button to build for this frame
	var/exterior_button_type = /obj/machinery/button/access/exterior/buildable

/obj/item/frame/button/airlock_controller_config/access/get_setup_option_choices()
	return list(
		CHOICE_INTERIOR_BUTTON,
		CHOICE_EXTERIOR_BUTTON,
	)

/obj/item/frame/button/airlock_controller_config/access/setup_for_chosen_type(obj/machinery/embedded_controller/radio/target, choice)
	preferred_id_tag = target.id_tag
	switch(choice)
		if(CHOICE_INTERIOR_BUTTON)
			build_machine_type = interior_button_type
			return TRUE
		if(CHOICE_EXTERIOR_BUTTON)
			build_machine_type = exterior_button_type
			return TRUE
		else
			build_machine_type = initial(build_machine_type)
			preferred_id_tag = null

/obj/item/frame/button/airlock_controller_config/access/kit
	fully_construct = TRUE
	name = "button kit (airlock)"
	desc = "An all-in-one wall-mounted button kit, comes preassembled and equipped with a radio transmitter. Use on an airlock controller to pre-configure it."
	build_machine_type = /obj/machinery/button/access
	interior_button_type = /obj/machinery/button/access/interior
	exterior_button_type = /obj/machinery/button/access/exterior

#undef CHOICE_INTERIOR_BUTTON
#undef CHOICE_EXTERIOR_BUTTON