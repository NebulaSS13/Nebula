//Machine meant to extra gases from hydrates
// Input is clockwise east, output clockwise west, gas output clockwise south
// The general concept is that it heats up things up to 20c and grabs anything gaseous or liquid at that temp range, with a debuff on liquids, so it doesn't replace more specialized machines.
#define GAS_EXTRACTOR_GAS_TANK 1000
#define GAS_EXTRACTOR_REAGENTS_TANK 500
#define GAS_EXTRACTOR_EXTRACTION_RATE 0.5 //units per tick
#define GAS_EXTRACTOR_OPERATING_TEMP T20C + 5 //Temperature the machine heat stuff to.. Has to be 20c + 5 because someone decided ice melted at 20c
#define GAS_EXTRACTOR_LIQUID_EFFICIENCY 0.75 //% efficiency for liquids
#define GAS_EXTRACTOR_MIN_REAGENT_AMOUNT 0.1 //Minimum amount of reagents units we tolerate in the machine to keep things clean

#define GAS_EXTRACTOR_WAIT_TIME_DUMP 4 SECONDS //Wait at least that many seconds after inserting something for the machine to dump the result. So reactions happens
#define GAS_EXTRACTOR_WAIT_TIME_EXTRACT 1 SECONDS 

//TODO: Sprite work?

GLOBAL_LIST_INIT(material_extractor_items_whitelist, list(/obj/item/ore))

/obj/machinery/atmospherics/unary/material/extractor
	name = "Gas extractor"
	desc = "A machine for extracting liquids and gases from ices and hydrates."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "extractor"
	layer = MOB_LAYER+1 // Overhead
	density = 1

	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT //We wanna disable those to trigger reactions on our own terms
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE
	use_power = POWER_USE_OFF
	idle_power_usage = 25
	power_rating = 1 KILOWATTS
	power_channel = EQUIP
	connect_types = CONNECT_TYPE_REGULAR

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/default/panel_closed
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES
	maximum_component_parts = list(/obj/item/stock_parts = 10, /obj/item/chems = 1)

	var/const/max_items = 25 //Max amount of items it can process at the same time
	var/time_last_input = 0 //Time since an item was processed, used to wait a bit for reactions to happen
	var/time_last_extract = 0 //Time since we last extracted an item. Needed because otherwise the extraction code gets called a lot for small quantities of currently reacting reagents
	var/time_last_bark = 0 //time since the machine said anything last
	var/obj/item/chems/glass/output_container //#TODO: change this when plumbing is a thing

/obj/machinery/atmospherics/unary/material/extractor/Initialize(mapload, d = 0, populate_parts = TRUE)
	. = ..()
	if(populate_parts)
		output_container = new/obj/item/chems/glass/bucket(src)
	air_contents.volume = GAS_EXTRACTOR_GAS_TANK
	if(!reagents)
		create_reagents(GAS_EXTRACTOR_REAGENTS_TANK)
	verbs |= /obj/machinery/atmospherics/unary/material/verb/FlushReagents
	verbs |= /obj/machinery/atmospherics/unary/material/verb/FlushGas
	// QUEUE_TEMPERATURE_ATOMS(src)

/obj/machinery/atmospherics/unary/material/extractor/Bumped(var/obj/O)
	//Ignore if we can't function
	if(inoperable())
		return ..()
	
	//Sanity filter
	if(O.pass_flags > PASS_FLAG_TABLE || O.anchored || count_items_processing() >= max_items) //Don't let items beyond capacity pass through
		return ..()

	//Only handles entities touching the machine from the input's direction only
	if(get_dir(loc, O.loc) == get_input_dir())
		//try adding to the processing list
		if(add_ore_to_queue(O))
			time_last_input = world.time
		else
			//Reject stuff that we cannot process
			O.dropInto(get_output_loc())
			if(world.time > (time_last_bark + 4 SECONDS))
				time_last_bark = world.time
				state("\The [O.name] was rejected for processing!")
	else
		return ..()

/obj/machinery/atmospherics/unary/material/extractor/ProcessAtomTemperature()
	if(operable() && use_power)
		temperature = GAS_EXTRACTOR_OPERATING_TEMP
		return TRUE
	return ..()

/obj/machinery/atmospherics/unary/material/extractor/examine(var/mob/user)
	. = ..()
	var/items_processing = count_items_processing()
	if(output_container)
		var/full_text
		if(REAGENTS_FREE_SPACE(reagents) <= 0)
			full_text = " Currently idling because its internal tanks are full.."
		to_chat(user, SPAN_NOTICE("Its currently processing [items_processing] items.[full_text]"))

	if(output_container)
		var/bucket_text
		if(is_output_container_full())
			bucket_text = " It looks full!"
		to_chat(user, SPAN_NOTICE("It has a [output_container.name] in place to receive reagents.[bucket_text]"))
	else 
		to_chat(user, SPAN_NOTICE("It has nothing to pour reagents into."))

	if(reagents)
		to_chat(user, SPAN_NOTICE("The internal liquid tank gauge reads [round(reagents.total_volume)]/[reagents.maximum_volume]"))

/obj/machinery/atmospherics/unary/material/extractor/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/chems/glass))
		add_fingerprint(user)
		if(!output_container)
			if(!user.unEquip(I, src))
				return
			output_container = I
			user.visible_message(SPAN_NOTICE("\The [user] place \a [I] in \the [src]."), SPAN_NOTICE("You place \a [I] in \the [src]."))
			update_icon()
		return TRUE
	return ..()

/obj/machinery/atmospherics/unary/material/extractor/physical_attack_hand(var/mob/user)
	if(output_container)
		user.put_in_hands(output_container)
		output_container.update_icon()
		output_container = null
		update_icon()
		return TRUE
	return ..()

// /obj/machinery/atmospherics/unary/material/extractor/power_change()
// 	. = ..()
// 	QUEUE_TEMPERATURE_ATOMS(src)

/obj/machinery/atmospherics/unary/material/extractor/on_update_icon()
	. = ..()
	icon_state = initial(icon_state)
	if(!use_power || inoperable())
		icon_state = "[icon_state]-off"
	//#TODO: add panel open state overlay
	//#TODO: add reagent container overlay

/obj/machinery/atmospherics/unary/material/extractor/Process()
	..()
	if(has_content_to_process())
		update_use_power(POWER_USE_ACTIVE)
		//Process anything we accepted into our internal buffer
		if(world.time >= time_last_extract + GAS_EXTRACTOR_WAIT_TIME_EXTRACT)
			extract(get_contained_external_atoms())
			time_last_extract = world.time
	else
		update_use_power(POWER_USE_IDLE)

	if(reagents?.total_volume > 0 && (world.time >= (time_last_input + GAS_EXTRACTOR_WAIT_TIME_DUMP)))
		force_process_reagents()
		dump_result()

//For some reasons that's not in the unary base class...
/obj/machinery/atmospherics/unary/material/extractor/return_air()
	return air_contents

/obj/machinery/atmospherics/unary/material/extractor/get_contained_external_atoms()
	return output_container? (..() - output_container) : ..() //This prevents the machine from eating the bucket....

/obj/machinery/atmospherics/unary/material/extractor/proc/count_items_processing()
	return length(get_contained_external_atoms())

/obj/machinery/atmospherics/unary/material/extractor/proc/has_content_to_process()
	return count_items_processing() > 0

/obj/machinery/atmospherics/unary/material/extractor/proc/output_container_free_volume()
	return output_container? round(max(REAGENTS_FREE_SPACE(output_container.reagents), 0), GAS_EXTRACTOR_MIN_REAGENT_AMOUNT) : 0

/obj/machinery/atmospherics/unary/material/extractor/proc/is_output_container_full()
	return output_container_free_volume() <= 0

/obj/machinery/atmospherics/unary/material/extractor/proc/is_buffer_full()
	return round(REAGENTS_FREE_SPACE(reagents), GAS_EXTRACTOR_MIN_REAGENT_AMOUNT) <= 0

/obj/machinery/atmospherics/unary/material/extractor/proc/can_process(var/obj/O)
	if(istype(O) && is_type_in_list(O, GLOB.material_extractor_items_whitelist))
		for(var/k in O.matter)
			var/decl/material/M = GET_DECL(k)
			ASSERT(istype(M))
			if(is_material_extractable(M) || has_extractable_heating_products(M))
				return TRUE
	return FALSE

/obj/machinery/atmospherics/unary/material/extractor/proc/has_extractable_heating_products(var/decl/material/M)
	for(var/k in M.heating_products)
		var/decl/material/P = GET_DECL(k)
		ASSERT(istype(P))
		if(is_material_extractable(P))
			return TRUE
	return FALSE

/obj/machinery/atmospherics/unary/material/extractor/proc/is_material_extractable(var/decl/material/M)
	//If is gas or liquid at operating temp we can process
	var/phase = M.phase_at_temperature(temperature)
	return phase == MAT_PHASE_LIQUID || phase == MAT_PHASE_GAS

//Add ore to contents for processing
/obj/machinery/atmospherics/unary/material/extractor/proc/add_ore_to_queue(var/obj/O)
	if(!can_process(O))
		return FALSE
	O.forceMove(src)
	return TRUE

//Since the process_reaction proc isn't guaranteed to process reactions in time, we have to beat it with a stick
/obj/machinery/atmospherics/unary/material/extractor/proc/force_process_reagents()
	atom_flags &= ~(ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT)
	. = reagents.process_reactions()
	atom_flags |= ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT

/obj/machinery/atmospherics/unary/material/extractor/proc/extract(var/list/obj/L)
	//No point processing anything if the processing buffer is full
	if(is_buffer_full())
		log_debug("EXTRACTING : BUFFER FULL")
		return 

	for(var/obj/O in L)
		var/free_volume = round(REAGENTS_FREE_SPACE(reagents), GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)
		if(free_volume <= 0)
			break
		for(var/k in O.matter)
			free_volume = round(REAGENTS_FREE_SPACE(reagents), GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)
			//Don't process over our internal buffer
			if(free_volume <= 0)
				break
			var/matter_units_removed = round(min(O.matter[k], free_volume / REAGENT_UNITS_PER_MATERIAL_UNIT), GAS_EXTRACTOR_MIN_REAGENT_AMOUNT) //Removed only what can be stored
			var/reagent_units = round(matter_units_removed * REAGENT_UNITS_PER_MATERIAL_UNIT, GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)
			reagents.add_reagent(k, reagent_units)
			log_debug("EXTRACTING : added [reagent_units] units of [k] to internal tank with [free_volume] units of free space")

			//Since we might have to extract over several ticks, if our internal tank is full. So we just subtract it from the matter list of the ore
			O.matter[k] -= matter_units_removed
			if(round(O.matter[k], 0.1) <= 0)
				O.matter -= k

		if(length(O.matter) < 1)
			qdel(O)	//Clean up any ores empty of matter

/obj/machinery/atmospherics/unary/material/extractor/proc/dump_result()
	//Only dump when everything in the tank is processed
	if(SSmaterials.active_holders[reagents])
		return

	for(var/mat in reagents?.reagent_volumes)
		var/decl/material/M = GET_DECL(mat)
		var/available_volume = round(REAGENT_VOLUME(reagents, M.type), GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)
		
		//Don't bother if we got a really small quatity, and just get rid of it
		if(available_volume < GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)
			reagents.clear_reagent(M.type)
			continue

		switch(M.phase_at_temperature(temperature))
			if(MAT_PHASE_SOLID)
				dump_solid(M, available_volume)
			if(MAT_PHASE_LIQUID)
				dump_liquid(M, available_volume)
			if(MAT_PHASE_GAS)
				dump_gas(M, available_volume)
			if(MAT_PHASE_PLASMA)
				dump_gas(M, available_volume)

/obj/machinery/atmospherics/unary/material/extractor/proc/dump_solid(var/decl/material/M, var/available_volume)
	//Check if we got enough to dump out a single sheet at least
	if(available_volume < REAGENT_UNITS_PER_MATERIAL_SHEET)
		return
	var/expected_sheets = round(available_volume / REAGENT_UNITS_PER_MATERIAL_SHEET)
	var/removed_volume = round(expected_sheets * REAGENT_UNITS_PER_MATERIAL_SHEET, GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)
	M.place_sheet(get_output_loc(), expected_sheets)
	reagents.remove_reagent(M.type, removed_volume)

/obj/machinery/atmospherics/unary/material/extractor/proc/dump_liquid(var/decl/material/M, var/available_volume)
	if(!output_container)
		return
	var/free_volume = output_container_free_volume()
	if(free_volume <= 0)
		log_debug("dump_liquid: No free volume in output container to dump liquid to. Free volume: [free_volume] units")
		return
	var/transferred = max(min(available_volume, free_volume), 0)
	if(transferred > 0)
		reagents.trans_to(output_container, transferred, GAS_EXTRACTOR_LIQUID_EFFICIENCY)
		log_debug("dump_liquid : dumping [round(transferred * GAS_EXTRACTOR_LIQUID_EFFICIENCY)] units of [M.type] to container with [free_volume] units of free space")

//We want to convert a liquid to its gaseous state
//So we want to convert liquid units to moles.
// We need: 
//	the volume of liquid
//	the density of the liquid
//	the molar mass of the liquid
//
//Since we have none of those currently in the material datum, just assume everything is water
// Density: 997.07 g/L 
// Molar Mass: 18.02 g/mol
//We'll assume a unit of reagent is 1 mL, so we'll divide the density by 1,000. We get 0.99707
// 0.99707 / 18.02 => 0.553 mol/ml
#define MOLES_PER_MILILITER_FACTOR 0.553 //placeholder until we can do this properly via phase transitions
/obj/machinery/atmospherics/unary/material/extractor/proc/dump_gas(var/decl/material/M, var/available_volume)
	var/datum/gas_mixture/produced = new
	var/moles = round(available_volume * MOLES_PER_MILILITER_FACTOR, GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)
	reagents.remove_reagent(M.type, available_volume)
	produced.adjust_gas(M.type, moles)
	air_contents.merge(produced)
#undef MOLES_PER_MILILITER_FACTOR

/obj/machinery/atmospherics/unary/material/extractor/proc/get_output_loc()
	return get_step(loc, get_output_dir())
/obj/machinery/atmospherics/unary/material/extractor/proc/get_output_dir()
	return turn(dir, 90)
/obj/machinery/atmospherics/unary/material/extractor/proc/get_input_dir()
	return turn(dir, -90)

/obj/machinery/atmospherics/unary/material/verb/FlushReagents()
	set name = "Flush Reagents Tank"
	set desc = "Empty the content of the internal reagent tank of the machine on the floor."
	set category = "Object"
	set src in oview(1)
	usr.visible_message(SPAN_NOTICE("[usr] empties the liquid tank of \the [src] onto \the [src.loc]!"), SPAN_NOTICE("You empty the liquid tank of the [src] onto \the [src.loc]!"))
	src.reagents.trans_to(src.loc, reagents.total_volume)

/obj/machinery/atmospherics/unary/material/verb/FlushGas()
	set name = "Flush Gas Tank"
	set desc = "Empty the content of the internal gas tank of the machine into the air."
	set category = "Object"
	set src in oview(1)
	usr.visible_message(SPAN_NOTICE("[usr] empties the gas tank of \the [src] into the air!"), SPAN_NOTICE("You empty the gas tank of the [src] into the air!"))
	var/datum/gas_mixture/environment = src.loc.return_air()
	environment.merge(src.air_contents)
	//Reset air content
	src.air_contents = new/datum/gas_mixture(GAS_EXTRACTOR_GAS_TANK, temperature)

#undef GAS_EXTRACTOR_GAS_TANK 
#undef GAS_EXTRACTOR_REAGENTS_TANK
#undef GAS_EXTRACTOR_EXTRACTION_RATE
#undef GAS_EXTRACTOR_OPERATING_TEMP
#undef GAS_EXTRACTOR_LIQUID_EFFICIENCY
#undef GAS_EXTRACTOR_MIN_REAGENT_AMOUNT
#undef GAS_EXTRACTOR_WAIT_TIME_DUMP
#undef GAS_EXTRACTOR_WAIT_TIME_EXTRACT
