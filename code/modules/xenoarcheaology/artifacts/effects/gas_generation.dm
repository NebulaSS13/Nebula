/datum/artifact_effect/gas
	name = "gas creation"
	var/spawned_gas

/datum/artifact_effect/gas/New()
	..()
	if(!spawned_gas)
		spawned_gas = pick(SSmaterials.all_gasses)
	operation_type = pick(EFFECT_TOUCH, EFFECT_AURA)
	origin_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)

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
	spawned_gas = MAT_OXYGEN

/datum/artifact_effect/gas/phoron
	name = "phoron creation"
	spawned_gas = MAT_PHORON

/datum/artifact_effect/gas/sleeping
	name = "N2O creation"
	spawned_gas = MAT_N2O

/datum/artifact_effect/gas/nitro
	name = "N2 creation"
	spawned_gas = MAT_NITROGEN

/datum/artifact_effect/gas/co2
	name = "CO2 creation"
	spawned_gas = MAT_CO2