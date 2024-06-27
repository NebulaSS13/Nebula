// Direct powernet connection via terminal machinery.
// Note that this isn't for the terminal itself, which is an auxiliary entity; it's for whatever is connected to it.
/obj/item/stock_parts/power/terminal
	name = "wired connection"
	desc = "A power connection directly to the grid, via power cables."
	icon_state = "terminal"
	priority = 2
	var/obj/machinery/power/terminal/terminal
	var/terminal_dir = 0

/obj/item/stock_parts/power/terminal/on_uninstall(var/obj/machinery/machine)
	if(status & PART_STAT_ACTIVE)
		machine.update_power_channel(cached_channel)
		unset_status(machine, PART_STAT_ACTIVE)
	qdel(terminal) // Will call unset_terminal().
	..()

/obj/item/stock_parts/power/terminal/Destroy()
	qdel(terminal)
	. = ..()

/obj/item/stock_parts/power/terminal/machine_process(var/obj/machinery/machine)

	if(!terminal) //Terminal is gone, give up
		if(status & PART_STAT_ACTIVE)
			machine.update_power_channel(cached_channel)
			machine.power_change()
		return

	var/surplus = terminal.surplus()
	var/usage = machine.get_power_usage()

	if((machine.stat & NOPOWER) && surplus > usage)
		machine.power_change()
		return // This suggests that we should be powering the machine instead, so let's try that

	if(status & PART_STAT_ACTIVE)
		terminal.draw_power(usage)
		if(surplus >= usage)
			return // had enough power and good to go.
		else
			// Try and use other (local) sources of power to make up for the deficit.
			var/deficit = machine.use_power_oneoff(usage - surplus)
			if(deficit > 0)
				machine.update_power_channel(cached_channel)
				machine.power_change()

//Is willing to provide power if the wired contribution is nonnegligible and there is enough total local power to run the machine.
/obj/item/stock_parts/power/terminal/can_provide_power(var/obj/machinery/machine)
	if(is_functional() && terminal && terminal.surplus() && machine.can_use_power_oneoff(machine.get_power_usage(), LOCAL) <= 0)
		set_status(machine, PART_STAT_ACTIVE)
		machine.update_power_channel(LOCAL)
		return TRUE
	return FALSE

/obj/item/stock_parts/power/terminal/can_use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	. = 0
	if(terminal && channel == LOCAL)
		return min(terminal.surplus(), amount)

/obj/item/stock_parts/power/terminal/use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	. = 0
	if(terminal && channel == LOCAL)
		return terminal.draw_power(amount)

/obj/item/stock_parts/power/terminal/not_needed(var/obj/machinery/machine)
	unset_status(machine, PART_STAT_ACTIVE)

/obj/item/stock_parts/power/terminal/proc/set_terminal(var/obj/machinery/machine, var/obj/machinery/power/new_terminal)
	if(terminal)
		unset_terminal(machine, terminal)
	terminal = new_terminal
	terminal.master = src

	events_repository.register(/decl/observ/destroyed, terminal, src, PROC_REF(unset_terminal))
	terminal.queue_icon_update()

	set_extension(src, /datum/extension/event_registration/shuttle_stationary, GET_DECL(/decl/observ/moved), machine, PROC_REF(machine_moved), get_area(src))
	set_status(machine, PART_STAT_CONNECTED)
	start_processing(machine)

/obj/item/stock_parts/power/terminal/proc/machine_moved(var/obj/machinery/machine, var/turf/old_loc, var/turf/new_loc)
	if(!terminal)
		events_repository.unregister(/decl/observ/moved, machine, src, PROC_REF(machine_moved))
		return
	if(istype(new_loc) && (terminal.loc == get_step(new_loc, terminal_dir)))
		return     // This location is fine
	// TODO: disconnect and drop the terminal as an item instead of deleting it.
	machine.visible_message(SPAN_WARNING("The terminal is ripped out of \the [machine]!"))
	qdel(terminal) // will handle everything via the destroyed event

/obj/item/stock_parts/power/terminal/proc/make_terminal(var/obj/machinery/machine)
	if(!machine)
		return
	var/obj/machinery/power/terminal/new_terminal = new (get_step(machine, terminal_dir))
	new_terminal.set_dir(terminal_dir ? global.reverse_dir[terminal_dir] : machine.dir)
	new_terminal.connect_to_network()
	set_terminal(machine, new_terminal)

/obj/item/stock_parts/power/terminal/proc/unset_terminal(var/obj/machinery/power/old_terminal, var/obj/machinery/machine)
	remove_extension(src, /datum/extension/event_registration/shuttle_stationary)
	events_repository.unregister(/decl/observ/destroyed, old_terminal, src)
	if(!machine && istype(loc, /obj/machinery))
		machine = loc
	if(machine)
		unset_status(machine, PART_STAT_CONNECTED)
	terminal = null
	stop_processing(machine)

/obj/item/stock_parts/power/terminal/proc/blocking_terminal_at_loc(var/obj/machinery/machine, var/turf/T, var/mob/user)
	. = FALSE
	var/check_dir = terminal_dir ? global.reverse_dir[terminal_dir] : machine.dir
	for(var/obj/machinery/power/terminal/term in T)
		if(T.dir == check_dir)
			to_chat(user, "<span class='notice'>There is already a terminal here.</span>")
			return TRUE

/obj/item/stock_parts/power/terminal/attackby(obj/item/I, mob/user)
	var/obj/machinery/machine = loc
	if(!istype(machine))
		return ..()

	// Interactions inside machine only
	if (istype(I, /obj/item/stack/cable_coil) && !terminal)
		var/turf/T = get_step(machine, terminal_dir)
		if(terminal_dir && user.loc != T)
			return FALSE // Wrong terminal handler.
		if(blocking_terminal_at_loc(machine, T, user))
			return FALSE

		if(istype(T) && !T.is_plating())
			to_chat(user, "<span class='warning'>You must remove the floor plating in front of \the [machine] first.</span>")
			return TRUE
		var/obj/item/stack/cable_coil/C = I
		if(!C.can_use(10))
			to_chat(user, "<span class='warning'>You need ten lengths of cable for \the [machine].</span>")
			return TRUE
		user.visible_message("<span class='warning'>\The [user] adds cables to the \the [machine].</span>", \
							"You start adding cables to \the [machine] frame...")
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 20, machine))
			if(C.can_use(10) && !terminal && (machine == loc) && machine.components_are_accessible(type) && !blocking_terminal_at_loc(machine, T, user))
				var/obj/structure/cable/N = T.get_cable_node()
				if (prob(50) && electrocute_mob(user, N, N))
					spark_at(machine, amount=5, cardinal_only = TRUE)
					if(HAS_STATUS(user, STAT_STUN))
						return TRUE
				C.use(10)
				user.visible_message(\
					"<span class='warning'>\The [user] has added cables to the \the [machine]!</span>",\
					"You add cables to the \the [machine].")
				make_terminal(machine)
		return TRUE

/obj/item/stock_parts/power/terminal/get_source_info()
	. =  "The machine can receive power by direct connection to the powernet. "
	if(terminal)
		if(!terminal.get_powernet())
			. += "The power terminal must be connected to the powernet using additional cables."
		else
			. += "The connected powernet must be powered."
	else
		. += "Add cables to the machine to construct a power terminal."

/obj/item/stock_parts/power/terminal/buildable
	part_flags = PART_FLAG_HAND_REMOVE
	max_health = null //Buildable variant may take damage
	material = /decl/material/solid/metal/steel

/decl/stock_part_preset/terminal_connect
	expected_part_type = /obj/item/stock_parts/power/terminal

/decl/stock_part_preset/terminal_connect/apply(obj/machinery/machine, var/obj/item/stock_parts/power/terminal/part, var/turf/picked_turf)
	if(!picked_turf)
		picked_turf = machine.loc
	var/obj/machinery/power/terminal/term = locate() in picked_turf
	if(istype(term) && !term.master)
		part.set_terminal(machine, term)

/decl/stock_part_preset/terminal_setup
	expected_part_type = /obj/item/stock_parts/power/terminal

/decl/stock_part_preset/terminal_setup/apply(obj/machinery/machine, var/obj/item/stock_parts/power/terminal/part)
	if(isturf(machine.loc) && machine.anchored)
		part.make_terminal(machine)

//Offset terminals towards the owner's facing direction
/decl/stock_part_preset/terminal_connect/offset_dir/apply(obj/machinery/machine, obj/item/stock_parts/power/terminal/part, turf/picked_turf)
	. = ..(machine, part, get_step(machine.loc, machine.dir))

/decl/stock_part_preset/terminal_setup/offset_dir/apply(obj/machinery/machine, obj/item/stock_parts/power/terminal/part)
	. = ..(machine, part)