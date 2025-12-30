#define FAX_QUICK_DIAL_FILE "quickdial"
#define FAX_HISTORY_FILE    "fax_history"
#define FAX_COOLDOWN        15 SECONDS    //Cooldown after sending a regular fax
#define FAX_ADMIN_COOLDOWN  30 SECONDS    //Cooldown after faxing an admin

var/global/list/allfaxes       = list()
var/global/list/adminfaxes     = list()	//cache for faxes that have been sent to admins

////////////////////////////////////////////////////////////////////////////////////////
// Fax Machine Board
////////////////////////////////////////////////////////////////////////////////////////
/obj/item/stock_parts/circuitboard/fax_machine
	name = "circuitboard (fax machine)"
	build_path = /obj/machinery/faxmachine
	board_type = "machine"
	origin_tech = @'{"engineering":1, "programming":1}'
	req_components = list(
		/obj/item/stock_parts/printer         = 1,
		/obj/item/stock_parts/manipulator     = 1,
		/obj/item/stock_parts/scanning_module = 1,
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/console_screen        = 1,
		/obj/item/stock_parts/keyboard              = 1,
		/obj/item/stock_parts/power/apc/buildable   = 1,
		/obj/item/stock_parts/computer/lan_port     = 1,
		/obj/item/stock_parts/computer/network_card = 1,
		/obj/item/stock_parts/item_holder/disk_reader/buildable = 1,
		/obj/item/stock_parts/item_holder/card_reader/buildable = 1,
		/obj/item/stock_parts/access_lock/buildable = 1,
	)

////////////////////////////////////////////////////////////////////////////////////////
// Fax Machine Network Device
////////////////////////////////////////////////////////////////////////////////////////
/datum/extension/network_device/fax
	has_commands = TRUE
	long_range   = TRUE

////////////////////////////////////////////////////////////////////////////////////////
// Fax Machine
////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/faxmachine
	name                    = "fax machine"
	icon                    = 'icons/obj/machines/fax_machine.dmi'
	icon_state              = "fax"
	anchored                = TRUE
	density                 = TRUE
	idle_power_usage        = 30
	active_power_usage      = 200
	base_type               = /obj/machinery/faxmachine
	construct_state         = /decl/machine_construction/default/panel_closed
	maximum_component_parts = list(
		/obj/item/stock_parts/item_holder/disk_reader = 1,
		/obj/item/stock_parts/item_holder/card_reader = 1,
		/obj/item/stock_parts/printer     = 1,
		/obj/item/stock_parts             = 15,
	)
	stock_part_presets = list(
		/decl/stock_part_preset/access_lock, //Empty access list
	)
	uncreated_component_parts = null
	public_methods = list(
		/decl/public_access/public_method/fax_receive_document,
	)
	var/obj/item/stock_parts/item_holder/disk_reader/disk_reader  //Cached ref to the disk_reader component. Used for handling data disks.
	var/obj/item/stock_parts/item_holder/card_reader/card_reader  //Cached ref to the card_reader component. Used for scanning a user's id card.
	var/obj/item/stock_parts/printer/printer          //Cached ref to the printer component. Used for printing things.
	var/obj/item/scanner_item                         //Item to fax
	var/list/quick_dial                              //List of name tag to network ids for other fax machines that the user added as quick dial options
	var/list/fax_history                             //List of the last 10 devices that sent us faxes, and when
	var/tmp/init_network_tag                         //The network tag of this fax machine, set by mappers.

	var/tmp/time_cooldown_end = 0
	var/tmp/current_page      = "main"
	var/tmp/dest_uri                   //The currently set destination URI for the target machine. Format is "[network_tag].[network_id]"

/obj/machinery/faxmachine/Initialize(mapload, d=0, populate_parts = TRUE)
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		global.allfaxes += src
		var/datum/extension/network_device/fax/netdevice = set_extension(src, /datum/extension/network_device/fax)
		if(init_network_tag)
			netdevice.set_network_tag(init_network_tag)
		if(populate_parts && printer)
			printer.make_full()

/obj/machinery/faxmachine/Destroy()
	global.allfaxes -= src
	disk_reader = null
	card_reader = null
	printer = null
	scanner_item = null
	. = ..()

/obj/machinery/faxmachine/on_update_icon()
	if(!QDELETED(scanner_item))
		icon_state = "faxpaper" //not using an overlay, because animations
	else
		icon_state = initial(icon_state)

/obj/machinery/faxmachine/RefreshParts()
	. = ..()
	disk_reader = get_component_of_type(/obj/item/stock_parts/item_holder/disk_reader)
	card_reader = get_component_of_type(/obj/item/stock_parts/item_holder/card_reader)
	printer     = get_component_of_type(/obj/item/stock_parts/printer)

	if(disk_reader)
		disk_reader.register_on_insert(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/faxmachine, on_insert_disk)))
		disk_reader.register_on_eject( CALLBACK(src, TYPE_PROC_REF(/obj/machinery/faxmachine, update_ui)))

	if(card_reader)
		card_reader.register_on_insert(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/faxmachine, on_insert_card)))
		card_reader.register_on_eject( CALLBACK(src, TYPE_PROC_REF(/obj/machinery/faxmachine, update_ui)))

	if(printer)
		printer.register_on_printed_page(  CALLBACK(src, TYPE_PROC_REF(/obj/machinery/faxmachine, on_printed_page)))
		printer.register_on_finished_queue(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/faxmachine, on_queue_finished)))
		printer.register_on_print_error(   CALLBACK(src, TYPE_PROC_REF(/obj/machinery/faxmachine, on_print_error)))
		printer.register_on_status_changed(CALLBACK(src, TYPE_PROC_REF(/obj/machinery/faxmachine, update_ui)))

/obj/machinery/faxmachine/interface_interact(mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/faxmachine/attackby(obj/item/used_item, mob/user)
	if(istype(construct_state, /decl/machine_construction/default/panel_closed))
		if(istype(used_item, /obj/item/paper) || istype(used_item, /obj/item/photo) || istype(used_item, /obj/item/paper_bundle))
			insert_scanner_item(used_item, user)
			return TRUE
	. = ..()

/obj/machinery/faxmachine/ui_data(mob/user, ui_key)
	. = ..()
	var/datum/extension/network_device/fax/net = get_extension(src, /datum/extension/network_device)
	LAZYADD(., net.ui_data(user)) //Grab some of the network data stuff

	//Convert the list to something we can use in the nanoui
	var/list/uiqd
	for(var/key in quick_dial)
		var/list/element = list("key" = key, "value" = quick_dial[key])
		LAZYADD(uiqd, list(element))

	LAZYSET(., "quick_dial_targets", uiqd)
	LAZYSET(., "fax_history",        fax_history)
	LAZYSET(., "scanner_item",       "[!QDELETED(scanner_item)? scanner_item : ""]")
	LAZYSET(., "is_cooling_down",    (time_cooldown_end > world.timeofday))
	LAZYSET(., "dest_uri",           dest_uri)
	LAZYSET(., "src",                "\ref[src]")
	LAZYSET(., "emagged",            emagged)
	LAZYSET(., "is_operational",     operable())
	LAZYSET(., "page",               current_page)

	//Printer stuff
	if(printer)
		LAZYADD(., printer.ui_data(user))

	//Card reader stuff
	var/obj/item/card/C = card_reader?.get_inserted()
	LAZYSET(., "has_card_reader",  !isnull(card_reader))
	LAZYSET(., "id_card",          C)
	LAZYSET(., "data_card",        card_reader?.get_data_card())
	if(C)
		var/info = C.name
		if(istype(C, /obj/item/card/id))
			var/obj/item/card/id/ID = C
			info = ID.get_display_name()
		LAZYSET(., "id_card_info", info)

	//Disk stuff
	var/obj/item/disk/D = disk_reader?.get_inserted()
	LAZYSET(., "has_disk_drive",   !isnull(disk_reader))
	LAZYSET(., "disk",             D)
	LAZYSET(., "disk_name",        D?.name)

/obj/machinery/faxmachine/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, datum/nanoui/master_ui, datum/topic_state/state)
	var/list/data = ui_data(user, ui_key)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "fax_machine.tmpl", name, 640, 480)
		ui.add_template("net_shared",                 "network_shared.tmpl") //Shared network UI stuff
		ui.add_template("stock_parts_printer_shared", "stock_parts_printer.tmpl")
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/faxmachine/DefaultTopicState()
	return global.physical_topic_state

/obj/machinery/faxmachine/OnTopic(mob/user, list/href_list, datum/topic_state/state)
	if(!CanInteract(user, state))
		to_chat(user, SPAN_WARNING("You must be close to \the [src] to do this!"))
		return TOPIC_NOACTION

	if(href_list["change_page"])
		var/pagename = href_list["change_page"]
		current_page = pagename
		return TOPIC_REFRESH

	if(href_list["network_settings"])
		var/datum/extension/network_device/fax/net = get_extension(src, /datum/extension/network_device)
		net.ui_interact(user)
		return TOPIC_REFRESH

	// --- Sending Fax ---
	if(href_list["send"])
		if(QDELETED(scanner_item))
			to_chat(user, SPAN_WARNING("You must insert something to send first!"))
			return TOPIC_NOACTION
		if(world.timeofday < time_cooldown_end)
			to_chat(user, SPAN_WARNING("\The [src] isn't ready yet for sending again! [max(0, time_cooldown_end - world.timeofday) / (1 SECOND)] second\s left."))
			return TOPIC_REFRESH

		//Prioritize the quick dial value
		dest_uri = replacetext(sanitize(href_list["quick_dial"], encode = FALSE), " ", "_")
		if(!length(dest_uri))
			dest_uri = replacetext(sanitize(href_list["network_uri"], encode = FALSE), " ", "_")
		if(!length(dest_uri))
			to_chat(user, SPAN_WARNING("You must specify a destination!"))
			return TOPIC_NOACTION

		var/list/parsed = parse_network_uri(dest_uri)
		if(!length(parsed))
			to_chat(user, SPAN_WARNING("Bad target URI!"))
			return TOPIC_NOACTION
		send_fax(user, parsed["network_tag"], parsed["network_id"])
		return TOPIC_REFRESH

	// --- Insert/Eject ---
	if(href_list["id_card"])
		if(card_reader)
			var/obj/item/card/C = card_reader.get_inserted()
			if(C)
				eject_card(user)
			else
				var/obj/item/card/id/ID = user.get_active_held_item()
				if(!istype(ID) && !istype(ID, /obj/item/card/data))
					to_chat(user, SPAN_WARNING("You need to hold a valid id/data card!"))
				else if(card_reader.should_swipe)
					to_chat(user, SPAN_WARNING("\The [card_reader] is currently set to swipe mode, which is unsupported by this machine. Please contact your system administrator."))
				else
					card_reader.insert_item(ID, user)
		else
			to_chat(user, SPAN_WARNING("The card reader is not responding!"))
			return TOPIC_NOACTION
		return TOPIC_REFRESH

	if(href_list["insert_item"])
		if(!QDELETED(scanner_item))
			to_chat(user, SPAN_WARNING("There's already a [scanner_item] in \the [src]!"))
			return TOPIC_NOACTION
		else
			var/obj/item/thing = user.get_active_held_item()
			if(thing)
				insert_scanner_item(thing, user)
			else
				to_chat(user, SPAN_WARNING("You're not holding anything!"))
				return TOPIC_NOACTION
			return TOPIC_REFRESH

	if(href_list["remove_item"])
		eject_scanner_item(user)
		return TOPIC_REFRESH

	//Handle extra disk ops here
	if(disk_reader && (OnTopic_DiskOps(user, href_list, state) != TOPIC_NOACTION))
		return TOPIC_REFRESH

	if(printer?.OnTopic(user, href_list, state) != TOPIC_NOACTION)
		return TOPIC_REFRESH

/**Handle disk operations topics. */
/obj/machinery/faxmachine/proc/OnTopic_DiskOps(mob/user, list/href_list, datum/topic_state/state)
	if(href_list["insert_disk"])
		if(!disk_reader)
			to_chat(user, SPAN_WARNING("There is no disk drive installed on \the [src]!"))
			return TOPIC_NOACTION
		var/obj/item/disk/D = user.get_active_held_item()
		if(!istype(D))
			to_chat(user, SPAN_WARNING("You need to hold a valid data disk!"))
			return TOPIC_NOACTION
		else
			disk_reader.insert_item(D, user)
		return TOPIC_REFRESH

	if(href_list["eject_disk"])
		eject_disk(user)
		return TOPIC_REFRESH

	// --- Quick Dial Operations  ---
	if(href_list["add_qd"])
		var/qduri = uppertext(replacetext(sanitize(href_list["network_uri"], encode = FALSE), " ", "_"))
		if(!length(qduri))
			to_chat(user, SPAN_WARNING("Please specify a destination URI!"))
			return TOPIC_NOACTION

		var/inputname = input(user, "Name for the new quick dial contact?", "New quick dial contact")
		if(length(inputname) && CanPhysicallyInteract(user))
			add_quick_dial_contact(sanitize_name(inputname, MAX_NAME_LEN, TRUE, TRUE), qduri, user)
		return TOPIC_REFRESH

	if(href_list["rem_qd"])
		var/qduri = uppertext(replacetext(sanitize(href_list["quick_dial"], encode = FALSE), " ", "_"))
		var/qdname
		for(var/key in quick_dial)
			if(quick_dial[key] == qduri)
				qdname = key
				break
		rem_quick_dial_contact(qdname, user)
		return TOPIC_REFRESH
	return TOPIC_NOACTION

/**Returns the inserted card if there is a reader and if there is a card. Otherwise print a warning to the user, if a user was passed */
/obj/machinery/faxmachine/proc/try_get_card(var/mob/user)
	var/obj/item/card/C = card_reader?.get_inserted()
	if(!card_reader)
		if(user)
			to_chat(user, SPAN_WARNING("There is no card reader!"))
		return
	else if(!C)
		if(user)
			to_chat(user, SPAN_WARNING("There is no card in \the [card_reader]!"))
		return
	return C

/**Warn the user if the disk cannot be accessed. Otherwise returns the disk in the disk reader. */
/obj/machinery/faxmachine/proc/try_get_disk(var/mob/user)
	var/obj/item/disk/D = disk_reader?.get_inserted()
	if(!disk_reader)
		if(user)
			to_chat(user, SPAN_WARNING("There is no disk drive!"))
		return
	else if(!D)
		if(user)
			to_chat(user, SPAN_WARNING("There is no disk in \the [disk_reader]!"))
		return
	return D

/obj/machinery/faxmachine/proc/insert_scanner_item(var/obj/item/thing, var/mob/user)
	if(!QDELETED(scanner_item))
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] already has something being scanned!"))
		return FALSE

	if(user)
		to_chat(user, SPAN_NOTICE("You place \the [thing] into \the [src]'s scanner."))
		if(!user.try_unequip(thing, src))
			return FALSE
	else
		thing.dropInto(src)
	scanner_item = thing
	update_ui()
	return TRUE

/obj/machinery/faxmachine/proc/eject_scanner_item(var/mob/user)
	if(QDELETED(scanner_item))
		if(user)
			to_chat(user, SPAN_WARNING("There's nothing to eject from \the [src]."))
		return FALSE

	if(user)
		to_chat(user, SPAN_NOTICE("You eject \the [scanner_item] from \the [src]."))
		user.put_in_hands(scanner_item)
	else
		scanner_item.dropInto(get_turf(src))
	scanner_item = null
	update_ui()
	return TRUE

/obj/machinery/faxmachine/proc/on_insert_card(var/obj/item/card/C, var/mob/user)
	if(card_reader.should_swipe) //We don't support swiping
		if(user)
			to_chat(user, SPAN_WARNING("\The [card_reader] is currently set to swipe mode, which is unsupported by this machine. Please contact your system administrator."))
		return
	if(user)
		to_chat(user, SPAN_NOTICE("You insert \the [C] into \the [src]."))
	update_ui()

/obj/machinery/faxmachine/proc/eject_card(var/mob/user)
	if(!card_reader)
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] has no card reader installed."))
		return FALSE
	card_reader.eject_item(user)
	update_ui()
	return TRUE

/obj/machinery/faxmachine/proc/on_insert_disk(var/obj/item/disk/D, var/mob/user)
	//Read any existing disk data
	var/datum/computer_file/data/qdfile = D.read_file(FAX_QUICK_DIAL_FILE)
	if(qdfile)
		quick_dial = json_decode(qdfile.stored_data)

	var/datum/computer_file/data/histfile = D.read_file(FAX_HISTORY_FILE)
	if(histfile)
		fax_history = json_decode(histfile.stored_data)
	update_ui()

/obj/machinery/faxmachine/proc/eject_disk(var/mob/user)
	if(!disk_reader)
		to_chat(user, SPAN_WARNING("\The [src] has no disk drive installed."))
		return FALSE
	disk_reader.eject_item(user)
	LAZYCLEARLIST(quick_dial)
	LAZYCLEARLIST(fax_history)
	update_ui()
	return TRUE

/obj/machinery/faxmachine/proc/send_fax(var/mob/user, var/target_net_tag, var/target_net_id)
	if(QDELETED(scanner_item))
		to_chat(user, SPAN_WARNING("You need to insert something to fax first!"))
		return FALSE
	if(inoperable())
		return FALSE
	if(world.timeofday < time_cooldown_end)
		to_chat(user, SPAN_WARNING("Cannot send while busy! [max(0, world.timeofday - time_cooldown_end) / (1 SECOND)] second\s remaining."))
		return FALSE

	//Try to get enough power
	if(can_use_power_oneoff(active_power_usage) > 0)
		return FALSE
	use_power_oneoff(active_power_usage)

	var/obj/item/card/id/ID = try_get_card()
	ID = istype(ID)? ID : null

	//Grab our network
	var/datum/extension/network_device/sender_dev = get_extension(src, /datum/extension/network_device)
	var/datum/computer_network/origin_network = sender_dev?.get_network()
	if(!origin_network)
		to_chat(user, SPAN_WARNING("No network connection!"))
		return FALSE

	//If sending to admins, don't try to get a target network or device
	var/target_URI = uppertext("[target_net_tag].[target_net_id]")
	var/list/target_admin_fax = LAZYACCESS(global.using_map.map_admin_faxes, target_URI)
	if(target_admin_fax)
		var/list/fax_req_access = target_admin_fax["access"]
		if(!emagged)
			if(!has_access(req_access, ID?.GetAccess()))
				to_chat(user, SPAN_WARNING("You do not have the right credentials to use the send function on this device!"))
				return FALSE
			if(!has_access(fax_req_access, ID?.GetAccess()))
				to_chat(user, SPAN_WARNING("You do not have the right credentials to send a fax to this recipient!"))
				return FALSE
		else if(prob(1))
			spark_at(src, 1)

		. = send_fax_to_admin(user, scanner_item, target_URI, src)
		log_history("Outgoing", "'[scanner_item]', from '[get_area(src)]'s [src]' @ '[sender_dev?.get_network_URI() || "UNKNOWN SENDER"]' to [target_admin_fax["name"]]' @ '[target_URI]'.")
		update_ui()
		flick("faxsend", src)
		//#TODO: sync the animation, sound and message together when I got enough patience.
		playsound(src, 'sound/machines/fax_send.ogg', 30, FALSE, 0, 4)
		ping("Message transmitted successfully!")
		time_cooldown_end = world.timeofday + FAX_ADMIN_COOLDOWN
		return TRUE

	if(!length(target_net_id))
		target_net_id = origin_network.network_id //Use the current network if none specified

	if((target_net_id != origin_network.network_id) && !sender_dev.has_internet_connection(origin_network))
		to_chat(user, SPAN_WARNING("No internet connection!"))
		return FALSE

	var/datum/computer_network/target_net
	if(target_net_id != origin_network.network_id)
		target_net = origin_network.get_internet_connection(target_net_id)
	else
		target_net = origin_network

	if(!target_net)
		to_chat(user, SPAN_WARNING("No such network '[target_net_id]'!"))
		return FALSE

	var/datum/extension/network_device/fax/target_dev = target_net.get_device_by_tag(target_net_tag)
	if(!target_dev)
		to_chat(user, SPAN_WARNING("No such devices '[target_net_tag]'!"))
		return FALSE
	if(!istype(target_dev) || !target_dev.has_commands)
		to_chat(user, SPAN_WARNING("Invalid target device '[target_net_tag]'!"))
		return FALSE
	var/obj/machinery/target = target_dev.holder
	if(!target)
		CRASH("There is a network_device extension without a holder!")

	//Authenticate as needed
	if(!emagged)
		if(!has_access(req_access, ID?.GetAccess()))
			to_chat(user, SPAN_WARNING("You do not have the right credentials to use the send function on this device!"))
			return FALSE
		if(!has_access(target.req_access, ID?.GetAccess()))
			to_chat(user, SPAN_WARNING("You do not have the right credentials to send a fax to this recipient!"))
			return FALSE
	else if(prob(1))
		spark_at(src, 1)

	//Setup cooldown
	time_cooldown_end = world.timeofday + FAX_COOLDOWN

	//Call receive on the target machine
	var/decl/public_access/public_method/send_method = GET_DECL(/decl/public_access/public_method/fax_receive_document)
	if(send_method.perform(target, scanner_item.Clone(), "[get_area(src)]'s [src]", sender_dev.get_network_URI()))
		log_history("Outgoing", "'[scanner_item]', from '[get_area(src)]'s [src]' @ '[sender_dev.get_network_URI()]' to '[get_area(target)]'s [target]' @ '[target_dev.get_network_URI()]'.")
		//#TODO: sync the animation, sound and message together when I got enough patience.
		ping("Message transmitted successfully.")
		playsound(src, 'sound/machines/fax_send.ogg', 30, FALSE, 0, 4)
		update_ui()
		flick("faxsend", src)
		return TRUE
	else if(target.inoperable())
		buzz("Error transmitting message, receiving machine won't reply.")
	else
		buzz("Error transmitting message.")
	return FALSE

/**Handles queuing any received fax message in the printer queue, and starts the printer if needed. */
/obj/machinery/faxmachine/proc/receive_fax(var/obj/item/incoming, var/source_name = "unknown", var/source_URI = "unknown.unknown")
	if(inoperable())
		return FALSE

	//Try to get enough power
	if(can_use_power_oneoff(active_power_usage) > 0)
		return FALSE

	printer?.queue_job(incoming) //Add it to the printer queue so we don't lose it on failure
	if(printer?.is_printing())
		return TRUE //Don't do anything extra if we're already printing

	if(!printer?.has_enough_to_print())
		buzz("Error while printing, not enough toner or paper to print the received message! Please refill, and resume printing!")
		return FALSE

	//Tell the printer to do its job
	printer.start_printing_queue()
	use_power_oneoff(active_power_usage)
	var/datum/extension/network_device/fax/ND = get_extension(src, /datum/extension/network_device)
	log_history("Incoming", "'[incoming]', from '[source_name]'@'[source_URI]' to '[get_area(src)]'s [src]'@'[ND.get_network_URI()]'.")
	return TRUE

/**Cause the nanoui to update, also updates the icon of the machine. */
/obj/machinery/faxmachine/proc/update_ui()
	SSnano.update_uis(src)
	update_icon()

/**Plays print animation async. */
/obj/machinery/faxmachine/proc/on_printed_page()
	flick("faxreceive", src)

/**Tells the user we just printed the last page of the queue, and do the print anim. */
/obj/machinery/faxmachine/proc/on_queue_finished()
	if(QDELETED(src))
		return
	state("Printing tasks complete!")
	on_printed_page()

/**Warn the user that something interrupted printing. */
/obj/machinery/faxmachine/proc/on_print_error()
	if(!printer?.has_enough_to_print())
		buzz("Error while printing, not enough toner or paper to print the received message! Please refill, and resume printing!")
	else
		buzz("Error while printing!")

/obj/machinery/faxmachine/proc/log_history(var/operation, var/text)
	LAZYADD(fax_history, "[stationdate2text()], [stationtime2text()]: [operation] - [text]")
	var/obj/item/disk/D = disk_reader?.get_inserted()
	if(!D)
		return
	var/datum/computer_file/data/hist = new
	hist.stored_data = json_encode(fax_history)
	D.write_file(hist, FAX_HISTORY_FILE)

/obj/machinery/faxmachine/proc/add_quick_dial_contact(var/contact_name, var/contact_URI, var/mob/user)
	if(!length(contact_URI))
		if(user)
			to_chat(user, SPAN_WARNING("Please specify a destination URI!"))
		return FALSE

	if(!length(contact_name))
		if(user)
			to_chat(user, SPAN_WARNING("Please specify a valid name for the contact!"))
		return FALSE
	LAZYSET(quick_dial, contact_name, contact_URI)

	//Overwrite quick dial
	var/obj/item/disk/D = try_get_disk()
	if(D)
		var/datum/computer_file/data/datfile = new
		datfile.stored_data = json_encode(quick_dial)
		D.write_file(datfile, FAX_QUICK_DIAL_FILE)

	if(user)
		to_chat(user, SPAN_NOTICE("New contact '[contact_name]' with URI '[contact_URI]' added successfully!"))
	update_ui()
	return TRUE

/obj/machinery/faxmachine/proc/rem_quick_dial_contact(var/contact_name, var/mob/user)
	if(!length(contact_name))
		if(user)
			to_chat(user, SPAN_WARNING("Please select a contact to remove!"))
		return FALSE

	var/remove_uri = LAZYACCESS(quick_dial, contact_name)
	LAZYREMOVE(quick_dial, contact_name)

	//Overwrite quick dial
	var/obj/item/disk/D = try_get_disk()
	if(D)
		var/datum/computer_file/data/datfile = new
		datfile.stored_data = json_encode(quick_dial)
		D.write_file(datfile, FAX_QUICK_DIAL_FILE)

	if(user)
		to_chat(user, SPAN_NOTICE("Successfully removed contact '[contact_name]' with URI '[remove_uri]'!"))
	update_ui()
	return TRUE

////////////////////////////////////////////////////////////////////////////////////////
// Public Methods
////////////////////////////////////////////////////////////////////////////////////////
/decl/public_access/public_method/fax_receive_document
	name = "Send Fax Message"
	desc = "Sends the specified document over to the specified network tag."
	call_proc = TYPE_PROC_REF(/obj/machinery/faxmachine, receive_fax)
	forward_args = TRUE

////////////////////////////////////////////////////////////////////////////////////////
// Admin Faxes Handling
////////////////////////////////////////////////////////////////////////////////////////

/**Helper for sending a fax from a fax machine to an admin destination. */
/proc/send_fax_to_admin(var/mob/sender, var/obj/item/doc, var/network_URI, var/obj/machinery/faxmachine/source_fax)
	var/obj/item/rcvdcopy = doc.Clone()
	if(!rcvdcopy)
		return
	rcvdcopy.forceMove(null)
	LAZYADD(global.adminfaxes, rcvdcopy)

	var/list/fax_details  = LAZYACCESS(global.using_map?.map_admin_faxes, network_URI)
	var/dest_display_name = LAZYACCESS(fax_details, "name") || network_URI
	var/font_colour       = LAZYACCESS(fax_details, "color") || "#006100"
	var/faxname           = "[uppertext(dest_display_name)] FAX"
	var/reply_type        = dest_display_name

	if(!(network_URI in global.using_map.map_admin_faxes))
		reply_type = "UNKNOWN"

	var/msg = "<span class='notice'><b><font color='[font_colour]'>[faxname]: </font>[get_options_bar(sender, 2,1,1)]"
	msg += "(<A HREF='byond://?_src_=holder;take_ic=\ref[sender]'>TAKE</a>) (<a href='byond://?_src_=holder;FaxReply=\ref[sender];originfax=\ref[source_fax];replyorigin=[reply_type]'>REPLY</a>)</b>: "
	msg += "Receiving '[rcvdcopy.name]' via secure connection ... <a href='byond://?_src_=holder;AdminFaxView=\ref[rcvdcopy]'>view message</a></span>"

	if (istype(doc, /obj/item/paper))
		var/obj/item/paper/paper = doc
		SSwebhooks.send(WEBHOOK_FAX_SENT, list("title" = "Incoming fax transmission from [sender] in [faxname] for [dest_display_name].", "body" = "[paper.info]"))

	for(var/client/C in global.admins)
		if(check_rights((R_ADMIN|R_MOD),0,C))
			to_chat(C, msg)
			sound_to(C, 'sound/machines/dotprinter.ogg')
	return TRUE

#undef FAX_QUICK_DIAL_FILE
#undef FAX_HISTORY_FILE
#undef FAX_COOLDOWN
#undef FAX_ADMIN_COOLDOWN

/obj/machinery/faxmachine/mapped/Initialize()
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		return INITIALIZE_HINT_LATELOAD

/obj/machinery/faxmachine/mapped/LateInitialize()
	..()
	// Pre-populate our admin targets.
	if(!disk_reader)
		CRASH("Missing disk reader from pre-mapped fax machine!")
	if(!disk_reader.disk)
		disk_reader.insert_item(new /obj/item/disk(disk_reader))
	for(var/uri in global.using_map.map_admin_faxes)
		var/list/contact_info = global.using_map.map_admin_faxes[uri]
		add_quick_dial_contact(contact_info["name"], uri)
