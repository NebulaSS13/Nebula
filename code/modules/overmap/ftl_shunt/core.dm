var/list/global/fuels = list(/decl/material/gas/hydrogen/tritium = 25000, /decl/material/gas/hydrogen/deuterium = 25000, /decl/material/gas/hydrogen = 25000, /decl/material/solid/exotic_matter = 50000)

/obj/machinery/ftl_shunt
	anchored = 1
	icon = 'icons/obj/shunt_drive.dmi'
	var/initial_id_tag

/obj/machinery/ftl_shunt/core
	name = "superluminal shunt core"
	desc = "An immensely powerful particle accelerator capable of forming a micro-wormhole and shunting an entire ship through it in a nanosecond."

	var/list/fuel_ports = list() //We mainly use fusion fuels.
	var/charge_time //We don't actually charge to a certain amount of power, we just charge for x amount of time depending on host ship mass.
	var/charge_started
	var/charging = FALSE
	var/shunt_x = 1
	var/shunt_y = 1
	var/obj/machinery/computer/ship/ftl/ftl_computer
	var/required_fuel_joules
	var/cooldown_delay = 5 MINUTES
	var/cooldown
	var/time_multiplier = 5 //The multiplier on how long it takes the shunt drive to charge.
	var/max_jump_distance = 8 //How many overmap tiles can this move the ship?
	var/sabotaged = null
	var/sabotaged_warn = FALSE
	var/sabotaged_amt = 0 //amount of crystals used to sabotage us.

	var/static/datum/announcement/priority/ftl_announcement = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/notice2.ogg'))

	var/shunt_start_text = "Attention! All hands brace for faster-than-light transition! ETA: %%TIME%%"
	var/shunt_cancel_text = "Attention! Faster-than-light transition cancelled."
	var/shunt_complete_text = "Attention! Faster-than-light transition completed."

	var/shunt_sabotage_text_minor = "Warning! Electromagnetic flux beyond safety limits - aborting shunt!"
	var/shunt_sabotage_text_major = "Warning! Critical electromagnetic flux in accelerator core! Dumping core and aborting shunt!"
	var/shunt_sabotage_text_critical = "ALERT! Critical malfunction in microsingularity containment core! Safety systems offline!"

	use_power = POWER_USE_OFF
	power_channel = EQUIP
	idle_power_usage = 1600
	active_power_usage = 150000
	icon_state = "bsd"

//Base procs

/obj/machinery/ftl_shunt/core/Initialize()
	. = ..()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/local_network = get_extension(src, /datum/extension/local_network_member)
		local_network.set_tag(null, initial_id_tag)
	find_ports()

/obj/machinery/ftl_shunt/core/Destroy()
	. = ..()
	for(var/obj/machinery/ftl_shunt/fuel_port/FP in fuel_ports)
		FP.master = null
		fuel_ports -= FP
	ftl_computer.linked_core = null
	ftl_computer = null

/obj/machinery/ftl_shunt/core/examine(mob/user)
	. = ..()
	if(sabotaged)
		switch(sabotaged)
			if(SHUNT_SABOTAGE_MINOR)
				to_chat(user, SPAN_WARNING("It looks like it's been tampered with in some way."))
			if(SHUNT_SABOTAGE_MAJOR)
				to_chat(user, SPAN_WARNING("Light behaves oddly around the core of [src], and it looks to have been tampered with!"))
			if(SHUNT_SABOTAGE_CRITICAL)
				to_chat(user, SPAN_DANGER("Light bends around the core of [src] in a manner that eerily reminds you of a singularity..."))

/obj/machinery/ftl_shunt/core/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/stack/telecrystal))
		var/obj/item/stack/telecrystal/TC = O
		var/tc_input = input(user, "How many telecrystals do you want to put in?", "TC Input", 0) as num|null

		if(!tc_input)
			return FALSE

		if(TC.amount < tc_input)
			to_chat(user, SPAN_WARNING("You don't have enough telecrystals for that."))
			return FALSE

		to_chat(user, SPAN_WARNING("You begin to insert the crystals into [src]..."))

		if(!do_after(user, 6 SECONDS, src))
			return FALSE

		switch(tc_input)
			if(10 to 25)
				sabotaged = SHUNT_SABOTAGE_MINOR
			if(25 to 49)
				sabotaged = SHUNT_SABOTAGE_MAJOR
			if(50 to INFINITY)
				sabotaged = SHUNT_SABOTAGE_CRITICAL

		sabotaged_amt = tc_input
		TC.use(tc_input)
		to_chat(user, SPAN_DANGER("You successfully sabotage [src] by inserting the crystals!"))
		return TRUE

/obj/machinery/ftl_shunt/core/attack_hand(var/mob/user)
	if(sabotaged)
		var/skill_delay = user.skill_delay_mult(SKILL_ENGINES, 0.3)
		if(!user.skill_check(SKILL_ENGINES, SKILL_BASIC))
			to_chat(user, SPAN_DANGER("You are nowhere near experienced enough to stick your hand into that thing."))
			return FALSE
		to_chat(user, SPAN_NOTICE("You reach your hand inside of [src] and slowly begin to remove a foreign object ..."))
		if(!do_after(user, (4 SECOND * skill_delay), src))
			return FALSE
		var/obj/item/stack/telecrystal/TC = new
		TC.amount = sabotaged_amt
		TC.forceMove(get_turf(user))
		user.put_in_hands(TC)
		to_chat(user, SPAN_NOTICE("You remove the object from [src], and it seems to return to normal."))
		sabotaged = null
		sabotaged_amt = 0
		return TRUE

//Custom procs.
//Finds fuel ports.
/obj/machinery/ftl_shunt/core/proc/find_ports()
	var/datum/extension/local_network_member/network = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = network.get_local_network()
	if(lan)
		var/list/ports = lan.get_devices(/obj/machinery/ftl_shunt/fuel_port)
		for(var/obj/machinery/ftl_shunt/fuel_port/FP in ports)
			if(!FP.master)
				FP.master = src
				fuel_ports += FP

//Starts the teleport process, returns 1-6, with 6 being the all-clear.
/obj/machinery/ftl_shunt/core/proc/start_shunt()
	var/shunt_distance
	var/vessel_mass = ftl_computer.linked.get_vessel_mass()
	var/shunt_turf = locate(shunt_x, shunt_y, GLOB.using_map.overmap_z)

	if(stat & (BROKEN))
		return FTL_START_FAILURE_BROKEN
	if(stat & (NOPOWER))
		return FTL_START_FAILURE_POWER

	if(!length(fuel_ports)) //no fuel ports
		find_ports()
		if(!length(fuel_ports))
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

	ftl_announcement.Announce(announcetxt, "FTL Shunt Management System", new_sound = sound('sound/misc/notice2.ogg'))
	return FTL_START_CONFIRMED

//Cancels the in-progress shunt.
/obj/machinery/ftl_shunt/core/proc/cancel_shunt(var/silent = FALSE)
	if(!charging) //Not preparing for a jump.
		return
	charging = FALSE
	charge_time = null
	charge_started = null
	cooldown = null
	required_fuel_joules = null
	if(silent)
		ftl_announcement.Announce(shunt_cancel_text, "FTL Shunt Management System", new_sound = sound('sound/misc/notice2.ogg'))
	update_use_power(POWER_USE_IDLE)

//Starts the shunt, and then hands off to do_shunt to finish it.
/obj/machinery/ftl_shunt/core/proc/execute_shunt()
	if(sabotaged)
		cancel_shunt(TRUE)
		do_sabotage()
		return

	use_power = POWER_USE_IDLE
	var/destination = locate(shunt_x, shunt_y, GLOB.using_map.overmap_z)
	var/jumpdist = get_dist(get_turf(ftl_computer.linked), destination)
	var/obj/effect/portal/wormhole/W = new(destination) //Generate a wormhole effect on overmap to give some indication that something is about to happen.
	QDEL_IN(W, 6 SECONDS)
	addtimer(CALLBACK(src, .proc/do_shunt, shunt_x, shunt_y, jumpdist, destination), 6 SECONDS)
	for(var/mob/living/carbon/M in world)
		if(!(M.z in ftl_computer.linked.map_z))
			continue
		sound_to(M, 'sound/machines/hyperspace_begin.ogg')

/obj/machinery/ftl_shunt/core/proc/do_shunt(var/turfx, var/turfy, var/jumpdist, var/destination) //this does the actual teleportation, execute_shunt is there to give us time to do our fancy effects
	ftl_computer.linked.forceMove(destination)
	ftl_announcement.Announce(shunt_complete_text, "FTL Shunt Management System", new_sound = sound('sound/misc/notice2.ogg'))
	cooldown = world.time + cooldown_delay
	update_use_power(POWER_USE_IDLE)
	do_effects(jumpdist)

//Handles all the effects of the jump.
/obj/machinery/ftl_shunt/core/proc/do_effects(var/distance) //If we're jumping too far, have some !!FUN!! with people and ship systems.
	var/shunt_sev
	switch(distance)
		if(1 to 3)
			shunt_sev = SHUNT_SEVERITY_MINOR
		if(4 to 5)
			shunt_sev = SHUNT_SEVERITY_MAJOR
		if(6 to INFINITY)
			shunt_sev = SHUNT_SEVERITY_CRITICAL

	for(var/mob/living/carbon/human/H in world) //Affect mobs, skip synthetics.
		sound_to(H, 'sound/machines/hyperspace_end.ogg')
		if(!(H.z in ftl_computer.linked.map_z))
			continue
		if(H.isSynthetic())
			continue //We don't affect synthetics.
		switch(shunt_sev)
			if(SHUNT_SEVERITY_MINOR)
				to_chat(H, SPAN_NOTICE("You feel your insides flutter about inside of you as you are briefly shunted into an alternate dimension.")) //No major effects.
				shake_camera(H, 2, 1)

			if(SHUNT_SEVERITY_MAJOR)
				to_chat(H, SPAN_WARNING("You feel your insides twisted inside and out as you are violently shunted between dimensions, and you feel like something is watching you!"))
				if(prob(25))
					H.hallucination(50, 50)
				if(prob(15))
					H.vomit()
				shake_camera(H, 2, 1)

			if(SHUNT_SEVERITY_CRITICAL)
				to_chat(H, SPAN_DANGER("You feel an overwhelming sense of nausea and vertigo wash over you, your instincts screaming that something is wrong!"))
				if(prob(50))
					H.hallucination(100, 100)
				if(prob(45))
					H.vomit()
				shake_camera(H, 5, 4)

	for(var/obj/machinery/light/L in SSmachines.machinery) //Fuck with and or break lights.
		if(!(L.z in ftl_computer.linked.map_z))
			continue
		switch(shunt_sev)
			if(SHUNT_SEVERITY_MINOR)
				if(prob(15))
					L.flicker()
			if(SHUNT_SEVERITY_MAJOR)
				if(prob(35))
					L.flicker()

	for(var/obj/machinery/power/apc/A in SSmachines.machinery)
		if(!(A.z in ftl_computer.linked.map_z))
			continue
		switch(shunt_sev)
			if(SHUNT_SEVERITY_MAJOR)
				if(prob(15))
					A.energy_fail(rand(30, 80))
				if(prob(10))
					A.overload_lighting(25)

			if(SHUNT_SEVERITY_CRITICAL)
				if(prob(35))
					A.energy_fail(rand(60, 150))
				if(prob(50))
					A.overload_lighting(50)

/obj/machinery/ftl_shunt/core/proc/do_sabotage()
	var/announcetxt
	var/uhoh = FALSE

	switch(sabotaged)
		if(SHUNT_SABOTAGE_MINOR)
			announcetxt = shunt_sabotage_text_minor
			for(var/mob/living/carbon/human/H in view(7))
				to_chat(H, SPAN_DANGER("[src] emits a flash of incredibly bright, searing light!"))
				H.flash_eyes(FLASH_PROTECTION_NONE)
			empulse(src, 8, 10)

		if(SHUNT_SABOTAGE_MAJOR)
			announcetxt = shunt_sabotage_text_major

			for(var/mob/living/carbon/human/H in view(7)) //Effect One: scary text.
				to_chat(H, SPAN_DANGER("[src] hisses and sparks, before coolant lines burst and spew superheated coolant!"))

			explosion(get_turf(src),-1,-1,8,10) //Effect Two: blow the windows out.

			for(var/obj/machinery/power/apc/A in SSmachines.machinery) //Effect Three: shut down power across the ship.
				if(!(A.z in ftl_computer.linked.map_z))
					continue
				A.energy_fail(rand(60,80))

		if(SHUNT_SABOTAGE_CRITICAL)
			announcetxt = shunt_sabotage_text_critical

			uhoh = TRUE //let the fuckening begin!

			for(var/obj/machinery/power/apc/A in SSmachines.machinery) //Effect One: shut down power across the ship.
				if(!(A.z in ftl_computer.linked.map_z))
					continue
				A.energy_fail(rand(100,120))

			for(var/mob/living/carbon/human/H in view(7)) //scary text if you're in view, because you're fucked now boy.
				to_chat(H, SPAN_DANGER("The light around [src] warps before it emits a flash of incredibly bright, searing light!"))
				H.flash_eyes(FLASH_PROTECTION_NONE)


	ftl_announcement.Announce(announcetxt, "FTL Shunt Management System", new_sound = sound('sound/misc/ftlsiren.ogg'))

	if(uhoh)
		new /obj/singularity/(get_turf(src))

//Returns status to ftl computer.
/obj/machinery/ftl_shunt/core/proc/get_status()
	if(stat & (BROKEN|NOPOWER))
		return FTL_STATUS_OFFLINE
	if(cooldown)
		return FTL_STATUS_COOLDOWN
	else
		return FTL_STATUS_GOOD

/obj/machinery/ftl_shunt/core/proc/get_fuel(var/list/input)
	var/total_fuel_joules

	for(var/obj/machinery/ftl_shunt/fuel_port/F in input)
		total_fuel_joules += F.get_fuel_joules()

	return total_fuel_joules

/obj/machinery/ftl_shunt/core/proc/get_fuel_maximum(var/list/input)
	var/max_fuel_joules = 0
	for(var/obj/machinery/ftl_shunt/fuel_port/F in input)
		max_fuel_joules += F.get_fuel_joules(TRUE)

	return max_fuel_joules

obj/machinery/ftl_shunt/core/proc/fuelpercentage()
	if(!length(fuel_ports))
		return 0
	var/fuel_max = get_fuel_maximum(fuel_ports)
	if(fuel_max == 0)
		return 0
	return round(100.0*get_fuel(fuel_ports)/fuel_max, 0.1)


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

	joules_per_port = (joules_req / length(fueled_ports))

	for(var/obj/machinery/ftl_shunt/fuel_port/F in fueled_ports)
		if(F.use_fuel_joules(joules_per_port))
			ports_used++

	if(ports_used == length(fueled_ports))
		return TRUE

/obj/machinery/ftl_shunt/core/proc/get_charge_time()
	return (ftl_computer.linked.vessel_mass * CHARGE_TIME_PER_TON) * time_multiplier

/obj/machinery/ftl_shunt/core/Process()
	if((stat & (BROKEN|NOPOWER)) & charging)
		cancel_shunt()

	if(!length(fuel_ports))
		find_ports()

	if(charging)

		if(sabotaged && !sabotaged_warn)
			for(var/mob/living/carbon/human/H in world) //Give engineers a hint that something might be very, very wrong.
				if(!(H.z in ftl_computer.linked.map_z))
					continue
				if(H.skill_check(SKILL_ENGINES, SKILL_EXPERT))
					to_chat(H, SPAN_DANGER("The deck vibrates with a harmonic that sets your teeth on edge and fills you with dread."))
			sabotaged_warn = TRUE

		if(use_power != POWER_USE_ACTIVE)
			update_use_power(POWER_USE_ACTIVE)
		if(world.time >= charge_time) //We've probably finished charging up.
			charging = FALSE
			if(use_fuel(required_fuel_joules))
				execute_shunt()
			else
				cancel_shunt() //Not enough fuel for whatever reason. Cancel.
		SSradiation.radiate(src, (active_power_usage / 1000))

	if(!charging)
		update_use_power(POWER_USE_IDLE)

/obj/machinery/ftl_shunt/fuel_port
	name = "superluminal shunt fuel port"
	desc = "A fuel port for an FTL shunt."
	icon_state = "empty"

	var/obj/item/fuel_assembly/fuel
	var/obj/machinery/ftl_shunt/core/master
	var/max_fuel = 0

/obj/machinery/ftl_shunt/fuel_port/on_update_icon()
	if(fuel)
		icon_state = "full"
	else
		icon_state = "empty"

/obj/machinery/ftl_shunt/fuel_port/Initialize()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/local_network = get_extension(src, /datum/extension/local_network_member)
		local_network.set_tag(null, initial_id_tag)

/obj/machinery/ftl_shunt/fuel_port/Destroy()
	. = ..()
	if(master)
		master.fuel_ports -= src
	master = null
	QDEL_NULL(fuel)
	return TRUE

/obj/machinery/ftl_shunt/fuel_port/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/fuel_assembly))
		if(!fuel)
			if(!do_after(user, 20, src))
				return
			if(user && !user.unEquip(O))
				return
			O.forceMove(src)
			fuel = O
			max_fuel = get_fuel_joules(TRUE)
			update_icon()
			return TRUE

	. = ..()
	return FALSE

/obj/machinery/ftl_shunt/fuel_port/attack_hand(var/mob/user)
	if(fuel)
		to_chat(user, SPAN_NOTICE("You begin to remove the fuel assembly from [src]..."))
		if(!do_after(user, 20, src))
			return FALSE
		fuel.forceMove(get_turf(user))
		user.put_in_hands(fuel)
		fuel = null
		max_fuel = 0
		to_chat(user, SPAN_NOTICE("You remove the fuel assembly!"))
		return TRUE

	. = ..()
	return FALSE

/obj/machinery/ftl_shunt/fuel_port/proc/has_fuel()
	return !!fuel

/obj/machinery/ftl_shunt/fuel_port/proc/get_fuel_joules(var/get_fuel_maximum)
	if(fuel)
		for(var/G in fuel.rod_quantities)
			if(G in fuels)
				. += (get_fuel_maximum ? fuel.rod_quantities[G] : 10000) * fuels[G]

/obj/machinery/ftl_shunt/fuel_port/proc/use_fuel_joules(var/joules)
	if(!fuel)
		return FALSE

	for(var/G in fuel.rod_quantities)
		if(G in fuels)
			var/fuel_to_use = joules / fuels[G]
			fuel.rod_quantities[G] -= fuel_to_use

	return TRUE

