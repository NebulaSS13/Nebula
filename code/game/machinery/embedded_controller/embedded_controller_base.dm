/obj/machinery/embedded_controller
	name = "Embedded Controller"
	anchored = 1
	idle_power_usage = 10
	layer = ABOVE_WINDOW_LAYER
	var/datum/computer/file/embedded_program/program	//the currently executing program
	var/on = 1

/obj/machinery/embedded_controller/Initialize()
	if(program)
		program = new program(src)
	return ..()

/obj/machinery/embedded_controller/Destroy()
	if(istype(program))
		qdel(program) // the program will clear the ref in its Destroy
	return ..()

/obj/machinery/embedded_controller/proc/post_signal(datum/signal/signal, comm_line)
	return 0

/obj/machinery/embedded_controller/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(!signal || signal.encryption) return

	if(program)
		program.receive_signal(signal, receive_method, receive_param)
			//spawn(5) program.process() //no, program.process sends some signals and machines respond and we here again and we lag -rastaf0

/obj/machinery/embedded_controller/Topic(href, href_list)
	if(..())
		return
	if(usr)
		usr.set_machine(src)
	if(program)
		return program.receive_user_command(href_list["command"]) // Any further sanitization should be done in here.

/obj/machinery/embedded_controller/Process()
	if(program)
		program.process()

	update_icon()

/obj/machinery/embedded_controller/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/embedded_controller/radio
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_off"
	power_channel = ENVIRON
	density = 0
	unacidable = 1
	var/frequency = EXTERNAL_AIR_FREQ
	var/datum/radio_frequency/radio_connection

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/wall_frame/panel_closed
	frame_type = /obj/item/frame/button/airlock_controller
	base_type = /obj/machinery/embedded_controller/radio/simple_docking_controller
	stat_immune = 0

/obj/machinery/embedded_controller/radio/Initialize()
	. = ..()
	set_frequency(frequency)
	set_extension(src, /datum/extension/interactive/multitool/embedded_controller)

obj/machinery/embedded_controller/radio/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	..()

/obj/machinery/embedded_controller/radio/on_update_icon()
	overlays.Cut()
	if(!on || !istype(program))
		return
	if(!program.memory["processing"])
		overlays += image(icon, "screen_standby")
		overlays += image(icon, "indicator_done")
	else
		overlays += image(icon, "indicator_active")
	var/datum/computer/file/embedded_program/docking/airlock/docking_program = program
	var/datum/computer/file/embedded_program/airlock/docking/airlock_program = program
	if(istype(docking_program))
		if(docking_program.override_enabled)
			overlays += image(icon, "indicator_forced")
		airlock_program = docking_program.airlock_program
	
	if(istype(airlock_program) && airlock_program.memory["processing"])
		if(airlock_program.memory["pump_status"] == "siphon")
			overlays += image(icon, "screen_drain")
		else
			overlays += image(icon, "screen_fill")

#define AIRLOCK_CONTROL_RANGE 22

/obj/machinery/embedded_controller/radio/post_signal(datum/signal/signal, var/radio_filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal, radio_filter, AIRLOCK_CONTROL_RANGE)
	else
		qdel(signal)

#undef AIRLOCK_CONTROL_RANGE

/obj/machinery/embedded_controller/radio/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	var/list/filters = program?.get_receive_filters()
	for(var/filter in filters)
		radio_connection = radio_controller.add_object(src, frequency, filter)

// resets all id_tags (including in programs) based on the given tag.
/obj/machinery/embedded_controller/radio/proc/reset_id_tags(base_tag)
	id_tag = base_tag
	if(program)
		program.reset_id_tags(base_tag)

/datum/extension/interactive/multitool/embedded_controller/get_interact_window(var/obj/item/multitool/M, var/mob/user)
	var/obj/machinery/embedded_controller/radio/controller = holder
	if(!istype(holder))
		return
	. = list()
	. += "ID tag: <a href='?src=\ref[src];set_tag=1'>[controller.id_tag]</a><br>"
	. += "Frequency: <a href='?src=\ref[src];set_freq=1'>[controller.frequency]</a><br>"
	. += "Likely tags used by controller:<br>"
	var/list/tags = controller.program?.get_receive_filters(TRUE)
	if(!length(tags))
		. += "None."
	else
		. += "<table>"
		for(var/tag in tags)
			. += "<tr>"
			. += "<td>[tags[tag]]</td>"
			. += "<td>[tag]</td>"
			. += "</tr>"
		. += "</table>"
	. = JOINTEXT(.)

/datum/extension/interactive/multitool/embedded_controller/on_topic(href, href_list, user)
	var/obj/machinery/embedded_controller/radio/controller = holder
	if(href_list["set_tag"])
		var/new_tag = input(user, "Enter a new tag to use. Warning: this will reset all tags used by this machine, not just the main one!", "Tag Selection", controller.id_tag) as text|null
		if(extension_status(user) != STATUS_INTERACTIVE)
			return MT_NOACTION
		sanitize(new_tag)
		if(new_tag)
			controller.reset_id_tags(new_tag)
			controller.set_frequency(controller.frequency)
			return MT_REFRESH

	if(href_list["set_freq"])
		var/new_frequency = input(user, "Enter a new frequency to use.", "frequency Selection", controller.frequency) as num|null
		if(!new_frequency || (extension_status(user) != STATUS_INTERACTIVE))
			return MT_NOACTION
		new_frequency = sanitize_frequency(new_frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
		controller.set_frequency(new_frequency)
		return MT_REFRESH