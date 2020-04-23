
/datum/computer/file/embedded_program
	var/list/memory = list()
	var/obj/machinery/embedded_controller/master
	var/id_tag

/datum/computer/file/embedded_program/New(var/obj/machinery/embedded_controller/M)
	..()
	master = M
	reset_id_tags()

/datum/computer/file/embedded_program/Destroy()
	if(master)
		master.program = null
		master = null
	return ..()

/datum/computer/file/embedded_program/proc/receive_user_command(command)
	return FALSE

// Returns all filters on which you want to receive signals
/datum/computer/file/embedded_program/proc/get_receive_filters(var/for_ui = FALSE)

/datum/computer/file/embedded_program/proc/receive_signal(datum/signal/signal, receive_method, receive_param)
	return

/datum/computer/file/embedded_program/proc/process()
	return

/datum/computer/file/embedded_program/proc/post_signal(datum/signal/signal, comm_line)
	if(master)
		master.post_signal(signal, comm_line)
	else
		qdel(signal)

/datum/computer/file/embedded_program/proc/reset_id_tags(base_tag)
	id_tag = base_tag || master.id_tag