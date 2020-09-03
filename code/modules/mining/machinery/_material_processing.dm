#define SET_INPUT(_dir)  input_turf = _dir  ? get_step(loc, _dir) : null
#define SET_OUTPUT(_dir) output_turf = _dir ? get_step(loc, _dir) : null

/obj/machinery/material_processing
	density =  TRUE
	anchored = TRUE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	icon = 'icons/obj/machines/mining_machines.dmi'
	var/use_ui_template
	var/allow_ui_config =  FALSE
	var/turf/input_turf =  WEST
	var/turf/output_turf = EAST

/obj/machinery/material_processing/emp_act(severity)
	if(severity == 1 || (severity == 2 && prob(50)))
		emagged = TRUE
	. = ..()

/obj/machinery/material_processing/emag_act(remaining_charges, mob/user, emag_source)
	if(!emagged)
		emagged = TRUE
		to_chat(user, SPAN_NOTICE("You short out \the [src]'s intake safety protocol."))
		return TRUE

/obj/machinery/material_processing/on_update_icon()

	cut_overlays()
	
	icon_state = initial(icon_state)
	if(panel_open)
		add_overlay("[icon_state]-open")
	if(!use_power || (stat & (BROKEN|NOPOWER)))
		icon_state = "[icon_state]-off"
	
	var/overlay_dir = 0
	if(input_turf)
		overlay_dir = get_dir(src, input_turf)
		if(overlay_dir != 0)
			var/image/I = image('icons/obj/machines/mining_machine_overlays.dmi', "[GLOB.reverse_dir[overlay_dir]]")
			I.layer = DECAL_LAYER
			switch(overlay_dir)
				if(NORTH) I.pixel_y += world.icon_size
				if(SOUTH) I.pixel_y -= world.icon_size
				if(EAST)  I.pixel_x += world.icon_size
				if(WEST)  I.pixel_x -= world.icon_size
			add_overlay(I)
	if(output_turf)
		overlay_dir = get_dir(src, output_turf)
		if(overlay_dir != 0)
			var/image/I = image('icons/obj/machines/mining_machine_overlays.dmi', "[overlay_dir]")
			I.layer = DECAL_LAYER
			switch(overlay_dir)
				if(NORTH) I.pixel_y += world.icon_size
				if(SOUTH) I.pixel_y -= world.icon_size
				if(EAST)  I.pixel_x += world.icon_size
				if(WEST)  I.pixel_x -= world.icon_size
			add_overlay(I)
	if(overlay_dir == 0)
		var/image/I = image('icons/obj/machines/mining_machine_overlays.dmi', "0")
		I.layer = DECAL_LAYER
		add_overlay(I)

/obj/machinery/material_processing/proc/get_ui_data()
	var/list/data = list()
	data["on"] = (use_power > 0)
	data["can_configure"] = allow_ui_config
	data["output_value"] =  output_turf ? get_dir(src, output_turf) : 0
	data["output_label"] =  data["output_value"] ? dir2text(data["output_value"]) : "disabled"
	data["input_value"] =   input_turf ? get_dir(src, input_turf) : 0
	data["input_label"] =   data["input_value"] ?  dir2text(data["input_value"])  : "disabled"
	return data

/obj/machinery/material_processing/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui=null, force_open=1)
	if(!use_ui_template)
		return
	var/list/data = get_ui_data()
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, use_ui_template, "[capitalize(name)]", 600, 800, state = GLOB.physical_state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/material_processing/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/material_processing/Destroy()
	input_turf = null
	output_turf = null
	. = ..()

/obj/machinery/material_processing/Initialize()
	dir = output_turf || input_turf
	SET_INPUT(input_turf)
	SET_OUTPUT(output_turf)
	. = ..()
	queue_icon_update()

/obj/machinery/material_processing/OnTopic(var/user, var/list/href_list)
	if(href_list["toggle_power"])
		update_use_power(use_power ? 0 : POWER_USE_IDLE)
		. = TOPIC_REFRESH
	if(href_list["set_input"])
		SET_INPUT(text2num(href_list["set_input"]))
		queue_icon_update()
		. = TOPIC_REFRESH
	if(href_list["set_output"])
		dir = text2num(href_list["set_output"])
		SET_OUTPUT(dir)
		queue_icon_update()
		. = TOPIC_REFRESH
	if(href_list["toggle_configuration"])
		allow_ui_config = !allow_ui_config
		. = TOPIC_REFRESH
