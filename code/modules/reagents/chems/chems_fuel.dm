/datum/reagent/fuel
	name = "welding fuel"
	description = "A stable hydrazine-based compound whose exact manufacturing specifications are a closely-guarded secret. One of the most common fuels in human space. Extremely flammable."
	taste_description = "gross metal"
	color = "#660000"
	touch_met = 5
	fuel_value = 1

	glass_name = "welder fuel"
	glass_desc = "Unless you are an industrial tool, this is probably not safe for consumption."
	value = 1.5

/datum/reagent/fuel/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(2 * removed)

/datum/reagent/fuel/ex_act(obj/item/chems/holder, severity)
	if(volume <= 50)
		return
	var/turf/T = get_turf(holder)
	var/datum/gas_mixture/products = new(_temperature = 5 * PHORON_FLASHPOINT)
	var/gas_moles = 3 * volume
	products.adjust_multi(MAT_NO, 0.1 * gas_moles, MAT_NO2, 0.1 * gas_moles, MAT_NITROGEN, 0.6 * gas_moles, MAT_HYDROGEN, 0.02 * gas_moles)
	T.assume_air(products)
	if(volume > 500)
		explosion(T,1,2,4)
	else if(volume > 100)
		explosion(T,0,1,3)
	else if(volume > 50)
		explosion(T,-1,1,2)
	remove_self(volume)

/datum/reagent/fuel/hydrazine
	name = "hydrazine"
	description = "A toxic, colorless, flammable liquid with a strong ammonia-like odor, in hydrate form."
	taste_description = "sweet tasting metal"
	color = "#808080"
	metabolism = REM * 0.2
	touch_met = 5
	value = 1.2
	fuel_value = 1.2
