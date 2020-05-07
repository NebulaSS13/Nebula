// Water!
#define WATER_LATENT_HEAT 9500 // How much heat is removed when applied to a hot turf, in J/unit (9500 makes 120 u of water roughly equivalent to 2L
/decl/reagent/water
	name = "water"
	description = "A ubiquitous chemical substance composed of hydrogen and oxygen."
	color = COLOR_OCEAN
	scannable = 1
	metabolism = REM * 10
	taste_description = "water"
	glass_name = "water"
	glass_desc = "The father of all refreshments."
	chilling_products = list(/decl/reagent/drink/ice)
	chilling_point = T0C
	heating_products = list(/decl/reagent/water/boiling)
	heating_point = T100C
	value = 0.01

/decl/reagent/water/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M, /mob/living/carbon/slime) && alien != IS_SLIME)
		return
	M.adjustToxLoss(2 * removed)

/decl/reagent/water/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M, /mob/living/carbon/slime) && alien != IS_SLIME)
		return
	M.adjustToxLoss(2 * removed)

/decl/reagent/water/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjust_hydration(removed * 10)

/decl/reagent/water/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)
	if(!istype(T))
		return

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T20C + rand(0, 20) // Room temperature + some variance. An actual diminishing return would be better, but this is *like* that. In a way. . This has the potential for weird behavior, but I says fuck it. Water grenades for everyone.

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	var/volume = REAGENT_VOLUME(holder, type)
	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * WATER_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5) && environment && environment.temperature > T100C)
			T.visible_message("<span class='warning'>The water sizzles as it lands on \the [T]!</span>")

	else if(volume >= 10)
		var/turf/simulated/S = T
		S.wet_floor(8, TRUE)

/decl/reagent/water/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	if(istype(O, /obj/item/chems/food/snacks/monkeycube))
		var/obj/item/chems/food/snacks/monkeycube/cube = O
		if(!cube.wrapped)
			cube.Expand()

/decl/reagent/water/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	if(istype(M))
		var/needed = M.fire_stacks * 10
		if(amount > needed)
			M.fire_stacks = 0
			M.ExtinguishMob()
			holder.remove_reagent(type, needed)

		else
			M.adjust_fire_stacks(-(amount / 10))
			holder.remove_reagent(type, amount)

/decl/reagent/water/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M, /mob/living/carbon/slime) && alien != IS_SLIME)
		return
	M.adjustToxLoss(10 * removed)	// Babies have 150 health, adults have 200; So, 15 units and 20
	var/mob/living/carbon/slime/S = M
	if(!S.client && istype(S))
		if(S.Target) // Like cats
			S.Target = null
		if(S.Victim)
			S.Feedstop()
	if(M.chem_doses[type] == removed)
		M.visible_message("<span class='warning'>[S]'s flesh sizzles where the water touches it!</span>", "<span class='danger'>Your flesh burns in the water!</span>")
		M.confused = max(M.confused, 2)

/decl/reagent/water/boiling
	name = "boiling water"
	chilling_products = list(/decl/reagent/water)
	chilling_point =   99 CELSIUS
	chilling_message = "stops boiling."
	heating_products =  list(null)
	heating_point =    null
	hidden_from_codex = TRUE

// Ice is a drink for some reason.
/decl/reagent/drink/ice
	name = "ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	taste_description = "ice"
	taste_mult = 1.5
	color = "#619494"
	adj_temp = -5
	hydration = 10

	glass_name = "ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."
	glass_icon = DRINK_ICON_NOISY

	heating_message = "cracks and melts."
	heating_products = list(/decl/reagent/water)
	heating_point = 299 // This is about 26C, higher than the actual melting point of ice but allows drinks to be made properly without weird workarounds.

/decl/reagent/drink/ice/build_presentation_name_from_reagents(var/obj/item/prop, var/supplied)
	. = glass_name
