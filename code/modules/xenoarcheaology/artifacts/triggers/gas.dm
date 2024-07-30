/datum/artifact_trigger/gas
	name = "concentration of a specific gas"
	toggle = FALSE
	var/list/gas_needed	//list of gas=percentage needed in air to activate

/datum/artifact_trigger/gas/New()
	if(!gas_needed)
		gas_needed = list(pick(decls_repository.get_decl_paths_of_subtype(/decl/material/gas)) = rand(1,10))
	var/decl/material/gas/gas = GET_DECL(gas_needed[1])
	name = "concentration of [gas.name]"

/datum/artifact_trigger/gas/copy()
	var/datum/artifact_trigger/gas/C = ..()
	C.gas_needed = gas_needed.Copy()

/datum/artifact_trigger/gas/on_gas_exposure(datum/gas_mixture/gas)
	. = TRUE
	for(var/g in gas_needed)
		var/percentage = round(gas.gas[g]/gas.total_moles * 100, 0.01)
		if(percentage < gas_needed[g])
			return FALSE

/datum/artifact_trigger/gas/co2
	gas_needed = list(/decl/material/gas/carbon_dioxide = 5)

/datum/artifact_trigger/gas/o2
	gas_needed = list(/decl/material/gas/oxygen = 5)

/datum/artifact_trigger/gas/n2
	gas_needed = list(/decl/material/gas/nitrogen = 5)

/datum/artifact_trigger/gas/hydrogen
	gas_needed = list(/decl/material/gas/hydrogen = 5)