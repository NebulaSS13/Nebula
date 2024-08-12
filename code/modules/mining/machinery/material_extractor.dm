#define GAS_EXTRACTOR_OPERATING_TEMP T20C + 15
#define MAX_INTAKE_ORE_PER_TICK 10

/obj/machinery/material_processing/extractor
	name = "material extractor"
	desc = "A machine for extracting liquids and gases from ices and hydrates."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "extractor"
	use_ui_template = "material_processing_extractor.tmpl"
	atom_flags = ATOM_FLAG_CLIMBABLE | ATOM_FLAG_NO_REACT | ATOM_FLAG_NO_DISSOLVE

	var/static/list/eating_whitelist = list(/obj/item/stack/material)

	var/datum/gas_mixture/gas_contents

	var/obj/item/chems/glass/output_container
	var/dispense_amount = 50

	// Since reactions and heating products may overfill the reagent tank, the reagent tank has 1.25x this volume.
	var/static/max_liquid = 3000

/obj/machinery/material_processing/extractor/Initialize()
	. = ..()
	if(!gas_contents)
		gas_contents = new(800)
	set_extension(src, /datum/extension/atmospherics_connection, FALSE, gas_contents)

	create_reagents(round(1.25*max_liquid))
	queue_temperature_atoms(src)

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/material_processing/extractor/Destroy()
	QDEL_NULL(output_container)
	. = ..()

/obj/machinery/material_processing/extractor/physically_destroyed(skip_qdel)
	var/obj/container = remove_container()
	if(container)
		container.dropInto(get_turf(src))
	. = ..()

/obj/machinery/material_processing/extractor/dismantle()
	var/obj/container = remove_container()
	if(container)
		container.dropInto(get_turf(src))
	. = ..()

/obj/machinery/material_processing/extractor/LateInitialize()
	. = ..()

	var/obj/machinery/atmospherics/portables_connector/port = locate() in loc
	if(port)
		var/datum/extension/atmospherics_connection/connection = get_extension(src, /datum/extension/atmospherics_connection)
		if(connection)
			connection.connect(port)


/obj/machinery/material_processing/extractor/examine(mob/user)
	. = ..()

	var/datum/extension/atmospherics_connection/connection = get_extension(src, /datum/extension/atmospherics_connection)
	if(connection.connected_port)
		to_chat(user, SPAN_NOTICE("It is connected to \the [connection.connected_port]."))
	else
		to_chat(user, SPAN_NOTICE("It may be connected to an atmospherics connector port with a wrench."))

	if(output_container)
		to_chat(user, SPAN_NOTICE("It has \a [output_container] inserted."))

/obj/machinery/material_processing/extractor/Process()
	if(!use_power || (stat & (BROKEN|NOPOWER)))
		return

	if(reagents?.total_volume >= max_liquid)
		return

	if(input_turf)
		var/eaten = 0
		for(var/obj/item/eating in input_turf)
			if(!eating.simulated || eating.anchored)
				continue
			if(!can_eat(eating))
				if(output_turf)
					eating.dropInto(output_turf)
				continue
			eaten++
			if(eating.reagents?.total_volume)
				eating.reagents.trans_to_obj(src, eating.reagents.total_volume)
			for(var/mtype in eating.matter)
				add_to_reagents(mtype, floor(eating.matter[mtype] * REAGENT_UNITS_PER_MATERIAL_UNIT))
			qdel(eating)
			if(eaten >= MAX_INTAKE_ORE_PER_TICK)
				break

/obj/machinery/material_processing/extractor/on_reagent_change()

	if(!(. = ..()) || !reagents)
		return

	var/adjusted_reagents = FALSE
	for(var/mtype in reagents.reagent_volumes)
		adjusted_reagents = max(adjusted_reagents, process_non_liquid(mtype))

	if(adjusted_reagents)
		if(gas_contents)
			gas_contents.update_values()
		reagents.update_total()

/obj/machinery/material_processing/extractor/proc/process_non_liquid(var/mtype)
	var/adjusted_reagents = FALSE
	var/flashed_warning = FALSE
	var/decl/material/mat = GET_DECL(mtype)
	// TODO: Change this to ambient/tank pressure when phase changes are properly implemented.
	switch(mat.phase_at_temperature(temperature, ONE_ATMOSPHERE))
		if(MAT_PHASE_GAS)
			if(gas_contents)
				adjusted_reagents = TRUE
				var/reagent_vol = REAGENT_VOLUME(reagents, mtype)
				var/mols = mat.get_mols_from_units(reagent_vol, MAT_PHASE_LIQUID)

				// Because this generates heated gas, we draw some additional power for heating it
				// from the ice temperature, ignoring latent heats.
				var/power_draw_per_mol = (temperature - T0C)*mat.gas_specific_heat

				var/avail_power = power_draw_per_mol*mols - max(can_use_power_oneoff(power_draw_per_mol*mols), 0)
				var/processed_mols = avail_power/power_draw_per_mol

				if(processed_mols)
					// The ratio processed_moles/moles gives us the ratio of the reagent volume to what should be removed
					// since the mole to unit conversion is linear.
					remove_from_reagents(mtype, reagent_vol*(processed_mols/mols), defer_update = TRUE)

					use_power_oneoff(power_draw_per_mol*mols)
					// Still somewhat arbitary
					gas_contents.adjust_gas_temp(mtype, mols, temperature, FALSE)

				// Some feedback for the user
				if(!flashed_warning && processed_mols < mols)
					visible_message(SPAN_WARNING("\The [src] flashes an 'Insufficient Power' error!"), range = 2)
					flashed_warning = TRUE
		// Unlike the smelter or compressor, we don't hold on to solids indefinitely. Spit them out, losing any remainders.
		if(MAT_PHASE_SOLID)
			if(!can_process_material_name(mtype))
				var/removing = REAGENT_VOLUME(reagents, mtype) || 0
				var/sheets = floor((removing / REAGENT_UNITS_PER_MATERIAL_UNIT) / SHEET_MATERIAL_AMOUNT)
				if(sheets > 0) // If we can't process any sheets at all, leave it for manual processing.
					adjusted_reagents = TRUE
					SSmaterials.create_object(mtype, output_turf, sheets)
					remove_from_reagents(mtype, removing)

	return adjusted_reagents

/obj/machinery/material_processing/extractor/attackby(obj/item/I, mob/user)
	if(IS_WRENCH(I) && !panel_open)
		var/datum/extension/atmospherics_connection/connection = get_extension(src, /datum/extension/atmospherics_connection)
		if(connection.disconnect())
			to_chat(user, SPAN_NOTICE("You disconnect \the [src] from the port."))
			return
		else
			var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector) in loc
			if(possible_port)
				if(connection.connect(possible_port))
					to_chat(user, SPAN_NOTICE("You connect \the [src] to the port."))
					return
				else
					to_chat(user, SPAN_WARNING("\The [src] failed to connect to the port."))
					return

	if(istype(I, /obj/item/chems/glass))
		if(isnull(output_container))
			if(!user.try_unequip(I, src))
				return
			output_container = I
			events_repository.register(/decl/observ/destroyed, output_container, src, TYPE_PROC_REF(/obj/machinery/material_processing/extractor, remove_container))
			user.visible_message(SPAN_NOTICE("\The [user] places \a [I] in \the [src]."), SPAN_NOTICE("You place \a [I] in \the [src]."))
			return

		to_chat(user, SPAN_WARNING("\The [src] already has an output container!"))
		return
	. = ..()

/obj/machinery/material_processing/extractor/proc/remove_container()
	if(!output_container)
		return
	. = output_container
	events_repository.unregister(/decl/observ/destroyed, output_container, src, TYPE_PROC_REF(/obj/machinery/material_processing/extractor, remove_container))
	output_container = null

/obj/machinery/material_processing/extractor/OnTopic(var/mob/user, var/list/href_list)
	. = ..()

	if(href_list["change_amount"])
		var/amount = input(user, "Enter the amount of units to transfer to the container (max 120):", "Units transfer", dispense_amount) as num

		if(!CanInteract(user, global.default_topic_state))
			return TOPIC_HANDLED

		dispense_amount = clamp(amount, 0, 120)
		return TOPIC_REFRESH

	if(href_list["dispense"])
		var/reagent_index = text2num(href_list["dispense"])
		if(!reagent_index || length(reagents.reagent_volumes) < reagent_index)
			return TOPIC_HANDLED

		var/mtype = reagents.reagent_volumes[reagent_index]

		// Only liquids are allowed to dispense. Otherwise, try to process the reagent.
		if(process_non_liquid(mtype))
			if(gas_contents)
				gas_contents.update_values()
			reagents.update_total()
			return TOPIC_REFRESH

		if(!output_container || !output_container.reagents)
			return TOPIC_HANDLED

		reagents.trans_type_to(output_container, mtype, dispense_amount)
		return TOPIC_REFRESH

	if(href_list["eject"])
		var/obj/container = remove_container()
		if(!container)
			return TOPIC_HANDLED
		if(CanPhysicallyInteract(user))
			user.put_in_hands(container)
		else
			container.dropInto(get_turf(src))
		return TOPIC_REFRESH

/obj/machinery/material_processing/extractor/get_ui_data(mob/user)
	var/list/data = ..()

	data["dispense_amount"] = dispense_amount
	if(output_container)
		var/curr_volume = output_container.reagents?.total_volume || 0
		var/max_volume  = output_container.reagents?.maximum_volume || 0

		data["container"] = "[output_container.name] ([curr_volume] / [max_volume] U)"

	data["reagents"] = list()
	var/index = 0
	for(var/mtype in reagents.reagent_volumes)
		index += 1
		var/decl/material/mat = GET_DECL(mtype)

		// TODO: Must be revised once state changes are in. Reagent names might be a litle odd in the meantime.
		var/is_liquid = mat.phase_at_temperature(temperature, ONE_ATMOSPHERE) == MAT_PHASE_LIQUID

		data["reagents"] += list(list("label" = "[mat.liquid_name] ([reagents.reagent_volumes[mtype]] U)", "index" = index, "liquid" = is_liquid))

	data["full"] = reagents.total_volume >= max_liquid
	data["gas_pressure"] = gas_contents?.return_pressure()
	return data

/obj/machinery/material_processing/extractor/return_air()
	return gas_contents

/obj/machinery/material_processing/extractor/proc/can_eat(obj/eating)
	if(istype(eating) && length(eating.matter) && is_type_in_list(eating, eating_whitelist))
		for(var/mtype in eating.matter)
			if(can_process_material_name(mtype))
				return TRUE
	return FALSE

/obj/machinery/material_processing/extractor/proc/can_process_material_name(mtype)
	var/decl/material/mat = GET_DECL(mtype)
	ASSERT(istype(mat))
	return (is_material_extractable(mat) || has_extractable_heating_products(mat))

/obj/machinery/material_processing/extractor/proc/has_extractable_heating_products(decl/material/M)
	for(var/mtype in M.heating_products)
		var/decl/material/mat = GET_DECL(mtype)
		ASSERT(istype(mat))
		if(is_material_extractable(mat))
			return TRUE
	return FALSE

/obj/machinery/material_processing/extractor/proc/is_material_extractable(decl/material/M)
	//If is gas or liquid at operating temp we can process
	var/phase = M.phase_at_temperature(temperature)
	return phase == MAT_PHASE_LIQUID || phase == MAT_PHASE_GAS

/obj/machinery/material_processing/extractor/ProcessAtomTemperature()
	if(use_power && operable())
		temperature = GAS_EXTRACTOR_OPERATING_TEMP
		return TRUE
	. = ..()

/obj/machinery/material_processing/extractor/power_change()
	. = ..()
	if(.)
		queue_temperature_atoms(src)

#undef MAX_INTAKE_ORE_PER_TICK
#undef GAS_EXTRACTOR_OPERATING_TEMP
