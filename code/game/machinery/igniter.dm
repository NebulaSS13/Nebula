/obj/machinery/igniter
	name = "igniter"
	desc = "A device that ignites flammable items and gases nearby when activated."
	icon = 'icons/obj/machines/igniter.dmi'
	icon_state = "igniter1"
	var/on = 0
	anchored = TRUE
	idle_power_usage = 20
	active_power_usage = 1000

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/power/apc/buildable
	)
	public_variables = list(
		/decl/public_access/public_variable/igniter_on
	)
	public_methods = list(
		/decl/public_access/public_method/igniter_toggle
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/igniter = 1)

	frame_type = /obj/item/machine_chassis/igniter/base
	construct_state = /decl/machine_construction/default/panel_closed/item_chassis
	base_type = /obj/machinery/igniter/buildable

/obj/machinery/igniter/buildable
	uncreated_component_parts = null

/obj/machinery/igniter/Initialize()
	. = ..()
	update_icon()
	if(!on)
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/igniter/on_update_icon()
	..()
	icon_state = "igniter[on]"

/obj/machinery/igniter/interface_interact(mob/user)
	if(!CanInteract(user, DefaultTopicState()))
		return FALSE
	toggle_igniter()
	visible_message(SPAN_NOTICE("\The [user] toggles \the [src]."))
	return TRUE

/obj/machinery/igniter/Process()
	if(!(stat & NOPOWER))
		var/turf/location = src.loc
		if (isturf(location))
			location.hotspot_expose(1000,500,1)
	return 1

/obj/machinery/igniter/proc/toggle_igniter()
	use_power_oneoff(2000)
	on = !on
	if(on)
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	else
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	update_icon()

/decl/public_access/public_variable/igniter_on
	expected_type = /obj/machinery/igniter
	name = "igniter active"
	desc = "Whether or not the igniter is igniting."
	can_write = FALSE
	has_updates = FALSE

/decl/public_access/public_variable/igniter_on/access_var(obj/machinery/igniter/igniter)
	return igniter.on

/decl/public_access/public_method/igniter_toggle
	name = "igniter toggle"
	desc = "Toggle the igniter on or off."
	call_proc = TYPE_PROC_REF(/obj/machinery/igniter, toggle_igniter)

/decl/stock_part_preset/radio/receiver/igniter
	frequency = BUTTON_FREQ
	receive_and_call = list("button_active" = /decl/public_access/public_method/igniter_toggle)

// Wall mounted remote-control igniter.

/obj/machinery/sparker
	name = "mounted igniter"
	desc = "A wall-mounted ignition device."
	icon = 'icons/obj/machines/igniter_mounted.dmi'
	icon_state = "migniter"
	var/disable = 0
	var/last_spark = 0
	var/base_state = "migniter"
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	anchored = TRUE
	idle_power_usage = 20
	active_power_usage = 1000

	uncreated_component_parts = list(
		/obj/item/stock_parts/radio/receiver/buildable,
		/obj/item/stock_parts/power/apc/buildable
	)
	public_methods = list(
		/decl/public_access/public_method/sparker_spark
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/sparker = 1)

	construct_state = /decl/machine_construction/wall_frame/panel_closed/simple
	frame_type = /obj/item/frame/button/sparker
	base_type = /obj/machinery/sparker/buildable
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "EAST":{"x":32}, "WEST":{"x":-32}}'

/obj/machinery/sparker/buildable
	uncreated_component_parts = null

/obj/machinery/sparker/on_update_icon()
	if(disable)
		icon_state = "[base_state]-d"
	else if(!(stat & NOPOWER))
		icon_state = base_state
	else
		icon_state = "[base_state]-p"

/obj/machinery/sparker/attackby(obj/item/used_item, mob/user)
	if(panel_open && IS_WIRECUTTER(used_item))
		add_fingerprint(user)
		disable = !disable
		if(disable)
			user.visible_message(SPAN_WARNING("[user] has disabled \the [src]!"), SPAN_WARNING("You disable the connection to \the [src]."))
		else
			user.visible_message(SPAN_WARNING("[user] has reconnected \the [src]!"), SPAN_WARNING("You fix the connection to \the [src]."))
		update_icon()
		return TRUE
	else
		return ..()

/obj/machinery/sparker/attack_ai()
	return anchored ? create_sparks() : null

/obj/machinery/sparker/proc/create_sparks()
	if (stat & NOPOWER)
		return

	if (disable || (last_spark && world.time < last_spark + 50))
		return

	flick("[base_state]-spark", src)
	spark_at(src, amount=2, cardinal_only = TRUE)
	src.last_spark = world.time
	use_power_oneoff(2000)
	var/turf/location = src.loc
	if (isturf(location))
		location.hotspot_expose(1000,500,1)
	return 1

/obj/machinery/sparker/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	create_sparks()
	..(severity)

/decl/public_access/public_method/sparker_spark
	name = "spark"
	desc = "Creates sparks to ignite nearby gases."
	call_proc = TYPE_PROC_REF(/obj/machinery/sparker, create_sparks)

/decl/stock_part_preset/radio/receiver/sparker
	frequency = BUTTON_FREQ
	receive_and_call = list("button_active" = /decl/public_access/public_method/sparker_spark)

/obj/machinery/button/ignition
	name = "ignition switch"
	desc = "A remote control switch for a mounted igniter."