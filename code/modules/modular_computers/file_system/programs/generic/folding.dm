GLOBAL_LIST_INIT(science_strings, list(
	"Extruding Mesh Terrain", "Virtualizing Microprocessor",
	"Reticulating Splines", "Inserting Chaos Generator",
	"Reversing Polarity", "Unfolding Proteins",
	"Simulating Alien Abductions", "Scanning Pigeons",
	"Iterating Chaos Array", "Abstracting Supermatter",
	"Adjusting Social Network", "Recalculating Clown Principle"
))

#define MINIMUM_SCIENCE_INTERVAL 450
#define MAXIMUM_SCIENCE_INTERVAL 900
#define MINIMUM_FOLDING_EVENT_INTERVAL 50
#define MAXIMUM_FOLDING_EVENT_INTERVAL 100
#define SCIENCE_MONEY_PER_MINUTE 0.08 // So little money.

/datum/computer_file/program/folding
	filename = "fldng"
	filedesc = "FOLDING@SAPCE"
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
	var/crashed				= FALSE	// Program periodically needs a restart.
	var/crashed_at			= 0		// When the program crashed.

/datum/computer_file/program/folding/Topic(href, href_list)
	. = ..()
	if(.)
		return
	. = TOPIC_REFRESH

	if(href_list["fix_crash"] && crashed)
		current_interval += world.timeofday - crashed_at
		crashed = FALSE

	if(href_list["start"] && started_on == 0)
		started_on = world.timeofday
		current_interval = rand(MINIMUM_SCIENCE_INTERVAL, MAXIMUM_SCIENCE_INTERVAL) SECONDS
		next_event = (rand(MINIMUM_FOLDING_EVENT_INTERVAL, MAXIMUM_FOLDING_EVENT_INTERVAL) SECONDS) + world.timeofday

	if(href_list["collect"] && started_on > 0 && !crashed)
		if(started_on + current_interval > world.timeofday)
			return TOPIC_HANDLED // not ready to collect.
		var/obj/item/card/id/I = usr.GetIdCard()
		if(!I)
			to_chat(usr, SPAN_WARNING("Unable to locate ID card for transaction."))
			return TOPIC_HANDLED
		var/datum/money_account/account = get_account(I.associated_account_number)
		var/earned = current_interval * (SCIENCE_MONEY_PER_MINUTE * computer.get_processing_power())
		account.deposit(earned, "Completed FOLDING@SPACE project.")
		to_chat(usr, SPAN_NOTICE("Transferred [earned] to your account."))
		started_on = 0
		current_interval = 0

/datum/computer_file/program/folding/process_tick()
	. = ..()
	if(!started_on)
		return

	if(world.timeofday > next_event)
		return

	var/mob/living/holder = get_holder_of_type(computer, /mob/living/carbon/human)
	if(!crashed)
		if(holder)
			switch(rand(1,3))
				if(1)
					to_chat(holder, SPAN_WARNING("The [computer] starts to get very warm."))
				if(2)
					to_chat(holder, SPAN_WARNING("The [computer] gets scaldingly hot, burning you!"))
					holder.take_overall_damage(0, 0.45)
				if(3)
					to_chat(holder, SPAN_WARNING("The [computer] pings an error chime."))
					crashed = TRUE
					crashed_at = world.timeofday
		else
			crashed = TRUE
			crashed_at = world.timeofday

	next_event = (rand(MINIMUM_FOLDING_EVENT_INTERVAL, MAXIMUM_FOLDING_EVENT_INTERVAL) SECONDS) + world.timeofday

/datum/computer_file/program/folding/on_shutdown()
	started_on = 0
	current_interval = 0
	crashed = FALSE
	. = ..()

/datum/nano_module/program/folding
	name = "FOLDING@SPACE"

/datum/nano_module/program/folding/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/folding/prog = program
	if(!prog.computer)
		return
	data["computing"] = !!prog.started_on
	data["time_remaining"] = ((prog.started_on + prog.current_interval) - world.timeofday) / 10
	data["completed"] = prog.started_on + prog.current_interval <= world.timeofday
	data["crashed"] = prog.crashed
	data["science_string"] = pick(GLOB.science_strings)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "science_folding.tmpl", name, 300, 350, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
