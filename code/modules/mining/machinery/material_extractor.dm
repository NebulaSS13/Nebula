//Machine meant to extra gases from hydrates
// Input is clockwise east, output clockwise west, gas output clockwise south
// The general concept is that it heats up things up to 20c and grabs anything gaseous or liquid at that temp range, with a debuff on liquids, so it doesn't replace more specialized machines.
#define GAS_EXTRACTOR_GAS_TANK 1000
#define GAS_EXTRACTOR_REAGENTS_TANK 500
#define GAS_EXTRACTOR_EXTRACTION_RATE 0.5 //units per tick
#define GAS_EXTRACTOR_OPERATING_TEMP T20C + 1 //Temperature the machine heat stuff to.. Has to be 20c + 1 because someone decided ice melted at 20c
#define GAS_EXTRACTOR_LIQUID_EFFICIENCY 0.75 //% efficiency for liquids
#define GAS_EXTRACTOR_WAIT_TIME_DUMP 1 SECONDS //Wait at least that many seconds after inserting something for the machine to dump the result. So reactions happens

//TODO: Sprite work?

GLOBAL_LIST_INIT(material_extractor_items_whitelist, list(/obj/item/ore))

/obj/machinery/atmospherics/unary/material/extractor
	name = "Gas extractor"
	desc = "A machine for extracting liquids and gases from ices and hydrates."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "extractor"
	layer = MOB_LAYER+1 // Overhead
	density = 1

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
	var/time_last_bark = 0 //time since the machine said anything last
	var/obj/item/chems/output_container //#TODO: change this when plumbing is a thing

/obj/machinery/atmospherics/unary/material/extractor/Initialize(mapload, d = 0, populate_parts = TRUE)
	. = ..()
	if(populate_parts)
		output_container = new/obj/item/chems/glass/bucket(src)
	air_contents.volume = GAS_EXTRACTOR_GAS_TANK
	if(!reagents)
		create_reagents(GAS_EXTRACTOR_REAGENTS_TANK)
	QUEUE_TEMPERATURE_ATOMS(src)

/obj/machinery/atmospherics/unary/material/extractor/Bumped(var/obj/O)
	//Ignore if we can't function
	if(inoperable())
		return
	
	//Sanity filter
	if(O.pass_flags > PASS_FLAG_TABLE || O.anchored)
		return

	//Only handles entities touching the machine from the input's direction only
	if(get_dir(loc, O.loc) == get_input_dir())
		//try processing
		if(process_ore(O))
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
	if(output_container)
		to_chat(user, SPAN_NOTICE("It has a [output_container.name]."))
	else 
		to_chat(user, SPAN_NOTICE("It has nothing to pour reagents into."))

/obj/machinery/atmospherics/unary/material/extractor/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/chems))
		add_fingerprint(user)
		if(!output_container)
			if(!user.unEquip(I, src))
				return
			output_container = I
			user.visible_message(SPAN_NOTICE("\The [user] place \a [I] in \the [src]."), SPAN_NOTICE("You place \a [I] in \the [src]."))
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

/obj/machinery/atmospherics/unary/material/extractor/power_change()
	. = ..()
	QUEUE_TEMPERATURE_ATOMS(src)

/obj/machinery/atmospherics/unary/material/extractor/on_update_icon()
	. = ..()
	icon_state = initial(icon_state)
	if(!use_power || inoperable())
		icon_state = "[icon_state]-off"

/obj/machinery/atmospherics/unary/material/extractor/get_contained_external_atoms()
	return output_container? (..() - output_container) : ..() //This prevents the machine from eating the bucket....

/obj/machinery/atmospherics/unary/material/extractor/Process()
	. = ..()
	if(has_content_to_process())
		update_use_power(POWER_USE_ACTIVE)
		//Process anything we accepted into our internal buffer
		extract(get_contained_external_atoms())
	else
		update_use_power(POWER_USE_IDLE)

	if(reagents?.total_volume > 0 && (world.time >= (time_last_input + GAS_EXTRACTOR_WAIT_TIME_DUMP)))
		dump_result()

//For some reasons that's not in the unary base class...
/obj/machinery/atmospherics/unary/material/extractor/return_air()
	return air_contents

/obj/machinery/atmospherics/unary/material/extractor/proc/has_content_to_process()
	return count_items_processing() > 0

/obj/machinery/atmospherics/unary/material/extractor/proc/can_process(var/obj/O)
	if(istype(O) && is_type_in_list(O, GLOB.material_extractor_items_whitelist) && (count_items_processing() < max_items))
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
	//If is gas or liquid at STP we can process
	var/phase = M.phase_at_temperature(temperature)
	return phase == MAT_PHASE_LIQUID || phase == MAT_PHASE_GAS

/obj/machinery/atmospherics/unary/material/extractor/proc/count_items_processing()
	return length(get_contained_external_atoms())

//Add ore to processing queue
/obj/machinery/atmospherics/unary/material/extractor/proc/process_ore(var/obj/O)
	if(!can_process(O))
		return FALSE
	O.forceMove(src)
	return TRUE

/obj/machinery/atmospherics/unary/material/extractor/proc/extract(var/list/obj/L)
	for(var/obj/O in L)
		for(var/k in O.matter)
			//Don't process over our internal buffer
			if(reagents.total_volume < reagents.maximum_volume)
				var/matter_units_removed = O.matter[k] * 1
				var/reagent_units = Floor(matter_units_removed * REAGENT_UNITS_PER_MATERIAL_UNIT)
				reagents.add_reagent(k, reagent_units)
				O.matter[k] -= matter_units_removed
				if(O.matter[k] <= 0)
					O.matter -= k
		if(length(O.matter) < 1)
			qdel(O)	//Clean up any empty ores
	reagents.process_reactions() //Force reactions to happen so things are sorted properly before being dumped...

/obj/machinery/atmospherics/unary/material/extractor/proc/dump_result()
	for(var/mat in reagents?.reagent_volumes)
		var/decl/material/M = GET_DECL(mat)
		switch(M.phase_at_temperature(temperature))
			if(MAT_PHASE_SOLID)
				dump_solid(M)
			if(MAT_PHASE_LIQUID)
				dump_liquid(M)
			if(MAT_PHASE_GAS || MAT_PHASE_PLASMA)
				dump_gas(M)

/obj/machinery/atmospherics/unary/material/extractor/proc/dump_solid(var/decl/material/M)
	//Check if we got enough to dump out a single sheet at least
	if(!reagents.has_reagent(M.type, REAGENT_UNITS_PER_MATERIAL_SHEET))
		return
	
	var/available_volume = REAGENT_VOLUME(reagents, M.type)
	var/expected_sheets = round(available_volume / REAGENT_UNITS_PER_MATERIAL_SHEET)
	var/removed_volume = expected_sheets * REAGENT_UNITS_PER_MATERIAL_SHEET
	M.place_sheet(get_output_loc(), expected_sheets)
	reagents.remove_reagent(M.type, removed_volume)

/obj/machinery/atmospherics/unary/material/extractor/proc/dump_liquid(var/decl/material/M)
	if(!reagents.has_reagent(M.type, 0.1) || !output_container)
		return
	var/available_volume = REAGENT_VOLUME(reagents, M.type)
	reagents.trans_to(output_container, available_volume, GAS_EXTRACTOR_LIQUID_EFFICIENCY)

/obj/machinery/atmospherics/unary/material/extractor/proc/dump_gas(var/decl/material/M)
	if(!reagents.has_reagent(M.type, 0.1))
		return
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
	var/const/MOLES_PER_MILILITER_FACTOR = 0.553 //placeholder until we can do this properly via phase transitions
	var/datum/gas_mixture/produced = new
	var/available_volume = REAGENT_VOLUME(reagents, M.type)
	var/moles = available_volume * MOLES_PER_MILILITER_FACTOR
	reagents.remove_reagent(M.type, available_volume)
	produced.adjust_gas(M.type, moles)
	air_contents.merge(produced)

/obj/machinery/atmospherics/unary/material/extractor/proc/get_output_loc()
	return get_step(loc, get_output_dir())
/obj/machinery/atmospherics/unary/material/extractor/proc/get_output_dir()
	return turn(dir, 90)
/obj/machinery/atmospherics/unary/material/extractor/proc/get_input_dir()
	return turn(dir, -90)

#undef GAS_EXTRACTOR_GAS_TANK 
#undef GAS_EXTRACTOR_REAGENTS_TANK
#undef GAS_EXTRACTOR_EXTRACTION_RATE
#undef GAS_EXTRACTOR_OPERATING_TEMP
#undef GAS_EXTRACTOR_LIQUID_EFFICIENCY
#undef GAS_EXTRACTOR_WAIT_TIME_DUMP