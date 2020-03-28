/datum/reagent/anfo
	name = "ANFO"
	description = "Ammonia Nitrate Fuel Oil mix, an explosive compound known for centuries. Safe to handle, can be set off with a small explosion."
	taste_description = "fertilizer and fuel"
	color = "#dbc3c3"
	var/boompower = 1

/datum/reagent/anfo/ex_act(obj/item/chems/holder, severity)
	var/activated_volume = volume
	switch(severity)
		if(2)
			if(prob(max(0, 2*(volume - 120))))
				activated_volume = rand(volume/4, volume)
		if(3)
			if(prob(max(0, 2*(volume - 60))))
				activated_volume = rand(0, max(volume, 120))
	if(activated_volume < 30) //whiff
		return
	var/turf/T = get_turf(holder)
	if(T)
		var/adj_power = round(boompower * activated_volume/60)
		var/datum/gas_mixture/products = new(_temperature = 5 * PHORON_FLASHPOINT)
		var/gas_moles = 3 * volume
		products.adjust_multi(MAT_CO2, 0.5 * gas_moles, MAT_NITROGEN, 0.3 * gas_moles, MAT_STEAM, 0.2 * gas_moles)
		T.assume_air(products)
		remove_self(activated_volume)
		explosion(T, adj_power, adj_power + 1, adj_power*2 + 2)

/datum/reagent/anfo/plus
	name = "ANFO+"
	description = "Ammonia Nitrate Fuel Oil, with aluminium powder, an explosive compound known for centuries. Safe to handle, can be set off with a small explosion."
	color = "#ffe8e8"
	boompower = 2
