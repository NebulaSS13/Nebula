/obj/machinery/body_scan_display
	name = "body scan display"
	desc = "A wall-mounted display linked to a body scanner."
	icon = 'icons/obj/modular_computers/modular_telescreen.dmi'
	icon_state = "telescreen"
	anchored = TRUE
	density = FALSE
	idle_power_usage = 75
	active_power_usage = 300
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	w_class = ITEM_SIZE_HUGE
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = @'{"NORTH":{"y":-32}, "SOUTH":{"y":32}, "EAST":{"x":32}, "WEST":{"x":-32}}'
	var/list/bodyscans = list()
	var/selected = 0

/obj/machinery/body_scan_display/proc/add_new_scan(var/list/scan)
	bodyscans += list(scan.Copy())
	updateUsrDialog()
	queue_icon_update()

/obj/machinery/body_scan_display/on_update_icon()
	. = ..()
	cut_overlays()
	if(!(stat & (BROKEN|NOPOWER)))
		if (selected != 0)
			add_overlay("operating")
		else if (bodyscans.len > 0)
			add_overlay("menu")
		else
			add_overlay("standby")

/obj/machinery/body_scan_display/OnTopic(mob/user, href_list)
	if(href_list["view"])
		var/selection = text2num(href_list["view"])
		if(is_valid_index(selection, bodyscans))
			selected = selection
			queue_icon_update()
			return TOPIC_REFRESH
		return TOPIC_HANDLED
	if(href_list["delete"])
		var/selection = text2num(href_list["delete"])
		if(!is_valid_index(selection, bodyscans))
			return TOPIC_HANDLED
		if(selected == selection)
			selected = 0
			queue_icon_update()
		else if(selected > selection)
			selected--
		bodyscans -= list(bodyscans[selection])
		return TOPIC_REFRESH

/obj/machinery/body_scan_display/interface_interact(user)
	ui_interact(user)
	return TRUE

/obj/machinery/body_scan_display/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open=1)
	var/list/data = list()
	data["scans"] = bodyscans
	data["selected"] = selected

	if(selected > 0)
		data["scan_header"] = display_medical_data_header(bodyscans[selected], user.get_skill_value(SKILL_MEDICAL))
		data["scan_health"] = display_medical_data_health(bodyscans[selected], user.get_skill_value(SKILL_MEDICAL))
		data["scan_body"] = display_medical_data_body(bodyscans[selected], user.get_skill_value(SKILL_MEDICAL))
	else
		data["scan_header"] = "&nbsp;"
		data["scan_health"] = "&nbsp;"
		data["scan_body"] = "&nbsp;"
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "body_scan_display.tmpl", "Body Scan Display Console", 600, 800)
		ui.set_initial_data(data)
		ui.open()