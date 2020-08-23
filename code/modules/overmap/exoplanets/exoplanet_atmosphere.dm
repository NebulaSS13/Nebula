

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_atmosphere()
	atmosphere = new
	if(habitability_class == HABITABILITY_IDEAL)
		atmosphere.adjust_gas(/decl/material/gas/oxygen, MOLES_O2STANDARD, 0)
		atmosphere.adjust_gas(/decl/material/gas/nitrogen, MOLES_N2STANDARD)
	else //let the fuckery commence
		var/list/newgases = subtypesof(/decl/material/gas)
		newgases = newgases.Copy() // So we don't mutate the global list.
		if(prob(50)) //alium gas should be slightly less common than mundane shit
			newgases -= /decl/material/gas/alien
		newgases -= /decl/material/liquid/water

		var/total_moles = MOLES_CELLSTANDARD * rand(80,120)/100
		var/badflag = 0

		//Breathable planet
		if(habitability_class == HABITABILITY_OKAY)
			atmosphere.gas[/decl/material/gas/oxygen] += MOLES_O2STANDARD
			total_moles -= MOLES_O2STANDARD
			badflag = XGM_GAS_FUEL|XGM_GAS_CONTAMINANT

		var/gasnum = rand(1,4)
		var/i = 1
		var/sanity = prob(99.9)
		while(i <= gasnum && total_moles && newgases.len)
			if(badflag && sanity)
				for(var/g in newgases)
					var/decl/material/mat = decls_repository.get_decl(g)
					if(mat.gas_flags & badflag)
						newgases -= g
			var/ng = pick_n_take(newgases)	//pick a gas
			var/decl/material/mat = decls_repository.get_decl(ng)
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

/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_habitability()
	var/roll = rand(1,100)
	switch(roll)
		if(1 to 10)
			habitability_class = HABITABILITY_IDEAL
		if(11 to 50)
			habitability_class = HABITABILITY_OKAY
		else
			habitability_class = HABITABILITY_BAD