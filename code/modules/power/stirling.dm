#define HEAT_TRANSFER 300
#define MAX_FREQUENCY 60
#define MIN_DELTA_T 5

/obj/machinery/atmospherics/binary/stirling
	name = "stirling engine"
	desc = "A mechanical stirling generator. It generates power dependent on the temperature differential between two gas lines."
	icon = 'icons/obj/power.dmi'
	icon_state = "stirling"
	density = TRUE
	anchored = TRUE
	layer = STRUCTURE_LAYER
	base_type = /obj/machinery/atmospherics/binary/stirling
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = NOSCREEN | NOINPUT | NOPOWER // Mechanical machine and display.
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL

	var/obj/item/tank/stirling/inserted_cylinder

	var/cycle_frequency = MAX_FREQUENCY/2
	var/active = FALSE

	var/max_power = 150000
	var/genlev = 0
	var/last_genlev

	var/last_gen = 0
	var/skipped_cycle = FALSE

	var/sound_id
	var/datum/sound_token/sound_token

/obj/machinery/atmospherics/binary/stirling/Destroy()
	QDEL_NULL(inserted_cylinder)
	QDEL_NULL(sound_token)
	. = ..()

/obj/machinery/atmospherics/binary/stirling/Process()
	..()

	var/line1_heatcap = air1.heat_capacity()
	var/line2_heatcap = air2.heat_capacity()

	var/delta_t = air1.temperature - air2.temperature

	// Absolute value of the heat transfer required to bring both lines in equilibrium.
	var/line_equilibrium_heat = ((line1_heatcap*line2_heatcap)/(line1_heatcap + line2_heatcap))*abs(delta_t)

	// Some passive equilibrium between the lines.
	var/passive_heat_transfer = min(HEAT_TRANSFER*abs(delta_t), line_equilibrium_heat)

	air1.add_thermal_energy(-sign(delta_t)*passive_heat_transfer)
	air2.add_thermal_energy(sign(delta_t)*passive_heat_transfer)

	if(!istype(inserted_cylinder))
		return
	if(!active)
		return

	var/datum/gas_mixture/working_volume = inserted_cylinder.air_contents

	if((stat & BROKEN) || !air1.total_moles || !air2.total_moles || !working_volume?.total_moles || !working_volume?.return_pressure())
		stop_engine()
		return

	// A rough approximation of a Stirling cycle with perfect regeneration e.g. Carnot efficiency.
	var/working_heatcap = working_volume.heat_capacity()

	// Bring the internal tank in thermal equilibrium with the hottest line. The temperature/pressure
	// is kept at the maximum constantly.
	var/equil_transfer

	if(air1.temperature >= air2.temperature)
		equil_transfer = (working_heatcap*line1_heatcap)/(working_heatcap + line1_heatcap)*(air1.temperature - working_volume.temperature)
		air1.add_thermal_energy(-equil_transfer)
	else
		equil_transfer = (working_heatcap*line2_heatcap)/(working_heatcap + line2_heatcap)*(air2.temperature - working_volume.temperature)
		air2.add_thermal_energy(-equil_transfer)

	working_volume.add_thermal_energy(equil_transfer)

	// Redefine in case there was a change from passive heat transfer.
	delta_t = air1.temperature - air2.temperature
	line_equilibrium_heat = ((line1_heatcap*line2_heatcap)/(line1_heatcap + line2_heatcap))*abs(delta_t)

	// The cycle requires a minimum temperature to overcome friction.
	if(abs(delta_t) < MIN_DELTA_T)
		if(skipped_cycle) // Allow some leeway since networks can take some time to update.
			stop_engine()
		skipped_cycle = TRUE
		return
	skipped_cycle = FALSE

	// Positive/negative work from volume expansion/compression. Maximum volume is 1.5 tank volume.	The volume of the tank is not actually adjusted.
	var/work_coefficient = working_volume.get_total_moles()*R_IDEAL_GAS_EQUATION*log(1.5)

	// Direction of heat flow, 1 for air1 -> air 2, -1 for air2 -> air 1
	var/heat_dir = sign(delta_t)

	// We multiply by the cycle frequency to get reasonable values for power generation.
	// Energy is still conserved, but the efficiency of the engine is slightly overestimated.

	// The hot line and cold line will not receive or give more than the heat required to reach equilibrium.
	var/air1_dq = -heat_dir*min(work_coefficient*air1.temperature*cycle_frequency, line_equilibrium_heat)
	var/air2_dq = heat_dir*min(work_coefficient*air2.temperature*cycle_frequency, line_equilibrium_heat)

	var/work_done = -(air1_dq + air2_dq)

	var/power_generated = 0.75*work_done
	// Excessive power is transferred as heat to the cooler side, reducing efficiency.
	if(power_generated > max_power)
		if(heat_dir == 1)
			air2_dq += 0.85*(max_power - power_generated)
		else
			air1_dq += 0.85*(max_power - power_generated)
		power_generated = max_power
		if(prob(5))
			spark_at(src, cardinal_only = TRUE)

	generate_power(power_generated)
	last_gen = power_generated
	genlev = max(0, min(round(4*power_generated / max_power), 4))
	if(genlev != last_genlev)
		update_icon()
		update_sound()
	last_genlev = genlev
	update_networks()

/obj/machinery/atmospherics/binary/stirling/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return
	if(active)
		to_chat(user, "\The [src] is generating [round(last_gen/1000, 0.1)] kW")
	if(!inserted_cylinder)
		to_chat(user, "There is no piston cylinder inserted into \the [src].")

/obj/machinery/atmospherics/binary/stirling/attackby(var/obj/item/W, var/mob/user)
	if((istype(W, /obj/item/tank/stirling)))
		if(inserted_cylinder)
			return
		if(!user.try_unequip(W, src))
			return
		to_chat(user, SPAN_NOTICE("You insert \the [W] into \the [src]."))
		inserted_cylinder = W
		update_icon()
		return TRUE

	if(!panel_open)
		if(IS_CROWBAR(W) && inserted_cylinder)
			inserted_cylinder.dropInto(get_turf(src))
			to_chat(user, SPAN_NOTICE("You remove \the [inserted_cylinder] from \the [src]."))
			inserted_cylinder = null
			stop_engine()
			return TRUE

		if(IS_WRENCH(W))
			var/target_frequency = input(user, "Enter the cycle frequency you would like \the [src] to operate at ([MAX_FREQUENCY/4] - [MAX_FREQUENCY] Hz)", "Stirling Frequency", cycle_frequency) as num | null
			if(!CanPhysicallyInteract(user) || !target_frequency)
				return
			cycle_frequency = round(clamp(target_frequency, MAX_FREQUENCY/4, MAX_FREQUENCY))
			to_chat(usr, SPAN_NOTICE("You adjust \the [src] to operate at a frequency of [cycle_frequency] Hz."))
			return TRUE

	. = ..()

/obj/machinery/atmospherics/binary/stirling/physical_attack_hand(mob/user)

	if((stat & BROKEN) || active || panel_open)
		return ..()

	if(!inserted_cylinder)
		to_chat(user, SPAN_WARNING("You must insert a stirling piston cylinder into \the [src] before you can start it!"))
		return
	to_chat(user, "You start trying to manually rev up \the [src].")
	if(do_after(user, 2 SECONDS, src) && !active && inserted_cylinder && !(stat & BROKEN))
		visible_message("[user] pulls on the starting cord of \the [src], revving it up!", "You pull on the starting cord of \the [src], revving it up!")
		playsound(src.loc, 'sound/machines/engine.ogg', 35, 1)
		active = TRUE

/obj/machinery/atmospherics/binary/stirling/on_update_icon()
	cut_overlays()
	if (stat & (BROKEN))
		return
	if (genlev != 0)
		add_overlay(emissive_overlay('icons/obj/power.dmi', "stirling-op[genlev]"))

/obj/machinery/atmospherics/binary/stirling/proc/update_sound()
	if(!sound_id)
		sound_id = "[type]_[sequential_id(/obj/machinery/atmospherics/binary/stirling)]"
	if(active)
		var/volume = 10 + 15*genlev
		if(!sound_token)
			sound_token = play_looping_sound(src, sound_id, 'sound/machines/engine.ogg', volume = volume)
		sound_token.SetVolume(volume)
	else if(sound_token)
		QDEL_NULL(sound_token)

/obj/machinery/atmospherics/binary/stirling/proc/stop_engine()
	skipped_cycle = FALSE
	if(active)
		visible_message(SPAN_WARNING("\The [src] sputters to a violent halt!"))
		active = FALSE
		update_sound()
		update_icon()

/obj/machinery/atmospherics/binary/stirling/dismantle()
	if(inserted_cylinder)
		inserted_cylinder.dropInto(get_turf(src))
	. = ..()

/obj/item/tank/stirling
	name = "stirling piston cylinder"
	desc = "A piston cylinder designed for use in a stirling engine. It must be charged with gas before it can be used."
	icon = 'icons/obj/items/tanks/tank_stirling.dmi'
	gauge_icon = null
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = null
	starting_pressure = list(/decl/material/gas/hydrogen = 2 ATM)

	volume = 30
	failure_temp = 1000

/obj/item/tank/stirling/Initialize()
	. = ..()
	desc += " It's rated for temperatures up to [failure_temp] C."

/obj/item/tank/stirling/empty
	starting_pressure = list()

#undef HEAT_TRANSFER
#undef MAX_FREQUENCY
#undef MIN_DELTA_T