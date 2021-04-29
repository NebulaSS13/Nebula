//Machine meant to extra gases from hydrates
// Input is clockwise east, output clockwise west, gas output clockwise south
#define GAS_EXTRACTOR_GAS_TANK 1000
#define GAS_EXTRACTOR_REAGENTS_TANK 500
#define GAS_EXTRACTOR_EXTRACTION_RATE 0.5 //units per tick

//TODO: Construction / dismantling
//TODO: Sprite work?

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

	var/const/max_items = 25 //Max amount of items it can process at the same time
	var/global/list/items_whitelist = list( //stuff that should be accepted
		/obj/item/ore,
	)

/obj/machinery/atmospherics/unary/material/extractor/Initialize()
	. = ..()
	air_contents.volume = GAS_EXTRACTOR_GAS_TANK
	if(!reagents)
		create_reagents(GAS_EXTRACTOR_REAGENTS_TANK)
	if(!matter)
		matter = list()

/obj/machinery/atmospherics/unary/material/extractor/Bumped(var/obj/O)
	if(inoperable())
		return
	
	if(O.pass_flags > PASS_FLAG_TABLE) //We prevent tall stuff from getting in
		return

	//This handles items touching the machine from the input's direction only
	if(get_dir(loc, O.loc) == get_input_dir())
		if(!process_ore(O))
			//Reject stuff that we cannot process
			O.forceMove(get_output_loc())
	else
		return ..()

/obj/machinery/atmospherics/unary/material/extractor/Process()
	. = ..()

	//Process contents
	if(has_content_to_process())
		update_use_power(POWER_USE_ACTIVE)

		//Process contents
		extract(get_contained_external_atoms())

		//Dump any accumulated solids
		dump_solids()

	else
		update_use_power(POWER_USE_IDLE)

///obj/machinery/atmospherics/unary/material/extractor/on_update_icon()
	//icon_state = (use_power == POWER_USE_ACTIVE) ? "cracker_on" : "cracker" //#TODO: Change me once we get an icon

/obj/machinery/atmospherics/unary/material/extractor/proc/has_content_to_process()
	return count_items_processing() > 0

/obj/machinery/atmospherics/unary/material/extractor/proc/can_process(var/obj/O)
	if(istype(O) && is_type_in_list(O, items_whitelist) && (count_items_processing() < max_items))
		for(var/k in O.matter)
			var/decl/material/M = GET_DECL(k)
			ASSERT(istype(M))
			if(is_material_extractable(M) || has_extractable_heating_products(M))
				ping("Accepted for processing!")
				return TRUE
	ping("Rejected for processing!")
	return FALSE

/obj/machinery/atmospherics/unary/material/extractor/proc/has_extractable_heating_products(var/decl/material/M)
	for(var/k in M.heating_products)
		var/decl/material/P = GET_DECL(k)
		ASSERT(istype(P))
		if(is_material_extractable(P))
			log_debug("Heating product can be processed")
			return TRUE
	return FALSE

/obj/machinery/atmospherics/unary/material/extractor/proc/is_material_extractable(var/decl/material/M)
	//If is gas or liquid at STP we can process
	return istype(M.type, /decl/material/gas) || istype(M.type, /decl/material/liquid)

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
			var/decl/material/M = GET_DECL(k)
			ASSERT(istype(M))
			
			//If material boils somewhere under 20C we can output it as a gas
			if(M.boiling_point <= T20C)
				extract_gas(O, k, GAS_EXTRACTOR_EXTRACTION_RATE)
			//If material melts somewhere under 20C we can output it as a liquid
			else if(M.melting_point <= T20C)
				extract_reagent(O, k, GAS_EXTRACTOR_EXTRACTION_RATE)
			//Otherwise we just dump leftovers as unprocessed ore
			else
				extract_solid(O, k, GAS_EXTRACTOR_EXTRACTION_RATE)
		
		//Clean up any empty ores
		if(!length(O.matter))
			O.forceMove(null)
			qdel(O)

//Returns the amount that was removed
/obj/machinery/atmospherics/unary/material/extractor/proc/remove_matter_amount(var/obj/O, var/M, var/amount)
	. = min(O.matter[M], amount)
	O.matter[M] -= .
	if(O.matter[M] == 0)
		O.matter -= M

//Send gases to internal tank
/obj/machinery/atmospherics/unary/material/extractor/proc/extract_gas(var/obj/O, var/M, var/consumed)
	var/removed = remove_matter_amount(O, M, consumed)
	var/datum/gas_mixture/produced = new
	produced.adjust_gas(M,  removed / REAGENT_UNITS_PER_MATERIAL_UNIT) //Reagent and gas volumes are used interchangeably
	produced.temperature = T20C
	air_contents.merge(produced)

//send reagents to internal tank
/obj/machinery/atmospherics/unary/material/extractor/proc/extract_reagent(var/obj/O, var/M, var/amount)
	var/removed = remove_matter_amount(O, M, amount)
	reagents.add_reagent(M, (removed * REAGENT_UNITS_PER_MATERIAL_SHEET * 0.75)) //Made 75% efficient like the smelter

//Poop out any solids left into ores
/obj/machinery/atmospherics/unary/material/extractor/proc/extract_solid(var/obj/O, var/M, var/amount)
	var/removed = remove_matter_amount(O, M, amount)
	matter[M] += removed

/obj/machinery/atmospherics/unary/material/extractor/proc/dump_solids()
	//If we don't have anything accumulated
	if(length(src.matter) == 0)
		return

	//Check if anything is ready to be dumped
	for(var/k in src.matter)
		if(matter[k] >= SHEET_MATERIAL_AMOUNT) //because for some reasons ores are locked to the amount of materials in a material sheet
			matter[k] = round(matter[k] - SHEET_MATERIAL_AMOUNT, 0.1)
			if(matter[k] == 0)
				matter -= k
			var/obj/item/ore/output = new(get_output_loc())
			output.set_material(k)

/obj/machinery/atmospherics/unary/material/extractor/proc/get_output_loc()
	return get_step(loc, get_output_dir())
/obj/machinery/atmospherics/unary/material/extractor/proc/get_output_dir()
	return turn(dir, 90)
/obj/machinery/atmospherics/unary/material/extractor/proc/get_input_dir()
	return turn(dir, -90)

#undef GAS_EXTRACTOR_GAS_TANK 
#undef GAS_EXTRACTOR_REAGENTS_TANK
#undef GAS_EXTRACTOR_EXTRACTION_RATE