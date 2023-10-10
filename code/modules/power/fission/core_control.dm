/obj/machinery/computer/fission
	name = "fission control computer"
	icon_keyboard = "power_key"
	icon_screen = "fission_screen"
	light_color = COLOR_ORANGE
	idle_power_usage = 250
	active_power_usage = 500
	var/initial_id_tag = "fission"

	var/current_core = 1 // Which core connected to the console is being controlled/viewed.
	var/current_rod = 0  // Which fuel rod in the selected core is being viewed. 0 if no rod is being viewed.
	var/diagnostics = FALSE // Whether or not the control computer displays advanced diagnostics.

/obj/machinery/computer/fission/Initialize()
	. = ..()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/fission = get_extension(src, /datum/extension/local_network_member)
		fission.set_tag(null, initial_id_tag)

/obj/machinery/computer/fission/attackby(var/obj/item/W, var/mob/user)
	if(IS_MULTITOOL(W))
		var/datum/extension/local_network_member/fission = get_extension(src, /datum/extension/local_network_member)
		fission.get_new_tag(user)
		return TRUE

	return ..()

/obj/machinery/computer/fission/proc/build_ui_data()
	. = list()
	var/datum/extension/local_network_member/fission = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = fission.get_local_network()
	.["current_core"] = current_core
	.["current_rod"] = current_rod
	.["diagnostics"] = diagnostics
	if(lan)
		var/list/fission_cores = lan.get_devices(/obj/machinery/atmospherics/unary/fission_core)
		if(!length(fission_cores))
			.["no_cores"] = 1
			return
		current_core = clamp(current_core, 1, length(fission_cores))
		var/obj/machinery/atmospherics/unary/fission_core/selected_core = fission_cores[current_core]
		if(istype(selected_core))
			if(selected_core.stat & (BROKEN|NOPOWER))
				.["error"] = 1
				return
			. |= selected_core.build_ui_data(current_rod)

/obj/machinery/computer/fission/OnTopic(var/mob/user, href_list, state)
	var/datum/extension/local_network_member/fission = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = fission.get_local_network()
	if(href_list["change_core"])
		if(lan)
			var/num_cores = length(lan.get_devices(/obj/machinery/atmospherics/unary/fission_core))
			if(num_cores)
				current_core += text2num(href_list["change_core"])
				if(current_core > num_cores)
					current_core = 1
				if(current_core < 1)
					current_core = num_cores
		return TOPIC_REFRESH

	if(href_list["toggle_diagnostics"])
		diagnostics = !diagnostics
		return TOPIC_REFRESH

	if(href_list["machine"])
		var/obj/machinery/atmospherics/unary/fission_core/C = locate(href_list["machine"])
		if(!istype(C))
			return TOPIC_NOACTION

		if(!lan || !lan.is_connected(C))
			return TOPIC_NOACTION

		if(href_list["control_rod"])
			var/new_depth = input(user,"Enter the desired control rod depth between 0 and 1:" ,"Control Rod Depth", 0) as num|null
			if(!CanInteract(user, state))
				return TOPIC_NOACTION
			C.adjust_control_rods(clamp(new_depth, 0, 1))
			return TOPIC_REFRESH

		if(href_list["jump_start"])
			if(C.check_active())
				to_chat(user, SPAN_NOTICE("\The [C] is already active!"))
				return TOPIC_NOACTION
			C.jump_start()
			return TOPIC_REFRESH

		if(href_list["rod"])
			var/new_rod = text2num(href_list["rod"])
			current_rod = (current_rod == new_rod ? 0 : new_rod)
			return TOPIC_REFRESH

		if(href_list["eject_rod"])
			if(!C.eject_rod(current_rod))
				to_chat(user, SPAN_WARNING("You cannot eject rods from \the [C] while it is active!"))
				return TOPIC_NOACTION
			return TOPIC_REFRESH

		if(href_list["expose_rod"])
			if(!C.toggle_rod_exposure(current_rod))
				to_chat(user, SPAN_WARNING("You cannot unexpose a rod while \the [C] is active!"))
				return TOPIC_NOACTION
			return TOPIC_REFRESH

/obj/machinery/computer/fission/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = build_ui_data()
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "fission_core.tmpl", name, 400, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/fission/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE
