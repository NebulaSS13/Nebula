/datum/codex_entry/atmos_pipe
	associated_paths = list(/obj/machinery/atmospherics/pipe)
	mechanics_text = "All pipes can be connected or disconnected with a wrench.  The internal pressure of the pipe must be below 300 kPa to do this.  More pipes can be obtained from a pipe dispenser. \
	<br>Some pipes, like scrubbers and supply pipes, do not connect to 'normal' pipes. If you want to connect them, use a universal adapter pipe. \
	<br>Pipes generally do not exchange thermal energy with the environment (ie. they do not heat up or cool down their turf), but heat exchange pipes are an exception. \
	<br>To join three or more pipe segments, you can use a pipe manifold.\
	<br>To terminate a pipeline, use a cap to prevent the gas escaping into the environment."
	include_subtypes = TRUE
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//T-shaped valves
/datum/codex_entry/atmos_tvalve
	associated_paths = list(/obj/machinery/atmospherics/tvalve)
	mechanics_text = "Click this to toggle the mode.  The direction with the green light is where the gas will flow."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Normal valves
/datum/codex_entry/atmos_valve
	associated_paths = list(/obj/machinery/atmospherics/valve)
	mechanics_text = "Click this to turn the valve.  If red, the pipes on each end are separated.  Otherwise, they are connected."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//TEG ports
/datum/codex_entry/atmos_circulator
	associated_paths = list(/obj/machinery/atmospherics/binary/circulator)
	mechanics_text = "This generates electricity, depending on the difference in temperature between each side of the machine.  The meter in \
	the center of the machine gives an indicator of how much elecrtricity is being generated."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Passive gates
/datum/codex_entry/atmos_gate
	associated_paths = list(/obj/machinery/atmospherics/binary/passive_gate)
	mechanics_text = "This is a one-way regulator, allowing gas to flow only at a specific pressure and flow rate.  If the light is green, it is flowing."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Normal pumps (high power one inherits from this)
/datum/codex_entry/atmos_pump
	associated_paths = list(/obj/machinery/atmospherics/binary/pump)
	mechanics_text = "This moves gas from one pipe to another.  A higher target pressure demands more energy.  The side with the red end is the output."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Vents
/datum/codex_entry/atmos_vent_pump
	associated_paths = list(/obj/machinery/atmospherics/unary/vent_pump)
	mechanics_text = "This pumps the contents of the attached pipe out into the atmosphere, if needed.  It can be controlled from an Air Alarm."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Freezers
/datum/codex_entry/atmos_freezer
	associated_paths = list(/obj/machinery/atmospherics/unary/freezer)
	mechanics_text = "Cools down the gas of the pipe it is connected to.  It uses massive amounts of electricity while on. \
	It can be upgraded by replacing the capacitors, manipulators, and matter bins.  It can be deconstructed by screwing the maintenance panel open with a \
	screwdriver, and then using a crowbar."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Heaters
/datum/codex_entry/atmos_heater
	associated_paths = list(/obj/machinery/atmospherics/unary/heater)
	mechanics_text = "Heats up the gas of the pipe it is connected to.  It uses massive amounts of electricity while on. \
	It can be upgraded by replacing the capacitors, manipulators, and matter bins.  It can be deconstructed by screwing the maintenance panel open with a \
	screwdriver, and then using a crowbar."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Gas injectors
/datum/codex_entry/atmos_injector
	associated_paths = list(/obj/machinery/atmospherics/unary/outlet_injector)
	mechanics_text = "Outputs the pipe's gas into the atmosphere, similar to an airvent.  It can be controlled by a nearby atmospherics computer. \
	A green light on it means it is on."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Scrubbers
/datum/codex_entry/atmos_vent_scrubber
	associated_paths = list(/obj/machinery/atmospherics/unary/vent_scrubber)
	mechanics_text = "This filters the atmosphere of harmful gas.  Filtered gas goes to the pipes connected to it, typically a scrubber pipe. \
	It can be controlled from an Air Alarm.  It can be configured to drain all air rapidly with a 'panic syphon' from an air alarm."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Omni filters
/datum/codex_entry/atmos_omni_filter
	associated_paths = list(/obj/machinery/atmospherics/omni/filter)
	mechanics_text = "Filters gas from a custom input direction, with up to two filtered outputs and a 'everything else' \
	output.  The filtered output's arrows glow orange."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Omni mixers
/datum/codex_entry/atmos_omni_mixer
	associated_paths = list(/obj/machinery/atmospherics/omni/mixer)
	mechanics_text = "Combines gas from custom input and output directions.  The percentage of combined gas can be defined."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Canisters
/datum/codex_entry/atmos_canister
	name = "gas canister" // because otherwise it shows up as 'canister: [caution]'
	associated_paths = list(/obj/machinery/portable_atmospherics/canister)
	mechanics_text = "The canister can be connected to a connector port with a wrench.  Tanks of gas (the kind you can hold in your hand) \
	can be filled by the canister, by using the tank on the canister, increasing the release pressure, then opening the valve until it is full, and then close it.  \
	*DO NOT* remove the tank until the valve is closed.  A gas analyzer can be used to check the contents of the canister."
	antag_text = "Canisters can be damaged, spilling their contents into the air, or you can just leave the release valve open."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Portable pumps
/datum/codex_entry/atmos_power_pump
	associated_paths = list(/obj/machinery/portable_atmospherics/powered/pump)
	mechanics_text = "Invaluable for filling air in a room rapidly after a breach repair.  The internal gas container can be filled by \
	connecting it to a connector port.  The pump can pump the air in (sucking) or out (blowing), at a specific target pressure.  The powercell inside can be \
	replaced by using a screwdriver, and then adding a new cell.  A tank of gas can also be attached to the air pump."
	disambiguator = "machine"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Portable scrubbers
/datum/codex_entry/atmos_power_scrubber
	associated_paths = list(/obj/machinery/portable_atmospherics/powered/scrubber)
	mechanics_text = "Filters the air, placing harmful gases into the internal gas container.  The container can be emptied by \
	connecting it to a connector port.  The pump can pump the air in (sucking) or out (blowing), at a specific target pressure.  The powercell inside can be \
	replaced by using a screwdriver, and then adding a new cell.  A tank of gas can also be attached to the scrubber. "
	disambiguator = "machine"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Meters
/datum/codex_entry/atmos_meter
	associated_paths = list(/obj/machinery/meter)
	mechanics_text = "Measures the volume and temperature of the pipe under the meter."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

//Pipe dispensers
/datum/codex_entry/atmos_pipe_dispenser
	associated_paths = list(/obj/machinery/fabricator/pipe)
	mechanics_text = "This can be moved by using a wrench.  You will need to wrench it again when you want to use it.  You can put \
	excess (atmospheric) pipes into the dispenser, as well.  The dispenser requires electricity to function."
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/transfer_valve
	associated_paths = list(/obj/item/transfer_valve)
	mechanics_text = "This machine is used to merge the contents of two different gas tanks. Plug the tanks into the transfer, then open the valve to mix them together. You can also attach various assembly devices to trigger this process."
	antag_text = "With a tank of hot accelerant and cold oxidiser, this benign little atmospheric device becomes an incredibly deadly bomb. You don't want to be anywhere near it when it goes off."
	disambiguator = "component"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/gas_tank
	associated_paths = list(/obj/item/tank)
	mechanics_text = "These tanks are utilised to store any of the various types of gaseous substances. \
	They can be attached to various portable atmospheric devices to be filled or emptied. <br>\
	<br>\
	Each tank is fitted with an emergency relief valve. This relief valve will open if the tank is pressurised to over ~3000kPa or heated to over 173?C. \
	The valve itself will close after expending most or all of the contents into the air.<br>\
	<br>\
	Filling a tank such that experiences ~4000kPa of pressure will cause the tank to rupture, spilling out its contents and destroying the tank. \
	Tanks filled over ~5000kPa will rupture rather violently, exploding with significant force."
	antag_text = "Each tank may be incited to burn by attaching wires and an igniter assembly, though the igniter can only be used once and the mixture only burn if the igniter pushes a flammable gas mixture above the minimum burn temperature (126?C). \
	Wired and assembled tanks may be disarmed with a set of wirecutters. Any exploding or rupturing tank will generate shrapnel, assuming their relief valves have been welded beforehand. Even if not, they can be incited to expel hot gas on ignition if pushed above 173?C. \
	Relatively easy to make, the single tank bomb requries no tank transfer valve, and is still a fairly formidable weapon that can be manufactured from any tank."
	disambiguator = "atmospherics"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/gas_analyzer
	associated_paths = list(/obj/item/scanner/gas)
	mechanics_text = "A device that analyzes the gas contents of a tile or atmospherics devices. Has 3 modes: Default operates without \
	additional output data; Moles and volume shows the moles per gas in the mixture and the total moles and volume; Gas \
	traits and data describes the traits per gas, how it interacts with the world, and some of its property constants."
	disambiguator = "equipment"
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE
