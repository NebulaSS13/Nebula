/obj/machinery/ftl_shunt
	anchored = 1
	icon = 'icons/obj/shunt_drive.dmi'
	var/initial_id_tag = "ftl"

/obj/machinery/ftl_shunt/core
	name = "superluminal shunt core"
	desc = "An immensely powerful transdimensional superluminal bridge initiator capable of forming a micro-wormhole and shunting an entire ship through it in a nanosecond."
	base_type = /obj/machinery/ftl_shunt/core
	uncreated_component_parts = list(/obj/item/stock_parts/ftl_core = 1)
	construct_state = /decl/machine_construction/default/no_deconstruct

	var/list/fuel_ports = list() //We mainly use fusion fuels.
	var/charge_time //Actually, we do use power now. This is here for the console.
	var/charging = FALSE
	var/jumping = FALSE
	var/shunt_x = 1
	var/shunt_y = 1
	var/chargepercent = 0
	var/last_percent_tick = 0
	var/obj/machinery/computer/ship/ftl/ftl_computer
	var/required_fuel_joules
	var/required_charge //This is a function of the required fuel joules.
	var/accumulated_charge
	var/max_charge = 2000000
	var/target_charge
	var/cooldown_delay = 5 MINUTES
	var/cooldown
	var/max_jump_distance = 8 //How many overmap tiles can this move the ship?
	var/moderate_jump_distance = 6
	var/safe_jump_distance = 3
	var/sabotaged
	var/sabotaged_amt = 0 //amount of crystals used to sabotage us.
	var/max_power_usage = 5 MEGAWATTS //how much power can we POSSIBLY consume.
	var/allowed_power_usage = 150 KILOWATTS
	var/last_power_drawn
	var/jump_delay = 2 MINUTES
	var/jump_timer //used to cancel the jump.

	var/static/datum/announcement/priority/ftl_announcement = new(do_log = 0, do_newscast = 1, new_sound = sound('sound/misc/notice2.ogg'))

	var/static/shunt_start_text = "Attention! Superluminal shunt warm-up initiated! Spool-up ETA: %%TIME%%"
	var/static/shunt_cancel_text = "Attention! Faster-than-light transition cancelled."
	var/static/shunt_complete_text = "Attention! Faster-than-light transition completed."
	var/static/shunt_spooling_text = "Attention! Superluminal shunt warm-up complete, spooling up."

	var/static/shunt_sabotage_text_minor = "Warning! Electromagnetic flux beyond safety limits - aborting shunt!"
	var/static/shunt_sabotage_text_major = "Warning! Critical electromagnetic flux in accelerator core! Dumping core and aborting shunt!"
	var/static/shunt_sabotage_text_critical = "ALERT! Critical malfunction in microsingularity containment core! Safety systems offline!"

	use_power = POWER_USE_OFF
	power_channel = EQUIP
	idle_power_usage = 1600
	icon_state = "bsd"
	light_color = COLOR_BLUE
	stock_part_presets = list(/decl/stock_part_preset/terminal_setup)
//Base procs

/obj/machinery/ftl_shunt/core/Initialize(mapload, d, populate_parts)
	. = ..()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/local_network = get_extension(src, /datum/extension/local_network_member)
		local_network.set_tag(null, initial_id_tag)
	find_ports()
	set_light(2)
	target_charge = max_charge * 0.25 //Target charge set to a quarter of our maximum charge, just for weirdness prevention

/obj/machinery/ftl_shunt/core/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(initial_id_tag, map_hash)

/obj/machinery/ftl_shunt/core/Destroy()
	. = ..()
	for(var/obj/machinery/ftl_shunt/fuel_port/FP in fuel_ports)
		FP.master = null
		fuel_ports -= FP
	if(ftl_computer)
		ftl_computer.linked_core = null
		ftl_computer = null

/obj/machinery/ftl_shunt/core/on_update_icon()
	cut_overlays()

	if(charging)
		var/image/I = image('icons/obj/shunt_drive.dmi', "activating")
		var/matrix/M = new()
		I.transform = M
		add_overlay(I)

	if(jumping)
		add_overlay(image('icons/obj/shunt_drive.dmi', "activated"))
		var/image/S = image('icons/obj/objects.dmi', "bhole3")
		var/matrix/M = new()
		M.Scale(0.75)
		S.transform = M
		S.alpha = 0
		animate(S, alpha = 255, time = 5.9 SECONDS)
		add_overlay(S)

/obj/machinery/ftl_shunt/core/examine(mob/user)
	. = ..()
	if(sabotaged)
		if(user.skill_check(SKILL_ENGINES, SKILL_ADEPT))
			switch(sabotaged)
				if(SHUNT_SABOTAGE_MINOR)
					to_chat(user, SPAN_WARNING("It looks like it's been tampered with in some way, and the accelerator vanes seem out of place."))
				if(SHUNT_SABOTAGE_MAJOR)
					to_chat(user, SPAN_WARNING("Light behaves oddly around the core of [src], and it looks to have been tampered with! The vanes are definitely out of place."))
				if(SHUNT_SABOTAGE_CRITICAL)
					to_chat(user, SPAN_DANGER("Light bends around the core of [src] in a manner that eerily reminds you of a singularity... the vanes look completely misaligned!"))
		else
			to_chat(user, SPAN_WARNING("It looks like it's been tampered with, but you're not sure to what extent."))

/obj/machinery/ftl_shunt/core/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/stack/telecrystal))
		var/obj/item/stack/telecrystal/TC = O

		if(TC.amount < 10)
			to_chat(user, SPAN_WARNING("You don't have enough telecrystals to sabotage [src]."))
			return FALSE

		var/tc_input = input(user, "How many telecrystals do you want to put in?", "TC Input", 0) as num|null


		if(QDELETED(user) || user.incapacitated() || !user.Adjacent(src) || !(TC in user.get_held_items()))
			return FALSE

		if(!tc_input)
			return FALSE

		if(TC.amount < tc_input)
			to_chat(user, SPAN_WARNING("You don't have enough telecrystals for that."))
			return FALSE

		to_chat(user, SPAN_DANGER("You begin to insert the crystals into [src]..."))

		if(!do_after(user, 6 SECONDS, src))
			return FALSE

		switch(tc_input)
			if(10 to 24)
				sabotaged = SHUNT_SABOTAGE_MINOR
			if(25 to 49)
				sabotaged = SHUNT_SABOTAGE_MAJOR
			if(50 to INFINITY)
				sabotaged = SHUNT_SABOTAGE_CRITICAL

		sabotaged_amt = tc_input
		TC.use(tc_input)
		to_chat(user, SPAN_DANGER("You successfully sabotage [src] by inserting the crystals!"))
		return TRUE
	. = ..()

/obj/machinery/ftl_shunt/core/physical_attack_hand(var/mob/user)
	if(sabotaged)
		var/mob/living/carbon/human/h_user = user
		if(!istype(h_user))
			return TRUE
		var/skill_delay = user.skill_delay_mult(SKILL_ENGINES, 0.3)
		if(!user.skill_check(SKILL_ENGINES, SKILL_BASIC))
			to_chat(user, SPAN_DANGER("You are nowhere near experienced enough to stick your hand into that thing."))
			return FALSE
		to_chat(user, SPAN_NOTICE("You reach your hand inside of [src] and slowly begin to re-align the accelerator vanes..."))
		if(!do_after(user, (4 SECOND * skill_delay), src))
			to_chat(user, SPAN_DANGER("You try to pull your hand away from the vanes, but you touch a conductor!"))
			h_user.electrocute_act(rand(150,250), src, def_zone = user.get_active_held_item_slot())
			return TRUE
		var/obj/item/stack/telecrystal/TC = new
		TC.amount = sabotaged_amt
		TC.forceMove(get_turf(user))
		user.put_in_hands(TC)
		to_chat(user, SPAN_NOTICE("You remove \the [TC] from \the [src] and realign the accelerator vanes, preventing what could have been a catastrophe."))
		sabotaged = null
		sabotaged_amt = 0
		return TRUE
	. = ..()

//Custom procs.
//Finds fuel ports.
/obj/machinery/ftl_shunt/core/proc/find_ports()
	var/datum/extension/local_network_member/network = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = network.get_local_network()
	if(lan)
		var/list/ports = lan.get_devices(/obj/machinery/ftl_shunt/fuel_port)
		fuel_ports.Cut()
		for(var/obj/machinery/ftl_shunt/fuel_port/FP in ports)
			if(!FP.master)
				FP.master = src
				fuel_ports += FP

//Starts the teleport process, returns 1-6, with 6 being the all-clear.
/obj/machinery/ftl_shunt/core/proc/start_shunt()

	if(isnull(ftl_computer))
		return

	if(isnull(ftl_computer.linked))
		return

	if(stat & BROKEN)
		return FTL_START_FAILURE_BROKEN
	if(stat & NOPOWER)
		return FTL_START_FAILURE_POWER

	if(world.time <= cooldown)
		return FTL_START_FAILURE_COOLDOWN

	if(!length(fuel_ports)) //no fuel ports
		find_ports()
		if(!length(fuel_ports))
			return FTL_START_FAILURE_OTHER

	calculate_jump_requirements()

	if(accumulated_charge < required_charge)
		return FTL_START_FAILURE_POWER
	if(max_charge < required_charge)
		return FTL_START_FAILURE_POWER

	if(required_fuel_joules > get_fuel(fuel_ports))
		return FTL_START_FAILURE_FUEL

	if(sabotaged)
		for(var/mob/living/carbon/human/H in global.living_mob_list_) //Give engineers a hint that something might be very, very wrong.
			if(!(H.z in ftl_computer.linked.map_z))
				continue
			if(H.skill_check(SKILL_ENGINES, SKILL_EXPERT))
				to_chat(H, SPAN_DANGER("The deck vibrates with a harmonic that sets your teeth on edge and fills you with dread."))

	var/announcetxt = replacetext(shunt_start_text, "%%TIME%%", "[round(jump_delay/600)] minutes.")

	ftl_announcement.Announce(announcetxt, "FTL Shunt Management System", new_sound = sound('sound/misc/notice2.ogg'))
	update_icon()

	if(check_charge())
		jump_timer = addtimer(CALLBACK(src, .proc/execute_shunt), jump_delay, TIMER_STOPPABLE)
	return FTL_START_CONFIRMED

/obj/machinery/ftl_shunt/core/proc/calculate_jump_requirements()
	var/obj/effect/overmap/visitable/O = global.overmap_sectors[num2text(z)]
	if(O)
		var/shunt_distance
		var/vessel_mass = ftl_computer.linked.get_vessel_mass()
		var/shunt_turf = locate(shunt_x, shunt_y, O.z)
		shunt_distance = get_dist(get_turf(ftl_computer.linked), shunt_turf)
		required_fuel_joules = (vessel_mass * JOULES_PER_TON) * shunt_distance
		required_charge = required_fuel_joules * REQUIRED_CHARGE_MULTIPLIER

//Cancels the in-progress shunt.
/obj/machinery/ftl_shunt/core/proc/cancel_shunt(var/silent = FALSE)
	if(!jump_timer)
		return
	deltimer(jump_timer)
	charge_time = null
	cooldown = null
	required_fuel_joules = null
	if(!silent)
		ftl_announcement.Announce(shunt_cancel_text, "FTL Shunt Management System", new_sound = sound('sound/misc/notice2.ogg'))
	update_icon()
	jump_timer = null

//Starts the shunt, and then hands off to do_shunt to finish it.
/obj/machinery/ftl_shunt/core/proc/execute_shunt()
	ftl_announcement.Announce(shunt_spooling_text, "FTL Shunt Management System", new_sound = sound('sound/misc/notice2.ogg'))
	if(sabotaged)
		cancel_shunt(TRUE)
		do_sabotage()
		ftl_computer.jump_plotted = FALSE
		return

	if(use_fuel(required_fuel_joules))
		jump_timer = addtimer(CALLBACK(src, .proc/execute_shunt), jump_delay, TIMER_STOPPABLE)
	else
		cancel_shunt()
		return //If for some reason we don't have fuel now, just return.

	var/obj/effect/overmap/visitable/O = global.overmap_sectors[num2text(z)]
	if(O)
		var/destination = locate(shunt_x, shunt_y, O.z)
		var/jumpdist = get_dist(get_turf(ftl_computer.linked), destination)
		var/obj/effect/portal/wormhole/W = new(destination) //Generate a wormhole effect on overmap to give some indication that something is about to happen.
		QDEL_IN(W, 6 SECONDS)
		addtimer(CALLBACK(src, .proc/do_shunt, shunt_x, shunt_y, jumpdist, destination), 6 SECONDS)
		jumping = TRUE
		update_icon()
		for(var/mob/living/carbon/M in global.living_mob_list_)
			if(!(M.z in ftl_computer.linked.map_z))
				continue
			sound_to(M, 'sound/machines/hyperspace_begin.ogg')

/obj/machinery/ftl_shunt/core/proc/do_shunt(var/turfx, var/turfy, var/jumpdist, var/destination) //this does the actual teleportation, execute_shunt is there to give us time to do our fancy effects
	ftl_computer.linked.forceMove(destination)
	ftl_announcement.Announce(shunt_complete_text, "FTL Shunt Management System", new_sound = sound('sound/misc/notice2.ogg'))
	cooldown = world.time + cooldown_delay
	do_effects(jumpdist)
	deltimer(jump_timer)
	jumping = FALSE
	update_use_power(POWER_USE_IDLE)
	accumulated_charge -= required_charge
	jump_timer = null
	ftl_computer.jump_plotted = FALSE

//Handles all the effects of the jump.
/obj/machinery/ftl_shunt/core/proc/do_effects(var/distance) //If we're jumping too far, have some !!FUN!! with people and ship systems.
	var/shunt_sev
	if(distance < safe_jump_distance)
		shunt_sev = SHUNT_SEVERITY_MINOR
	else if(distance < moderate_jump_distance)
		shunt_sev = SHUNT_SEVERITY_MAJOR
	else
		shunt_sev = SHUNT_SEVERITY_CRITICAL

	for(var/mob/living/carbon/human/H in global.living_mob_list_) //Affect mobs, skip synthetics.
		sound_to(H, 'sound/machines/hyperspace_end.ogg')

		if(!(H.z in ftl_computer.linked.map_z))
			continue

		handle_spacefloat(H)

		if(isnull(H) || QDELETED(H))
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
					H.set_hallucination(50, 50)
				if(prob(15))
					H.vomit()
				shake_camera(H, 2, 1)

			if(SHUNT_SEVERITY_CRITICAL)
				to_chat(H, SPAN_DANGER("You feel an overwhelming sense of nausea and vertigo wash over you, your instincts screaming that something is wrong!"))
				if(prob(50))
					H.set_hallucination(100, 100)
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

/obj/machinery/ftl_shunt/core/proc/handle_spacefloat(var/mob/living/carbon/human/H)
	if(!H.check_space_footing())
		 //Flip a coin ...
		to_chat(H, SPAN_WARNING("Being untethered from a ship entering FTL is a bad idea, but you roll the dice..."))
		if(prob(50))
			to_chat(H, SPAN_NOTICE("and win, surviving the energy dancing over your body. Not unharmed, however."))
			H.apply_damage(300, IRRADIATE, damage_flags = DAM_DISPERSED)
			return
		else
			to_chat(H, SPAN_DANGER("and lose, being ripped apart in a nanosecond by energies beyond comprehension."))
			H.gib()

/obj/machinery/ftl_shunt/core/proc/do_sabotage()
	var/announcetxt

	switch(sabotaged)
		if(SHUNT_SABOTAGE_MINOR)
			announcetxt = shunt_sabotage_text_minor
			for(var/mob/living/carbon/human/H in view(7))
				H.show_message(SPAN_DANGER("\The [src] emits a flash of incredibly bright, searing light!"), VISIBLE_MESSAGE)
				H.flash_eyes(FLASH_PROTECTION_NONE)
			empulse(src, 8, 10)

		if(SHUNT_SABOTAGE_MAJOR)
			announcetxt = shunt_sabotage_text_major

			visible_message(SPAN_DANGER("\The [src] hisses and sparks, before the coolant lines burst and spew superheated coolant!")) //Effect One: scary text.

			explosion(get_turf(src),-1,-1,8,10) //Effect Two: blow the windows out.

			for(var/obj/machinery/power/apc/A in SSmachines.machinery) //Effect Three: shut down power across the ship.
				if(!(A.z in ftl_computer.linked.map_z))
					continue
				A.energy_fail(rand(60,80))

		if(SHUNT_SABOTAGE_CRITICAL)
			announcetxt = shunt_sabotage_text_critical

			for(var/obj/machinery/power/apc/A in SSmachines.machinery) //Effect One: shut down power across the ship.
				if(!(A.z in ftl_computer.linked.map_z))
					continue
				A.energy_fail(rand(100,120))

			for(var/mob/living/carbon/human/H in view(7)) //scary text if you're in view, because you're fucked now boy.
				H.show_message(SPAN_DANGER("The light around \the [src] warps before it emits a flash of incredibly bright, searing light!"), VISIBLE_MESSAGE)
				H.flash_eyes(FLASH_PROTECTION_NONE)

			new /obj/effect/singularity/(get_turf(src))


	ftl_announcement.Announce(announcetxt, "FTL Shunt Management System", new_sound = sound('sound/misc/ftlsiren.ogg'))


//Returns status to ftl computer.
/obj/machinery/ftl_shunt/core/proc/get_status()
	if(stat & (BROKEN|NOPOWER))
		return FTL_STATUS_OFFLINE
	if(cooldown)
		return FTL_STATUS_COOLDOWN
	if(jump_timer)
		return FTL_STATUS_SPOOLING_UP
	else
		return FTL_STATUS_GOOD

/obj/machinery/ftl_shunt/core/proc/get_fuel(var/list/input)
	. = 0
	for(var/obj/machinery/ftl_shunt/fuel_port/F in input)
		. += F.get_fuel_joules(FALSE)

/obj/machinery/ftl_shunt/core/proc/get_fuel_maximum(var/list/input)
	. = 0
	for(var/obj/machinery/ftl_shunt/fuel_port/F in input)
		. += F.get_fuel_joules(TRUE)

/obj/machinery/ftl_shunt/core/proc/fuelpercentage()
	if(!length(fuel_ports))
		return 0
	var/fuel_max = get_fuel_maximum(fuel_ports)
	if(fuel_max == 0)
		return 0
	return round(100.0*get_fuel(fuel_ports)/fuel_max, 0.1)


/obj/machinery/ftl_shunt/core/proc/use_fuel(var/joules_req)
	var/avail_fuel = get_fuel(fuel_ports)

	if(joules_req > avail_fuel) //Not enough fuel in the system.
		return FALSE

	var/list/fueled_ports = list()
	var/total_joules
	var/joules_per_port
	var/joule_debt

	for(var/obj/machinery/ftl_shunt/fuel_port/F in fuel_ports) //Step one, loop through ports, sort them by those who are fully fueled and those that are not.
		if(!F.has_fuel())
			continue
		fueled_ports += F

	joules_per_port = (joules_req / length(fueled_ports))

	for(var/obj/machinery/ftl_shunt/fuel_port/F in fueled_ports) //Loop through all our ports, use fuel from those that have enough and those that are partially empty.
		if(F.get_fuel_joules() >= joules_per_port) //Enough fuel in this one!
			if(F.use_fuel_joules(joules_per_port))
				total_joules += joules_per_port
				continue
		else //Not enough fuel in this port to meet the per-port quota - take as much as we can and pick up the slack with others.
			var/available_fuel = F.get_fuel_joules()
			if(F.use_fuel_joules(available_fuel))
				total_joules += available_fuel
				joule_debt += joules_per_port - available_fuel
				fueled_ports -= F //Remove this one from the pool of avaliable ports, since it's used up.
				continue

	if(total_joules == joules_req)
		return TRUE //All ports supplied enough fuel first go around, return early.

	if(joule_debt) //We haven't rallied up enough energy for the jump, probably from ports that were only partially fueled.
		var/fuel_debt_spread = joule_debt / length(fueled_ports)
		for(var/obj/machinery/ftl_shunt/fuel_port/F in fueled_ports) //Loop through all our ports, use fuel from those that have enough and those that are partially empty.
			if(F.get_fuel_joules() >= fuel_debt_spread) //Enough fuel in this one!
				if(F.use_fuel_joules(fuel_debt_spread))
					total_joules += fuel_debt_spread
					continue
			else //Not enough fuel in this port to meet the per-port quota - take as much as we can and pick up the slack with others.
				var/available_fuel_debt = F.get_fuel_joules()
				if(F.use_fuel_joules(available_fuel_debt))
					total_joules += available_fuel_debt
					joule_debt -= available_fuel_debt
					continue

	if(total_joules == joules_req && !joule_debt)
		return TRUE

/obj/machinery/ftl_shunt/core/proc/get_charge_time()
	if(isnull(last_power_drawn))
		return "UNKNOWN"
	return "[clamp(round((target_charge-accumulated_charge)/((last_power_drawn*CELLRATE) * 1 SECOND / SSmachines.wait), 0.1),0, INFINITY)] Seconds"

/obj/machinery/ftl_shunt/core/proc/check_charge()
	if(accumulated_charge >= required_charge)
		return TRUE

/obj/machinery/ftl_shunt/core/proc/draw_charge(var/input)
	if(stat & NOPOWER)
		return FALSE

	var/drawn_charge = use_power_oneoff(input)
	last_power_drawn = drawn_charge
	accumulated_charge += drawn_charge * CELLRATE

	return TRUE

/obj/machinery/ftl_shunt/core/proc/get_total_fuel_conversion_rate()
	var/rate
	for(var/obj/machinery/ftl_shunt/fuel_port/F in fuel_ports)
		rate += F.get_fuel_conversion_rate()
	. = round((rate / length(fuel_ports)), 0.1)


/obj/machinery/ftl_shunt/core/Process()
	if(stat & (BROKEN|NOPOWER))
		return
	update_icon()

	if(charging)
		if(accumulated_charge < target_charge)
			draw_charge(allowed_power_usage)
			accumulated_charge = clamp(accumulated_charge, 0, max_charge)
		SSradiation.radiate(src, (active_power_usage / 1000))
	chargepercent = round(100*(accumulated_charge/max_charge), 0.1)

/obj/machinery/ftl_shunt/fuel_port
	name = "superluminal shunt fuel port"
	desc = "A fuel port for an FTL shunt."
	icon_state = "empty"

	var/static/list/fuels = list(
		/decl/material/gas/hydrogen/tritium = 25000,
		/decl/material/gas/hydrogen/deuterium = 25000,
		/decl/material/gas/hydrogen = 25000,
		/decl/material/solid/exotic_matter = 50000
		)
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
	. = ..()

/obj/machinery/ftl_shunt/fuel_port/modify_mapped_vars(map_hash)
	..()
	ADJUST_TAG_VAR(initial_id_tag, map_hash)

/obj/machinery/ftl_shunt/fuel_port/Destroy()
	. = ..()
	if(master)
		master.fuel_ports -= src
	master = null
	QDEL_NULL(fuel)

/obj/machinery/ftl_shunt/fuel_port/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/fuel_assembly))
		if(!fuel)
			if(!do_after(user, 2 SECONDS, src) || fuel)
				return
			if(!user || !user.try_unequip(O, src))
				return
			fuel = O
			max_fuel = get_fuel_joules(TRUE)
			update_icon()
			return TRUE

	. = ..()

/obj/machinery/ftl_shunt/fuel_port/physical_attack_hand(var/mob/user)
	if(fuel)
		to_chat(user, SPAN_NOTICE("You begin to remove the fuel assembly from [src]..."))
		if(!do_after(user, 2 SECONDS, src) || !fuel || fuel.loc != src)
			return FALSE
		fuel.dropInto(loc)
		user.put_in_hands(fuel)
		fuel = null
		max_fuel = 0
		to_chat(user, SPAN_NOTICE("You remove the fuel assembly!"))
		return TRUE

	. = ..()

/obj/machinery/ftl_shunt/fuel_port/proc/has_fuel()
	return !!fuel

/obj/machinery/ftl_shunt/fuel_port/proc/get_fuel_joules(var/get_fuel_maximum)
	if(fuel)
		for(var/G in fuel.matter)
			if(G in fuels)
				. += (get_fuel_maximum ? 10000 : fuel.matter[G]) * fuels[G]

/obj/machinery/ftl_shunt/fuel_port/proc/get_fuel_conversion_rate() //This is mostly a fluff proc, since internally everything is done in joules.
	if(fuel)
		for(var/G in fuel.matter)
			if(G in fuels)
				. = fuels[G]

/obj/machinery/ftl_shunt/fuel_port/proc/use_fuel_joules(var/joules)
	if(!fuel)
		return FALSE

	for(var/G in fuel.matter)
		if(G in fuels)
			var/fuel_to_use = joules / fuels[G]
			fuel.matter[G] -= fuel_to_use

	return TRUE

//
// Construction MacGuffins down here.
//

/obj/item/stock_parts/circuitboard/ftl_shunt
	name = "circuit board (superluminal shunt)"
	board_type = "machine"
	build_path = /obj/machinery/ftl_shunt/core
	origin_tech = "{'programming':3,'magnets':5,'materials':5,'wormholes':5}"
	additional_spawn_components = list(/obj/item/stock_parts/power/terminal = 1)

/obj/item/stock_parts/ftl_core
	name = "exotic matter bridge"
	desc = "The beating heart of a superluminal shunt - without this, the power to manipulate space-time is out of reach."
	origin_tech = "{'programming':3,'magnets':5,'materials':5,'wormholes':5}"
	icon = 'icons/obj/items/stock_parts/stock_parts.dmi'
	icon_state = "smes_coil"
	color = COLOR_YELLOW
	matter = list(/decl/material/solid/exotic_matter = MATTER_AMOUNT_REINFORCEMENT, /decl/material/solid/metal/plasteel = MATTER_AMOUNT_PRIMARY)
