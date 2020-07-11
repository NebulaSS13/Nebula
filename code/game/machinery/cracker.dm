/obj/machinery/portable_atmospherics/cracker
	name = "molecular cracking unit"
	desc = "An integrated catalytic water cracking system used to break H2O down into H and O."
	icon = 'icons/obj/machines/cracker.dmi'
	icon_state = "cracker"
	density = 1
	anchored = 1
	waterproof = TRUE
	volume = 5000
	use_power = POWER_USE_IDLE
	idle_power_usage = 100
	active_power_usage = 10000

	var/tmp/fluid_consumption_per_tick = 100
	var/tmp/gas_generated_per_tick = 1
	var/tmp/max_reagents = 100

/obj/machinery/portable_atmospherics/cracker/on_update_icon()
	icon_state = (use_power == POWER_USE_ACTIVE) ? "cracker_on" : "cracker"

/obj/machinery/portable_atmospherics/cracker/interface_interact(mob/user)
	if(use_power == POWER_USE_IDLE)
		update_use_power(POWER_USE_ACTIVE)
	else
		update_use_power(POWER_USE_IDLE)
	user.visible_message(SPAN_NOTICE("\The [user] [use_power == POWER_USE_ACTIVE ? "engages" : "disengages"] \the [src]."))
	update_icon()
	return TRUE

/obj/machinery/portable_atmospherics/cracker/power_change()
	. = ..()
	if(. && (stat & NOPOWER))
		update_use_power(POWER_USE_IDLE)
		update_icon()

/obj/machinery/portable_atmospherics/cracker/set_broken(new_state)
	. = ..()
	if(. && (stat & BROKEN))
		update_use_power(POWER_USE_IDLE)
		update_icon()

/obj/machinery/portable_atmospherics/cracker/Process()
	..()
	if(use_power == POWER_USE_IDLE)
		return

	// Produce materials.
	var/turf/T = get_turf(src)
	if(istype(T))
		var/obj/effect/fluid/F = T.return_fluid()
		if(istype(F))

			// Drink more water!
			var/consuming = min(F.reagents.total_volume, fluid_consumption_per_tick)
			F.reagents.remove_any(consuming)
			T.show_bubbles()

			// Gas production.
			var/datum/gas_mixture/produced = new
			var/gen_amt = min(1, (gas_generated_per_tick * (consuming/fluid_consumption_per_tick)))
			produced.adjust_gas(/decl/material/gas/oxygen,  gen_amt)
			produced.adjust_gas(/decl/material/gas/hydrogen, gen_amt * 2)
			produced.temperature = T20C //todo water temperature
			air_contents.merge(produced)
