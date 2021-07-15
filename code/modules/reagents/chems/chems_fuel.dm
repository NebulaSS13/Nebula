/decl/material/liquid/fuel
	name = "welding fuel"
	lore_text = "A stable hydrazine-based compound whose exact manufacturing specifications are a closely-guarded secret. One of the most common fuels in human space. Extremely flammable."
	taste_description = "gross metal"
	color = "#660000"
	touch_met = 5
	fuel_value = 1
	burn_product = /decl/material/gas/carbon_monoxide

	glass_name = "welder fuel"
	glass_desc = "Unless you are an industrial tool, this is probably not safe for consumption."
	value = 1.5

/decl/material/liquid/fuel/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	M.adjustToxLoss(2 * removed)

/decl/material/liquid/fuel/explosion_act(obj/item/chems/holder, severity)
	. = ..()
	if(.)
		var/volume = REAGENT_VOLUME(holder?.reagents, type)
		if(volume <= 50)
			return
		var/turf/T = get_turf(holder)
		var/datum/gas_mixture/products = new(_temperature = 5 * FLAMMABLE_GAS_FLASHPOINT)
		var/gas_moles = 3 * volume
		products.adjust_multi(/decl/material/gas/nitricoxide, 0.1 * gas_moles, /decl/material/gas/nitrodioxide, 0.1 * gas_moles, /decl/material/gas/nitrogen, 0.6 * gas_moles, /decl/material/gas/hydrogen, 0.02 * gas_moles)
		T.assume_air(products)
		if(volume > 500)
			explosion(T,1,2,4)
		else if(volume > 100)
			explosion(T,0,1,3)
		else if(volume > 50)
			explosion(T,-1,1,2)
		holder?.reagents?.remove_reagent(type, volume)

/decl/material/liquid/fuel/hydrazine
	name = "hydrazine"
	lore_text = "A toxic, colorless, flammable liquid with a strong ammonia-like odor, in hydrate form."
	taste_description = "sweet tasting metal"
	color = "#808080"
	metabolism = REM * 0.2
	touch_met = 5
	value = 1.2
	fuel_value = 1.2
