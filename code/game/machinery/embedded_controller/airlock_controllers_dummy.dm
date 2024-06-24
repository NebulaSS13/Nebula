///Provides remote access to a controller (since they must be unique).
/obj/machinery/dummy_airlock_controller
	name               = "remote airlock control terminal"
	desc               = "A secondary airlock control terminal meant to be subordinated to a master airlock control terminal to allow remotely controlling the later from the former."
	icon               = 'icons/obj/airlock_machines.dmi'
	icon_state         = "airlock_control_off"
	layer              = ABOVE_OBJ_LAYER
	obj_flags          = OBJ_FLAG_MOVES_UNSUPPORTED
	base_type          = /obj/machinery/dummy_airlock_controller
	construct_state    = /decl/machine_construction/wall_frame/panel_closed
	frame_type         = /obj/item/frame/button/airlock_controller
	directional_offset = @'{"NORTH":{"y":-22}, "SOUTH":{"y":24}, "EAST":{"x":-22}, "WEST":{"x":22}}'
	power_channel      = ENVIRON //Same as airlock controller
	required_interaction_dexterity = DEXTERITY_TOUCHSCREENS
	///Topic state used to interact remotely with the master controller's UI
	var/datum/topic_state/remote/remote_state
	///Master controller we're subordinated to
	var/obj/machinery/embedded_controller/radio/airlock/master_controller

/obj/machinery/dummy_airlock_controller/Initialize(mapload, d, populate_parts)
	. = ..()
	set_extension(src, /datum/extension/interactive/multitool/embedded_controller_terminal)
	update_icon()
	if(mapload && length(id_tag))
		return INITIALIZE_HINT_LATELOAD

/obj/machinery/dummy_airlock_controller/LateInitialize()
	. = ..()
	if(!setup_target_controller())
		log_warning("\The mapped [src] ([x], [y], [z]) couldn't find a matching airlock controller with id_tag '[id_tag? id_tag : "null"]'. Deleting!")
		qdel(src)
		return

/obj/machinery/dummy_airlock_controller/Destroy()
	if(master_controller)
		unset_target_controller()
	QDEL_NULL(remote_state)
	return ..()

/obj/machinery/dummy_airlock_controller/interface_interact(var/mob/user)
	if(!master_controller)
		//#TODO: Show error UI
		return FALSE
	master_controller.ui_interact(user, state = remote_state)
	return TRUE

/obj/machinery/dummy_airlock_controller/proc/setup_target_controller()
	if(!id_tag)
		return FALSE
	unset_target_controller()
	for(var/obj/machinery/embedded_controller/radio/airlock/_master in SSmachines.machinery)
		if(_master.id_tag == id_tag)
			master_controller = _master
			master_controller.add_remote_terminal(src)
			break
	if(!master_controller)
		return FALSE
	remote_state = new /datum/topic_state/remote(src, master_controller)
	update_icon()
	return TRUE

/obj/machinery/dummy_airlock_controller/set_id_tag(new_id_tag)
	unset_target_controller()
	. = ..()
	setup_target_controller()

/obj/machinery/dummy_airlock_controller/proc/unset_target_controller()
	if(master_controller)
		master_controller.remove_remote_terminal(src)
		master_controller = null
	QDEL_NULL(remote_state)
	update_icon()

/**Callback from the master controller when it is destroyed. */
/obj/machinery/dummy_airlock_controller/proc/on_master_destroyed()
	unset_target_controller()

/**Update our appearence and state to match our parent's, unless we don't have a parent.*/
/obj/machinery/dummy_airlock_controller/on_update_icon()
	cut_overlays()
	icon_state = initial(icon_state)
	if(!operable() || !use_power)
		set_light(0)
		return

	if(master_controller)
		if(master_controller.screen_state)
			add_overlay(master_controller.screen_state)
		if(master_controller.indicator_state & master_controller.INDICATOR_FLAG_DONE)
			add_overlay("indicator_done")
		if(master_controller.indicator_state & master_controller.INDICATOR_FLAG_ACTIVE)
			add_overlay("indicator_active")
		if(master_controller.indicator_state & master_controller.INDICATOR_FLAG_FORCED)
			add_overlay("indicator_forced")
		set_light(master_controller.light_range, master_controller.light_power, master_controller.light_color)
	else
		//Disconnected screen
		add_overlay("screen_disconnected")
		add_overlay("indicator_active")
		add_overlay("indicator_done")
		add_overlay("indicator_forced")
		set_light(l_range = 2, l_power = 0.5, l_color = "#bf3133")

////////////////////////////////////////////////////////////////////////////////
// Multitool Interaction
////////////////////////////////////////////////////////////////////////////////
/datum/extension/interactive/multitool/embedded_controller_terminal
	expected_type = /obj/machinery/dummy_airlock_controller
	//#TODO: Maybe make some predicates to only allow authorized people to do maintenance and etc

/datum/extension/interactive/multitool/embedded_controller_terminal/get_interact_window(var/obj/item/multitool/M, var/mob/user)
	var/obj/machinery/dummy_airlock_controller/terminal = holder
	if(!istype(terminal))
		return
	. = list()
	. += "ID tag: <a href='byond://?src=\ref[src];input_tag=1'>[terminal.id_tag]</a><br>"
	. += "Nearby controllers:<br>"

	var/list/controllers
	for(var/obj/machinery/embedded_controller/radio/C in range(12, terminal))
		LAZYADD(controllers, "<tr> <td>[C]</td><td><a href='byond://?src=\ref[src];set_tag=\"[C.id_tag]\"'>[C.id_tag]</a></td> </tr>")

	if(!LAZYLEN(controllers))
		. += "None."
	else
		. += "<table>[JOINTEXT(controllers)]</table>"

	. = JOINTEXT(.)

/datum/extension/interactive/multitool/embedded_controller_terminal/on_topic(href, href_list, user)
	var/obj/machinery/dummy_airlock_controller/terminal = holder
	if(href_list["input_tag"])
		var/new_tag = input(user, "Enter the tag of the controller to connect to.", "Tag Selection", terminal.id_tag) as text|null
		if(extension_status(user) != STATUS_INTERACTIVE)
			return MT_NOACTION
		new_tag = sanitize_name(new_tag, MAX_MESSAGE_LEN, TRUE, FALSE)
		if(new_tag)
			terminal.id_tag = new_tag
			terminal.setup_target_controller()
			return MT_REFRESH

	if(istext(href_list["set_tag"]))
		var/new_tag = href_list["set_tag"]
		new_tag = sanitize_name(new_tag, MAX_MESSAGE_LEN, TRUE, FALSE)
		if(new_tag)
			terminal.id_tag = new_tag
			terminal.setup_target_controller()
			return MT_REFRESH

	return ..()
