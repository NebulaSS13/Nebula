/decl/material/liquid/water
	name = "water"
	codex_name = "liquid water" // need a better name than this so it passes the overlapping ID unit tests :(
	uid = "liquid_water"
	solid_name = "ice"
	gas_name = "water vapour"
	lore_text = "A ubiquitous chemical substance composed of hydrogen and oxygen."
	color = COLOR_LIQUID_WATER
	gas_tile_overlay = "generic"
	gas_overlay_limit = 0.5
	gas_specific_heat = 30
	molar_mass = 0.020
	boiling_point = 100 CELSIUS
	melting_point = 0 CELSIUS
	latent_heat = 2258
	gas_condensation_point = 308.15 // 35C. Dew point is ~20C but this is better for gameplay considerations.
	gas_symbol_html = "H<sub>2</sub>O"
	gas_symbol = "H2O"
	scannable = 1
	metabolism = REM * 10
	taste_description = "water"
	glass_name = "water"
	glass_desc = "The father of all refreshments."
	slipperiness = 8
	slippery_amount = 5
	dirtiness = DIRTINESS_CLEAN
	turf_touch_threshold = 0.1
	chilling_point = T0C
	chilling_products = list(
		/decl/material/solid/ice = 1
	)

/decl/material/liquid/water/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/list/data = REAGENT_DATA(holder, type)
		if(data?["holy"])
			affect_holy(M, removed, holder)

/decl/material/liquid/water/proc/affect_holy(mob/living/M, removed, datum/reagents/holder)
	return FALSE

/decl/material/liquid/water/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	M.adjust_hydration(removed * 10)
	affect_blood(M, removed, holder)

#define WATER_LATENT_HEAT 9500 // How much heat is removed when applied to a hot turf, in J/unit (9500 makes 120 u of water roughly equivalent to 2L
/decl/material/liquid/water/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder)

	..()

	if(!istype(T))
		return

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T20C + rand(0, 20) // Room temperature + some variance. An actual diminishing return would be better, but this is *like* that. In a way. . This has the potential for weird behavior, but I says fuck it. Water grenades for everyone.

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !isspaceturf(T))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	var/volume = REAGENT_VOLUME(holder, type)
	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = clamp(volume * WATER_LATENT_HEAT, 0, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5) && environment && environment.temperature > T100C)
			T.visible_message("<span class='warning'>The water sizzles as it lands on \the [T]!</span>")

	var/list/data = REAGENT_DATA(holder, type)
	if(LAZYACCESS(data, "holy"))
		T.turf_flags |= TURF_FLAG_HOLY

/decl/material/liquid/water/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	..()
	if(istype(O, /obj/item/food/monkeycube))
		var/obj/item/food/monkeycube/cube = O
		if(!cube.wrapper_type)
			cube.Expand()

/decl/material/liquid/water/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	..()
	if(istype(M))
		var/needed = M.fire_stacks * 10
		if(amount > needed)
			M.fire_stacks = 0
			M.ExtinguishMob()
			holder.remove_reagent(type, needed)
		else
			M.adjust_fire_stacks(-(amount / 10))
			holder.remove_reagent(type, amount)
