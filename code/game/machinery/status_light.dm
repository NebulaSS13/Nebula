/obj/machinery/status_light
	name = "combustion chamber status indicator"
	desc = "A status indicator for a combustion chamber, based on temperature."
	icon = 'icons/obj/machines/door_timer.dmi'
	icon_state = "doortimer-p"
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "EAST":{"x":32}, "WEST":{"x":-32}}'
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/frequency = 1441
	var/alert_temperature = 10000
	var/alert = 1
	var/datum/radio_frequency/radio_connection

/obj/machinery/status_light/Initialize()
	. = ..()
	update_icon()
	radio_connection = register_radio_to_controller(src, frequency, frequency, RADIO_ATMOSIA)

/obj/machinery/status_light/Destroy()
	radio_controller.remove_object(src,frequency)
	return ..()

/obj/machinery/status_light/on_update_icon()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "doortimer-b"
		return
	icon_state = "doortimer[alert]"

/obj/machinery/status_light/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!signal.data["tag"] || (signal.data["tag"] != id_tag) || !signal.data["temperature"])
		return 0

	if(signal.data["temperature"] >= alert_temperature)
		alert = 1
	else
		alert = 2

	update_icon()
	return
