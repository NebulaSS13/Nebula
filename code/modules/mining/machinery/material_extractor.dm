//Machine meant to extra gases from hydrates
// Input is clockwise east, output clockwise west, gas output clockwise south
// The general concept is that it heats up things up to 20c and grabs anything gaseous or liquid at that temp range, with a debuff on liquids, so it doesn't replace more specialized machines.
#define GAS_EXTRACTOR_GAS_TANK 1000
#define GAS_EXTRACTOR_REAGENTS_TANK 500
#define GAS_EXTRACTOR_REAGENTS_INPUT_TANK 500
#define GAS_EXTRACTOR_OPERATING_TEMP T20C + 5 //Temperature the machine heat stuff to.. Has to be 20c + 5 because someone decided ice melted at 20c
#define GAS_EXTRACTOR_LIQUID_EFFICIENCY 0.75 //% efficiency for liquids
#define GAS_EXTRACTOR_MIN_REAGENT_AMOUNT 0.1 //Minimum amount of reagents units we tolerate in the machine to keep things clean

//Whitelist of items that can be processed by the machine
var/global/list/material_extractor_items_whitelist = list(/obj/item/stack/material/ore)

////////////////////////////////////////////////////
// Holder for the reagents_holder.
// Since reagents_holder can't exist on its own for some reasons
////////////////////////////////////////////////////
/obj/input_holder
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT //We wanna disable those to trigger reactions on our own terms

////////////////////////////////////////////////////
// Actual machine
////////////////////////////////////////////////////
/obj/machinery/atmospherics/unary/material/extractor
	name = "gas extractor"
	desc = "A machine for extracting liquids and gases from ices and hydrates. Extracts liquids at a reduced efficiency."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "extractor"
	layer = MOB_LAYER+1 // Overhead
	density = 1

	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT //We wanna disable those to trigger reactions on our own terms
	obj_flags = OBJ_FLAG_ANCHORABLE | OBJ_FLAG_ROTATABLE
	use_power = POWER_USE_OFF
	idle_power_usage = 25 //WATTS
	power_rating = 1 KILOWATTS
	power_channel = EQUIP
	connect_types = CONNECT_TYPE_REGULAR

	uncreated_component_parts = null
	construct_state = /decl/machine_construction/default/panel_closed
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES
	public_variables = list(
		/decl/public_access/public_variable/use_power,
		/decl/public_access/public_variable/gas,
		/decl/public_access/public_variable/pressure,
		/decl/public_access/public_variable/temperature,
		/decl/public_access/public_variable/reagents,
		/decl/public_access/public_variable/reagents/volumes,
		/decl/public_access/public_variable/reagents/free_space,
		/decl/public_access/public_variable/reagents/total_volume,
		/decl/public_access/public_variable/reagents/maximum_volume,
		/decl/public_access/public_variable/material_extractor/has_bucket,
	)
	public_methods = list(
		/decl/public_access/public_method/toggle_power,
		/decl/public_access/public_method/material_extractor/flush_gas,
		/decl/public_access/public_method/material_extractor/flush_reagents,
	)
	var/obj/item/chems/glass/output_container //#TODO: change this when plumbing is a thing
	var/obj/input_holder/input_buffer //Since reagent_holder needs a parent object to exist on creation we gotta do this horrible hack

/obj/machinery/atmospherics/unary/material/extractor/proc/get_output_loc()
	return get_step(loc, get_output_dir())
/obj/machinery/atmospherics/unary/material/extractor/proc/get_output_dir()
	return turn(dir, 90)
/obj/machinery/atmospherics/unary/material/extractor/proc/get_input_dir()
	return turn(dir, -90)

/obj/machinery/atmospherics/unary/material/extractor/Initialize(mapload, d = 0, populate_parts = TRUE)
	. = ..()
	if(populate_parts)
		output_container = new/obj/item/chems/glass/bucket(src)
	air_contents.volume = GAS_EXTRACTOR_GAS_TANK
	if(!reagents)
		create_reagents(GAS_EXTRACTOR_REAGENTS_TANK)
	if(!input_buffer)
		input_buffer = new(src)
		input_buffer.create_reagents(GAS_EXTRACTOR_REAGENTS_INPUT_TANK) //Did this here because reimplementing that in the new() proc failed a test for some reasons
	queue_temperature_atoms(src)

/obj/machinery/atmospherics/unary/material/extractor/Destroy()
	output_container = null
	QDEL_NULL(input_buffer)
	. = ..()

/obj/machinery/atmospherics/unary/material/extractor/Bumped(var/obj/O)
	if(QDELETED(O)) //Because we qdel object at the input if we can process them. And its possible this might happen
		return
	//We only override for entities touching the machine from the input's direction only
	if(get_dir(loc, O.loc) != get_input_dir() || inoperable() || !O.checkpass(PASS_FLAG_TABLE) || O.anchored)
		return ..()

	//2 possible cases here. One we got something that we can turn into liquids or gas (with or without accompanying solid reagent at STP)
	// OR we get something that only contains matter that's solid at STP, which we should just pass along so whatever else is in the
	// conveyor line can process it.
	if(can_process_object(O))
		if(calc_resulting_reagents_total_vol(O) > input_tank_free_volume())
			return //If we can process it, but there's no room currently in the input, just don't interact with it for now!
		process_ore(O)
	else
		O.dropInto(get_output_loc())

/obj/machinery/atmospherics/unary/material/extractor/ProcessAtomTemperature()
	if(operable() && use_power)
		//We process temp for the input reagent_holder too
		input_buffer.temperature = GAS_EXTRACTOR_OPERATING_TEMP
		temperature = GAS_EXTRACTOR_OPERATING_TEMP
		return TRUE
	return ..()

/obj/machinery/atmospherics/unary/material/extractor/examine(var/mob/user)
	. = ..()
	//Only display info if the screen is there
	if(get_component_of_type(/obj/item/stock_parts/console_screen))
		to_chat(user, SPAN_NOTICE("The processing tank gauge reads [round(input_buffer.reagents.total_volume)]/[input_buffer.reagents.maximum_volume] units of liquid."))
		to_chat(user, SPAN_NOTICE("The internal storage tank gauge reads [round(reagents.total_volume)]/[reagents.maximum_volume] units of liquid."))
		to_chat(user, SPAN_NOTICE("The internal gas tank pressure gauge reads [air_contents.return_pressure()] kPa."))

		if(is_output_container_full() || is_internal_tank_full())
			to_chat(user, SPAN_WARNING("It is currently idling because one or more of its liquid tanks are full."))
		else
			to_chat(user, SPAN_NOTICE("Everything is working correctly."))

	if(output_container)
		var/output_desc = SPAN_NOTICE("It has \a [output_container.name] in place to receive reagents.")
		if(is_output_container_full())
			output_desc = "[output_desc] [SPAN_WARNING("It's full!")]"
		to_chat(user, output_desc)
	else
		to_chat(user, SPAN_NOTICE("It has nothing to pour reagents into."))

/obj/machinery/atmospherics/unary/material/extractor/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/chems/glass))
		add_fingerprint(user)
		if(!output_container)
			if(!user.try_unequip(I, src))
				return
			output_container = I
			user.visible_message(SPAN_NOTICE("\The [user] places \a [I] in \the [src]."), SPAN_NOTICE("You place \a [I] in \the [src]."))
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

/obj/machinery/atmospherics/unary/material/extractor/power_change()
	. = ..()
	if(.)
		queue_temperature_atoms(src)

/obj/machinery/atmospherics/unary/material/extractor/on_update_icon()
	cut_overlays()

	var/initial_state = initial(icon_state)
	if(!use_power || inoperable())
		icon_state = "[initial_state]-off"
	else
		icon_state = initial_state

	if(panel_open)
		add_overlay("[initial_state]-open")
	if(output_container)
		add_overlay("[initial_state]-bucket")

/obj/machinery/atmospherics/unary/material/extractor/Process()
	..()
	if(!is_input_tank_empty())
		update_use_power(POWER_USE_ACTIVE)

		//Its crucial that all reactions happen ONLY in the input tank
		if(!force_react_input())
			process_input_tank()
			input_clear_remainder() //Keep the input tank tidy by removing very small amounts of reagents
	else
		update_use_power(POWER_USE_IDLE)

	//Make the internal liquid tank transfer liquids into the output
	move_liquids_to_output()

//For some reasons that's not in the unary base class...
/obj/machinery/atmospherics/unary/material/extractor/return_air()
	return air_contents

//Remove trace amounts of reagents from the input tank, to prevent that from causing problems
/obj/machinery/atmospherics/unary/material/extractor/proc/input_clear_remainder()
	if(input_buffer.reagents.total_volume >= GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)
		return
	input_buffer.reagents.clear_reagents()

//Calculate the amount of reagents we can get from this. Returns a list with each materials and the amount of expected reagents
/obj/machinery/atmospherics/unary/material/extractor/proc/gather_resulting_reagents_vol(var/obj/O)
	var/list/processable
	if(length(O.matter) > 0)
		processable = list()
		for(var/k in O.matter)
			if(can_process_material_name(k))
				processable[k] = MATERIAL_UNITS_TO_REAGENTS_UNITS(O.matter[k])
				O.matter -= k
	return processable

/obj/machinery/atmospherics/unary/material/extractor/proc/calc_resulting_reagents_total_vol(var/obj/O)
	var/total = 0
	for(var/k in O.matter)
		if(can_process_material_name(k))
			total += MATERIAL_UNITS_TO_REAGENTS_UNITS(O.matter[k])
	return total

/obj/machinery/atmospherics/unary/material/extractor/proc/input_tank_free_volume()
	return round(max(REAGENTS_FREE_SPACE(input_buffer.reagents),0), GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)

/obj/machinery/atmospherics/unary/material/extractor/proc/output_container_free_volume()
	return output_container? round(max(REAGENTS_FREE_SPACE(output_container.reagents), 0), GAS_EXTRACTOR_MIN_REAGENT_AMOUNT) : 0

/obj/machinery/atmospherics/unary/material/extractor/proc/internal_tank_free_volume()
	return round(max(REAGENTS_FREE_SPACE(reagents), 0), GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)

/obj/machinery/atmospherics/unary/material/extractor/proc/is_output_container_full()
	return output_container_free_volume() <= 0

/obj/machinery/atmospherics/unary/material/extractor/proc/is_input_tank_empty()
	return round(input_buffer.reagents.total_volume, GAS_EXTRACTOR_MIN_REAGENT_AMOUNT) == 0

/obj/machinery/atmospherics/unary/material/extractor/proc/is_internal_tank_full()
	return internal_tank_free_volume() <= 0

/obj/machinery/atmospherics/unary/material/extractor/proc/can_process_object(var/obj/O)
	if(istype(O) && length(O.matter) && is_type_in_list(O, global.material_extractor_items_whitelist))
		for(var/k in O.matter)
			if(can_process_material_name(k))
				return TRUE
	return FALSE

/obj/machinery/atmospherics/unary/material/extractor/proc/can_process_material_name(var/name)
	var/decl/material/M = GET_DECL(name)
	ASSERT(istype(M))
	return (is_material_extractable(M) || has_extractable_heating_products(M))

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
/obj/machinery/atmospherics/unary/material/extractor/proc/process_ore(var/obj/O)
	var/list/extracted = gather_resulting_reagents_vol(O)

	for(var/k in extracted)
		input_buffer.reagents.add_reagent(k, extracted[k]) //Put everything we can in the input for further processing

	//Spit out the stripped ore with whatever we can't process, or otherwise just delete it
	if(length(O.matter))
		O.dropInto(get_output_loc())
	else
		qdel(O)

//Force the content of the input reagents_holder to react in one tick, so we can have some control on when the reaction happens
/obj/machinery/atmospherics/unary/material/extractor/proc/force_react_input()
	input_buffer.atom_flags &= ~(ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT)
	. = input_buffer.reagents.process_reactions()
	input_buffer.atom_flags |= ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_REACT

//Filters all the reagents in the input tank, and send them to the proper output
/obj/machinery/atmospherics/unary/material/extractor/proc/process_input_tank()
	for(var/mat in input_buffer.reagents?.reagent_volumes)
		var/decl/material/M = GET_DECL(mat)
		var/available_volume = round(REAGENT_VOLUME(input_buffer.reagents, M.type), GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)

		//Don't bother if we got a really small quatity, and just get rid of it
		if(available_volume < GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)
			input_buffer.reagents.clear_reagent(M.type)
			continue

		switch(M.phase_at_temperature(temperature))
			if(MAT_PHASE_SOLID)
				dump_solid(M, available_volume) //If for silly reasons anything turns solid while reacting in the input, dump that here
			if(MAT_PHASE_LIQUID)
				dump_liquid(M, available_volume)
			if(MAT_PHASE_GAS)
				dump_gas(M, available_volume)
			if(MAT_PHASE_PLASMA)
				dump_gas(M, available_volume)

//Called each ticks, tries to fill the output with the content of the liquid tank
/obj/machinery/atmospherics/unary/material/extractor/proc/move_liquids_to_output()
	if(!output_container)
		return
	var/transferred = max(min(output_container_free_volume(), reagents.total_volume), 0)
	if(transferred > 0)
		reagents.trans_to(output_container, transferred)

//Used in case some reaction happens in the tank and result in a solid, so it doesn't clog it up
/obj/machinery/atmospherics/unary/material/extractor/proc/dump_solid(var/decl/material/M, var/available_volume)
	//Check if we got enough to dump out a single sheet at least
	if(available_volume < REAGENT_UNITS_PER_MATERIAL_SHEET)
		return
	var/expected_sheets = round(available_volume / REAGENT_UNITS_PER_MATERIAL_SHEET)
	var/removed_volume = round(expected_sheets * REAGENT_UNITS_PER_MATERIAL_SHEET, GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)
	M.create_object(get_output_loc(), expected_sheets)
	input_buffer.reagents.remove_reagent(M.type, removed_volume)

/obj/machinery/atmospherics/unary/material/extractor/proc/dump_liquid(var/decl/material/M, var/available_volume)
	var/internal_free_vol = internal_tank_free_volume()
	var/external_free_vol = output_container_free_volume()

	//Might as well dump directly into the output if there's one, it'll save some extra unneeded processing
	if(external_free_vol > 0)
		var/transferred = max(min(available_volume, external_free_vol), 0)
		if(transferred > 0)
			input_buffer.reagents.trans_to(output_container, transferred, GAS_EXTRACTOR_LIQUID_EFFICIENCY)
			//log_debug("dump_liquid : dumping [round(transferred * GAS_EXTRACTOR_LIQUID_EFFICIENCY)] units of [M.type] to container with [external_free_vol] units of free space")
	else if(internal_free_vol > 0)
		var/transferred = max(min(available_volume, internal_free_vol), 0)
		if(transferred > 0)
			input_buffer.reagents.trans_to_holder(reagents, transferred, GAS_EXTRACTOR_LIQUID_EFFICIENCY)
			//log_debug("dump_liquid : dumping [round(transferred * GAS_EXTRACTOR_LIQUID_EFFICIENCY)] units of [M.type] to internal tank with [internal_free_vol] units of free space")


//We want to convert a liquid to its gaseous state
//So we want to convert liquid units to moles.
// We need:
//	the volume of liquid
//	the density of the liquid
//	the molar mass of the liquid
//Since we have none of those currently in the material datums, just assume everything is water
// Density: 997.07 g/L
// Molar Mass: 18.02 g/mol
//We'll assume a unit of reagent is 1 mL, so we'll divide the density by 1,000. We get 0.99707
// 0.99707 / 18.02 => 0.553 mol/ml
#define MOLES_PER_MILILITER_FACTOR 0.553 //placeholder until we can do this properly via phase transitions
/obj/machinery/atmospherics/unary/material/extractor/proc/dump_gas(var/decl/material/M, var/available_volume)
	var/datum/gas_mixture/produced = new
	var/moles = round(available_volume * MOLES_PER_MILILITER_FACTOR, GAS_EXTRACTOR_MIN_REAGENT_AMOUNT)
	input_buffer.reagents.remove_reagent(M.type, available_volume)
	produced.adjust_gas(M.type, moles)
	air_contents.merge(produced)
#undef MOLES_PER_MILILITER_FACTOR


////////////////////////////////////////////////////
// Verbs
////////////////////////////////////////////////////
/obj/machinery/atmospherics/unary/material/extractor/verb/FlushReagents()
	set name = "Flush Reagents Tank"
	set desc = "Empty the content of the internal reagent tank of the machine on the floor."
	set category = "Object"
	set src in oview(1)
	usr.visible_message(SPAN_NOTICE("[usr] empties the liquid tank of \the [src] onto \the [src.loc]!"), SPAN_NOTICE("You empty the liquid tank of the [src] onto \the [src.loc]!"))
	src.reagents.trans_to(src.loc, reagents.total_volume)

/obj/machinery/atmospherics/unary/material/extractor/verb/FlushGas()
	set name = "Flush Gas Tank"
	set desc = "Empty the content of the internal gas tank of the machine into the air."
	set category = "Object"
	set src in oview(1)
	usr.visible_message(SPAN_NOTICE("[usr] empties the gas tank of \the [src] into the air!"), SPAN_NOTICE("You empty the gas tank of the [src] into the air!"))
	var/datum/gas_mixture/environment = src.loc.return_air()
	environment.merge(src.air_contents)
	//Reset air content
	src.air_contents = new/datum/gas_mixture(GAS_EXTRACTOR_GAS_TANK, temperature)

////////////////////////////////////////////////////
// Public Vars
////////////////////////////////////////////////////
/decl/public_access/public_variable/material_extractor/has_bucket
	expected_type = /obj/machinery/atmospherics/unary/material
	name = "has bucket"
	desc = "Whether or not the extractor has a bucket collecting reagents."
	can_write = FALSE
	has_updates = FALSE
	var_type = IC_FORMAT_BOOLEAN

/decl/public_access/public_variable/material_extractor/has_bucket/access_var(obj/machinery/atmospherics/unary/material/extractor/M)
	return M.output_container != null

////////////////////////////////////////////////////
// Public Methods
////////////////////////////////////////////////////
/decl/public_access/public_method/material_extractor/flush_gas
	name = "flush gas"
	desc = "Empty the internal gas tank into the atmosphere."
	call_proc = /obj/machinery/atmospherics/unary/material/extractor/verb/FlushGas

/decl/public_access/public_method/material_extractor/flush_reagents
	name = "flush reagents"
	desc = "Empty the internal reagents tank on the floor."
	call_proc = /obj/machinery/atmospherics/unary/material/extractor/verb/FlushReagents

#undef GAS_EXTRACTOR_GAS_TANK
#undef GAS_EXTRACTOR_REAGENTS_TANK
#undef GAS_EXTRACTOR_REAGENTS_INPUT_TANK
#undef GAS_EXTRACTOR_OPERATING_TEMP
#undef GAS_EXTRACTOR_LIQUID_EFFICIENCY
#undef GAS_EXTRACTOR_MIN_REAGENT_AMOUNT
