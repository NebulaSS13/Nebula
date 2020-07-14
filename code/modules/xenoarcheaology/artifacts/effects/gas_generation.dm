/datum/artifact_effect/gas
	name = "gas creation"
	var/spawned_gas

/datum/artifact_effect/gas/New()
	..()
	if(!spawned_gas)
		spawned_gas = pick(subtypesof(/decl/material/gas))
	operation_type = pick(EFFECT_TOUCH, EFFECT_AURA)
	origin_type = EFFECT_SYNTH

/datum/artifact_effect/gas/DoEffectTouch(var/mob/user)
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(spawned_gas, rand(2, 15))

/datum/artifact_effect/gas/DoEffectAura()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(spawned_gas, 1)

/datum/artifact_effect/gas/oxygen
	name = "O2 creation"
	spawned_gas = /decl/material/gas/oxygen

/datum/artifact_effect/gas/hydrogen
	name = "H2 creation"
	spawned_gas = /decl/material/gas/hydrogen

/datum/artifact_effect/gas/sleeping
	name = "N2O creation"
	spawned_gas = /decl/material/gas/nitrous_oxide

/datum/artifact_effect/gas/nitro
	name = "N2 creation"
	spawned_gas = /decl/material/gas/nitrogen

/datum/artifact_effect/gas/co2
	name = "CO2 creation"
	spawned_gas = /decl/material/gas/carbon_dioxide