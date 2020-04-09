

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_atmosphere()
	atmosphere = new
	if(habitability_class == HABITABILITY_IDEAL)
		atmosphere.adjust_gas(MAT_OXYGEN, MOLES_O2STANDARD, 0)
		atmosphere.adjust_gas(MAT_NITROGEN, MOLES_N2STANDARD)
	else //let the fuckery commence
		var/list/newgases = SSmaterials.all_gasses
		newgases = newgases.Copy() // So we don't mutate the global list.
		if(prob(90)) //all phoron planet should be rare
			newgases -= MAT_PHORON
		if(prob(50)) //alium gas should be slightly less common than mundane shit
			newgases -= MAT_ALIEN_GAS
		newgases -= MAT_STEAM

		var/total_moles = MOLES_CELLSTANDARD * rand(80,120)/100
		var/badflag = 0

		//Breathable planet
		if(habitability_class == HABITABILITY_OKAY)
			atmosphere.gas[MAT_OXYGEN] += MOLES_O2STANDARD
			total_moles -= MOLES_O2STANDARD
			badflag = XGM_GAS_FUEL|XGM_GAS_CONTAMINANT

		var/gasnum = rand(1,4)
		var/i = 1
		var/sanity = prob(99.9)
		while(i <= gasnum && total_moles && newgases.len)
			if(badflag && sanity)
				for(var/g in newgases)
					var/material/mat = SSmaterials.get_material_datum(g)
					if(mat.gas_flags & badflag)
						newgases -= g
			var/ng = pick_n_take(newgases)	//pick a gas
			var/material/mat = SSmaterials.get_material_datum(ng)
			if(sanity) //make sure atmosphere is not flammable... always
				if(mat.gas_flags & XGM_GAS_OXIDIZER)
					badflag |= XGM_GAS_FUEL
				if(mat.gas_flags & XGM_GAS_FUEL)
					badflag |= XGM_GAS_OXIDIZER
				sanity = 0

			var/part = total_moles * rand(3,80)/100 //allocate percentage to it
			if(i == gasnum || !newgases.len) //if it's last gas, let it have all remaining moles
				part = total_moles
			atmosphere.gas[ng] += part
			total_moles = max(total_moles - part, 0)
			i++

//Tries to 'reset' planet's surface atmos to normal values
/obj/effect/overmap/visitable/sector/exoplanet/proc/handle_atmosphere()
	if(!atmosphere)
		return
	for(var/zlevel in map_z)
		var/zone/Z
		for(var/i = TRANSITIONEDGE to maxx - TRANSITIONEDGE)
			var/turf/simulated/floor/exoplanet/T = locate(i, 2, zlevel)
			if(istype(T) && T.zone && T.zone.contents.len > (maxx*maxy*0.25)) //if it's a zone quarter of zlevel, good enough odds it's planetary main one
				Z = T.zone
				break
		if(Z && !Z.fire_tiles.len && !atmosphere.compare(Z.air)) //let fire die out first if there is one
			var/datum/gas_mixture/daddy = new() //make a fake 'planet' zone gas
			daddy.copy_from(atmosphere)
			daddy.group_multiplier = Z.air.group_multiplier
			Z.air.equalize(daddy)

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_habitability()
	var/roll = rand(1,100)
	switch(roll)
		if(1 to 10)
			habitability_class = HABITABILITY_IDEAL
		if(11 to 50)
			habitability_class = HABITABILITY_OKAY
		else
			habitability_class = HABITABILITY_BAD