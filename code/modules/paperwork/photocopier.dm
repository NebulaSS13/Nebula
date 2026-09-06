////////////////////////////////////////////////////////////////////////////////////////
// Photocopier Board
////////////////////////////////////////////////////////////////////////////////////////
/obj/item/stock_parts/circuitboard/photocopier
	name = "circuitboard (photocopier)"
	build_path = /obj/machinery/photocopier
	board_type = "machine"
	origin_tech = @'{"engineering":1, "programming":1}'
	req_components = list(
			/obj/item/stock_parts/printer/buildable = 1,
			/obj/item/stock_parts/manipulator       = 2,
			/obj/item/stock_parts/scanning_module   = 1,
		)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen      = 1,
		/obj/item/stock_parts/keyboard            = 1,
		/obj/item/stock_parts/power/apc/buildable = 1
	)

////////////////////////////////////////////////////////////////////////////////////////
// Photocopier
////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/photocopier
	name                  = "photocopier"
	icon                  = 'icons/obj/machines/photocopier.dmi'
	icon_state            = "photocopier"
	anchored              = TRUE
	density               = TRUE
	idle_power_usage      = 30
	active_power_usage    = 200
	atom_flags            = ATOM_FLAG_CLIMBABLE
	obj_flags             = OBJ_FLAG_ANCHORABLE
	construct_state       = /decl/machine_construction/default/panel_closed
	maximum_component_parts = list(
		/obj/item/stock_parts/printer = 1,
		/obj/item/stock_parts         = 10,
	)
	uncreated_component_parts = null
	var/tmp/insert_anim   = "photocopier_animation"
	var/obj/item/scanner_item                  //what's in the scanner
	var/obj/item/stock_parts/printer/printer   //What handles the printing queue
	var/tmp/max_copies    = 10                 //how many copies can be copied at once- idea shamelessly stolen from bs12's copier!
	var/total_printing    = 0                  //The total number of pages we are printing in the current run

/obj/machinery/photocopier/Initialize(mapload, d=0, populate_parts = TRUE)
	. = ..()
	if(. != INITIALIZE_HINT_QDEL && populate_parts && printer)
		//Mapped photocopiers shall spawn with ink and paper
		printer.make_full()

/obj/machinery/photocopier/Destroy()
	scanner_item = null
	printer = null
	return ..()

/obj/machinery/photocopier/RefreshParts()
	. = ..()
	printer = get_component_of_type(/obj/item/stock_parts/printer) //Cache the printer component
	if(printer)
		printer.show_queue_ctrl = FALSE //Make sure we don't let users mess with the print queue
		printer.register_on_printed_page(  CALLBACK(src, TYPE_PROC_REF(/obj/machinery/photocopier, update_ui)))
		printer.register_on_finished_queue(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/photocopier, update_ui)))
		printer.register_on_print_error(   CALLBACK(src, TYPE_PROC_REF(/obj/machinery/photocopier, update_ui)))
		printer.register_on_status_changed(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/photocopier, update_ui)))

/obj/machinery/photocopier/on_update_icon()
	cut_overlays()
	//Set the icon first
	if(scanner_item)
		icon_state = "photocopier_paper"
	else
		icon_state = initial(icon_state)

	//If powered and working add the flashing lights
	if(inoperable())
		return
	//Warning lights
	if(scanner_item)
		add_overlay("photocopier_ready")
	if(!has_enough_to_print())
		add_overlay("photocopier_bad")

/obj/machinery/photocopier/proc/update_ui()
	SSnano.update_uis(src)
	update_icon()

/obj/machinery/photocopier/proc/queue_copies(var/copy_amount, var/mob/user)
	if(!scanner_item)
		if(user)
			to_chat(user, SPAN_WARNING("Insert something to copy first!"))
		return FALSE

	//First, check we have enough to print the copies
	var/required_toner = 0
	var/required_paper = 1

	//Compile the total amount needed for printing the whole bundle if applicable
	if(istype(scanner_item, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/B = scanner_item
		for(var/obj/item/I in B.pages)
			required_toner += istype(I, /obj/item/photo)? TONER_USAGE_PHOTO : TONER_USAGE_PAPER
		required_paper = length(B.pages)
	else if(istype(scanner_item, /obj/item/photo))
		required_toner = TONER_USAGE_PHOTO
	else
		required_toner = TONER_USAGE_PAPER

	if(!has_enough_to_print(required_toner, required_paper * copy_amount))
		buzz("Warning: Not enough paper or toner!")
		return FALSE

	//If we have enough go ahead
	var/list/obj/item/scanned_item = scan_item(scanner_item) //Generate the copies we'll queue for printing
	for(var/i=1 to copy_amount)
		for(var/obj/item/page in scanned_item)
			printer.queue_job(page)

	//Play the scanner animation
	flick(insert_anim, src)

	//Actually start printing out the copies we created when queueing
	start_processing_queue()
	return TRUE

/obj/machinery/photocopier/proc/start_processing_queue()
	if(!printer)
		return FALSE
	audible_message(SPAN_NOTICE("\The [src] whirrs into action."))
	total_printing = printer.get_amount_queued()
	printer.start_printing_queue()

	use_power_oneoff(active_power_usage)
	update_icon()
	SSnano.update_uis(src)
	return TRUE

/obj/machinery/photocopier/proc/stop_processing_queue()
	if(!printer)
		return FALSE
	total_printing = 0
	printer.stop_printing_queue()
	printer.clear_job_queue()

	update_use_power(POWER_USE_IDLE)
	update_icon()
	SSnano.update_uis(src)
	return TRUE

/obj/machinery/photocopier/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/photocopier/proc/get_name_copy_item()
	if(istype(scanner_item, /obj/item/paper))
		return "Sheet of paper"
	else if(istype(scanner_item, /obj/item/paper_bundle))
		return "Paper bundle"
	else if(istype(scanner_item, /obj/item/photo))
		return "Photo"

/obj/machinery/photocopier/ui_data(mob/user, ui_key)
	. = ..()
	//Printer header stuff
	if(printer)
		LAZYADD(., printer.ui_data(user))

	//Photocopier stuff
	LAZYSET(., "src",                "\ref[src]")
	LAZYSET(., "is_sillicon_mode",   issilicon(user))
	LAZYSET(., "copies_max",         max_copies)
	LAZYSET(., "is_operational",     operable())
	LAZYSET(., "total_printing",     total_printing)
	LAZYSET(., "loaded_item_name",   get_name_copy_item())

/obj/machinery/photocopier/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/list/data = ui_data(user, ui_key)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "photocopier.tmpl", name, 640, 480)
		ui.add_template("stock_parts_printer_shared", "stock_parts_printer.tmpl") //printer info header
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/photocopier/DefaultTopicState()
	return global.physical_topic_state

/obj/machinery/photocopier/OnTopic(user, href_list, state)
	//We don't plug in the printer's own OnTopic here since we don't want to allow the user control over it

	if(href_list["eject"])
		eject_item(user)
		return TOPIC_REFRESH

	if(href_list["copy_amount"])
		queue_copies(sanitize_integer(text2num(href_list["copy_amount"]), 1, max_copies, 1))
		return TOPIC_REFRESH

	if(href_list["cancel_queue"])
		stop_processing_queue()
		return TOPIC_REFRESH

	if(href_list["aipic"])
		if(!issilicon(user))
			return TOPIC_NOACTION
		if(has_enough_to_print(TONER_USAGE_PHOTO))
			var/mob/living/silicon/tempAI = user
			var/obj/item/camera/siliconcam/camera = tempAI.silicon_camera
			if(!camera)
				return TOPIC_NOACTION
			var/obj/item/photo/selection = camera.selectpicture()
			if (!selection)
				return TOPIC_NOACTION

			var/obj/item/photo/p = selection.Clone()
			if (p.desc == "")
				p.desc += "Copied by [tempAI.name]"
			else
				p.desc += " - Copied by [tempAI.name]"
			printer.queue_job(p)
			start_processing_queue()
		else
			to_chat(user, SPAN_WARNING("Not enough toner and/or paper to print!"))
			return TOPIC_NOACTION
		return TOPIC_REFRESH

/obj/machinery/photocopier/proc/insert_item(var/obj/item/I, var/mob/user)
	if(!scanner_item)
		if(!user.try_unequip(I, src))
			return
		scanner_item = I
		to_chat(user, SPAN_NOTICE("You insert \the [I] into \the [src]."))
		SSnano.update_uis(src)
		update_icon()
		return TRUE
	else
		to_chat(user, SPAN_NOTICE("There is already something in \the [src]."))

/obj/machinery/photocopier/proc/eject_item(var/mob/user)
	if(!scanner_item)
		return
	user.put_in_hands(scanner_item)
	to_chat(user, SPAN_NOTICE("You take \the [scanner_item] out of \the [src]."))
	scanner_item = null
	SSnano.update_uis(src)
	update_icon()
	return TRUE

/obj/machinery/photocopier/attackby(obj/item/used_item, mob/user)
	if(printer.is_printing())
		to_chat(user, SPAN_WARNING("\The [src] is busy!"))
		return TRUE
	if(istype(construct_state, /decl/machine_construction/default/panel_closed) && (istype(used_item, /obj/item/paper) || istype(used_item, /obj/item/photo) || istype(used_item, /obj/item/paper_bundle)))
		insert_item(used_item, user)
		return TRUE
	return ..() //Components attackby will handle refilling with paper and toner

/**Creates a clone of the specified item. Returns a list of cloned items. */
/obj/machinery/photocopier/proc/scan_item(var/obj/item/I)
	LAZYADD(., I.Clone())

/**Check if the amount of toner and paper are available */
/obj/machinery/photocopier/proc/has_enough_to_print(var/req_toner = TONER_USAGE_PAPER, var/req_paper = 1)
	return printer?.has_enough_to_print(req_toner, req_paper)

/obj/machinery/photocopier/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/empty/photocopier_paper_bin)
	LAZYADD(., /decl/interaction_handler/remove/photocopier_scanner_item)

////////////////////////////////////////////////////////////////////////////////////////
// Empty paper bin
////////////////////////////////////////////////////////////////////////////////////////
/decl/interaction_handler/empty/photocopier_paper_bin
	name = "Empty Paper Bin"
	expected_target_type = /obj/machinery/photocopier
	examine_desc         = "empty $TARGET_THEM$"

/decl/interaction_handler/empty/photocopier_paper_bin/is_possible(obj/machinery/photocopier/target, mob/user, obj/item/prop)
	return (target.printer?.get_amount_paper() > 0) && ..()

/decl/interaction_handler/empty/photocopier_paper_bin/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/machinery/photocopier/copier = target
	if(copier.printer?.get_amount_paper() <= 0)
		return
	var/obj/item/paper_bundle/B = copier.printer?.remove_paper(user)
	if(B)
		user.put_in_hands(B)
	target.update_icon()
	SSnano.update_uis(target)

////////////////////////////////////////////////////////////////////////////////////////
// Remove item from scanner
////////////////////////////////////////////////////////////////////////////////////////
/decl/interaction_handler/remove/photocopier_scanner_item
	name = "Remove Item From Scanner"
	expected_target_type = /obj/machinery/photocopier
	examine_desc         = "remove a loaded item"

/decl/interaction_handler/remove/photocopier_scanner_item/is_possible(obj/machinery/photocopier/target, mob/user, obj/item/prop)
	return target.scanner_item && ..()

/decl/interaction_handler/remove/photocopier_scanner_item/invoked(atom/target, mob/user, obj/item/prop)
	var/obj/machinery/photocopier/copier = target
	copier.eject_item(user)
