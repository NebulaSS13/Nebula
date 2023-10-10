#define PRINTER_LOW_TONER_THRESHOLD 10 //Below this threshold we consider the toner to be low, and print lighter tones.

////////////////////////////////////////////////////////////////////////////////////////
// Printer Component
////////////////////////////////////////////////////////////////////////////////////////
/obj/item/stock_parts/printer
	name       = "printer"
	desc       = "A full fledged laser printer. This one is meant to be installed inside another machine. Comes with its own paper feeder and toner slot."
	icon       = 'icons/obj/items/stock_parts/modular_components.dmi'
	icon_state = "printer"
	randpixel  = 5
	w_class    = ITEM_SIZE_SMALL
	material   = /decl/material/solid/plastic
	matter     = list(
		/decl/material/solid/metal/steel  = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/fiberglass   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper = MATTER_AMOUNT_REINFORCEMENT,
	)
	base_type  = /obj/item/stock_parts/printer
	max_health = ITEM_HEALTH_NO_DAMAGE
	part_flags = PART_FLAG_QDEL
	var/list/print_queue               //Contains a single copy of each of the /obj/item/paper or /obj/item/photo that we'll print.
	var/obj/item/chems/toner_cartridge/toner //Contains our ink
	var/paper_left      = 0            //Amount of blank paper sheets left in the printer
	var/tmp/paper_max   = 100          //Maximum amount of blank paper sheets in the printer
	var/is_printing     = FALSE        //Whether we're currently running our print queue
	var/time_last_print = 0            //Time we last printed a sheet
	var/tmp/print_time  = 1 SECONDS    //Time it takes to print a sheet
	var/show_queue_ctrl = TRUE         //Whether the UI will display queue controls for the printer

	var/datum/callback/call_on_printed_page   //Callback called when we printed a page from the queue.
	var/datum/callback/call_on_finished_queue //Callback called when we finish printing all queued items.
	var/datum/callback/call_on_print_error    //Callback called when we run out of paper or toner, or something else interrupts printing.
	var/datum/callback/call_on_status_changed //Callback called when the status of the printer changes, and the owner ui should update.

//Buildable: Can be removed from the machine, and damaged
/obj/item/stock_parts/printer/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	max_health = 64

//Buildable + Filled variant: has sheet and toner on spawn
/obj/item/stock_parts/printer/buildable/filled/Initialize(ml, material_key)
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		make_full()

/obj/item/stock_parts/printer/proc/make_full()
	paper_left = paper_max
	toner      = new(src)

/obj/item/stock_parts/printer/Destroy()
	stop_printing_queue()
	QDEL_NULL_LIST(print_queue) //Since we don't drop those, we have to delete them
	QDEL_NULL(toner)
	unregister_on_printed_page()
	unregister_on_finished_queue()
	unregister_on_print_error()
	unregister_on_status_changed()
	return ..()

/obj/item/stock_parts/printer/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/chems/toner_cartridge))
		if(toner)
			to_chat(user, SPAN_WARNING("There is already \a [W] in \the [src]!"))
		else
			return insert_toner(W, user)

	else if((istype(W, /obj/item/paper) || istype(W, /obj/item/paper_bundle)))
		if(paper_left >= paper_max)
			to_chat(user, SPAN_WARNING("There is no more room for paper in \the [src]!"))
		else
			return insert_paper(W, user)
	. = ..()

/obj/item/stock_parts/printer/attack_hand(mob/user)
	if(toner && istype(loc, /obj/machinery) && user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return remove_toner(user)
	return ..()

/obj/item/stock_parts/printer/attack_self(mob/user)
	if(toner)
		return remove_toner(user)
	return ..()

/obj/item/stock_parts/printer/dump_contents()
	. = ..()
	LAZYREMOVE(., print_queue) //Don't drop our stored copies, those are gonna get deleted
	remove_paper() //Dump the blank paper we contain

/obj/item/stock_parts/printer/machine_process()
	if(!is_functional() || !has_enough_to_print() || (LAZYLEN(print_queue) <= 0))
		stop_printing_queue()
		return PROCESS_KILL

	//Process print queue
	if(world.timeofday > (time_last_print + print_time))
		//update queue
		print(print_queue[print_queue.len])
		print_queue.len--
		time_last_print = world.timeofday

//Since its hard to store all data from all kinds of printable things in a generic way, just create a copy and store it in us
/** Enqueue a job and make a copy of the paper, picture, bundle or text string or image that's passed into parameters. */
/obj/item/stock_parts/printer/proc/queue_job(var/obj/item/doc)
	if(istype(doc, /obj/item/paper))
		var/obj/item/paper/P = doc
		P = P.Clone()
		P.forceMove(src)
		LAZYADD(print_queue, P)

	else if(istype(doc, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/B = doc
		B = B.Clone()
		B.forceMove(src)
		LAZYADD(print_queue, B)

	else if(istype(doc, /obj/item/photo))
		var/obj/item/photo/Ph = doc
		Ph = Ph.Clone()
		Ph.forceMove(src)
		LAZYADD(print_queue, Ph)

	else if(istext(doc))
		var/obj/item/paper/P = new(src, null, doc)
		LAZYADD(print_queue, P)

	else if(istype(doc, /image))
		var/obj/item/photo/Ph = new(src, null, new /icon(doc))
		LAZYADD(print_queue, Ph)

	else
		CRASH("Invalid type '[doc]'([doc?.type]) was passed to printer!")

	if(call_on_status_changed)
		call_on_status_changed.InvokeAsync()
	return TRUE

/**Fully clears the job queue */
/obj/item/stock_parts/printer/proc/clear_job_queue()
	QDEL_NULL_LIST(print_queue)

/**Allow inserting a toner cartridge into the printer */
/obj/item/stock_parts/printer/proc/insert_toner(var/obj/item/chems/toner_cartridge/T, var/mob/user)
	if(toner)
		if(user)
			to_chat(user, SPAN_WARNING("There's already a cartridge in \the [src]."))
		return

	if(!user.try_unequip(T, src))
		return
	toner = T
	if(user)
		to_chat(user, SPAN_NOTICE("You install \a [T] in \the [src]."))
	if(call_on_status_changed)
		call_on_status_changed.InvokeAsync()
	return TRUE

/**Allow removing the toner cartridge from the printer */
/obj/item/stock_parts/printer/proc/remove_toner(var/mob/user)
	if(!toner)
		if(user)
			to_chat(user, SPAN_WARNING("There is no toner cartridge in \the [src]."))
		return

	if(user)
		user.put_in_hands(toner)
		to_chat(user, SPAN_NOTICE("You remove \the [toner] from \the [src]."))
	else
		toner.dropInto(get_turf(loc))
	toner = null
	if(call_on_status_changed)
		call_on_status_changed.InvokeAsync()
	return TRUE

/**Allow inserting either a blank paper or blank paper bundle into the printer. */
/obj/item/stock_parts/printer/proc/insert_paper(var/obj/item/paper_refill, var/mob/user)
	if(paper_left >= paper_max)
		if(user)
			to_chat(user, SPAN_WARNING("There is no room for more paper in \the [src]."))
		return

	if(istype(paper_refill, /obj/item/paper))
		var/obj/item/paper/P = paper_refill
		if(!P.is_blank())
			if(user)
				to_chat(user, SPAN_WARNING("\The [P] isn't blank!"))
			return
		if(!user?.try_unequip(paper_refill))
			return
		if(user)
			to_chat(user, SPAN_NOTICE("You insert \a [paper_refill] in \the [src]."))
		qdel(paper_refill)
		paper_left++

	else if(istype(paper_refill, /obj/item/paper_bundle))
		var/obj/item/paper_bundle/B = paper_refill
		if(!B.is_blank())
			if(user)
				to_chat(user, SPAN_WARNING("\The [B] contains some non-blank pages, or something else than paper sheets!"))
			return

		var/amt_papers = B.get_amount_papers()
		var/to_insert = min((paper_max - paper_left), amt_papers)
		if(user)
			to_chat(user, SPAN_NOTICE("You insert \a [paper_refill] in \the [src]."))
		if(to_insert >= amt_papers)
			if(user.try_unequip(B))
				qdel(B)
			else
				return
		else
			B.remove_sheets(to_insert, user)
		paper_left += to_insert

	if(call_on_status_changed)
		call_on_status_changed.InvokeAsync()
	return TRUE

/obj/item/stock_parts/printer/proc/remove_paper(var/mob/user)
	if(paper_left <= 0)
		if(user)
			to_chat(user, SPAN_WARNING("There are no sheets of paper in \the [src]."))
		return

	var/obj/item/paper_bundle/B = new
	while(paper_left > 0)
		B.merge(new /obj/item/paper)
		paper_left--

	if(user)
		user.put_in_hands(B)
		to_chat(user, SPAN_NOTICE("You grab all the paper sheets from \the [src]."))
	else
		B.dropInto(get_turf(loc))
	if(call_on_status_changed)
		call_on_status_changed.InvokeAsync()
	return B

/obj/item/stock_parts/printer/proc/has_enough_to_print(var/req_toner = 1, var/req_paper = 1)
	return (req_paper <= paper_left) && (req_toner <= (toner?.get_amount_toner()))

/obj/item/stock_parts/printer/proc/get_amount_paper()
	return paper_left

/obj/item/stock_parts/printer/proc/get_amount_paper_max()
	return paper_max

/obj/item/stock_parts/printer/proc/get_amount_toner()
	return toner? toner.get_amount_toner() : 0

/obj/item/stock_parts/printer/proc/get_amount_toner_max()
	return toner? toner.get_amount_toner_max() : 0

/obj/item/stock_parts/printer/proc/get_amount_queued()
	return length(print_queue)

/obj/item/stock_parts/printer/proc/is_printing()
	return is_printing

/obj/item/stock_parts/printer/proc/start_printing_queue()
	start_processing(loc)
	is_printing = TRUE
	if(call_on_status_changed)
		call_on_status_changed.InvokeAsync()

/obj/item/stock_parts/printer/proc/stop_printing_queue()
	stop_processing(loc)
	is_printing = FALSE

	if(LAZYLEN(print_queue) < 1 && call_on_finished_queue)
		call_on_finished_queue.InvokeAsync()
	else if(call_on_status_changed)
		call_on_status_changed.InvokeAsync()

/obj/item/stock_parts/printer/proc/print(var/obj/item/queued_element)
	if(istype(queued_element, /obj/item/photo))
		if(!has_enough_to_print(TONER_USAGE_PHOTO))
			var/obj/machinery/M = loc
			if(istype(M))
				M.state("Warning: Not enough paper or toner!")
			stop_printing_queue()
			return FALSE
		print_picture(queued_element)
	else
		if(!has_enough_to_print(TONER_USAGE_PAPER))
			var/obj/machinery/M = loc
			if(istype(M))
				M.state("Warning: Not enough paper or toner!")
			stop_printing_queue()
			return FALSE
		print_paper(queued_element)

	//#TODO: machinery should allow a component to trigger and wait for an animation sequence. So that we can drop out the paper in sync.
	queued_element.dropInto(get_turf(loc))
	playsound(loc, "sound/machines/dotprinter.ogg", 50, TRUE)
	return TRUE

/obj/item/stock_parts/printer/proc/print_picture(var/obj/item/photo/P)
	if(get_amount_toner() > PRINTER_LOW_TONER_THRESHOLD)	//plenty of toner, go straight greyscale
		P.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))//I'm not sure how expensive this is, but given the many limitations of photocopying, it shouldn't be an issue.
		P.update_icon()
	else			//not much toner left, lighten the photo
		P.img.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(100,100,100))
		P.update_icon()

	use_toner(TONER_USAGE_PHOTO, FALSE) //photos use a lot of ink!
	use_paper(1)

/obj/item/stock_parts/printer/proc/print_paper(var/obj/item/paper/P)
	//Apply a greyscale filter on all stamps overlays
	for(var/image/I in P.applied_stamps)
		I.filters += filter(type = "color", color = list(1,0,0, 0,0,0, 0,0,1), space = FILTER_COLOR_HSV)
	var/copied = P.info

	//#TODO: This is very janky, but too many things work this way in pencode to change it for now.
	//This basically just breaks the existing color tag, which we need to do because the innermost tag takes priority.
	copied = replacetext(copied, "<font face=\"[P.deffont]\" color=", "<font face=\"[P.deffont]\" nocolor=")
	copied = replacetext(copied, "<font face=\"[P.crayonfont]\" color=", "<font face=\"[P.crayonfont]\" nocolor=")

	P.set_content("<font color = [(get_amount_toner() > PRINTER_LOW_TONER_THRESHOLD)? "#101010" : "#808080"]>[copied]</font>")

	use_toner(TONER_USAGE_PAPER, FALSE)
	use_paper(1)

/obj/item/stock_parts/printer/proc/use_toner(var/amount, var/update_parent = TRUE)
	if(!toner?.use_toner(amount))
		return FALSE
	if(update_parent && call_on_status_changed)
		call_on_status_changed.InvokeAsync()
	return TRUE

/obj/item/stock_parts/printer/proc/use_paper(var/amount, var/update_parent = TRUE)
	if(paper_left <= 0)
		return FALSE
	paper_left -= amount
	if(update_parent && call_on_status_changed)
		call_on_status_changed.InvokeAsync()
	return TRUE

/obj/item/stock_parts/printer/proc/register_on_printed_page(var/datum/callback/cb)
	call_on_printed_page = cb
/obj/item/stock_parts/printer/proc/unregister_on_printed_page()
	QDEL_NULL(call_on_printed_page)

/obj/item/stock_parts/printer/proc/register_on_finished_queue(var/datum/callback/cb)
	call_on_finished_queue = cb
/obj/item/stock_parts/printer/proc/unregister_on_finished_queue()
	QDEL_NULL(call_on_finished_queue)

/obj/item/stock_parts/printer/proc/register_on_print_error(var/datum/callback/cb)
	call_on_print_error = cb
/obj/item/stock_parts/printer/proc/unregister_on_print_error()
	QDEL_NULL(call_on_print_error)

/obj/item/stock_parts/printer/proc/register_on_status_changed(var/datum/callback/cb)
	call_on_status_changed = cb
/obj/item/stock_parts/printer/proc/unregister_on_status_changed()
	QDEL_NULL(call_on_status_changed)

/obj/item/stock_parts/printer/on_install(obj/machinery/machine)
	unregister_on_printed_page()
	unregister_on_finished_queue()
	unregister_on_print_error()
	unregister_on_status_changed()
	. = ..()

/obj/item/stock_parts/printer/on_uninstall(obj/machinery/machine, temporary)
	. = ..()
	unregister_on_printed_page()
	unregister_on_finished_queue()
	unregister_on_print_error()
	unregister_on_status_changed()

/obj/item/stock_parts/printer/ui_data(mob/user, ui_key)
	. = ..()
	LAZYSET(., "toner",              get_amount_toner())
	LAZYSET(., "toner_max",          get_amount_toner_max())
	LAZYSET(., "paper_feeder",       get_amount_paper())
	LAZYSET(., "paper_feeder_max",   get_amount_paper_max())
	LAZYSET(., "is_printing",        is_printing())
	LAZYSET(., "is_functional",      is_functional())
	LAZYSET(., "left_printing",      get_amount_queued())
	LAZYSET(., "show_print_ctrl",    show_queue_ctrl)

/obj/item/stock_parts/printer/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(href_list["resume_print"])
		if(has_enough_to_print() && (get_amount_queued() > 0))
			start_printing_queue()
		else if(user)
			to_chat(user, SPAN_WARNING("\The [src] is out of paper or toner!"))
		. = TOPIC_REFRESH

	if(href_list["stop_print"])
		if(is_printing())
			stop_printing_queue()
		else if(user)
			to_chat(user, SPAN_WARNING("\The [src] is not currently printing!"))
		. = TOPIC_REFRESH

// Interactions
/decl/interaction_handler/empty/stock_parts_printer
	name = "Empty Paper Bin"
	expected_target_type = /obj/item/stock_parts/printer

/decl/interaction_handler/empty/stock_parts_printer/is_possible(obj/item/stock_parts/printer/target, mob/user, obj/item/prop)
	return (target.get_amount_paper() > 0) && ..()

/decl/interaction_handler/empty/stock_parts_printer/invoked(obj/item/stock_parts/printer/target, mob/user)
	if(target.get_amount_paper() <= 0)
		return
	var/obj/item/paper_bundle/B = target.remove_paper(user)
	if(B)
		user.put_in_hands(B)
	target.update_icon()
	SSnano.update_uis(target)

#undef PRINTER_LOW_TONER_THRESHOLD