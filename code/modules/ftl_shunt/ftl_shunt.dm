/obj/machinery/ftl_shunt/core
	name = "FTL shunt core"
	desc = "An immensely powerful particle accelerator capable of forming a micro-wormhole and shunting an entire ship through it in a nanosecond."

	var/list/fuel_ports = list() //We mainly use fusion fuels.
	var/charge_time //We don't actually charge to a certain amount of power, we just charge for x amount of time depending on host ship mass.
	var/charging = FALSE
	var/phasing = FALSE
	var/mode = FTL_DRIVE_MODE_SHUNT
	var/shunt_x
	var/shunt_y
	var/obj/machinery/computer/ship/ftl_computer
	var/required_fuel_joules

	use_power = POWER_USE_OFF
	power_channel = EQUIP
	idle_power_usage = 1600
	active_power_usage = 150000

/obj/machinery/ftl_shunt/core/proc/start_shunt()
	var/shunt_distance
	var/vessel_mass = ftl_computer.linked.get_vessel_mass()

	if(stat & (BROKEN|NOPOWER))
		if(stat & (BROKEN))
			return FTL_START_FAILURE_BROKEN
		if(stat & (NOPOWER))
			return FTL_START_FAILURE_POWER

	if(mode = FTL_DRIVE_MODE_SHUNT)
		var/shunt_turf = locate(shunt_x, shunt_y, GLOB.using_map.overmap_z)
		shunt_distance = get_dist(get_turf(ftl_computer.linked), shunt_turf)

	if(mode = FTL_DRIVE_MODE_SHUNT) //We only use fuel if we're shunting.
		required_fuel_joules = (vessel_mass * JOULES_PER_TON) * shunt_distance

	if(required_fuel_joules > get_fuel())
		return FTL_START_FAILURE_FUEL

	charge_time = world.time + get_charge_time()
	//If we've gotten to this point then we're okay to start charging up.
	charging = TRUE

/obj/machinery/ftl_shunt/core/proc/cancel_shunt()
	charging = FALSE
	charge_time = null
	shunt_x = null
	shunt_y = null

	if(phasing)
		phasing = FALSE

/obj/machinery/ftl_shunt/core/proc/execute_shunt()
	switch(mode)
		if(FTL_DRIVE_MODE_SHUNT)
			use_fuel(required_fuel_joules)
			use_power = POWER_USE_IDLE
			var/destination = locate(shunt_x, shunt_y, GLOB.using_map.overmap_z)
			ftl_computer.linked.forceMove(destination)

		if(FTL_DRIVE_MODE_PHASE)

/obj/machinery/ftl_shunt/core/proc/get_fuel()
	var/total_fuel_joules

	for(var/obj/machinery/ftl_shunt/fuel_port/F in fuel_ports)
		total_fuel_joules += F.get_avaliable_fuel_joules()

	return total_fuel_joules

/obj/machinery/ftl_shunt/core/proc/use_fuel(var/joules_req)
	var/fuel_port_num = fuel_ports.len
	var/joules_per_port = joules_req / fuel_port_num

	for(var/obj/machinery/ftl_shunt/fuel_port/F in fuel_ports)
		F.use_fuel_joules(joules_per_port)

	return total_fuel_joules

/obj/machinery/ftl_shunt/core/proc/get_charge_time()
	var/time_multiplier = 1
	if(mode == FTL_DRIVE_MODE_SHUNT)
		time_multiplier = 0.5 //It's faster to shunt than to phase.
	return (vessel_mass * CHARGE_TIME_PER_TON) * time_multiplier

/obj/machinery/ftl_shunt/core/Process()
	. = ..()
	if(stat & (BROKEN|NOPOWER) && charging)
		cancel_shunt()
	if(charging)
		if(use_power != POWER_USE_ACTIVE)
			use_power = POWER_USE_ACTIVE
		if(world.time >= charge_time) //We've probably finished charging up.
			charging = FALSE
			execute_shunt()

/obj/machinery/ftl_shunt/fuel_port
	name = "FTL shunt fuel port"
	desc = "A fuel port for an FTL shunt device."

	var/list/fuels = list(/decl/material/gas/hydrogen/tritium = 10000, /decl/material/gas/hydrogen/deuterium = 10000, /decl/material/gas/hydrogen = 10000, /decl/material/solid/exotic_matter = 50000)
	var/obj/item/fuel_assembly/fuel
	var/obj/machinery/ftl_shunt/core/master

/obj/machinery/ftl_shunt/fuel_port/proc/get_avaliable_fuel_joules()
	var/total_joules_amount

	for(var/decl/material/gas/G in fuel.rod_quantities)
		if(G in fuels)
			var/fuel_quantity = fuel.rod_quantities[G]
			var/joules_per_unit = fuels[G]
			var/total_joules = fuel_quantity * joules_per_unit
			total_joules_amount += total_joules

	return total_joules_amount

/obj/machinery/ftl_shunt/fuel_port/proc/use_fuel_joules(var/joules)
	for(var/decl/material/gas/G in fuel.rod_quantities)
		if(G in fuels)
			var/fuel_quantity = fuel.rod_quantities[G]
			var/joules_per_unit = fuels[G]
			var/fuel_to_use = joules / fuels[G]
			fuel.rod_quantities[G] - fuel_to_use



