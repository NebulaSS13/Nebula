/datum/artifact_trigger/gas
	name = "concentration of a specific gas"
	toggle = FALSE
	var/list/gas_needed	//list of gas=percentage needed in air to activate

/datum/artifact_trigger/gas/New()
	if(!gas_needed)
		gas_needed = list(pick(SSmaterials.all_gasses) = rand(1,10))

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
	name = "concentration of CO2"
	gas_needed = list(MAT_CO2 = 5)

/datum/artifact_trigger/gas/o2
	name = "concentration of oxygen"
	gas_needed = list(MAT_OXYGEN = 5)

/datum/artifact_trigger/gas/n2
	name = "concentration of nitrogen"
	gas_needed = list(MAT_NITROGEN = 5)

/datum/artifact_trigger/gas/phoron
	name = "concentration of phoron"
	gas_needed = list(MAT_PHORON = 5)