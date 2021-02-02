/obj/machinery/ftl_shunt
	anchored = 1
	icon = 'icons/obj/shunt_drive.dmi'

/obj/machinery/ftl_shunt/core
	name = "FTL shunt core"
	desc = "An immensely powerful particle accelerator capable of forming a micro-wormhole and shunting an entire ship through it in a nanosecond."

	var/list/fuel_ports = list() //We mainly use fusion fuels.
	var/charge_time //We don't actually charge to a certain amount of power, we just charge for x amount of time depending on host ship mass.
	var/charge_started
	var/charging = FALSE
	var/shunt_x
	var/shunt_y
	var/obj/machinery/computer/ship/ftl/ftl_computer
	var/required_fuel_joules
	var/cooldown_delay = 5 MINUTES
	var/cooldown

	var/static/datum/announcement/priority/ftl_announcement = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/notice1.ogg'))

	var/shunt_start_text = "Attention! All hands brace for faster-than-light transition! ETA: %%TIME%%"
	var/shunt_cancel_text = "Attention! Faster-than-light transition cancelled."
	var/shunt_complete_text = "Attention! Faster-than-light transition completed."

	use_power = POWER_USE_OFF
	power_channel = EQUIP
	idle_power_usage = 1600
	active_power_usage = 150000
	icon_state = "bsd"

/obj/machinery/ftl_shunt/core/Initialize()
	. = ..()

/obj/machinery/ftl_shunt/core/proc/find_ports()
	for(var/obj/machinery/ftl_shunt/fuel_port/FP in range(7))
		if(!FP.master)
			FP.master = src
			fuel_ports += FP

/obj/machinery/ftl_shunt/core/proc/start_shunt()
	var/shunt_distance
	var/vessel_mass = ftl_computer.linked.get_vessel_mass()
	var/shunt_turf = locate(shunt_x, shunt_y, GLOB.using_map.overmap_z)

	if(stat & (BROKEN|NOPOWER))
		if(stat & (BROKEN))
			return FTL_START_FAILURE_BROKEN
		if(stat & (NOPOWER))
			return FTL_START_FAILURE_POWER

	if(!fuel_ports.len) //no fuel ports
		return FTL_START_FAILURE_OTHER

	if(world.time <= cooldown)
		return FTL_START_FAILURE_COOLDOWN

	shunt_distance = get_dist(get_turf(ftl_computer.linked), shunt_turf)
	required_fuel_joules = (vessel_mass * JOULES_PER_TON) * shunt_distance

	if(required_fuel_joules > get_fuel(fuel_ports))
		return FTL_START_FAILURE_FUEL

	charge_time = world.time + get_charge_time()
	//If we've gotten to this point then we're okay to start charging up.
	charging = TRUE
	charge_started = world.time

	var/eta = round((get_charge_time() / 600))

	var/announcetxt = replacetext(shunt_start_text, "%%TIME%%", "[eta] minutes.")

	ftl_announcement.Announce(announcetxt, "Shunt Drive Management System")
	return FTL_START_CONFIRMED

/obj/machinery/ftl_shunt/core/proc/cancel_shunt()
	charging = FALSE
	charge_time = null
	cooldown = null
	shunt_x = null
	shunt_y = null
	required_fuel_joules = null
	ftl_announcement.Announce(shunt_cancel_text, "Shunt Drive Management System")

/obj/machinery/ftl_shunt/core/proc/execute_shunt()
	use_power = POWER_USE_IDLE
	var/destination = locate(shunt_x, shunt_y, GLOB.using_map.overmap_z)
	ftl_computer.linked.forceMove(destination)
	ftl_announcement.Announce(shunt_complete_text, "Shunt Drive Management System")
	cooldown = world.time + cooldown_delay

/obj/machinery/ftl_shunt/core/proc/get_fuel(var/list/input)
	var/total_fuel_joules

	for(var/obj/machinery/ftl_shunt/fuel_port/F in input)
		total_fuel_joules += F.get_avaliable_fuel_joules()

	return total_fuel_joules

/obj/machinery/ftl_shunt/core/proc/use_fuel(var/joules_req)
	var/joules_per_port
	var/avail_fuel = get_fuel(fuel_ports)
	var/list/fueled_ports = list()
	var/ports_used

	if(joules_req > avail_fuel) //Not enough fuel in the system.
		return FALSE

	for(var/obj/machinery/ftl_shunt/fuel_port/F in fuel_ports)
		if(F.has_fuel())
			fueled_ports += F

	joules_per_port = (joules_req / fueled_ports.len)

	for(var/obj/machinery/ftl_shunt/fuel_port/F in fueled_ports)
		if(F.use_fuel_joules(joules_per_port))
			ports_used++

	if(ports_used == fueled_ports.len)
		return TRUE

/obj/machinery/ftl_shunt/core/proc/get_charge_time()
	return (ftl_computer.linked.vessel_mass * CHARGE_TIME_PER_TON) * 0.5

/obj/machinery/ftl_shunt/core/Process()
	. = ..()
	if(stat & (BROKEN|NOPOWER) && charging)
		cancel_shunt()

	if(!fuel_ports.len)
		find_ports()

	if(charging)
		if(use_power != POWER_USE_ACTIVE)
			use_power = POWER_USE_ACTIVE
		if(world.time >= charge_time) //We've probably finished charging up.
			charging = FALSE
			if(use_fuel(required_fuel_joules))
				execute_shunt()
			else
				cancel_shunt() //Not enough fuel for whatever reason. Cancel.

/obj/machinery/ftl_shunt/fuel_port
	name = "FTL shunt fuel port"
	desc = "A fuel port for an FTL shunt device."
	icon_state = "empty"

	var/list/fuels = list(/decl/material/gas/hydrogen/tritium = 10000, /decl/material/gas/hydrogen/deuterium = 10000, /decl/material/gas/hydrogen = 10000, /decl/material/solid/exotic_matter = 50000)
	var/obj/item/fuel_assembly/fuel
	var/obj/machinery/ftl_shunt/core/master

/obj/machinery/ftl_shunt/fuel_port/on_update_icon()
	if(fuel)
		icon_state = "full"

/obj/machinery/ftl_shunt/fuel_port/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/fuel_assembly))
		if(!fuel)
			if(user && !user.unEquip(O))
				return
			O.forceMove(src)
			fuel = O

/obj/machinery/ftl_shunt/fuel_port/proc/has_fuel()
	if(fuel)
		return TRUE
	else
		return FALSE

/obj/machinery/ftl_shunt/fuel_port/proc/get_avaliable_fuel_joules()
	if(!fuel)
		return 0

	var/total_joules_amount

	for(var/decl/material/gas/G in fuel.rod_quantities)
		if(G in fuels)
			var/fuel_quantity = fuel.rod_quantities[G]
			var/joules_per_unit = fuels[G]
			var/total_joules = fuel_quantity * joules_per_unit
			total_joules_amount += total_joules

	return total_joules_amount

/obj/machinery/ftl_shunt/fuel_port/proc/use_fuel_joules(var/joules)
	if(!fuel)
		return FALSE

	for(var/decl/material/gas/G in fuel.rod_quantities)
		if(G in fuels)
			var/fuel_to_use = joules / fuels[G]
			fuel.rod_quantities[G] -= fuel_to_use

	return TRUE

