/obj/machinery/artifact_analyser
	name = "anomaly analyser"
	desc = "Studies the emissions of anomalous materials to discover their uses."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "xenoarch_analyser1"
	var/obj/scanned_object
	var/obj/machinery/artifact_scanpad/owned_scanner
	var/scanning_counter = 0
	var/scan_duration = 5
	var/report_num = 0
	var/list/stored_scan = list()

	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/artifact_analyser

/obj/machinery/artifact_analyser/on_update_icon()
	icon_state = "xenoarch_analyser[operable()]"

/obj/machinery/artifact_analyser/Initialize()
	. = ..()
	reconnect_scanner()

/obj/machinery/artifact_analyser/proc/reconnect_scanner()
	//connect to a nearby scanner pad
	clear_scanner()
	owned_scanner = locate(/obj/machinery/artifact_scanpad) in get_step(src, dir)
	if(!owned_scanner)
		owned_scanner = locate(/obj/machinery/artifact_scanpad) in orange(1, src)
	if(owned_scanner)
		events_repository.register(/decl/observ/destroyed, owned_scanner, src, TYPE_PROC_REF(/obj/machinery/artifact_analyser, clear_scanner))

/obj/machinery/artifact_analyser/proc/clear_scanner()
	if(owned_scanner)
		events_repository.unregister(/decl/observ/destroyed, owned_scanner, src)
		owned_scanner = null

/obj/machinery/artifact_analyser/proc/set_object(var/obj/O)
	if(O != scanned_object && O)
		clear_object()
		events_repository.register(/decl/observ/destroyed, O, src, TYPE_PROC_REF(/obj/machinery/artifact_analyser, clear_object))
		scanned_object = O

/obj/machinery/artifact_analyser/proc/clear_object()
	if(scanned_object)
		events_repository.unregister(/decl/observ/destroyed, scanned_object, src)
		scanned_object = null

/obj/machinery/artifact_analyser/Destroy()
	clear_scanner()
	clear_object()
	. = ..()

/obj/machinery/artifact_analyser/DefaultTopicState()
	return global.physical_topic_state

/obj/machinery/artifact_analyser/interface_interact(user)
	ui_interact(user)
	return TRUE

/obj/machinery/artifact_analyser/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	if(!owned_scanner)
		reconnect_scanner()
	if(!owned_scanner)
		data["error"] = "Unable to locate the scanner pad."
	else
		data["scan_progress"] = scan_duration - scanning_counter
		data["scan_duration"] = scan_duration
		if(length(stored_scan))
			data["stored_scan"] = stored_scan

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "anomaly_scanner.tmpl", "Anomaly Analyzer Console", 360, 500)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/artifact_analyser/proc/stop_scan()
	scanning_counter = 0
	clear_object()

/obj/machinery/artifact_analyser/Process()
	if(!scanning_counter)
		return

	if(!owned_scanner)
		reconnect_scanner()
	if(!owned_scanner)
		state("Error communicating with the scanner pad.")
		stop_scan()
		return

	if(!scanned_object || scanned_object.loc != owned_scanner.loc)
		state("Unable to locate scanned object. Ensure it was not moved in the process.")
		stop_scan()
		return

	scanning_counter--
	if(!scanning_counter)
		updateDialog()

		ping("Scanning complete.")

		stored_scan["name"] = scanned_object.name
		stored_scan["data"] = scanned_object.get_artifact_scan_data()
		clear_object()

/obj/machinery/artifact_analyser/OnTopic(user, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["begin_scan"])
		if(!owned_scanner)
			reconnect_scanner()
		if(!owned_scanner)
			state("Unable to locate the scanner pad.")
			return
		for(var/obj/O in owned_scanner.loc)
			if(O == owned_scanner || O.invisibility || !O.simulated)
				continue
			set_object(O)
			scanning_counter = scan_duration
			state("Scanning of \the [O] initiated.")
			playsound(loc, "sound/effects/ping.ogg", 50, 1)
			break
		if(!scanned_object)
			state("Unable to isolate a scan target.")
		. = TOPIC_REFRESH

	if(href_list["halt_scan"])
		stop_scan()
		state("Scanning halted.")
		. = TOPIC_REFRESH

	if(href_list["print"])
		if(length(stored_scan))
			playsound(loc, "sound/machines/dotprinter.ogg", 30, 1)
			new/obj/item/paper(get_turf(src), null, "<h3>[src] analysis report #[++report_num]</h3>[stored_scan["data"]]", "artifact report #[report_num] ([stored_scan["name"]])")
		. = TOPIC_HANDLED

//Overriden by subtypes to provide fluff description of object function.
/obj/proc/get_artifact_scan_data()
	return "[name] - mundane application."
