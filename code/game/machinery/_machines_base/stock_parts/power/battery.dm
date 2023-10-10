/obj/item/stock_parts/power/battery
	name = "battery backup"
	desc = "A self-contained battery backup system, using replaceable cells to provide backup power."
	icon_state = "battery0"
	var/obj/item/cell/cell
	var/charge_channel = ENVIRON  // The channel it attempts to charge from.
	var/charge_rate = 1           // This is in battery units, per tick.
	var/can_charge = TRUE
	var/charge_wait_counter = 10  // How many ticks we wait until we start charging after charging becomes an option.
	var/last_cell_charge  = 0     // Used for UI stuff.
	var/seek_alternatives = 5     // How many ticks we wait before seeking other power sources, if we can provide the machine with power. Set to 0 to never do this.

/obj/item/stock_parts/power/battery/Destroy()
	QDEL_NULL(cell)
	. = ..()

/obj/item/stock_parts/power/battery/on_install(var/obj/machinery/machine)
	..()
	start_processing(machine)

/obj/item/stock_parts/power/battery/on_uninstall(var/obj/machinery/machine)
	if(status & PART_STAT_ACTIVE)
		machine.update_power_channel(cached_channel)
		unset_status(machine, PART_STAT_ACTIVE)
	if(cell && (part_flags & PART_FLAG_QDEL))
		cell.dropInto(loc)
		remove_cell()
	..()

/obj/item/stock_parts/power/battery/check_health(lastdamage, lastdamtype, lastdamflags, consumed)
	if(can_take_damage() && lastdamage > 0)
		switch(lastdamtype)
			if(ELECTROCUTE)
				if(prob(50) && cell && (get_percent_health() < 50))
					cell.emp_act(3)
			if(BRUTE)
				if(prob(20) && cell && (get_percent_health() < 50))
					cell.explosion_act(3)
	. = ..()

// None of these helpers actually change the cell's loc. They only manage internal references and state.
/obj/item/stock_parts/power/battery/proc/add_cell(var/obj/machinery/machine, var/obj/item/cell/new_cell)
	if(cell)
		return
	cell = new_cell
	events_repository.register(/decl/observ/destroyed, cell, src, .proc/remove_cell)
	if(!machine)
		machine = loc
	if(istype(machine))
		machine.power_change()
		machine.queue_icon_update()
	set_status(machine, PART_STAT_CONNECTED)
	update_icon()
	return cell

/obj/item/stock_parts/power/battery/proc/remove_cell()
	if(cell)
		events_repository.unregister(/decl/observ/destroyed, cell, src)
		. = cell
		cell = null
		var/obj/machinery/machine = loc
		if(istype(machine))
			machine.power_change()
			machine.queue_icon_update()
		update_icon()
		unset_status(machine, PART_STAT_CONNECTED)

/obj/item/stock_parts/power/battery/proc/extract_cell(mob/user)
	if(!cell)
		return
	cell.add_fingerprint(user)
	cell.update_icon()

	user.visible_message("<span class='warning'>\The [user] removes the power cell from [src]!</span>",\
							"<span class='notice'>You remove the power cell.</span>")
	. = remove_cell()
	var/obj/machinery/machine = loc
	if(machine)
		machine.update_icon()

/obj/item/stock_parts/power/battery/machine_process(var/obj/machinery/machine)
	last_cell_charge = cell && cell.charge

	if(status & PART_STAT_ACTIVE)
		if(!(cell && cell.checked_use(CELLRATE * machine.get_power_usage())))
			machine.update_power_channel(cached_channel)
			machine.power_change() // Out of power
			return
		if(seek_alternatives > 0)
			seek_alternatives--
			if(!seek_alternatives)
				seek_alternatives = initial(seek_alternatives)
				machine.update_power_channel(cached_channel)
				machine.power_change()
		return // We don't recharge if discharging

	if((machine.stat & NOPOWER) && cell && cell.fully_charged())
		machine.power_change()
		return // This suggests that we should be powering the machine instead, so let's try that

	// try and recharge
	var/area/A = get_area(machine)
	if(!can_charge || !cell || cell.fully_charged() || !A.powered(charge_channel))
		charge_wait_counter = initial(charge_wait_counter)
		return
	if(charge_wait_counter > 0)
		charge_wait_counter--
		return
	var/give = cell.give(charge_rate) / CELLRATE
	A.use_power_oneoff(give, charge_channel)

/obj/item/stock_parts/power/battery/can_provide_power(var/obj/machinery/machine)
	if(is_functional() && cell && cell.check_charge(CELLRATE * machine.get_power_usage()))
		machine.update_power_channel(LOCAL)
		set_status(machine, PART_STAT_ACTIVE)
		return TRUE
	return FALSE

/obj/item/stock_parts/power/battery/can_use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	. = 0
	if(cell && channel == LOCAL)
		return min(cell.charge / CELLRATE, amount)

/obj/item/stock_parts/power/battery/use_power_oneoff(var/obj/machinery/machine, var/amount, var/channel)
	. = 0
	if(cell && channel == LOCAL)
		. = cell.use(amount * CELLRATE) / CELLRATE
		charge_wait_counter = initial(charge_wait_counter) // If we are providing power, we wait to start charging.

/obj/item/stock_parts/power/battery/not_needed(var/obj/machinery/machine)
	if(status & PART_STAT_ACTIVE)
		unset_status(machine, PART_STAT_ACTIVE)
		charge_wait_counter = initial(charge_wait_counter)

// Find a cell from the machine building materials if possible.
/obj/item/stock_parts/power/battery/on_refresh(var/obj/machinery/machine)
	if(machine && !cell)
		var/obj/item/stock_parts/building_material/mat = machine.get_component_of_type(/obj/item/stock_parts/building_material)
		var/obj/item/cell/cell = mat && mat.remove_material(/obj/item/cell, 1)
		if(cell)
			add_cell(machine, cell)
			cell.forceMove(src)
	charge_rate = initial(charge_rate)
	charge_rate *= 1 + 0.5 * machine.total_component_rating_of_type(/obj/item/stock_parts/capacitor)

/obj/item/stock_parts/power/battery/on_update_icon()
	. = ..()
	icon_state = "battery[!!cell]"

// Cell interaction
/obj/item/stock_parts/power/battery/attackby(obj/item/I, mob/user)
	var/obj/machinery/machine = loc

	// Interactions with/without machine
	if(istype(I, /obj/item/cell))
		if(cell)
			to_chat(user, "There is a power cell already installed.")
			return TRUE
		if(istype(machine) && (machine.stat & MAINT))
			to_chat(user, "<span class='warning'>There is no connector for your power cell.</span>")
			return TRUE
		if(I.w_class != ITEM_SIZE_NORMAL)
			to_chat(user, "\The [I] is too [I.w_class < ITEM_SIZE_NORMAL? "small" : "large"] to fit here.")
			return TRUE

		if(!user.try_unequip(I, src))
			return
		add_cell(machine, I)
		user.visible_message(\
			SPAN_WARNING("\The [user] has inserted the power cell to \the [src]!"),\
			SPAN_NOTICE("You insert the power cell."))
		return TRUE

	// Interactions without machine
	if(!istype(machine))
		return ..()

/obj/item/stock_parts/power/battery/attack_self(mob/user)
	if(cell)
		user.put_in_hands(cell)
		extract_cell(user)
		return TRUE
	return ..()

/obj/item/stock_parts/power/battery/attack_hand(mob/user)
	if(cell && istype(loc, /obj/machinery) && user.check_dexterity(DEXTERITY_GRIP))
		user.put_in_hands(cell)
		extract_cell(user)
		return TRUE
	return ..()

/obj/item/stock_parts/power/battery/get_cell()
	return cell

/obj/item/stock_parts/power/battery/get_source_info()
	return "The machine can receive power from an installed power cell."

/obj/item/stock_parts/power/battery/buildable
	max_health = null //Buildable variant may take damage
	part_flags = PART_FLAG_HAND_REMOVE
	material = /decl/material/solid/metal/steel

/obj/item/stock_parts/power/battery/buildable/crap
	name = "battery backup (weak)"
	desc = "The BAT84 is an all-in-one battery backup system sold at an affordable price."
	material = /decl/material/solid/metal/steel
	charge_rate = 0.25
	charge_wait_counter = 15

/obj/item/stock_parts/power/battery/buildable/crap/get_lore_info()
	return "The BAT84's debut on the battery backup market was greeted by universally negative reviews, \
	highlighting its slow recharge rate and exceptional lack of responsiveness to power changes.\
	Nevertheless, it has been steadily gaining market share due to rock-bottom prices and a predatory marketing campaign."

/obj/item/stock_parts/power/battery/buildable/stock
	name = "battery backup (standard)"
	desc = "The 3006915, or, as this part is colloquially known, model 15, is the workhorse battery backup solution of populated space."

/obj/item/stock_parts/power/battery/buildable/stock/get_lore_info()
	return "Combining tolerable recharge rate and high durability into a conveniently shaped package, the model 15 has dominated the market for over three decades."

/obj/item/stock_parts/power/battery/buildable/turbo
	name = "battery backup (rapid)"
	desc = "The Xcharge state-of-the-art battery backup claims to charge over ten times as fast as its competitors."
	charge_rate = 5
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/plastic = MATTER_AMOUNT_TRACE
	)

/obj/item/stock_parts/power/battery/buildable/turbo/get_lore_info()
	return "The latest in battery charging technology deploys advanced composites and semiorganic interfaces to attain previously unheard-of charge rates. \
	The relevant marketing divisions, on the other hand, has been engaged in seeminly endless lawsuits over false advertising, having allegedly overstated said rates."

/obj/item/stock_parts/power/battery/buildable/responsive
	name = "battery backup (responsive)"
	desc = "The Focal Point FOXUS is a battery backup device marketed for its fast startup time."
	charge_wait_counter = 2
	charge_rate = 0.8
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/plastic = MATTER_AMOUNT_TRACE
	)

/obj/item/stock_parts/power/battery/buildable/responsive/get_lore_info()
	return "Unable to compete on price with the larger conglomerates, Focal Point's FOXUS instead sacrifices a bit of charge rate for drastically better responsiveness. \
	While an instant cult classic in the high-performance market, the FOXUS's bewildering name, lackluster marketing effort, and steep price have kept it from becoming a household name."