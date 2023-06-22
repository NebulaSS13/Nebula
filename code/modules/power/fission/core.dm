#define RATIO_PER_NEUTRON      0.0000001
#define MIN_RADIATION_ENERGY        2000
#define ACTIVE_THRESHOLD             200
#define MAX_RODS                       7
#define JUMPED_FLUX                 1000
#define JUMPED_ENERGY               1200
#define MAX_RADS                      50

#define MAX_INTERACT_RATIO           0.5
#define HI_NEUT_DIVISOR              125
#define LO_NEUT_DIVISOR               50
#define CONTROL_ROD_DIVISOR            5

/obj/machinery/atmospherics/unary/fission_core
	name = "nuclear fission core"
	desc = "An advanced atomic pile used to generate heat and create isotopes via nuclear fission."
	icon = 'icons/obj/machines/power/fission.dmi'
	icon_state = "fission_core"
	layer = ABOVE_HUMAN_LAYER
	density = 1
	stat_immune = NOINPUT | NOSCREEN
	base_type = /obj/machinery/atmospherics/unary/fission_core
	construct_state = /decl/machine_construction/default/panel_closed
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL

	var/control_rod_depth = 1   // 0-1, how deeply the control rods are inserted into the core, controlling neutron absorption.
	var/neutron_flux = 0        // The amount of neutrons in the core. Determines the ratio of fuel inside the core that is interacted with each tick.
	var/neutron_energy = 0      // The average energy of the neutrons in the core. Df

	var/list/fuel_rods = list() // Material inserted into the core, fuel, moderators etc.

	var/max_temperature = 1000  // Maximum temperature of the interior gas mixture before the core begins to take damage.
	var/last_message            // Time of the last damage warning message.
	var/damage = 0
	var/melted_down = FALSE

	// Diagnostics
	var/last_neutron_flux_increase = 0
	var/last_neutron_flux_decrease = 0
	var/net_neutron_flux_change    = 0

	var/last_neutron_energy_increase = 0
	var/last_neutron_energy_decrease = 0
	var/net_neutron_energy_change    = 0

	var/initial_id_tag = "fission"

/obj/machinery/atmospherics/unary/fission_core/Initialize()
	. = ..()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/fission = get_extension(src, /datum/extension/local_network_member)
		fission.set_tag(null, initial_id_tag)

/obj/machinery/atmospherics/unary/fission_core/Destroy()
	fuel_rods.Cut()
	. = ..()

/obj/machinery/atmospherics/unary/fission_core/Process()
	..()

	last_neutron_flux_increase = 0
	last_neutron_flux_decrease = 0
	net_neutron_flux_change    = 0

	last_neutron_energy_increase = 0
	last_neutron_energy_decrease = 0
	net_neutron_energy_change    = 0

	if((!air_contents.get_total_moles() && check_active()) || (air_contents.temperature > max_temperature))
		// Stopping the reaction is relatively easy, but removing the heat rapidly is not. Total meltdown takes some time.
		damage += air_contents.temperature ? min(3, round(air_contents.temperature/max_temperature)) : 3

		if(world.time >= last_message + 10 SECONDS)
			if(damage > 75)
				visible_message(SPAN_DANGER("Parts of \the [src] begin to buckle outwards threateningly!"))
				last_message = world.time
			else if(damage > 50)
				visible_message(SPAN_WARNING("\The [src]'s outward facing insulation begins to melt!"))
				last_message = world.time
			else if(damage > 10)
				visible_message(SPAN_WARNING("\The [src] creaks loudly!"))
				last_message = world.time

	if(damage >= 100)
		meltdown()
		return

	// Interactions modify these values, so to prevent inconsistencies depending on the order of materials, use the initial values for most calculations.
	var/old_neutron_flux = neutron_flux
	var/old_neutron_energy = neutron_energy

	// What percentage of the material is interacted with. Capped at 0.5 to prevent instantaneous disasters.
	var/interaction_ratio = min(MAX_INTERACT_RATIO, RATIO_PER_NEUTRON*old_neutron_flux)
	for(var/obj/item/fuel_assembly/fr in fuel_rods)
		if(!fuel_rods[fr]) // The fuel rod is not exposed.
			continue
		for(var/mat_type in fr.matter)
			var/decl/material/mat = GET_DECL(mat_type)
			if(!(mat.flags & MAT_FLAG_FISSIBLE))
				continue
			var/total_interacted_units = interaction_ratio * fr.matter[mat_type]
			var/list/interactions = mat.neutron_interact(old_neutron_energy, total_interacted_units, fr.matter[mat_type])
			for(var/interaction in interactions)
				var/interaction_units = interactions[interaction] // How many units of the material underwent this specific interaction.
				var/removed = 0
				if(!interaction_units)
					continue
				switch(interaction)
					if(INTERACTION_FISSION)
						if(length(mat.fission_products))
							if(fr.matter[mat_type] - interaction_units < 0)
								removed = fr.matter[mat_type]
								fr.matter -= mat_type
							else
								removed = interaction_units
								fr.matter[mat_type] -= removed
							// Add the fission byproducts to the fuel assembly.
							for(var/byproduct_type in mat.fission_products)
								fr.matter[byproduct_type] += removed * mat.fission_products[byproduct_type]

							if(mat.neutron_production)
								// Determine how many neutrons should be added to the flux.
								var/d_neutron_flux = mat.neutron_production*removed
								// Fission releases high energy neutrons that increase the average energy of the neutrons in the core.
								var/d_neutron_energy = max(0, interaction_units * (mat.fission_energy - old_neutron_energy)/HI_NEUT_DIVISOR)
								last_neutron_energy_increase += d_neutron_energy
								neutron_energy += d_neutron_energy
								neutron_flux += d_neutron_flux
								last_neutron_flux_increase += d_neutron_flux

							if(mat.fission_heat)
								air_contents.add_thermal_energy(removed*mat.fission_heat)

					// A simplification of neutron capture and/or subsequent beta decay.
					if(INTERACTION_ABSORPTION)
						if(length(mat.absorption_products))
							if(fr.matter[mat_type] - interaction_units < 0)
								removed = fr.matter[mat_type]
								fr.matter -= mat_type
							else
								removed = interaction_units
								fr.matter[mat_type] -= removed

							for(var/byproduct_type in mat.absorption_products)
								fr.matter[byproduct_type] += removed * mat.absorption_products[byproduct_type]

						var/d_neutron_flux = mat.neutron_absorption*removed
						neutron_flux -= d_neutron_flux
						last_neutron_flux_decrease += d_neutron_flux

					// Neutron moderation, reduction of neutron energy towards the target value for that material.
					if(INTERACTION_SCATTER)
						// Neutron moderators can only slow, not speed up neutrons. Check against the current neutron energy to ensure this.
						if(mat.moderation_target > neutron_energy)
							continue
						var/d_neutron_energy = min(neutron_energy, interaction_units * (old_neutron_energy - mat.moderation_target)/LO_NEUT_DIVISOR)
						last_neutron_energy_decrease += d_neutron_energy
						neutron_energy = max(mat.moderation_target, neutron_energy - d_neutron_energy)

	// Neutron energy must pass a threshold for there to be danger of radiation.
	if(neutron_energy >= MIN_RADIATION_ENERGY)
		var/radiation_power = clamp(old_neutron_energy/1000 * old_neutron_flux/1000, 0, 40)
		SSradiation.radiate(src, round(radiation_power))

	// Control rods reduces neutron flux by 1/5th at full depth.
	last_neutron_flux_decrease += round(neutron_flux*(control_rod_depth/CONTROL_ROD_DIVISOR))
	neutron_flux = round(neutron_flux*(1 - (control_rod_depth/CONTROL_ROD_DIVISOR)))

	if(!neutron_flux)
		neutron_energy = 0

	net_neutron_energy_change = last_neutron_energy_increase - last_neutron_energy_decrease
	net_neutron_flux_change = last_neutron_flux_increase - last_neutron_flux_decrease

/obj/machinery/atmospherics/unary/fission_core/proc/meltdown()
	if(melted_down)
		return
	melted_down = TRUE
	var/total_radioactivity = 0

	for(var/obj/item/fuel_assembly/rod in fuel_rods)
		if(total_radioactivity >= MAX_RADS)
			break
		for(var/mat_type in rod.matter)
			var/decl/material/mat = GET_DECL(mat_type)
			total_radioactivity += mat.radioactivity*SHEET_MATERIAL_AMOUNT / rod.matter[mat_type]

	visible_message(SPAN_DANGER("\The [src] explodes, blowing out its stored material!"))
	// The core contained radioactive material, so irradiate the surroundings.
	SSradiation.radiate(src, total_radioactivity)

	// Determine how powerful the explosion produced by the reactor will be. A larger explosion can be achieved by heating the reactor up very quickly.
	var/temperature = clamp(air_contents.temperature, 1000, 7500)
	explosion(get_turf(src), temperature/1500, temperature/750, temperature/500, temperature/500)
	qdel(src)

/obj/machinery/atmospherics/unary/fission_core/proc/check_active()
	return neutron_flux >= ACTIVE_THRESHOLD

/obj/machinery/atmospherics/unary/fission_core/attackby(var/obj/item/W, var/mob/user)
	if(IS_MULTITOOL(W))
		var/datum/extension/local_network_member/fission = get_extension(src, /datum/extension/local_network_member)
		fission.get_new_tag(user)
		return

	// Cannot deconstruct etc. the core while it is active.
	if(check_active())
		to_chat(user, SPAN_WARNING("You cannot do that while \the [src] is active!"))
		return

	if(istype(W, /obj/item/fuel_assembly))
		if(length(fuel_rods) >= MAX_RODS)
			to_chat(user, SPAN_WARNING("\The [src] is full!"))
			return
		if(!user.try_unequip(W, src))
			return
		fuel_rods[W] = FALSE // Rod is not exposed to begin with.
		visible_message(SPAN_NOTICE("\The [user] inserts \a [W] into \the [src]."), SPAN_NOTICE("You insert \a [W] into \the [src]."))
		return
	. = ..()

/obj/machinery/atmospherics/unary/fission_core/proc/jump_start()
	if((stat & (BROKEN|NOPOWER)) || (can_use_power_oneoff(5 KILOWATTS) > 0))
		visible_message("\The [src] flashes an 'Insufficient Power' error.")
		return
	use_power_oneoff(5 KILOWATTS)

	neutron_flux = JUMPED_FLUX
	neutron_energy = JUMPED_ENERGY

/obj/machinery/atmospherics/unary/fission_core/proc/adjust_control_rods(var/new_depth)
	if(stat & (BROKEN|NOPOWER))
		return
	new_depth = clamp(new_depth, 0, 1)
	control_rod_depth = new_depth

/obj/machinery/atmospherics/unary/fission_core/proc/toggle_rod_exposure(var/rod)
	if(stat & (BROKEN|NOPOWER))
		return
	if(!rod || !fuel_rods[rod])
		return FALSE
	var/obj/item/fuel_assembly/fr = fuel_rods[rod]
	if(fuel_rods[fr] && check_active())
		return FALSE

	fuel_rods[fr] = !fuel_rods[fr]
	return TRUE

/obj/machinery/atmospherics/unary/fission_core/proc/eject_rod(var/rod)
	if(check_active() || !rod || !fuel_rods[rod])
		return FALSE
	var/obj/item/fuel_assembly/fr = fuel_rods[rod]
	fuel_rods -= fr
	fr.dropInto(loc)
	return TRUE

// Returns the data visible via a fission core control computer.
/obj/machinery/atmospherics/unary/fission_core/proc/build_ui_data(var/rod)
	. = list()
	.["core"] = "\ref[src]"
	.["neutron_flux"] = neutron_flux
	.["neutron_energy"] = neutron_energy
	.["temperature"] = air_contents.temperature
	.["control_rod_depth"] = control_rod_depth
	for(var/obj/item/fuel_assembly/fa in fuel_rods)
		.["rods"] += list(list("name" = "[fa.name]"))
	var/list/rod_mats = list()
	if(rod && length(fuel_rods) >= rod)
		var/obj/item/fuel_assembly/current_rod = fuel_rods[rod]
		if(istype(current_rod))
			for(var/mat_type in current_rod.matter)
				var/decl/material/mat = GET_DECL(mat_type)
				rod_mats += list(list("name" = mat.name, "amount" = current_rod.matter[mat_type]))
			.["rod_exposed"] = fuel_rods[current_rod]
			.["rod_materials"] = rod_mats
	// Advanced diagnostics - used for precise balancing of the reaction
	.["lastenergyincrease"] = last_neutron_energy_increase
	.["lastenergydecrease"] = last_neutron_energy_decrease
	.["netenergychange"] = net_neutron_energy_change

	.["lastfluxincrease"] = last_neutron_flux_increase
	.["lastfluxdecrease"] = last_neutron_flux_decrease
	.["netfluxchange"] = net_neutron_flux_change

/obj/machinery/atmospherics/unary/fission_core/explosion_act(severity)
	. = ..()
	if(!QDELETED(src))
		damage += 10 * severity

#undef RATIO_PER_NEUTRON
#undef MIN_RADIATION_ENERGY
#undef ACTIVE_THRESHOLD
#undef MAX_RODS
#undef JUMPED_FLUX
#undef JUMPED_ENERGY
#undef MAX_RADS

#undef MAX_INTERACT_RATIO
#undef HI_NEUT_DIVISOR
#undef LO_NEUT_DIVISOR
#undef CONTROL_ROD_DIVISOR