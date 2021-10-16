#define FUSION_ENERGY_PER_K         20
#define FUSION_INSTABILITY_DIVISOR  50000
#define FUSION_RUPTURE_THRESHOLD    10000
#define FUSION_FIELD_CAP_COEFF	    5000
#define FUSION_COHESION_LOSS_COEFF 3
#define FUSION_COHESION_LOSS_LIMIT  4.5

/obj/effect/fusion_em_field
	name = "electromagnetic field"
	desc = "A coruscating, barely visible field of energy. It is shaped like a slightly flattened torus."
	icon = 'icons/obj/machines/power/fusion.dmi'
	icon_state = "emfield_s1"
	alpha = 30
	layer = 4
	light_color = COLOR_RED
	color = COLOR_RED
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE

	var/size = 1
	var/energy = 0
	var/radiation = 0
	var/field_strength = 0.01
	var/tick_instability = 0
	var/percent_unstable = 0
	var/field_cohesion = 100 //Should be 100-0.
	var/fusion_reactant_cap
	var/cohesion_regeneration = 1

	var/obj/machinery/power/fusion_core/owned_core
	var/list/particle_catchers = list()

	var/static/list/ignore_types = list(
		/obj/item/projectile,
		/obj/effect,
		/obj/structure/cable,
		/obj/machinery/atmospherics
		)

	var/light_min_range = 2
	var/light_min_power = 3
	var/light_max_range = 12
	var/light_max_power = 12

	var/last_range
	var/last_power

/obj/effect/fusion_em_field/Initialize(mapload, var/obj/machinery/power/fusion_core/new_owned_core)
	. = ..()

	set_light(light_min_range, light_min_power)
	last_range = light_min_range
	last_power = light_min_power

	owned_core = new_owned_core
	if(!owned_core)
		return INITIALIZE_HINT_QDEL

	create_reagents(10000)

	//create the gimmicky things to handle field collisions
	var/obj/effect/fusion_particle_catcher/catcher

	catcher = new (locate(src.x,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(1)
	particle_catchers.Add(catcher)

	for(var/iter=1,iter<=6,iter++)
		catcher = new (locate(src.x-iter,src.y,src.z))
		catcher.parent = src
		catcher.SetSize((iter*2)+1)
		particle_catchers.Add(catcher)

		catcher = new (locate(src.x+iter,src.y,src.z))
		catcher.parent = src
		catcher.SetSize((iter*2)+1)
		particle_catchers.Add(catcher)

		catcher = new (locate(src.x,src.y+iter,src.z))
		catcher.parent = src
		catcher.SetSize((iter*2)+1)
		particle_catchers.Add(catcher)

		catcher = new (locate(src.x,src.y-iter,src.z))
		catcher.parent = src
		catcher.SetSize((iter*2)+1)
		particle_catchers.Add(catcher)

	addtimer(CALLBACK(src, .proc/update_light_colors), 10 SECONDS, TIMER_LOOP)

/obj/effect/fusion_em_field/proc/handle_tick()
	//make sure the field generator is still intact
	if(QDELETED(owned_core))
		qdel(src)
		return

	// Take some gas up from our environment.
	var/added_particles = FALSE
	var/datum/gas_mixture/uptake_gas = owned_core.loc.return_air()
	if(uptake_gas)
		uptake_gas = uptake_gas.remove_by_flag(MAT_FLAG_FUSION_FUEL, rand(50,100), TRUE)
	if(uptake_gas && uptake_gas.total_moles)
		for(var/gasname in uptake_gas.gas)
			if(uptake_gas.gas[gasname]*10 > REAGENT_VOLUME(reagents, gasname))
				reagents.add_reagent(gasname, uptake_gas.gas[gasname]*10)
				uptake_gas.adjust_gas(gasname, -(uptake_gas.gas[gasname]), update=FALSE)
				added_particles = TRUE
		if(added_particles)
			uptake_gas.update_values()

	// Dump power to our powernet.
	owned_core.add_avail(FUSION_ENERGY_PER_K * temperature)

	// Energy decay.
	if(temperature > T0C)
		var/lost = temperature*0.01
		radiation += lost
		temperature -= lost
		HANDLE_REACTIONS(reagents)

	//handle some reagent formatting
	for(var/reactant in reagents.reagent_volumes)
		var/amount = reagents.reagent_volumes[reactant]
		if(amount < 1)
			reagents.clear_reagent(reactant)
		else if(amount >= fusion_reactant_cap)
			var/radiate = rand(3 * amount / 4, amount / 4)
			reagents.remove_reagent(reactant, radiate)
			radiation += radiate

	check_instability()
	Radiate()
	handle_cohesion()
	if(radiation)
		SSradiation.radiate(src, round(radiation*0.001))
	return 1

/obj/effect/fusion_em_field/proc/update_light_colors()
	var/use_range
	var/use_power
	switch (temperature)
		if (-INFINITY to 1000)
			light_color = COLOR_RED
			use_range = light_min_range
			use_power = light_min_power
			alpha = 30
		if (100000 to INFINITY)
			light_color = COLOR_VIOLET
			use_range = light_max_range
			use_power = light_max_power
			alpha = 230
		else
			var/temp_mod = ((temperature-5000)/20000)
			use_range = light_min_range + CEILING((light_max_range-light_min_range)*temp_mod)
			use_power = light_min_power + CEILING((light_max_power-light_min_power)*temp_mod)
			switch (temperature)
				if (1000 to 6000)
					light_color = COLOR_ORANGE
					alpha = 50
				if (6000 to 20000)
					light_color = COLOR_YELLOW
					alpha = 80
				if (20000 to 50000)
					light_color = COLOR_GREEN
					alpha = 120
				if (50000 to 70000)
					light_color = COLOR_CYAN
					alpha = 160
				if (70000 to 100000)
					light_color = COLOR_BLUE
					alpha = 200

	if (last_range != use_range || last_power != use_power || color != light_color)
		color = light_color
		set_light(use_range, min(use_power, 1))
		last_range = use_range
		last_power = use_power

/obj/effect/fusion_em_field/proc/check_instability()
	if(tick_instability > 0)
		percent_unstable += (tick_instability*size)/FUSION_INSTABILITY_DIVISOR
		tick_instability = 0
	else
		if(percent_unstable < 0)
			percent_unstable = 0
		else
			if(percent_unstable > 1)
				percent_unstable = 1
			if(percent_unstable > 0)
				percent_unstable = max(0, percent_unstable-rand(0.01,0.03))

	if(field_cohesion == 0)
		owned_core.Shutdown(force_rupture=1)
		
	if(percent_unstable > 0.5 && prob(percent_unstable*100))
		if(temperature < FUSION_RUPTURE_THRESHOLD)
			visible_message("<span class='danger'>\The [src] ripples uneasily, like a disturbed pond.</span>")
		else
			var/flare
			var/fuel_loss
			if(percent_unstable < 0.7)
				visible_message("<span class='danger'>\The [src] ripples uneasily, like a disturbed pond.</span>")
				fuel_loss = prob(5)
			else if(percent_unstable < 0.9)
				visible_message("<span class='danger'>\The [src] undulates violently, shedding plumes of plasma!</span>")
				flare = prob(50)
				fuel_loss = prob(20)
			else
				visible_message("<span class='danger'>\The [src] is wracked by a series of horrendous distortions, buckling and twisting like a living thing!</span>")
				flare = 1
				fuel_loss = prob(50)
			var/lost_plasma = (temperature*percent_unstable)
			radiation += lost_plasma
			if(flare)
				radiation += temperature/2

			if(fuel_loss)
				var/lost_fuel = round(reagents.total_volume*percent_unstable)
				if(lost_fuel)
					reagents.remove_any(lost_fuel)
					radiation += lost_fuel

/obj/effect/fusion_em_field/proc/is_shutdown_safe()
	return temperature < 1000

/obj/effect/fusion_em_field/proc/Rupture()
	set waitfor = FALSE
	visible_message("<span class='danger'>\The [src] shudders like a dying animal before flaring to eye-searing brightness and rupturing!</span>")
	set_light(15, 15, "#ccccff")
	empulse(get_turf(src), CEILING(temperature/1000), CEILING(temperature/300))
	sleep(5)
	RadiateAll()
	explosion(get_turf(owned_core),-1,-1,8,10) // Blow out all the windows.
	return

/obj/effect/fusion_em_field/proc/ChangeFieldStrength(var/new_strength)
	var/calc_size = 1
	if(new_strength <= 50)
		calc_size = 1
	else if(new_strength <= 200)
		calc_size = 3
	else if(new_strength <= 500)
		calc_size = 5
	else if(new_strength <= 1000)
		calc_size = 7
	else if(new_strength <= 2000)
		calc_size = 9
	else if(new_strength <= 5000)
		calc_size = 11
	else
		calc_size = 13
	field_strength = new_strength
	change_size(calc_size)
	fusion_reactant_cap = field_strength * FUSION_FIELD_CAP_COEFF // Excess reagents will be ejected over the next few calls to Process()

/obj/effect/fusion_em_field/proc/AddEnergy(var/a_energy, var/a_plasma_temperature)
	energy += a_energy
	temperature += a_plasma_temperature
	if(a_energy && percent_unstable > 0)
		percent_unstable -= a_energy/10000
		if(percent_unstable < 0)
			percent_unstable = 0
	while(energy >= 100)
		energy -= 100
		temperature += 1
	HANDLE_REACTIONS(reagents)

/obj/effect/fusion_em_field/proc/AddParticles(var/mat, var/quantity = 1)
	reagents.add_reagent(mat, quantity)

/obj/effect/fusion_em_field/proc/RadiateAll(var/ratio_lost = 1)

	// Create our plasma field and dump it into our environment.
	var/turf/T = get_turf(src)
	if(istype(T))
		var/datum/gas_mixture/plasma
		for(var/reactant in reagents.reagent_volumes)
			if(!plasma)
				plasma = new
			plasma.adjust_gas(reactant, max(1,round(reagents.reagent_volumes[reactant]*0.1)), 0) // *0.1 to compensate for *10 when uptaking gas.
		reagents.clear_reagents()
		if(!plasma)
			return
		plasma.temperature = (temperature/2)
		plasma.update_values()
		T.assume_air(plasma)
		T.hotspot_expose(temperature)
		plasma = null

	// Radiate all our unspent fuel and energy.
	for(var/particle in reagents.reagent_volumes)
		radiation += reagents.reagent_volumes[particle]
		reagents.clear_reagent(particle)
	radiation += temperature/2
	temperature = T0C

	SSradiation.radiate(src, round(radiation*0.001))
	Radiate()

/obj/effect/fusion_em_field/proc/Radiate()
	if(isturf(loc))
		var/empsev = max(1, min(3, CEILING(size/2)))
		for(var/atom/movable/AM in range(max(1,FLOOR(size/2)), loc))

			if(AM == src || AM == owned_core || !AM.simulated)
				continue

			var/skip_obstacle
			for(var/ignore_path in ignore_types)
				if(istype(AM, ignore_path))
					skip_obstacle = TRUE
					break
			if(skip_obstacle)
				continue

			AM.visible_message("<span class='danger'>The field buckles visibly around \the [AM]!</span>")
			tick_instability += rand(30,50)
			AM.emp_act(empsev)

	if(owned_core && owned_core.loc)
		var/datum/gas_mixture/environment = owned_core.loc.return_air()
		if(environment && environment.temperature < (T0C+1000)) // Putting an upper bound on it to stop it being used in a TEG.
			environment.add_thermal_energy(temperature*20000)

/obj/effect/fusion_em_field/proc/change_size(var/newsize = 1)
	var/changed = 0
	var/static/list/size_to_icon = list(
			"3" = 'icons/effects/96x96.dmi',
			"5" = 'icons/effects/160x160.dmi',
			"7" = 'icons/effects/224x224.dmi',
			"9" = 'icons/effects/288x288.dmi',
			"11" = 'icons/effects/352x352.dmi',
			"13" = 'icons/effects/416x416.dmi'
			)

	if( ((newsize-1)%2==0) && (newsize<=13) )
		icon = 'icons/obj/machines/power/fusion.dmi'
		if(newsize>1)
			icon = size_to_icon["[newsize]"]
		icon_state = "emfield_s[newsize]"
		pixel_x = ((newsize-1) * -16) * PIXEL_MULTIPLIER
		pixel_y = ((newsize-1) * -16) * PIXEL_MULTIPLIER
		size = newsize
		changed = newsize

	for(var/obj/effect/fusion_particle_catcher/catcher in particle_catchers)
		catcher.UpdateSize()
	return changed

/obj/effect/fusion_em_field/Destroy()
	set_light(0)
	RadiateAll()
	QDEL_NULL_LIST(particle_catchers)
	if(owned_core)
		owned_core.owned_field = null
		owned_core = null
	. = ..()

/obj/effect/fusion_em_field/bullet_act(var/obj/item/projectile/Proj)
	AddEnergy(Proj.damage)
	update_icon()
	return 0

/obj/effect/fusion_em_field/proc/handle_cohesion()
	field_cohesion = clamp(((field_cohesion + cohesion_regeneration) - clamp(percent_unstable*FUSION_COHESION_LOSS_COEFF, 0, FUSION_COHESION_LOSS_LIMIT)),0,100)

#undef FUSION_HEAT_CAP
#undef FUSION_INSTABILITY_DIVISOR
#undef FUSION_RUPTURE_THRESHOLD
#undef FUSION_FIELD_CAP_COEFF
