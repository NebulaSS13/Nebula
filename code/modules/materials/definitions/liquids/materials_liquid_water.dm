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
	temperature_burn_milestone_material = /decl/material/liquid/water
	can_boil_to_gas = TRUE
	coated_adjective = "wet"

/decl/material/liquid/water/build_coated_name(datum/reagents/coating, list/accumulator)
	if(length(coating.reagent_volumes) > 1)
		accumulator.Insert(1, "dilute") // dilute always comes first! also this is intentionally not colored in component color mode
		return // don't insert 'wet'
	..()

// make salty water named saltwater
/decl/material/liquid/water/get_reagent_name(datum/reagents/holder, phase = MAT_PHASE_LIQUID)
	if(phase == MAT_PHASE_LIQUID && holder?.get_primary_reagent_decl() == src)
		if(REAGENT_VOLUME(holder, /decl/material/solid/sodiumchloride))
			return "saltwater"
	return ..() // just use the default handling

// make pure water named fresh water
/decl/material/liquid/water/get_reagent_name(datum/reagents/holder, phase = MAT_PHASE_LIQUID)
	. = ..()
	// length == 1 implies primary reagent, so checking both is redundant
	if(phase == MAT_PHASE_LIQUID && length(holder?.reagent_volumes) == 1)
		return "fresh [.]"
	return

/decl/material/liquid/water/affect_blood(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/list/data = REAGENT_DATA(holder, src)
		if(data?[DATA_WATER_HOLINESS])
			affect_holy(M, removed, holder)

/decl/material/liquid/water/proc/affect_holy(mob/living/M, removed, datum/reagents/holder)
	return FALSE

/decl/material/liquid/water/affect_ingest(var/mob/living/M, var/removed, var/datum/reagents/holder)
	..()
	M.adjust_hydration(removed * 10)
	affect_blood(M, removed, holder)

#define WATER_LATENT_HEAT 9500 // How much heat is removed when applied to a hot turf, in J/unit (9500 makes 120 u of water roughly equivalent to 2L
/decl/material/liquid/water/touch_turf(var/turf/touching_turf, var/amount, var/datum/reagents/holder)

	..()

	if(!istype(touching_turf))
		return

	var/datum/gas_mixture/environment = touching_turf.return_air()
	var/min_temperature = T20C + rand(0, 20) // Room temperature + some variance. An actual diminishing return would be better, but this is *like* that. In a way. . This has the potential for weird behavior, but I says fuck it. Water grenades for everyone.

	// TODO: Cannot for the life of me work out what this is doing or why it's reducing the air temp by 2000; shouldn't it just be using environment?
	var/hotspot = (locate(/obj/fire) in touching_turf)
	if(hotspot && !isspaceturf(touching_turf))
		var/datum/gas_mixture/lowertemp = touching_turf.remove_air(touching_turf:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		touching_turf.assume_air(lowertemp)
		qdel(hotspot)

	var/affect_volume = REAGENT_VOLUME(holder, src)
	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = clamp(affect_volume * WATER_LATENT_HEAT, 0, -environment.get_thermal_energy_change(min_temperature))
		environment.add_thermal_energy(-removed_heat)
		if (prob(5) && environment && environment.temperature > T100C)
			touching_turf.visible_message(SPAN_NOTICE("The water sizzles as it lands on \the [touching_turf]!"))

	var/list/data = REAGENT_DATA(holder, src)
	if(LAZYACCESS(data, DATA_WATER_HOLINESS))
		touching_turf.turf_flags |= TURF_FLAG_HOLY

/decl/material/liquid/water/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder)
	..()
	if(istype(O, /obj/item/food/animal_cube))
		var/obj/item/food/animal_cube/cube = O
		if(!cube.wrapper_type)
			cube.spawn_creature()

/decl/material/liquid/water/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	..()
	if(istype(M))
		var/needed = M.get_fire_intensity() * 10
		if(amount > needed)
			M.set_fire_intensity(0)
			M.extinguish_fire()
			holder.remove_reagent(type, needed)
		else
			M.adjust_fire_intensity(-(amount / 10))
			holder.remove_reagent(type, amount)
