#define HEAT_TRANSFER 5000
#define MAX_FREQUENCY 60
#define MIN_DELTA_T 5

/obj/machinery/atmospherics/binary/stirling
	name = "stirling engine"
	desc = "A mechanical stirling generator. It generates power dependent on the temperature differential between input gas and a radiative heatsink"
	icon = 'icons/obj/power.dmi'
	icon_state = "stirling"
	density = 1
	anchored = 1
	layer = STRUCTURE_LAYER
	use_power = POWER_USE_OFF
	base_type = /obj/machinery/atmospherics/binary/stirling
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = NOSCREEN | NOINPUT | NOPOWER // Mechanical machine and display.
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_FUEL

	var/obj/item/tank/stirling/inserted_cylinder

	var/cycle_frequency = MAX_FREQUENCY/2

	var/max_power = 100000
	var/genlev = 0
	var/lastgen = 0
	var/skipped_cycle = FALSE

	var/sound_id
	var/datum/sound_token/sound_token

/obj/machinery/atmospherics/binary/stirling/Destroy()
	QDEL_NULL(inserted_cylinder)
	QDEL_NULL(sound_token)
	. = ..()

/obj/machinery/atmospherics/binary/stirling/Process()
	..()

	// Some temperature equilibrium between the gas lines.
	var/air1_eq = air1.get_thermal_energy_change(air2.temperature)
	var/air2_eq = air2.get_thermal_energy_change(air1.temperature)

	var/heat_transfer = clamp(HEAT_TRANSFER*(air1.temperature - air2.temperature), min(air1_eq, air2_eq), max(air1_eq, air2_eq))
	if(heat_transfer)
		air1.add_thermal_energy(-heat_transfer)
		air2.add_thermal_energy(heat_transfer)

	if(!istype(inserted_cylinder))
		return

	if(use_power != POWER_USE_ACTIVE)
		update_icon()
		update_sound()
		return

	var/datum/gas_mixture/working_volume = inserted_cylinder.air_contents

	if(stat & (BROKEN) || !air1.total_moles || !air2.total_moles || !working_volume.total_moles)
		stop_engine()
		return
	
	// A rough approximation of a Stirling cycle with perfect regeneration e.g. Carnot efficiency.
	var/working_heatcap = working_volume.heat_capacity()
	var/line1_heatcap = air1.heat_capacity()
	var/line2_heatcap = air2.heat_capacity()

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

	// The cycle requires a minimum temperature to overcome friction.
	if(abs(air1.temperature - air2.temperature) < MIN_DELTA_T)
		if(skipped_cycle) // Allow some leeway since networks can take some time to update.
			stop_engine()
		skipped_cycle = TRUE
		return
	skipped_cycle = FALSE

	// Positive/negative Work from volume expansion/compression. Maximum volume is 1.5 tank volume.	The volume of the tank is not actually adjusted.
	var/work_coefficient = working_volume.get_total_moles()*R_IDEAL_GAS_EQUATION*log(1.5)
	var/work_done = work_coefficient*abs(air1.temperature - air2.temperature)*cycle_frequency

	var/reversed = air1.temperature < air2.temperature ? 1 : -1

	var/air1_dq = reversed*work_coefficient*air1.temperature*cycle_frequency
	var/air2_dq = -reversed*work_coefficient*air2.temperature*cycle_frequency

	var/power_generated = 0.75*work_done
	// Excessive power is transferred as heat to the opposite side, reducing efficiency.
	if(power_generated > max_power)
		if(reversed)
			air1_dq += 0.75*(max_power - power_generated)
		else
			air2_dq += 0.75*(max_power - power_generated)
		power_generated = max_power
		if(prob(5))
			spark_at(src, cardinal_only = TRUE)

	air1.add_thermal_energy(air1_dq)
	air2.add_thermal_energy(air2_dq)
	
	generate_power(power_generated)
	lastgen = power_generated
	genlev = max(0, min(round(4*power_generated / max_power), 4))

	update_icon()
	update_sound()
	update_networks()

/obj/machinery/atmospherics/binary/stirling/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return

	to_chat(user, "\The [src] is generating [round(lastgen/1000, 0.1)] kW")
	if(!inserted_cylinder)
		to_chat(user, "There is no piston cylinder inserted into \the [src].")

/obj/machinery/atmospherics/binary/stirling/attackby(var/obj/item/W, var/mob/user)
	if((istype(W, /obj/item/tank/stirling)))
		if(inserted_cylinder)
			return
		if(!user.unEquip(W, src))
			return
		to_chat(user, SPAN_NOTICE("You insert \the [W] into \the [src]."))
		inserted_cylinder = W
		update_icon()
		return TRUE
	
	if(isCrowbar(W) && inserted_cylinder)
		inserted_cylinder.dropInto(get_turf(src))
		to_chat(user, SPAN_NOTICE("You remove \the [inserted_cylinder] from \the [src]."))
		inserted_cylinder = null
		stop_engine()
		return TRUE

	if(panel_open && isWrench(W))
		var/target_frequency = input(user, "Enter the cycle frequency you would like \the [src] to operate at ([MAX_FREQUENCY/4] - [MAX_FREQUENCY] Hz)", "Stirling Frequency", cycle_frequency) as num | null
		if(!CanPhysicallyInteract(user) || !target_frequency)
			return
		cycle_frequency = round(clamp(target_frequency, MAX_FREQUENCY/4, MAX_FREQUENCY))
		to_chat(usr, SPAN_NOTICE("You adjust \the [src] to operate at a frequency of [cycle_frequency] Hz."))
		return TRUE

	. = ..()

/obj/machinery/atmospherics/binary/stirling/attack_hand(mob/user)
	if(!(stat & BROKEN) && use_power != POWER_USE_ACTIVE)
		if(!inserted_cylinder)
			to_chat(user, SPAN_WARNING("You must insert a stirling piston cylinder into \the [src] before you can start it!"))
			return
		to_chat(user, "You start trying to manually rev up \the [src].")
		if(do_after(user, 2 SECONDS, src) && use_power != POWER_USE_ACTIVE && inserted_cylinder && !(stat & BROKEN))
			visible_message("[user] pulls on the starting cord of \the [src], revving it up!", "You pull on the starting cord of \the [src], revving it up!")
			playsound(src.loc, 'sound/machines/engine.ogg', 35, 1)
			update_use_power(POWER_USE_ACTIVE)
		return
	. = ..()

/obj/machinery/atmospherics/binary/stirling/on_update_icon()
	cut_overlays()
	if (stat & (BROKEN))
		return
	if (genlev != 0)
		add_overlay(emissive_overlay('icons/obj/power.dmi', "stirling-op[genlev]")) 

/obj/machinery/atmospherics/binary/stirling/proc/update_sound()
	if(!sound_id)
		sound_id = "[type]_[sequential_id(/obj/machinery/atmospherics/binary/stirling)]"
	if(use_power == POWER_USE_ACTIVE)
		var/volume = 10 + 15*genlev
		if(!sound_token)
			sound_token = play_looping_sound(src, sound_id, 'sound/machines/engine.ogg', volume = volume)
		sound_token.SetVolume(volume)
	else if(sound_token)
		QDEL_NULL(sound_token)

/obj/machinery/atmospherics/binary/stirling/proc/stop_engine()
	skipped_cycle = FALSE
	if(use_power == POWER_USE_ACTIVE)
		visible_message(SPAN_WARNING("\The [src] sputters to a violent halt!"))
		update_use_power(POWER_USE_IDLE)
		update_sound()
		update_icon()

/obj/machinery/atmospherics/binary/stirling/dismantle()
	if(inserted_cylinder)
		inserted_cylinder.dropInto(get_turf(src))
	. = ..()

/obj/item/tank/stirling
	name = "stirling piston cylinder"
	desc = "A piston cylinder designed for use in a stirling engine. It must be charged with gas before it can be used. Rated for temperatures up to 1000 C"
	icon = 'icons/obj/items/tanks/tank_stirling.dmi'
	gauge_icon = null
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = null
	starting_pressure = list(/decl/material/gas/hydrogen = 2*ONE_ATMOSPHERE)

	volume = 30
	failure_temp = 1000

/obj/item/tank/stirling/empty
	starting_pressure = list()

#undef HEAT_TRANSFER
#undef MAX_FREQUENCY
#undef MIN_DELTA_T