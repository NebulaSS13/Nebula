/*
Note that these have to be within range of world.view (7 tiles), centered on the controller for them to function.
You still need to set the controller's "id_tag" to something unique.
*/
/obj/abstract/airlock_helper
	icon = 'icons/effects/airlock_helper.dmi'
	abstract_type = /obj/abstract/airlock_helper
	is_spawnable_type = FALSE
	layer = ABOVE_DOOR_LAYER
	/// The controller we're using. Set to a type to locate the type during Initialize().
	var/obj/machinery/embedded_controller/radio/my_controller = /obj/machinery/embedded_controller/radio/airlock
	/// The device we're setting up. Set to a type to locate the type during Initialize().
	var/my_device
	/// Adjusts the various radio tags used to configure airlock devices.
	var/tag_addon

/obj/abstract/airlock_helper/Initialize()
	..()
	my_controller = get_controller()
	if(!my_controller)
		log_error("Airlock helper '[name]' couldn't find a controller at: X:[x] Y:[y] Z:[z]")
		return INITIALIZE_HINT_QDEL

	if(!my_controller.id_tag)
		log_error("Airlock helper '[name]' found a controller without an 'id_tag' set: X:[x] Y:[y] Z:[z]")
		return INITIALIZE_HINT_QDEL

	my_device = locate(my_device) in loc
	if(!my_device)
		log_error("Airlock helper '[name]' couldn't find the device it wanted at: X:[x] Y:[y] Z:[z]")
		return INITIALIZE_HINT_QDEL

	configure_associated_device()
	return INITIALIZE_HINT_QDEL

/obj/abstract/airlock_helper/Destroy()
	my_controller = null
	my_device = null
	return ..()

/obj/abstract/airlock_helper/proc/get_controller()
	var/closest_distance = INFINITY
	for(var/obj/O in range(world.view, src))
		if(istype(O, my_controller))
			if(!.)
				. = O
			else
				var/check_distance = get_dist(src, O)
				if(check_distance < closest_distance)
					closest_distance = check_distance
					. = O

/// Stub for subtypes to override to deal with their specific devices.
/obj/abstract/airlock_helper/proc/configure_associated_device()
	return

/*
	Doors
*/
/obj/abstract/airlock_helper/door
	name = "use a subtype! - airlock door"
	my_device = /obj/machinery/door/airlock

/obj/abstract/airlock_helper/door/configure_associated_device()
	var/obj/machinery/door/airlock/my_airlock = my_device
	my_airlock.lock()
	my_airlock.set_id_tag(my_controller.id_tag + tag_addon)
	for(var/obj/item/stock_parts/radio/R in my_airlock.get_all_components_of_type(/obj/item/stock_parts/radio))
		R.set_id_tag(my_controller.id_tag + tag_addon)

/obj/abstract/airlock_helper/door/ext_door
	name = "exterior airlock door"
	icon_state = "doorout"
	tag_addon = "_outer"

/obj/abstract/airlock_helper/door/int_door
	name = "interior airlock door"
	icon_state = "doorin"
	tag_addon = "_inner"

/obj/abstract/airlock_helper/door/simple
	name = "simple docking controller hatch"
	icon_state = "doorsimple"
	tag_addon = "_hatch"
	my_controller = /obj/machinery/embedded_controller/radio/simple_docking_controller


/*
	Atmos
*/
/obj/abstract/airlock_helper/atmos
	name = "use a subtype! - airlock pump"
	my_device = /obj/machinery/atmospherics/unary/vent_pump

/obj/abstract/airlock_helper/atmos/configure_associated_device()
	var/obj/machinery/atmospherics/unary/vent_pump/my_pump = my_device
	my_pump.set_id_tag(my_controller.id_tag + tag_addon)
	for(var/obj/item/stock_parts/radio/R in my_pump.get_all_components_of_type(/obj/item/stock_parts/radio))
		R.set_id_tag(my_controller.id_tag + tag_addon)

/obj/abstract/airlock_helper/atmos/chamber_pump
	name = "chamber pump"
	icon_state = "pump"
	tag_addon = "_pump"

/obj/abstract/airlock_helper/atmos/pump_out_internal
	name = "air dump intake"
	icon_state = "pumpdin"
	tag_addon = "_pump_out_internal"

/obj/abstract/airlock_helper/atmos/pump_out_external
	name = "air dump output"
	icon_state = "pumpdout"
	tag_addon = "_pump_out_external"


/*
	Sensors
*/
/obj/abstract/airlock_helper/sensor
	my_device = /obj/machinery/airlock_sensor

/obj/abstract/airlock_helper/sensor/configure_associated_device()
	var/obj/machinery/airlock_sensor/my_sensor = my_device
	my_sensor.set_id_tag(my_controller.id_tag + tag_addon)

/obj/abstract/airlock_helper/sensor/ext_sensor
	name = "exterior sensor"
	icon_state = "sensout"
	tag_addon = "_exterior_sensor"

/obj/abstract/airlock_helper/sensor/chamber_sensor
	name = "chamber sensor"
	icon_state = "sens"
	tag_addon = "_sensor"

/obj/abstract/airlock_helper/sensor/int_sensor
	name = "interior sensor"
	icon_state = "sensin"
	tag_addon = "_interior_sensor"

/*
	Buttons - at one point in time, sensors also worked as buttons, but now that isn't the case.
*/
/obj/abstract/airlock_helper/button
	my_device = /obj/machinery/button/access
	icon_state = "button"
	tag_addon = "_airlock"
