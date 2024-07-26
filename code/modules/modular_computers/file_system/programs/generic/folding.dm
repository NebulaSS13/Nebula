#define MINIMUM_SCIENCE_INTERVAL 450
#define MAXIMUM_SCIENCE_INTERVAL 900
#define MINIMUM_FOLDING_EVENT_INTERVAL 50
#define MAXIMUM_FOLDING_EVENT_INTERVAL 100
#define SCIENCE_MONEY_PER_SECOND 0.08 // So little money.
#define PROGRAM_STATUS_CRASHED 0
#define PROGRAM_STATUS_RUNNING 1
#define PROGRAM_STATUS_RUNNING_WARM 2
#define PROGRAM_STATUS_RUNNING_SCALDING 3

/datum/computer_file/program/folding
	filename = "fldng"
	filedesc = "FOLDING@SPACE"
	extended_desc = "This program uses processor cycles for science, in exchange for money."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 6
	available_on_network = 1
	usage_flags = PROGRAM_ALL
	nanomodule_path = /datum/nano_module/program/folding
	category = PROG_UTIL
	requires_network = 1

	var/started_on 			= 0 	// When the program started some science.
	var/current_interval 	= 0		// How long the current interval will be.
	var/next_event 			= 0 	// in world timeofday, when the next event is scheduled to pop.
	var/program_status		= PROGRAM_STATUS_RUNNING		// Program periodically needs a restart, increases crash chance slightly over time.
	var/crashed_at			= 0		// When the program crashed.

/datum/computer_file/program/folding/Topic(href, href_list)
	. = ..()
	if(.)
		return
	. = TOPIC_REFRESH

	if(href_list["fix_crash"] && program_status == PROGRAM_STATUS_CRASHED)
		started_on += world.timeofday - crashed_at
		program_status = PROGRAM_STATUS_RUNNING

	if(href_list["start"] && started_on == 0)
		started_on = world.timeofday
		current_interval = rand(MINIMUM_SCIENCE_INTERVAL, MAXIMUM_SCIENCE_INTERVAL) SECONDS
		next_event = (rand(MINIMUM_FOLDING_EVENT_INTERVAL, MAXIMUM_FOLDING_EVENT_INTERVAL) SECONDS) + world.timeofday

	if(href_list["collect"] && started_on > 0 && program_status != PROGRAM_STATUS_CRASHED)
		if(started_on + current_interval > world.timeofday)
			return TOPIC_HANDLED // not ready to collect.
		var/obj/item/card/id/I = usr.GetIdCard()
		if(!istype(I))
			to_chat(usr, SPAN_WARNING("Unable to locate ID card for transaction."))
			return TOPIC_HANDLED
		var/datum/money_account/account = get_account(I.associated_account_number)
		if(!istype(account))
			to_chat(usr, SPAN_WARNING("Unable to locate account for deposit using account number #[I.associated_account_number || "NULL"]."))
			return TOPIC_HANDLED
		var/earned = (current_interval / 10) * (SCIENCE_MONEY_PER_SECOND * computer.get_processing_power()) //Divide by 10 to convert from ticks to seconds
		account.deposit(earned, "Completed FOLDING@SPACE project.")
		var/decl/currency/currency = GET_DECL(global.using_map.default_currency)
		to_chat(usr, SPAN_NOTICE("Transferred [currency.format_value(earned)] to your account."))
		started_on = 0
		current_interval = 0

/datum/computer_file/program/folding/process_tick() //Every 50-100 seconds, gives you a 1/3 chance of the program crashing.
	. = ..()
	if(!started_on)
		return

	if(world.timeofday < next_event) //Checks if it's time for the next crash chance.
		return
	var/mob/living/holder = computer.holder.get_recursive_loc_of_type(/mob/living/human)
	var/host = computer.get_physical_host()
	if(program_status > PROGRAM_STATUS_CRASHED)
		if(PROGRAM_STATUS_RUNNING_SCALDING >= program_status)
			switch(rand(PROGRAM_STATUS_RUNNING,program_status))
				if(PROGRAM_STATUS_RUNNING) //Guaranteed 1 tick without crashing.
					to_chat(holder, SPAN_WARNING("\The [host] starts to get very warm."))
					if (program_status == PROGRAM_STATUS_RUNNING)
						program_status = PROGRAM_STATUS_RUNNING_WARM
				if(PROGRAM_STATUS_RUNNING_WARM) //50% chance on subsequent ticks to make the program able to crash.
					to_chat(holder, SPAN_WARNING("\The [host] gets scaldingly hot, burning you!"))
					holder?.take_overall_damage(0, 0.45) //It checks holder? so that it doesn't cause a runtime error if no one is holding it.
					if (program_status == PROGRAM_STATUS_RUNNING_WARM)
						program_status = PROGRAM_STATUS_RUNNING_SCALDING
				if(PROGRAM_STATUS_RUNNING_SCALDING) //1/3 chance on all following ticks for the program to crash.
					to_chat(holder, SPAN_WARNING("\The [host] pings an error chime."))
					program_status = PROGRAM_STATUS_CRASHED
					crashed_at = world.timeofday
		else
			program_status = PROGRAM_STATUS_CRASHED
			crashed_at = world.timeofday

	next_event = (rand(MINIMUM_FOLDING_EVENT_INTERVAL, MAXIMUM_FOLDING_EVENT_INTERVAL) SECONDS) + world.timeofday //Sets the next crash chance 50-100 seconds from now

/datum/computer_file/program/folding/on_shutdown()
	started_on = 0
	current_interval = 0
	program_status = PROGRAM_STATUS_RUNNING
	. = ..()

/datum/nano_module/program/folding
	name = "FOLDING@SPACE"
	var/static/list/science_strings = list(
		"Extruding Mesh Terrain",
		"Virtualizing Microprocessor",
		"Reticulating Splines",
		"Inserting Chaos Generator",
		"Reversing Polarity",
		"Unfolding Proteins",
		"Simulating Alien Abductions",
		"Scanning Pigeons",
		"Iterating Chaos Array",
		"Abstracting Supermatter",
		"Adjusting Social Network",
		"Recalculating Clown Principle"
	)

/datum/nano_module/program/folding/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = global.default_topic_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/folding/prog = program
	if(!prog.computer)
		return
	data["computing"] = !!prog.started_on
	data["time_remaining"] = ((prog.started_on + prog.current_interval) - world.timeofday) / 10
	data["completed"] = prog.started_on + prog.current_interval <= world.timeofday
	data["crashed"] = (prog.program_status <= PROGRAM_STATUS_CRASHED)
	data["science_string"] = pick(science_strings)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "science_folding.tmpl", name, 300, 350, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
